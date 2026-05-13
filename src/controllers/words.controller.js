const db = require('../config/database');
const cache = require('../config/redis');

const getWords = async (req, res) => {
  // Compatibilité bidirectionnelle: accepter à la fois (language, search) et (lang, q)
  const language = req.query.language || req.query.lang;
  const level = req.query.level;
  const search = req.query.search || req.query.q;
  const page = parseInt(req.query.page || 1);
  const limit = parseInt(req.query.limit || 20);
  const offset = (page - 1) * limit;

  const cacheKey = `words:${language || ''}:${level || ''}:${search || ''}:${page}:${limit}`;
  const cached = await cache.get(cacheKey);
  if (cached) return res.json({ success: true, data: JSON.parse(cached) });

  let sql = `SELECT w.*, l.code as lang_code FROM words w JOIN languages l ON l.id = w.language_id WHERE 1=1`;
  const params = [];

  if (language) { sql += ' AND l.code = ?'; params.push(language); }
  if (level) { sql += ' AND w.level = ?'; params.push(level); }
  if (search) { sql += ' AND (w.word LIKE ? OR w.reading LIKE ? OR w.meaning_vi LIKE ?)'; params.push(`%${search}%`, `%${search}%`, `%${search}%`); }

  sql += ' ORDER BY w.id LIMIT ? OFFSET ?';
  params.push(limit, offset);

  const [rows] = await db.query(sql, params);
  await cache.set(cacheKey, JSON.stringify(rows), { EX: 300 });
  res.json({ success: true, data: rows });
};

// 1.7 — GET /api/words/search?q=...&lang=... (alias pour rétrocompatibilité)
const searchWords = (req, res) => getWords(req, res);

// 2.5 — GET /api/words/:id/examples
const getWordExamples = async (req, res) => {
  const { id } = req.params;
  const [rows] = await db.query(
    `SELECT id, word_id, sentence, reading, translation, audio_url, level_code, source
     FROM word_examples WHERE word_id = ? ORDER BY id`, [id]
  );
  res.json({ success: true, data: rows });
};

const getWordById = async (req, res) => {
  const [rows] = await db.query(
    `SELECT w.*, l.code as lang_code FROM words w JOIN languages l ON l.id = w.language_id WHERE w.id = ?`,
    [req.params.id]
  );
  if (!rows.length) return res.status(404).json({ success: false, message: 'Không tìm thấy từ' });

  const [examples] = await db.query('SELECT * FROM word_examples WHERE word_id = ?', [req.params.id]);
  rows[0].examples = examples;
  res.json({ success: true, data: rows[0] });
};

const getCharacter = async (req, res) => {
  const { char } = req.params;
  const [rows] = await db.query(
    `SELECT * FROM characters WHERE \`char\` = ?`, [char]
  );
  if (!rows.length) return res.status(404).json({ success: false, message: 'Không tìm thấy ký tự' });

  const [words] = await db.query(
    `SELECT w.id, w.word, w.reading, w.meaning_vi FROM words w
     WHERE w.word LIKE ? LIMIT 10`, [`%${char}%`]
  );

  // 3.1 FIX: parse strokes JSON nếu có (KanjiVG paths) — trả về array string.
  // Nếu DB không có cột strokes (migration 017 chưa apply), bỏ qua im lặng.
  const row = rows[0];
  let strokes = null;
  if (row.strokes) {
    try {
      strokes = typeof row.strokes === 'string' ? JSON.parse(row.strokes) : row.strokes;
    } catch (_) { strokes = null; }
  }

  res.json({ success: true, data: { ...row, strokes, relatedWords: words } });
};

module.exports = { getWords, searchWords, getWordById, getCharacter, getWordExamples };
