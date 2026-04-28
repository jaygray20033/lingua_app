const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/words.controller');

// GET /api/words?language=ja&level=N5&search=食べる&page=1&limit=20
router.get('/', ctrl.getWords);
router.get('/:id', ctrl.getWordById);
router.get('/character/:char', ctrl.getCharacter);

module.exports = router;
