const db = require('../config/database');

const safeJson = (v) => { try { return typeof v === 'string' ? JSON.parse(v) : v; } catch { return v; } };

// GET /api/mock-tests?language=ja&type=JLPT
const list = async (req, res) => {
  const { language, type } = req.query;
  let sql = 'SELECT * FROM mock_tests WHERE 1=1';
  const params = [];
  if (language) { sql += ' AND lang_code = ?'; params.push(language); }
  if (type) { sql += ' AND type = ?'; params.push(type); }
  sql += ' ORDER BY id';
  const [rows] = await db.query(sql, params);
  res.json({ success: true, data: rows });
};

// GET /api/mock-tests/attempts — 1.4 lịch sử thi
//  Doit précéder /:id pour éviter le conflit (Express matche en ordre)
const myAttempts = async (req, res) => {
  const [rows] = await db.query(
    `SELECT a.*, m.title, m.type, m.lang_code
     FROM mock_test_attempts a
     LEFT JOIN mock_tests m ON m.id = a.mock_test_id
     WHERE a.user_id = ?
     ORDER BY a.id DESC LIMIT 100`,
    [req.user.id]
  );
  res.json({ success: true, data: rows });
};

// GET /api/mock-tests/:id
const detail = async (req, res) => {
  const { id } = req.params;
  const [rows] = await db.query('SELECT * FROM mock_tests WHERE id = ?', [id]);
  if (!rows.length) return res.status(404).json({ success: false, message: 'Không tìm thấy bài thi' });

  const [sections] = await db.query(
    'SELECT * FROM mock_test_sections WHERE mock_test_id = ? ORDER BY id',
    [id]
  );
  for (const section of sections) {
    const [questions] = await db.query(
      `SELECT id, section_id, \`type\`, prompt, question, options_json,
              correct_answer, audio_url, image_url
       FROM mock_test_questions WHERE section_id = ? ORDER BY id`, [section.id]
    );
    section.questions = questions.map(q => ({ ...q, options_json: safeJson(q.options_json) }));
  }
  const test = rows[0];
  test.sections = sections;
  res.json({ success: true, data: test });
};

// POST /api/mock-tests/:id/submit  { answers: [{questionId, answer}] }
const submit = async (req, res) => {
  const { id } = req.params;
  const answers = Array.isArray(req.body.answers) ? req.body.answers : [];

  // Récupérer toutes les bonnes réponses
  const [questions] = await db.query(
    `SELECT q.id, q.correct_answer
     FROM mock_test_questions q
     JOIN mock_test_sections s ON s.id = q.section_id
     WHERE s.mock_test_id = ?`, [id]
  );
  const correctMap = new Map(questions.map(q => [q.id, q.correct_answer]));

  let correct = 0;
  for (const a of answers) {
    const expected = correctMap.get(parseInt(a.questionId, 10));
    if (expected !== undefined && expected !== null) {
      const userAns = (a.answer ?? '').toString().trim().toLowerCase();
      if (userAns === expected.toString().trim().toLowerCase()) correct++;
    }
  }

  const total = questions.length || 1;
  const scorePercent = Math.round((correct / total) * 100);

  const [result] = await db.query(
    `INSERT INTO mock_test_attempts (user_id, mock_test_id, score_percent, correct_count, total_count, completed_at)
     VALUES (?, ?, ?, ?, ?, NOW())`,
    [req.user.id, id, scorePercent, correct, total]
  ).catch(() => [{ insertId: 0 }]);

  res.json({
    success: true,
    data: {
      attemptId: result.insertId,
      scorePercent,
      correct,
      total,
    },
  });
};

module.exports = { list, detail, myAttempts, submit };
