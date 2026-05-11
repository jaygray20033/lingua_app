const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/mocktest.controller');

// GET /api/mock-tests?language=ja&type=JLPT
router.get('/', ctrl.list);

// 1.4 — GET /api/mock-tests/attempts (DOIT précéder /:id)
router.get('/attempts', ctrl.myAttempts);

// GET /api/mock-tests/:id
router.get('/:id', ctrl.detail);

// POST /api/mock-tests/:id/submit
router.post('/:id/submit', ctrl.submit);

module.exports = router;
