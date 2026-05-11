const gamService = require('../services/gamification.service');
const cache = require('../config/redis');
const db = require('../config/database');

const getMyStats = async (req, res) => {
  const stats = await gamService.getStats(req.user.id);
  res.json({ success: true, data: stats });
};

const loseHeart = async (req, res) => {
  // BUG B2 FIX: wrap résultat dans un objet { hearts: N } pour que Android
  // (Gson) puisse parser correctement HeartsData.hearts.
  // BUG B19 FIX: gamService.loseHeart now returns { hearts, outOfHearts } object
  // (previously threw on 0 hearts). Pass through the structured response.
  const result = await gamService.loseHeart(req.user.id);
  if (result && typeof result === 'object') {
    res.json({ success: true, data: result });
  } else {
    res.json({ success: true, data: { hearts: result } });
  }
};

const refillHearts = async (req, res) => {
  const result = await gamService.refillHearts(req.user.id);
  res.json({ success: true, data: { hearts: result } });
};

const addXP = async (req, res) => {
  const { amount, source } = req.body;
  if (!amount || amount <= 0) return res.status(400).json({ success: false, message: 'Số XP không hợp lệ' });
  const result = await gamService.addXP(req.user.id, amount, source || 'MANUAL');
  // Récupère le total_xp à jour pour renvoyer un objet utilisable côté Android
  const [rows] = await db.query(
    'SELECT total_xp, level FROM user_gamification WHERE user_id = ?',
    [req.user.id]
  );
  res.json({
    success: true,
    data: {
      added: result,
      totalXp: rows[0]?.total_xp || 0,
      level: rows[0]?.level || 1,
    },
  });
};

const getLeaderboard = async (req, res) => {
  // BUG B8 FIX: prendre en compte le paramètre `period` (weekly|monthly|all)
  // Auparavant la même cache key écrasait tout, et tous les onglets renvoyaient
  // la même liste « weekly ».
  const period = (req.query.period || 'weekly').toLowerCase();
  const validPeriods = ['weekly', 'monthly', 'all'];
  const safePeriod = validPeriods.includes(period) ? period : 'weekly';

  const cacheKey = `leaderboard:${safePeriod}`;
  const cached = await cache.get(cacheKey);
  if (cached) return res.json({ success: true, data: JSON.parse(cached) });

  let rows;
  if (safePeriod === 'all') {
    // Total cumulé depuis l'inscription
    [rows] = await db.query(
      `SELECT u.id, u.display_name, u.avatar_url,
              COALESCE(g.total_xp, 0) as xp,
              ROW_NUMBER() OVER (ORDER BY g.total_xp DESC) as \`rank\`
       FROM users u
       LEFT JOIN user_gamification g ON g.user_id = u.id
       WHERE u.status = 'ACTIVE'
       ORDER BY g.total_xp DESC
       LIMIT 50`
    );
  } else {
    // weekly = 7 derniers jours, monthly = 30 derniers jours
    const days = safePeriod === 'monthly' ? 30 : 7;
    [rows] = await db.query(
      `SELECT u.id, u.display_name, u.avatar_url,
              COALESCE(SUM(d.xp_gained), 0) as xp,
              ROW_NUMBER() OVER (ORDER BY COALESCE(SUM(d.xp_gained), 0) DESC) as \`rank\`
       FROM users u
       LEFT JOIN daily_xp_logs d
         ON d.user_id = u.id AND d.date >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
       WHERE u.status = 'ACTIVE'
       GROUP BY u.id, u.display_name, u.avatar_url
       ORDER BY xp DESC
       LIMIT 50`,
      [days]
    );
  }

  await cache.set(cacheKey, JSON.stringify(rows), { EX: 300 });
  res.json({ success: true, data: rows });
};

const getAchievements = async (req, res) => {
  const [rows] = await db.query(
    `SELECT a.*, ua.unlocked_at
     FROM achievements a
     LEFT JOIN user_achievements ua ON ua.achievement_id = a.id AND ua.user_id = ?
     ORDER BY a.id`, [req.user.id]
  );
  const result = rows.map(r => ({
    ...r,
    unlocked: !!r.unlocked_at,
    unlockedAt: r.unlocked_at,
  }));
  res.json({ success: true, data: result });
};

const getDailyQuests = async (req, res) => {
  const today = new Date().toISOString().slice(0, 10);
  const [rows] = await db.query(
    'SELECT * FROM daily_quests WHERE user_id = ? AND `date` = ?',
    [req.user.id, today]
  );
  res.json({ success: true, data: rows });
};

