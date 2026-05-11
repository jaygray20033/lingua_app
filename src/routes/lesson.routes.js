const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/lesson.controller');

// Backward-compat: GET /api/lessons/mock-tests
router.get('/mock-tests', ctrl.getMockTests);

// 1.3 — GET /api/lessons/review-queue
router.get('/review-queue', ctrl.getReviewQueue);

router.get('/:lessonId/exercises', ctrl.getLessonExercises);

// 2.3 — Lesson attempt flow (Android)
router.post('/:lessonId/start', ctrl.startLesson);
router.post('/attempts/:attemptId/answer', ctrl.submitAnswer);
router.post('/attempts/:attemptId/complete', ctrl.completeLesson);

// Backward-compat: POST /api/lessons/:lessonId/complete (legacy path)
router.post('/:lessonId/complete', ctrl.completeLessonLegacy);

module.exports = router;
