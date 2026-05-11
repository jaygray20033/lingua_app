const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/mydecks.controller');

// GET /api/srs/decks
router.get('/decks', ctrl.srsDecks);

// GET /api/srs/due?deckId=&limit=
router.get('/due', ctrl.srsDue);

// POST /api/srs/:reviewId/review { rating: 'AGAIN'|'HARD'|'GOOD'|'EASY' }
router.post('/:reviewId/review', ctrl.srsReview);

module.exports = router;
