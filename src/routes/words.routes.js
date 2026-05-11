const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/words.controller');

// GET /api/words?language=ja&level=N5&search=食べる&page=1&limit=20
// Compatible aussi avec ?lang=ja&q=食べru
router.get('/', ctrl.getWords);

// 1.7 — Alias rétrocompatible: GET /api/words/search?q=...&lang=...
router.get('/search', ctrl.searchWords);

// BUG B5 FIX: La route /character/:char doit être enregistrée AVANT /:id
// sinon Express l'interprète comme /:id avec id="character" et renvoie 404.
router.get('/character/:char', ctrl.getCharacter);

// 2.5 — GET /api/words/:id/examples
router.get('/:id/examples', ctrl.getWordExamples);

router.get('/:id', ctrl.getWordById);

module.exports = router;