const claimQuest = async (req, res) => {
  const { questId } = req.params;
  const [rows] = await db.query(
    'SELECT * FROM daily_quests WHERE id = ? AND user_id = ?',
    [questId, req.user.id]
  );
  if (!rows.length) return res.status(404).json({ success: false, message: 'Không tìm thấy nhiệm vụ' });
  const q = rows[0];
  if (!q.completed) return res.status(400).json({ success: false, message: 'Nhiệm vụ chưa hoàn thành' });
  if (q.claimed_at) return res.status(400).json({ success: false, message: 'Đã nhận phần thưởng rồi' });

  await db.query('UPDATE daily_quests SET claimed_at = NOW() WHERE id = ?', [questId]);
  await db.query(
    'UPDATE user_gamification SET gems = gems + ? WHERE user_id = ?',
    [q.reward_gems, req.user.id]
  );
  res.json({ success: true, data: { gems: q.reward_gems, message: 'Đã nhận phần thưởng nhiệm vụ' } });
};

// 1.1 — GET /api/gamification/analytics
const getAnalytics = async (req, res) => {
  // XP par jour sur les 30 derniers jours
  const [dailyXp] = await db.query(
    `SELECT date, xp_gained, goal_met
     FROM daily_xp_logs
     WHERE user_id = ? AND date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
     ORDER BY date ASC`,
    [req.user.id]
  );

  // Stats globales
  const [gam] = await db.query(
    'SELECT total_xp, level, streak_count, longest_streak FROM user_gamification WHERE user_id = ?',
    [req.user.id]
  );

  // Total bài học hoàn thành
  const [lessonStats] = await db.query(
    `SELECT
       COUNT(*) as total_lessons,
       AVG(score_percent) as avg_score,
       SUM(xp_earned) as total_xp_lessons
     FROM lesson_attempts WHERE user_id = ? AND status = 'COMPLETED'`,
    [req.user.id]
  );

  // Số ngày học (distinct dates)
  const [activeDays] = await db.query(
    'SELECT COUNT(DISTINCT date) as days FROM daily_xp_logs WHERE user_id = ?',
    [req.user.id]
  );

  // Trend XP 7 jours vs 7 jours précédents
  const [recent7] = await db.query(
    `SELECT COALESCE(SUM(xp_gained), 0) as xp FROM daily_xp_logs
     WHERE user_id = ? AND date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)`,
    [req.user.id]
  );
  const [previous7] = await db.query(
    `SELECT COALESCE(SUM(xp_gained), 0) as xp FROM daily_xp_logs
     WHERE user_id = ?
       AND date < DATE_SUB(CURDATE(), INTERVAL 7 DAY)
       AND date >= DATE_SUB(CURDATE(), INTERVAL 14 DAY)`,
    [req.user.id]
  );
  const recentXp = recent7[0]?.xp || 0;
  const prevXp = previous7[0]?.xp || 0;
  const trendPercent = prevXp > 0 ? Math.round(((recentXp - prevXp) / prevXp) * 100) : 0;

  res.json({
    success: true,
    data: {
      gamification: gam[0] || null,
      activeDays: activeDays[0]?.days || 0,
      totalLessons: lessonStats[0]?.total_lessons || 0,
      averageScore: Math.round(lessonStats[0]?.avg_score || 0),
      xpFromLessons: lessonStats[0]?.total_xp_lessons || 0,
      dailyXp,
      trend: {
        last7DaysXp: recentXp,
        previous7DaysXp: prevXp,
        percentChange: trendPercent,
      },
    },
  });
};

