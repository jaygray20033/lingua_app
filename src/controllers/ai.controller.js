const aiService = require('../services/ai.service');
const db = require('../config/database');

const explainGrammar = async (req, res) => {
  const { text, context, language = 'ja' } = req.body;
  if (!text) return res.status(400).json({ success: false, message: 'text requis' });

  const result = await aiService.explainGrammar(text, context, language);
  res.json({ success: true, data: result });
};

const getScenarios = async (req, res) => {
  const { language, level } = req.query;
  let query = 'SELECT rs.*, l.code as lang_code, l.flag_emoji FROM roleplay_scenarios rs JOIN languages l ON l.id = rs.language_id WHERE 1=1';
  const params = [];
  if (language) { query += ' AND l.code = ?'; params.push(language); }
  if (level) { query += ' AND rs.level_code = ?'; params.push(level); }
  // Filter premium
  if (req.user.role !== 'PREMIUM' && req.user.role !== 'ADMIN') {
    query += ' AND rs.is_premium = 0';
  }
  query += ' ORDER BY rs.id';
  const [rows] = await db.query(query, params);
  res.json({ success: true, data: rows });
};

const startSession = async (req, res) => {
  const { scenarioId, language, type = 'ROLEPLAY' } = req.body;
  const [result] = await db.query(
    'INSERT INTO ai_sessions (user_id, type, scenario_id, language_id) VALUES (?, ?, ?, (SELECT id FROM languages WHERE code = ?))',
    [req.user.id, type, scenarioId || null, language || 'ja']
  );
  res.status(201).json({ success: true, data: { sessionId: result.insertId } });
};

const chatStream = async (req, res) => {
  const { sessionId } = req.params;
  const { message } = req.body;

  if (!message) return res.status(400).json({ success: false, message: 'message requis' });

  // Get session
  const [sessions] = await db.query(
    'SELECT s.*, rs.context_prompt, rs.goal FROM ai_sessions s LEFT JOIN roleplay_scenarios rs ON rs.id = s.scenario_id WHERE s.id = ? AND s.user_id = ?',
    [sessionId, req.user.id]
  );
  if (!sessions.length) return res.status(404).json({ success: false, message: 'Session non trouvée' });

  const session = sessions[0];

  // Get message history
  const [history] = await db.query(
    'SELECT role, content FROM ai_messages WHERE session_id = ? ORDER BY created_at ASC LIMIT 20',
    [sessionId]
  );

  // Save user message
  await db.query(
    'INSERT INTO ai_messages (session_id, role, content) VALUES (?, "USER", ?)',
    [sessionId, message]
  );
  await db.query('UPDATE ai_sessions SET messages_count = messages_count + 1 WHERE id = ?', [sessionId]);

  const scenario = session.context_prompt
    ? { context_prompt: session.context_prompt, goal: session.goal }
    : null;

  // Stream response
  await aiService.chatRoleplayStream(res, {
    scenario,
    messages: [...history, { role: 'USER', content: message }],
    language: session.language_code
  });

  // Save AI response (async, after stream)
  // Note: In production, capture the full response and save it
};

const explainAnswer = async (req, res) => {
  const { exercise, userAnswer, correctAnswer, language = 'ja', answerLogId } = req.body;
  if (!exercise || !correctAnswer) {
    return res.status(400).json({ success: false, message: 'exercise et correctAnswer requis' });
  }

  const result = await aiService.explainAnswer(exercise, userAnswer, correctAnswer, language);

  // Save explanation
  if (answerLogId) {
    await db.query(
      'INSERT INTO ai_explanations (user_id, answer_log_id, explanation_text, tokens_used) VALUES (?, ?, ?, ?)',
      [req.user.id, answerLogId, result.explanation, result.tokensUsed]
    );
  }

  res.json({ success: true, data: result });
};

const generateStudyPlan = async (req, res) => {
  const { language, level, dailyMinutes, targetDate, weakPoints } = req.body;
  if (!language || !level) {
    return res.status(400).json({ success: false, message: 'language et level requis' });
  }

  const plan = await aiService.generateStudyPlan({ language, level, dailyMinutes, targetDate, weakPoints });
  res.json({ success: true, data: plan });
};

module.exports = { explainGrammar, getScenarios, startSession, chatStream, explainAnswer, generateStudyPlan };
