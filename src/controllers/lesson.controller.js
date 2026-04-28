const db = require('../config/database');
const gamService = require('../services/gamification.service');

const getCourses = async (req, res) => {
  const { language, level, certification } = req.query;
  let query = `
    SELECT c.*, l.code as lang_code, l.flag_emoji,
      (SELECT COUNT(*) FROM enrollments e WHERE e.course_id = c.id AND e.user_id = ?) as is_enrolled,
      u.display_name as author_name
    FROM courses c
    JOIN languages l ON l.id = c.target_lang_id
    LEFT JOIN users u ON u.id = c.author_id
    WHERE c.status = 'PUBLISHED'
  `;
  const params = [req.user?.id || 0];
  if (language) { query += ' AND l.code = ?'; params.push(language); }
  if (level) { query += ' AND c.level_code = ?'; params.push(level); }
  if (certification) { query += ' AND c.certification = ?'; params.push(certification); }
  query += ' ORDER BY c.total_enrollments DESC LIMIT 50';

  const [rows] = await db.query(query, params);
  res.json({ success: true, data: rows });
};

const getCourseDetail = async (req, res) => {
  const { courseId } = req.params;
  const [rows] = await db.query(
    `SELECT c.*, l.code as lang_code, l.name as lang_name, l.flag_emoji
     FROM courses c JOIN languages l ON l.id = c.target_lang_id
     WHERE c.id = ?`,
    [courseId]
  );
  if (!rows.length) return res.status(404).json({ success: false, message: 'Cours non trouvé' });

  const [sections] = await db.query(
    `SELECT s.*, 
      (SELECT COUNT(*) FROM units u WHERE u.section_id = s.id) as unit_count
     FROM sections s WHERE s.course_id = ? ORDER BY s.order_index`,
    [courseId]
  );

  for (const section of sections) {
    const [units] = await db.query(
      `SELECT u.*,
        (SELECT COUNT(*) FROM lessons l WHERE l.unit_id = u.id) as lesson_count,
        (SELECT COUNT(*) FROM user_lesson_progress ulp 
         JOIN lessons l ON l.id = ulp.lesson_id 
         WHERE l.unit_id = u.id AND ulp.user_id = ? AND ulp.completion_count > 0) as completed_lessons
       FROM units u WHERE u.section_id = ? ORDER BY u.order_index`,
      [req.user?.id || 0, section.id]
    );
    section.units = units;
  }

  res.json({ success: true, data: { ...rows[0], sections } });
};

const getLessonExercises = async (req, res) => {
  const { lessonId } = req.params;
  const [lesson] = await db.query('SELECT * FROM lessons WHERE id = ?', [lessonId]);
  if (!lesson.length) return res.status(404).json({ success: false, message: 'Leçon non trouvée' });

  const [exercises] = await db.query(
    'SELECT * FROM exercises WHERE lesson_id = ? ORDER BY order_index',
    [lessonId]
  );

  res.json({
    success: true,
    data: {
      lesson: lesson[0],
      exercises: exercises.map(e => ({
        ...e,
        prompt_json: typeof e.prompt_json === 'string' ? JSON.parse(e.prompt_json) : e.prompt_json,
        answer_json: typeof e.answer_json === 'string' ? JSON.parse(e.answer_json) : e.answer_json,
        hint_json: e.hint_json ? (typeof e.hint_json === 'string' ? JSON.parse(e.hint_json) : e.hint_json) : null
      }))
    }
  });
};

const startLesson = async (req, res) => {
  const { lessonId } = req.params;
  const [result] = await db.query(
    'INSERT INTO lesson_attempts (user_id, lesson_id) VALUES (?, ?)',
    [req.user.id, lessonId]
  );
  res.status(201).json({ success: true, data: { attemptId: result.insertId } });
};

