const db = require('../config/database');
const cache = require('../config/redis');
const gamService = require('../services/gamification.service');

const safeJson = (v) => { try { return typeof v === 'string' ? JSON.parse(v) : v; } catch { return v; } };

const getCourses = async (req, res) => {
  const cacheKey = `courses:all`;
  const cached = await cache.get(cacheKey);
  if (cached) return res.json({ success: true, data: JSON.parse(cached) });

  const [rows] = await db.query(
    `SELECT c.*, l.code as lang_code, l.name as lang_name, l.flag_emoji
     FROM courses c JOIN languages l ON l.id = c.target_lang_id
     ORDER BY c.id`
  );
  await cache.set(cacheKey, JSON.stringify(rows), { EX: 600 });
  res.json({ success: true, data: rows });
};

const getCourseDetail = async (req, res) => {
  const { courseId } = req.params;
  const [rows] = await db.query(
    `SELECT c.*, l.code as lang_code, l.name as lang_name, l.flag_emoji
     FROM courses c JOIN languages l ON l.id = c.target_lang_id
     WHERE c.id = ?`, [courseId]
  );
  if (!rows.length) return res.status(404).json({ success: false, message: 'Không tìm thấy khoá học' });

  const course = rows[0];
  const [sections] = await db.query('SELECT * FROM sections WHERE course_id = ? ORDER BY order_index', [courseId]);
  for (const section of sections) {
    const [units] = await db.query(
      `SELECT u.*, 
        (SELECT COUNT(*) FROM lessons WHERE unit_id = u.id) as lesson_count,
        (SELECT COUNT(*) FROM lesson_attempts la JOIN lessons l ON l.id = la.lesson_id WHERE l.unit_id = u.id AND la.user_id = ? AND la.status = 'COMPLETED') as completed_lessons
       FROM units u WHERE u.section_id = ? ORDER BY u.order_index`,
      [req.user?.id || 0, section.id]
    );
    section.units = units;
  }
  course.sections = sections;
  res.json({ success: true, data: course });
};

const enrollCourse = async (req, res) => {
  const { courseId } = req.params;
  const [course] = await db.query('SELECT id FROM courses WHERE id = ?', [courseId]);
  if (!course.length) return res.status(404).json({ success: false, message: 'Không tìm thấy khoá học' });

  await db.query(
    `INSERT INTO enrollments (user_id, course_id) VALUES (?, ?)
     ON DUPLICATE KEY UPDATE status = 'ACTIVE'`,
    [req.user.id, courseId]
  );
  await db.query('UPDATE courses SET total_enrollments = total_enrollments + 1 WHERE id = ?', [courseId]);
  res.json({ success: true, message: 'Đã đăng ký khoá học' });
};

const getLessonExercises = async (req, res) => {
  const { lessonId } = req.params;

  // Access control: check enrollment or free preview
  const [lesson] = await db.query(
    `SELECT l.*, u.section_id FROM lessons l JOIN units u ON u.id = l.unit_id WHERE l.id = ?`, [lessonId]
  );
  if (!lesson.length) return res.status(404).json({ success: false, message: 'Không tìm thấy bài học' });

  if (!lesson[0].is_free_preview) {
    const [enrolled] = await db.query(
      `SELECT 1 FROM enrollments e JOIN sections s ON s.course_id = e.course_id
       WHERE e.user_id = ? AND s.id = ? AND e.status = 'ACTIVE' LIMIT 1`,
      [req.user.id, lesson[0].section_id]
    );
    if (!enrolled.length) {
      return res.status(403).json({ success: false, message: 'Bạn chưa đăng ký khoá học này' });
    }
  }

  const [exercises] = await db.query(
    'SELECT * FROM exercises WHERE lesson_id = ? ORDER BY order_index', [lessonId]
  );
  res.json({
    success: true,
    data: {
      lesson: lesson[0],
      exercises: exercises.map(e => ({
        ...e,
        prompt_json: safeJson(e.prompt_json),
        correct_answer_json: safeJson(e.correct_answer_json),
        options_json: safeJson(e.options_json),
        hint_json: safeJson(e.hint_json),
      })),
    },
  });
};

