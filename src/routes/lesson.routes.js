const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/lesson.controller');

router.get('/mock-tests', ctrl.getMockTests);
router.get('/:lessonId/exercises', ctrl.getLessonExercises);
router.post('/:lessonId/start', ctrl.startLesson);
router.post('/attempts/:attemptId/answer', ctrl.submitAnswer);
router.post('/attempts/:attemptId/complete', ctrl.completeLesson);

module.exports = router;
