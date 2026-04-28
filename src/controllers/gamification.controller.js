const gamService = require('../services/gamification.service');
const db = require('../config/database');

const getMyStats = async (req, res) => {
  const stats = await gamService.getStats(req.user.id);
  if (!stats) return res.status(404).json({ success: false, message: 'Stats non trouvées' });
  res.json({ success: true, data: stats });
};

const loseHeart = async (req, res) => {
  const remaining = await gamService.loseHeart(req.user.id);
  res.json({ success: true, data: { hearts: remaining } });
};

const refillHearts = async (req, res) => {
  const { method = 'REFILL_GEM' } = req.body;
  const hearts = await gamService.refillHearts(req.user.id, method);
  res.json({ success: true, data: { hearts } });
};

const addXP = async (req, res) => {
  const { amount, reason } = req.body;
  if (!amount) return res.status(400).json({ success: false, message: 'amount requis' });
  await gamService.addXP(req.user.id, amount, reason);
  res.json({ success: true, data: { added: amount } });
};

const getLeaderboard = async (req, res) => {
  const { type = 'weekly' } = req.query;
  let query;
  if (type === 'weekly') {
    query = `
      SELECT u.id, u.display_name, u.avatar_url, ul.weekly_xp as xp,
             ROW_NUMBER() OVER (ORDER BY ul.weekly_xp DESC) as rank
      FROM user_leagues ul
      JOIN users u ON u.id = ul.user_id
      WHERE ul.league_group_id = (
        SELECT id FROM league_groups ORDER BY week_start_date DESC LIMIT 1
      )
      ORDER BY ul.weekly_xp DESC LIMIT 50
    `;
  } else {
    query = `
      SELECT u.id, u.display_name, u.avatar_url, ug.total_xp as xp,
             ROW_NUMBER() OVER (ORDER BY ug.total_xp DESC) as rank
      FROM user_gamification ug
      JOIN users u ON u.id = ug.user_id
      ORDER BY ug.total_xp DESC LIMIT 50
    `;
  }
  const [rows] = await db.query(query);
  res.json({ success: true, data: rows });
};

const getAchievements = async (req, res) => {
  const [all] = await db.query('SELECT * FROM achievements ORDER BY rarity DESC');
  const [unlocked] = await db.query(
    'SELECT achievement_id, unlocked_at, progress FROM user_achievements WHERE user_id = ?',
    [req.user.id]
  );
  const unlockedMap = {};
  unlocked.forEach(u => { unlockedMap[u.achievement_id] = u; });

  const data = all.map(a => ({
    ...a,
    unlocked: !!unlockedMap[a.id],
    unlockedAt: unlockedMap[a.id]?.unlocked_at || null,
    progress: unlockedMap[a.id]?.progress || 0
  }));

  res.json({ success: true, data });
};

const getDailyQuests = async (req, res) => {
  const today = new Date().toISOString().split('T')[0];
  let [quests] = await db.query(
    'SELECT * FROM daily_quests WHERE user_id = ? AND date = ?',
    [req.user.id, today]
  );

  if (!quests.length) {
    // Generate daily quests
    const questTemplates = [
      { quest_code: 'LEARN_10_MIN', target: 10, reward_gems: 10, description: 'Học 10 phút hôm nay' },
      { quest_code: 'REVIEW_20_CARDS', target: 20, reward_gems: 15, description: 'Review 20 thẻ flashcard' },
      { quest_code: 'COMPLETE_LESSON', target: 1, reward_gems: 20, description: 'Hoàn thành 1 bài học' }
    ];
    for (const tpl of questTemplates) {
      await db.query(
        'INSERT IGNORE INTO daily_quests (user_id, quest_code, target, reward_gems, date) VALUES (?, ?, ?, ?, ?)',
        [req.user.id, tpl.quest_code, tpl.target, tpl.reward_gems, today]
      );
    }
    [quests] = await db.query(
      'SELECT * FROM daily_quests WHERE user_id = ? AND date = ?',
      [req.user.id, today]
    );
  }

  res.json({ success: true, data: quests });
};

module.exports = { getMyStats, loseHeart, refillHearts, addXP, getLeaderboard, getAchievements, getDailyQuests };