const startLesson = async (req, res) => {
  const { lessonId } = req.params;

  // BUG B10 FIX: vérifier l'enrollment avant de créer un attempt
  // (sinon un user pouvait commencer un cours qu'il n'a pas acheté).
  const [lesson] = await db.query(
    `SELECT l.*, u.section_id FROM lessons l JOIN units u ON u.id = l.unit_id WHERE l.id = ?`,
    [lessonId]
  );
  if (!lesson.length) return res.status(404).json({ success: false, message: 'Không tìm thấy bài học' });

  if (!lesson[0].is_free_preview) {
    const [enrolled] = await db.query(
      `SELECT 1 FROM enrollments e JOIN sections s ON s.course_id = e.course_id
       WHERE e.user_id = ? AND s.id = ? AND e.status = 'ACTIVE' LIMIT 1`,
      [req.user.id, lesson[0].section_id]
    );
    if (!enrolled.length) {
      return res.status(403).json({ success: false, message: 'Bạn chưa đăng ký khoá học này' });
    }
  }

  const [result] = await db.query(
    `INSERT INTO lesson_attempts (user_id, lesson_id, status) VALUES (?, ?, 'IN_PROGRESS')`,
    [req.user.id, lessonId]
  );
  await gamService.updateStreak(req.user.id);
  res.json({ success: true, data: { attemptId: result.insertId } });
};

const submitAnswer = async (req, res) => {
  const { attemptId } = req.params;
  const { exerciseId, userAnswer, timeMs } = req.body;

  // BUG B9 FIX: vérifier que l'attempt appartient bien à l'utilisateur courant
  // afin d'empêcher une élévation de privilèges (un user qui devine
  // l'attemptId d'un autre user pouvait poster des réponses dans son tentative).
  const [attemptCheck] = await db.query(
    'SELECT id FROM lesson_attempts WHERE id = ? AND user_id = ?',
    [attemptId, req.user.id]
  );
  if (!attemptCheck.length) {
    return res.status(403).json({ success: false, message: 'Bạn không có quyền truy cập tiến trình này' });
  }

  const [ex] = await db.query('SELECT * FROM exercises WHERE id = ?', [exerciseId]);
  if (!ex.length) return res.status(404).json({ success: false, message: 'Bài tập không tồn tại' });

  const correctAnswer = safeJson(ex[0].correct_answer_json);
  let isCorrect = false;
  if (typeof correctAnswer === 'string') {
    isCorrect = userAnswer?.toString().trim().toLowerCase() === correctAnswer.trim().toLowerCase();
  } else if (correctAnswer?.answer) {
    isCorrect = userAnswer?.toString().trim().toLowerCase() === correctAnswer.answer.trim().toLowerCase();
  } else if (Array.isArray(correctAnswer)) {
    isCorrect = correctAnswer.some(a => a.toString().trim().toLowerCase() === userAnswer?.toString().trim().toLowerCase());
  }

  await db.query(
    `INSERT INTO exercise_responses (attempt_id, exercise_id, user_answer, is_correct, response_time_ms) VALUES (?, ?, ?, ?, ?)`,
    [attemptId, exerciseId, JSON.stringify(userAnswer), isCorrect, timeMs || 0]
  );

  // BUG B1 FIX: Ne plus appeler loseHeart côté serveur — c'est l'app Android
  // qui gère la perte de cœur via POST /api/gamification/hearts/lose.
  // Sinon une mauvaise réponse coûterait 2 cœurs au lieu d'1.

  res.json({
    success: true,
    data: {
      isCorrect,
      correctAnswer,
      explanation: ex[0].explanation || null,
    },
  });
};

