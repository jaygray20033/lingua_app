const jwt = require('jsonwebtoken');
const db = require('../config/database');
const cache = require('../config/redis');

const authenticate = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ success: false, message: 'Thiếu token xác thực' });
    }
    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // Redis cache for user lookup
    const cacheKey = `user:${decoded.userId}`;
    const cached = await cache.get(cacheKey);
    let user;
    if (cached) {
      user = JSON.parse(cached);
    } else {
      const [rows] = await db.query(
        'SELECT id, email, display_name, role, status, avatar_url FROM users WHERE id = ?',
        [decoded.userId]
      );
      if (!rows.length || rows[0].status !== 'ACTIVE') {
        return res.status(401).json({ success: false, message: 'Người dùng không tồn tại hoặc đã bị khoá' });
      }
      user = rows[0];
      await cache.set(cacheKey, JSON.stringify(user), { EX: 300 });

      // BUG L3 FIX: pour les users créés avant le fix register (ou via seed SQL),
      // s'assurer qu'une ligne user_gamification existe — sinon updateStreak()
      // sort en early-return et le streak reste bloqué à 0.
      try {
        await db.query(
          'INSERT IGNORE INTO user_gamification (user_id) VALUES (?)',
          [user.id]
        );
      } catch (e) {
        console.error('auth middleware: ensure user_gamification failed:', e.message);
      }
    }
    req.user = user;
    next();
  } catch (err) {
    return res.status(401).json({ success: false, message: 'Token không hợp lệ hoặc đã hết hạn' });
  }
};

const requireRole = (...roles) => (req, res, next) => {
  if (!roles.includes(req.user.role)) {
    return res.status(403).json({ success: false, message: 'Không có quyền truy cập' });
  }
  next();
};

module.exports = { authenticate, requireRole };
