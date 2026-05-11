const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/lesson.controller');

// GET /api/enrollments — Khoá học của tôi
router.get('/', ctrl.myEnrollments);

module.exports = router;