const completeLesson = async (req, res) => {
  const { attemptId } = req.params;

  // BUG B9 FIX: vérifier l'ownership de l'attempt
  const [attempt] = await db.query(
    'SELECT lesson_id FROM lesson_attempts WHERE id = ? AND user_id = ?',
    [attemptId, req.user.id]
  );
  if (!attempt.length) {
    return res.status(403).json({ success: false, message: 'Bạn không có quyền hoàn thành tiến trình này' });
  }

  const [responses] = await db.query(
    'SELECT is_correct FROM exercise_responses WHERE attempt_id = ?', [attemptId]
  );
  const total = responses.length || 1;
  const correct = responses.filter(r => r.is_correct).length;
  const scorePercent = Math.round((correct / total) * 100);

  const [lesson] = await db.query('SELECT xp_reward FROM lessons WHERE id = ?', [attempt[0].lesson_id]);
  const xpReward = lesson.length ? lesson[0].xp_reward : 10;

  await db.query(
    `UPDATE lesson_attempts SET status = 'COMPLETED', score_percent = ?, xp_earned = ?, completed_at = NOW() WHERE id = ?`,
    [scorePercent, xpReward, attemptId]
  );

  // BUG B20 FIX: also bump the streak counter on completion. Otherwise users
  // who finish a lesson but never call /streak directly would lose their daily
  // streak even though they were active that day.
  await gamService.updateStreak(req.user.id);
  await gamService.addXP(req.user.id, xpReward, 'LESSON_COMPLETE');

  res.json({ success: true, data: { scorePercent, xpEarned: xpReward } });
};

const getMockTests = async (req, res) => {
  const { language, type } = req.query;
  let sql = 'SELECT * FROM mock_tests WHERE 1=1';
  const params = [];
  if (language) { sql += ' AND lang_code = ?'; params.push(language); }
  if (type) { sql += ' AND type = ?'; params.push(type); }
  sql += ' ORDER BY id';
  const [rows] = await db.query(sql, params);
  res.json({ success: true, data: rows });
};

// 1.5 — GET /api/courses/:courseId/enrollment
const getEnrollment = async (req, res) => {
  const { courseId } = req.params;
  const [rows] = await db.query(
    `SELECT e.*, c.title as course_title
     FROM enrollments e JOIN courses c ON c.id = e.course_id
     WHERE e.user_id = ? AND e.course_id = ?`,
    [req.user.id, courseId]
  );
  if (!rows.length) {
    return res.json({ success: true, data: { enrolled: false, progressPercent: 0 } });
  }
  const enrollment = rows[0];

  // Calculer progress %
  const [totalRow] = await db.query(
    `SELECT COUNT(*) as total FROM lessons l
     JOIN units u ON u.id = l.unit_id
     JOIN sections s ON s.id = u.section_id
     WHERE s.course_id = ?`, [courseId]
  );
  const [completedRow] = await db.query(
    `SELECT COUNT(DISTINCT la.lesson_id) as completed
     FROM lesson_attempts la
     JOIN lessons l ON l.id = la.lesson_id
     JOIN units u ON u.id = l.unit_id
     JOIN sections s ON s.id = u.section_id
     WHERE la.user_id = ? AND s.course_id = ? AND la.status = 'COMPLETED'`,
    [req.user.id, courseId]
  );
  const total = totalRow[0]?.total || 0;
  const completed = completedRow[0]?.completed || 0;
  const progressPercent = total > 0 ? Math.round((completed / total) * 100) : 0;

  res.json({
    success: true,
    data: {
      enrolled: true,
      enrollment,
      progressPercent,
      totalLessons: total,
      completedLessons: completed,
    },
  });
};