const submitAnswer = async (req, res) => {
  const { attemptId } = req.params;
  const { exerciseId, userAnswer, timeMs, hintsUsed = 0 } = req.body;

  // Get correct answer
  const [exercises] = await db.query(
    'SELECT * FROM exercises WHERE id = ?',
    [exerciseId]
  );
  if (!exercises.length) return res.status(404).json({ success: false, message: 'Exercice non trouvé' });

  const exercise = exercises[0];
  const answerData = typeof exercise.answer_json === 'string'
    ? JSON.parse(exercise.answer_json)
    : exercise.answer_json;

  const isCorrect = checkAnswer(userAnswer, answerData);

  await db.query(
    'INSERT INTO answer_logs (attempt_id, exercise_id, user_answer, is_correct, time_ms, hints_used) VALUES (?, ?, ?, ?, ?, ?)',
    [attemptId, exerciseId, userAnswer, isCorrect ? 1 : 0, timeMs || 0, hintsUsed]
  );

  if (!isCorrect) {
    try {
      await gamService.loseHeart(req.user.id);
    } catch (e) {
      return res.json({ success: true, data: { isCorrect, noHearts: true, message: e.message } });
    }
  }

  res.json({ success: true, data: { isCorrect, correctAnswer: answerData } });
};

const completeLesson = async (req, res) => {
  const { attemptId } = req.params;

  const [attempts] = await db.query(
    'SELECT * FROM lesson_attempts WHERE id = ? AND user_id = ?',
    [attemptId, req.user.id]
  );
  if (!attempts.length) return res.status(404).json({ success: false, message: 'Tentative non trouvée' });

  const attempt = attempts[0];

  // Calculate score
  const [answerStats] = await db.query(
    `SELECT COUNT(*) as total, SUM(is_correct) as correct
     FROM answer_logs WHERE attempt_id = ?`,
    [attemptId]
  );
  const { total, correct } = answerStats[0];
  const scorePercent = total > 0 ? Math.round((correct / total) * 100) : 100;

  // Get lesson XP
  const [lessons] = await db.query('SELECT xp_reward FROM lessons WHERE id = ?', [attempt.lesson_id]);
  const xpReward = scorePercent >= 80 ? (lessons[0]?.xp_reward || 10) : Math.floor((lessons[0]?.xp_reward || 10) * 0.5);

  await db.query(
    `UPDATE lesson_attempts SET status = 'COMPLETED', score_percent = ?, xp_earned = ?, completed_at = NOW() WHERE id = ?`,
    [scorePercent, xpReward, attemptId]
  );

  await db.query(
    `INSERT INTO user_lesson_progress (user_id, lesson_id, completion_count, best_score, last_completed_at)
     VALUES (?, ?, 1, ?, NOW())
     ON DUPLICATE KEY UPDATE
       completion_count = completion_count + 1,
       best_score = GREATEST(best_score, ?),
       is_legendary = IF(? >= 100, 1, is_legendary),
       last_completed_at = NOW()`,
    [req.user.id, attempt.lesson_id, scorePercent, scorePercent, scorePercent]
  );

  await gamService.addXP(req.user.id, xpReward);
  await gamService.updateStreak(req.user.id);

  res.json({ success: true, data: { scorePercent, xpEarned: xpReward } });
};

const checkAnswer = (userAnswer, answerData) => {
  if (!userAnswer || !answerData) return false;
  const correct = answerData.correct || answerData;
  if (Array.isArray(correct)) {
    return correct.some(a => a.toString().toLowerCase().trim() === userAnswer.toString().toLowerCase().trim());
  }
  return correct.toString().toLowerCase().trim() === userAnswer.toString().toLowerCase().trim();
};

const getMockTests = async (req, res) => {
  const { language, type, level } = req.query;
  let query = `
    SELECT mt.*, l.code as lang_code, l.flag_emoji
    FROM mock_tests mt JOIN languages l ON l.id = mt.language_id
    WHERE 1=1
  `;
  const params = [];
  if (language) { query += ' AND l.code = ?'; params.push(language); }
  if (type) { query += ' AND mt.type = ?'; params.push(type); }
  if (level) { query += ' AND mt.level_code = ?'; params.push(level); }
  query += ' ORDER BY mt.id';

  const [rows] = await db.query(query, params);
  res.json({ success: true, data: rows });
};

module.exports = { getCourses, getCourseDetail, getLessonExercises, startLesson, submitAnswer, completeLesson, getMockTests };
