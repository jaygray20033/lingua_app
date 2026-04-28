const db = require('../config/database');

const XP_REWARDS = {
  LESSON_COMPLETE: 15,
  PERFECT_LESSON: 25,
  SRS_REVIEW: 1,
  DAILY_GOAL: 10,
  STREAK_BONUS: 5
};

const addXP = async (userId, amount, reason = 'LESSON_COMPLETE') => {
  await db.query(
    'UPDATE user_gamification SET total_xp = total_xp + ? WHERE user_id = ?',
    [amount, userId]
  );

  // Update daily XP log
  const today = new Date().toISOString().split('T')[0];
  await db.query(
    `INSERT INTO daily_xp_logs (user_id, date, xp_gained) VALUES (?, ?, ?)
     ON DUPLICATE KEY UPDATE xp_gained = xp_gained + ?`,
    [userId, today, amount, amount]
  );

  // Check daily goal
  const [gamRow] = await db.query(
    'SELECT daily_xp_goal FROM user_languages WHERE user_id = ? AND is_primary = 1',
    [userId]
  );
  if (gamRow.length) {
    const [xpRow] = await db.query(
      'SELECT xp_gained FROM daily_xp_logs WHERE user_id = ? AND date = ?',
      [userId, today]
    );
    if (xpRow.length && xpRow[0].xp_gained >= gamRow[0].daily_xp_goal) {
      await db.query(
        'UPDATE daily_xp_logs SET goal_met = 1 WHERE user_id = ? AND date = ?',
        [userId, today]
      );
    }
  }

  // Level up check
  await checkLevelUp(userId);
  return amount;
};

const checkLevelUp = async (userId) => {
  const [rows] = await db.query(
    'SELECT total_xp, level FROM user_gamification WHERE user_id = ?',
    [userId]
  );
  if (!rows.length) return;

  const { total_xp, level } = rows[0];
  const newLevel = Math.floor(Math.sqrt(total_xp / 100)) + 1;

  if (newLevel > level) {
    await db.query(
      'UPDATE user_gamification SET level = ?, gems = gems + ? WHERE user_id = ?',
      [newLevel, (newLevel - level) * 10, userId]
    );
    await db.query(
      'INSERT INTO gem_transactions (user_id, delta, reason) VALUES (?, ?, ?)',
      [userId, (newLevel - level) * 10, 'LEVEL_UP']
    );
    return newLevel;
  }
  return level;
};

const updateStreak = async (userId) => {
  const [rows] = await db.query(
    'SELECT streak_count, longest_streak, last_streak_date, streak_freeze_count FROM user_gamification WHERE user_id = ?',
    [userId]
  );
  if (!rows.length) return;

  const { streak_count, longest_streak, last_streak_date, streak_freeze_count } = rows[0];
  const today = new Date().toISOString().split('T')[0];
  const yesterday = new Date(Date.now() - 86400000).toISOString().split('T')[0];

  if (last_streak_date === today) return streak_count; // Already updated today

  let newStreak = 1;
  if (last_streak_date === yesterday) {
    newStreak = streak_count + 1;
  } else if (streak_freeze_count > 0 && last_streak_date !== null) {
    // Check if only one day was missed (streak freeze)
    const twoDaysAgo = new Date(Date.now() - 2 * 86400000).toISOString().split('T')[0];
    if (last_streak_date === twoDaysAgo) {
      newStreak = streak_count + 1;
      await db.query(
        'UPDATE user_gamification SET streak_freeze_count = streak_freeze_count - 1 WHERE user_id = ?',
        [userId]
      );
    }
  }

  await db.query(
    `UPDATE user_gamification SET
      streak_count = ?,
      longest_streak = GREATEST(longest_streak, ?),
      last_streak_date = ?
     WHERE user_id = ?`,
    [newStreak, newStreak, today, userId]
  );

  // Add streak bonus XP
  if (newStreak > 1) {
    await addXP(userId, XP_REWARDS.STREAK_BONUS, 'STREAK_BONUS');
  }

  return newStreak;
};

const loseHeart = async (userId) => {
  const [rows] = await db.query(
    'SELECT hearts, role FROM user_gamification ug JOIN users u ON u.id = ug.user_id WHERE ug.user_id = ?',
    [userId]
  );
  if (!rows.length) return;

  // Premium users have unlimited hearts
  if (rows[0].role === 'PREMIUM') return rows[0].hearts;

  if (rows[0].hearts <= 0) {
    throw new Error('Plus de cœurs ! Attendez ou rechargez.');
  }

  await db.query(
    'UPDATE user_gamification SET hearts = hearts - 1 WHERE user_id = ?',
    [userId]
  );
  await db.query(
    'INSERT INTO heart_logs (user_id, delta, reason) VALUES (?, -1, ?)',
    [userId, 'WRONG_ANSWER']
  );

  return rows[0].hearts - 1;
};

const refillHearts = async (userId, method = 'REFILL_GEM') => {
  const GEM_COST = 350;

  if (method === 'REFILL_GEM') {
    const [rows] = await db.query(
      'SELECT gems FROM user_gamification WHERE user_id = ?',
      [userId]
    );
    if (!rows.length || rows[0].gems < GEM_COST) {
      throw new Error(`Pas assez de gems. Requis: ${GEM_COST}`);
    }
    await db.query(
      'UPDATE user_gamification SET hearts = 5, gems = gems - ? WHERE user_id = ?',
      [GEM_COST, userId]
    );
    await db.query(
      'INSERT INTO gem_transactions (user_id, delta, reason) VALUES (?, ?, ?)',
      [userId, -GEM_COST, 'SPEND_HEART']
    );
  } else {
    await db.query(
      'UPDATE user_gamification SET hearts = 5 WHERE user_id = ?',
      [userId]
    );
  }

  await db.query(
    'INSERT INTO heart_logs (user_id, delta, reason) VALUES (?, 5, ?)',
    [userId, method]
  );

  return 5;
};

const getStats = async (userId) => {
  const [gam] = await db.query(
    'SELECT * FROM user_gamification WHERE user_id = ?',
    [userId]
  );
  if (!gam.length) return null;

  const [dailyXp] = await db.query(
    'SELECT xp_gained, goal_met FROM daily_xp_logs WHERE user_id = ? AND date = CURDATE()',
    [userId]
  );

  const [achievements] = await db.query(
    `SELECT a.code, a.title, a.icon_url, ua.unlocked_at
     FROM user_achievements ua JOIN achievements a ON a.id = ua.achievement_id
     WHERE ua.user_id = ? ORDER BY ua.unlocked_at DESC LIMIT 5`,
    [userId]
  );

  return {
    ...gam[0],
    todayXp: dailyXp[0]?.xp_gained || 0,
    goalMet: dailyXp[0]?.goal_met || 0,
    recentAchievements: achievements
  };
};

module.exports = { addXP, updateStreak, loseHeart, refillHearts, getStats, checkLevelUp };