// 1.5 — GET /api/courses/:courseId/path (lộ trình học)
const getCoursePath = async (req, res) => {
  const { courseId } = req.params;
  const [sections] = await db.query(
    'SELECT * FROM sections WHERE course_id = ? ORDER BY order_index', [courseId]
  );
  for (const section of sections) {
    const [units] = await db.query(
      'SELECT * FROM units WHERE section_id = ? ORDER BY order_index', [section.id]
    );
    for (const unit of units) {
      const [lessons] = await db.query(
        `SELECT l.id, l.title, l.lesson_type, l.xp_reward, l.is_free_preview,
          (SELECT status FROM lesson_attempts WHERE lesson_id = l.id AND user_id = ?
            ORDER BY id DESC LIMIT 1) as last_status
         FROM lessons l WHERE l.unit_id = ? ORDER BY l.order_index`,
        [req.user.id, unit.id]
      );
      unit.lessons = lessons;
    }
    section.units = units;
  }
  res.json({ success: true, data: { sections } });
};

// DELETE /api/courses/:courseId/enroll
const unenrollCourse = async (req, res) => {
  const { courseId } = req.params;
  await db.query(
    "UPDATE enrollments SET status = 'CANCELLED' WHERE user_id = ? AND course_id = ?",
    [req.user.id, courseId]
  );
  res.json({ success: true, message: 'Đã huỷ đăng ký khoá học' });
};

// GET /api/enrollments — 1.2 — Khoá học của tôi
const myEnrollments = async (req, res) => {
  const [rows] = await db.query(
    `SELECT e.*, c.title, c.target_lang_id, c.cover_url, l.code as lang_code, l.flag_emoji
     FROM enrollments e
     JOIN courses c ON c.id = e.course_id
     LEFT JOIN languages l ON l.id = c.target_lang_id
     WHERE e.user_id = ? AND e.status = 'ACTIVE'
     ORDER BY e.id DESC`,
    [req.user.id]
  );
  res.json({ success: true, data: rows });
};

// 1.3 — GET /api/lessons/review-queue
const getReviewQueue = async (req, res) => {
  // Bài học đã hoàn thành >= 7 ngày trước, hoặc score < 80%
  const [rows] = await db.query(
    `SELECT DISTINCT l.id, l.title, l.lesson_type, l.xp_reward,
       la.score_percent, la.completed_at,
       u.title as unit_title,
       (CASE
          WHEN la.score_percent < 80 THEN 'low_score'
          WHEN DATEDIFF(NOW(), la.completed_at) >= 7 THEN 'spaced_review'
          ELSE 'review'
       END) as reason
     FROM lesson_attempts la
     JOIN lessons l ON l.id = la.lesson_id
     LEFT JOIN units u ON u.id = l.unit_id
     WHERE la.user_id = ?
       AND la.status = 'COMPLETED'
       AND (la.score_percent < 80 OR DATEDIFF(NOW(), la.completed_at) >= 7)
     ORDER BY la.completed_at ASC LIMIT 30`,
    [req.user.id]
  );
  res.json({ success: true, data: rows });
};

// Backward-compat: ancien path POST /api/lessons/:lessonId/complete (sans attempt)
// Crée un attempt à la volée si l'Android utilise encore l'ancien format
const completeLessonLegacy = async (req, res) => {
  const { lessonId } = req.params;
  const { scorePercent = 100, xpEarned } = req.body || {};

  const [result] = await db.query(
    `INSERT INTO lesson_attempts (user_id, lesson_id, status, score_percent, xp_earned, completed_at)
     VALUES (?, ?, 'COMPLETED', ?, ?, NOW())`,
    [req.user.id, lessonId, scorePercent, xpEarned || 10]
  );

  const [lesson] = await db.query('SELECT xp_reward FROM lessons WHERE id = ?', [lessonId]);
  const xp = xpEarned || (lesson.length ? lesson[0].xp_reward : 10);

  await gamService.updateStreak(req.user.id);
  await gamService.addXP(req.user.id, xp, 'LESSON_COMPLETE');

  res.json({
    success: true,
    data: { attemptId: result.insertId, scorePercent, xpEarned: xp },
  });
};

module.exports = {
  getCourses, getCourseDetail, enrollCourse, unenrollCourse,
  getEnrollment, getCoursePath, myEnrollments,
  getLessonExercises, startLesson, submitAnswer, completeLesson, completeLessonLegacy,
  getMockTests, getReviewQueue,
};
