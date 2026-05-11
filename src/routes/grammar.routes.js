const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/grammar.controller');

// GET /api/grammars?language=ja&level=N5&search=...
router.get('/', ctrl.list);

// GET /api/grammars/:id
router.get('/:id', ctrl.detail);

// 3.7 — GET /api/grammars/:id/exercises
router.get('/:id/exercises', ctrl.getExercises);

module.exports = router;
