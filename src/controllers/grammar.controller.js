const db = require('../config/database');

const safeJson = (v) => { try { return typeof v === 'string' ? JSON.parse(v) : v; } catch { return v; } };

// GET /api/grammars?language=ja&level=N5&search=...
const list = async (req, res) => {
  const { language, level, search } = req.query;
  let sql = `SELECT g.*, l.code as lang_code, l.name as lang_name
             FROM grammar_points g JOIN languages l ON l.id = g.language_id
             WHERE 1=1`;
  const params = [];
  if (language) { sql += ' AND l.code = ?'; params.push(language); }
  if (level) { sql += ' AND g.level_code = ?'; params.push(level); }
  if (search) {
    sql += ' AND (g.title LIKE ? OR g.structure LIKE ? OR g.explanation LIKE ?)';
    params.push(`%${search}%`, `%${search}%`, `%${search}%`);
  }
  sql += ' ORDER BY g.id LIMIT 200';
  const [rows] = await db.query(sql, params);
  res.json({ success: true, data: rows });
};

// GET /api/grammars/:id
const detail = async (req, res) => {
  const { id } = req.params;
  const [rows] = await db.query(
    `SELECT g.*, l.code as lang_code FROM grammar_points g
     JOIN languages l ON l.id = g.language_id WHERE g.id = ?`, [id]
  );
  if (!rows.length) return res.status(404).json({ success: false, message: 'Không tìm thấy ngữ pháp' });

  const [examples] = await db.query(
    'SELECT id, sentence, translation, audio_url, note, order_index FROM grammar_examples WHERE grammar_id = ? ORDER BY order_index',
    [id]
  );
  const [exercises] = await db.query(
    'SELECT id, `type`, prompt, options_json, answer, explanation FROM grammar_exercises WHERE grammar_id = ?',
    [id]
  );

  const grammar = rows[0];
  grammar.examples = examples;
  grammar.exercises = exercises.map(e => ({ ...e, options_json: safeJson(e.options_json) }));

  res.json({ success: true, data: grammar });
};

// 3.7 — GET /api/grammars/:id/exercises
const getExercises = async (req, res) => {
  const { id } = req.params;
  const [rows] = await db.query(
    'SELECT id, `type`, prompt, options_json, answer, explanation FROM grammar_exercises WHERE grammar_id = ?',
    [id]
  );
  res.json({
    success: true,
    data: rows.map(e => ({ ...e, options_json: safeJson(e.options_json) }))
  });
};

module.exports = { list, detail, getExercises };
