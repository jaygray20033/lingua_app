const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/lesson.controller');

router.get('/', ctrl.getCourses);
router.get('/:courseId', ctrl.getCourseDetail);

module.exports = router;
