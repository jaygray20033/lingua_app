const aiService = require('../services/ai.service');
const db = require('../config/database');

// 2.4 — POST /api/ai/explain { text, context?, language? }
const explainGrammar = async (req, res) => {
  const { text, context, language } = req.body;
  if (!text) return res.status(400).json({ success: false, message: 'Thiếu nội dung cần giải thích' });
  const result = await aiService.explainGrammar(text, context || '', language || 'ja');
  res.json({ success: true, data: result });
};

// 2.4 — GET /api/ai/scenarios?language=&level=
const getScenarios = async (req, res) => {
  const { language, level } = req.query;
  let sql = 'SELECT * FROM roleplay_scenarios WHERE 1=1';
  const params = [];
  if (language) {
    sql += ' AND language_id = (SELECT id FROM languages WHERE code = ? LIMIT 1)';
    params.push(language);
  }
  if (level) { sql += ' AND level = ?'; params.push(level); }
  const [rows] = await db.query(sql, params);
  res.json({ success: true, data: rows });
};

// 2.4 — POST /api/ai/sessions { scenarioId }
const startSession = async (req, res) => {
  const { scenarioId } = req.body;
  if (!scenarioId) {
    return res.status(400).json({ success: false, message: 'Thiếu scenarioId' });
  }
  const [result] = await db.query(
    `INSERT INTO ai_sessions (user_id, scenario_id) VALUES (?, ?)`,
    [req.user.id, scenarioId]
  );
  // Charger les infos du scénario pour Android
  const [scenario] = await db.query(
    'SELECT id, title, level, context_prompt, goal FROM roleplay_scenarios WHERE id = ?',
    [scenarioId]
  );
  res.json({
    success: true,
    data: {
      sessionId: result.insertId,
      scenario: scenario[0] || null,
    },
  });
};

// POST /api/ai/sessions/:sessionId/chat (SSE)
const chatStream = async (req, res) => {
  const { sessionId } = req.params;
  const { message } = req.body;
  if (!message) {
    return res.status(400).json({ success: false, message: 'Thiếu nội dung tin nhắn' });
  }

  // BUG B12 FIX: vérifier la session AVANT d'insérer le message utilisateur,
  // sinon un attaquant pourrait injecter des messages dans la session d'un
  // autre utilisateur (le 404 arriverait après l'INSERT).
  const [sessionRows] = await db.query(
    `SELECT s.*, sc.context_prompt, sc.goal, sc.title, sc.level,
            l.code as lang_code
     FROM ai_sessions s
     LEFT JOIN roleplay_scenarios sc ON sc.id = s.scenario_id
     LEFT JOIN languages l ON l.id = sc.language_id
     WHERE s.id = ? AND s.user_id = ?`,
    [sessionId, req.user.id]
  );
  if (!sessionRows.length) {
    return res.status(404).json({ success: false, message: 'Phiên không tồn tại' });
  }
  const session = sessionRows[0];

  // Une fois la session vérifiée, on peut sauvegarder le message utilisateur
  await db.query(
    'INSERT INTO ai_messages (session_id, role, content) VALUES (?, ?, ?)',
    [sessionId, 'user', message]
  );

  // Charger l'historique
  const [history] = await db.query(
    'SELECT role, content FROM ai_messages WHERE session_id = ? ORDER BY id',
    [sessionId]
  );

  // Stream via le service (qui gère lui-même les headers SSE et la persistance)
  await aiService.chatRoleplayStream(res, {
    scenario: session.context_prompt
      ? { context_prompt: session.context_prompt, goal: session.goal }
      : null,
    messages: history.map(m => ({
      role: m.role === 'assistant' ? 'AI' : 'user',
      content: m.content,
    })),
    language: session.lang_code || 'ja',
  });

  // Note: la sauvegarde de la réponse de l'IA se fait via l'event 'done' côté client
  // ou peut être ajoutée ici si on veut écouter le 'fullContent'
};

// 2.4 — POST /api/ai/explain-answer { question/exercise, userAnswer, correctAnswer, language? }
const explainAnswer = async (req, res) => {
  const { question, exercise, userAnswer, correctAnswer, language } = req.body;
  const exText = exercise || question;
  if (!exText || correctAnswer === undefined) {
    return res.status(400).json({ success: false, message: 'Thiếu thông tin bài tập hoặc đáp án' });
  }
  const result = await aiService.explainAnswer(exText, userAnswer, correctAnswer, language || 'ja');
  res.json({ success: true, data: result });
};

// 2.4 — POST /api/ai/study-plan { language, level, dailyMinutes/hoursPerDay, targetDate?, weakPoints? }
const generateStudyPlan = async (req, res) => {
  const { language, level, targetDate, weakPoints, goals } = req.body;
  // Compatibilité Android: hoursPerDay (en heures) → dailyMinutes
  let dailyMinutes = req.body.dailyMinutes;
  if (!dailyMinutes && req.body.hoursPerDay) {
    dailyMinutes = Math.round(parseFloat(req.body.hoursPerDay) * 60);
  }
  if (!dailyMinutes) dailyMinutes = 30;

  const plan = await aiService.generateStudyPlan({
    language: language || 'ja',
    level: level || 'beginner',
    dailyMinutes,
    targetDate: targetDate || null,
    weakPoints: weakPoints || (goals ? [goals] : []),
  });
  res.json({ success: true, data: plan });
};

module.exports = {
  explainGrammar, getScenarios, startSession, chatStream, explainAnswer, generateStudyPlan,
};
