const db = require('../config/database');

// 2.5 — GET /api/examples?language=ja&level=N5&limit=20
const list = async (req, res) => {
  const { language, level } = req.query;
  const limit = Math.min(parseInt(req.query.limit || 20, 10), 100);

  let sql = `SELECT we.id, we.word_id, we.sentence, we.reading, we.translation,
                    we.audio_url, we.level_code, we.source,
                    w.word, w.reading as word_reading, l.code as lang_code
             FROM word_examples we
             JOIN words w ON w.id = we.word_id
             JOIN languages l ON l.id = w.language_id
             WHERE 1=1`;
  const params = [];
  if (language) { sql += ' AND l.code = ?'; params.push(language); }
  if (level) { sql += ' AND (we.level_code = ? OR w.level = ?)'; params.push(level, level); }
  sql += ' ORDER BY we.id DESC LIMIT ?';
  params.push(limit);

  const [rows] = await db.query(sql, params);
  res.json({ success: true, data: rows });
};

module.exports = { list };