// 1.1 — POST /api/gamification/achievements/evaluate
const evaluateAchievements = async (req, res) => {
  const userId = req.user.id;

  const [gamRows] = await db.query(
    'SELECT total_xp, level, streak_count, longest_streak FROM user_gamification WHERE user_id = ?',
    [userId]
  );
  const gam = gamRows[0] || { total_xp: 0, level: 1, streak_count: 0, longest_streak: 0 };

  const [completedRows] = await db.query(
    "SELECT COUNT(*) as c FROM lesson_attempts WHERE user_id = ? AND status = 'COMPLETED'",
    [userId]
  );
  const completedLessons = completedRows[0]?.c || 0;

  const [allAchievements] = await db.query('SELECT * FROM achievements');
  const [unlocked] = await db.query(
    'SELECT achievement_id FROM user_achievements WHERE user_id = ?', [userId]
  );
  const unlockedSet = new Set(unlocked.map(r => r.achievement_id));

  const newlyUnlocked = [];
  for (const a of allAchievements) {
    if (unlockedSet.has(a.id)) continue;

    // Heuristique simple sur a.code (ex: STREAK_7, XP_1000, LESSONS_10)
    const code = (a.code || '').toUpperCase();
    let unlock = false;

    if (code.startsWith('STREAK_')) {
      const n = parseInt(code.replace('STREAK_', ''), 10);
      if (!isNaN(n) && gam.longest_streak >= n) unlock = true;
    } else if (code.startsWith('XP_')) {
      const n = parseInt(code.replace('XP_', ''), 10);
      if (!isNaN(n) && gam.total_xp >= n) unlock = true;
    } else if (code.startsWith('LESSONS_') || code.startsWith('LESSON_')) {
      const n = parseInt(code.replace(/^LESSONS?_/, ''), 10);
      if (!isNaN(n) && completedLessons >= n) unlock = true;
    } else if (code.startsWith('LEVEL_')) {
      const n = parseInt(code.replace('LEVEL_', ''), 10);
      if (!isNaN(n) && gam.level >= n) unlock = true;
    }

    if (unlock) {
      await db.query(
        'INSERT IGNORE INTO user_achievements (user_id, achievement_id, unlocked_at) VALUES (?, ?, NOW())',
        [userId, a.id]
      );
      newlyUnlocked.push(a);
    }
  }

  res.json({
    success: true,
    data: { unlockedCount: newlyUnlocked.length, unlocked: newlyUnlocked },
  });
};

// 1.1 — GET /api/gamification/languages
const getLanguages = async (req, res) => {
  const [rows] = await db.query(
    'SELECT id, code, name, flag_emoji FROM languages ORDER BY id'
  );
  res.json({ success: true, data: rows });
};

// 1.8 — PUT /api/gamification/daily-goal { dailyXpGoal }
const setDailyGoal = async (req, res) => {
  const goal = parseInt(req.body.dailyXpGoal || req.body.goal, 10);
  if (!goal || goal < 5 || goal > 500) {
    return res.status(400).json({ success: false, message: 'Mục tiêu XP phải từ 5 đến 500' });
  }
  await db.query(
    `UPDATE user_languages SET daily_xp_goal = ? WHERE user_id = ? AND is_primary = 1`,
    [goal, req.user.id]
  );
  res.json({ success: true, data: { dailyXpGoal: goal } });
};

// 1.8 — POST /api/gamification/streak-freeze/buy
const buyStreakFreeze = async (req, res) => {
  const COST = 200;
  const [rows] = await db.query(
    'SELECT gems, streak_freeze_count FROM user_gamification WHERE user_id = ?',
    [req.user.id]
  );
  if (!rows.length) return res.status(404).json({ success: false, message: 'User not found' });
  if ((rows[0].gems || 0) < COST) {
    return res.status(400).json({ success: false, message: `Không đủ gems. Cần ${COST} gems` });
  }
  if ((rows[0].streak_freeze_count || 0) >= 3) {
    return res.status(400).json({ success: false, message: 'Đã đạt tối đa 3 streak freeze' });
  }
  await db.query(
    'UPDATE user_gamification SET gems = gems - ?, streak_freeze_count = streak_freeze_count + 1 WHERE user_id = ?',
    [COST, req.user.id]
  );
  await db.query(
    'INSERT INTO gem_transactions (user_id, delta, reason) VALUES (?, ?, ?)',
    [req.user.id, -COST, 'BUY_STREAK_FREEZE']
  );
  res.json({ success: true, data: { freezeCount: (rows[0].streak_freeze_count || 0) + 1 } });
};

// 1.8 — POST /api/quests/event { event, value }
const triggerQuestEvent = async (req, res) => {
  const { event, value = 1 } = req.body || {};
  if (!event) return res.status(400).json({ success: false, message: 'Thiếu event' });

  const today = new Date().toISOString().slice(0, 10);
  // Incrémenter progress de toutes les quêtes du jour ayant ce event_type
  await db.query(
    `UPDATE daily_quests SET progress = LEAST(progress + ?, target),
       completed = (CASE WHEN progress + ? >= target THEN 1 ELSE completed END)
     WHERE user_id = ? AND \`date\` = ? AND event_type = ?`,
    [value, value, req.user.id, today, event]
  ).catch(() => {});

  res.json({ success: true, message: 'Đã ghi nhận sự kiện', data: { event, value } });
};

module.exports = {
  getMyStats, loseHeart, refillHearts, addXP,
  getLeaderboard, getAchievements, getDailyQuests, claimQuest,
  getAnalytics, evaluateAchievements, getLanguages,
  setDailyGoal, buyStreakFreeze, triggerQuestEvent,
};
