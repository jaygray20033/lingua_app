const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/lesson.controller');

router.get('/', ctrl.getCourses);
router.get('/:courseId', ctrl.getCourseDetail);

// 1.5 — GET /api/courses/:courseId/enrollment
router.get('/:courseId/enrollment', ctrl.getEnrollment);

// 1.2 — GET /api/courses/:courseId/path
router.get('/:courseId/path', ctrl.getCoursePath);

router.post('/:courseId/enroll', ctrl.enrollCourse);
router.delete('/:courseId/enroll', ctrl.unenrollCourse);

module.exports = router;
