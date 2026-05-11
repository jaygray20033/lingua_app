const db = require('../config/database');

// Normaliser type vers les valeurs ENUM ('WORD','GRAMMAR','SENTENCE','MOCK_TEST')
const normalizeType = (t) => {
  if (!t) return null;
  const up = t.toString().toUpperCase();
  const allowed = ['WORD', 'GRAMMAR', 'SENTENCE', 'MOCK_TEST'];
  return allowed.includes(up) ? up : null;
};

// GET /api/favorites?type=word
const list = async (req, res) => {
  const type = normalizeType(req.query.type);
  let sql = 'SELECT id, user_id, `type`, item_id, created_at FROM favorites WHERE user_id = ?';
  const params = [req.user.id];
  if (type) { sql += ' AND `type` = ?'; params.push(type); }
  sql += ' ORDER BY created_at DESC';
  const [rows] = await db.query(sql, params);
  res.json({ success: true, data: rows });
};

// POST /api/favorites { type, itemId }
const add = async (req, res) => {
  const type = normalizeType(req.body.type);
  const itemId = parseInt(req.body.itemId, 10);
  if (!type || !itemId) {
    return res.status(400).json({ success: false, message: 'Thiếu type hoặc itemId' });
  }
  await db.query(
    'INSERT IGNORE INTO favorites (user_id, `type`, item_id) VALUES (?, ?, ?)',
    [req.user.id, type, itemId]
  );
  res.json({ success: true, message: 'Đã thêm vào yêu thích' });
};

// DELETE /api/favorites/:type/:itemId
const remove = async (req, res) => {
  const type = normalizeType(req.params.type);
  const itemId = parseInt(req.params.itemId, 10);
  if (!type || !itemId) {
    return res.status(400).json({ success: false, message: 'Thiếu type hoặc itemId' });
  }
  await db.query(
    'DELETE FROM favorites WHERE user_id = ? AND `type` = ? AND item_id = ?',
    [req.user.id, type, itemId]
  );
  res.json({ success: true, message: 'Đã xoá khỏi yêu thích' });
};

// 1.2 — GET /api/favorites/check?type=word&itemId=123
const check = async (req, res) => {
  const type = normalizeType(req.query.type);
  const itemId = parseInt(req.query.itemId, 10);
  if (!type || !itemId) {
    return res.status(400).json({ success: false, message: 'Thiếu type hoặc itemId' });
  }
  const [rows] = await db.query(
    'SELECT id FROM favorites WHERE user_id = ? AND `type` = ? AND item_id = ? LIMIT 1',
    [req.user.id, type, itemId]
  );
  res.json({ success: true, data: { isFavorite: rows.length > 0 } });
};

module.exports = { list, add, remove, check };
