const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/mydecks.controller');

// GET /api/my-decks
router.get('/', ctrl.list);

// POST /api/my-decks
router.post('/', ctrl.create);

// GET /api/my-decks/:deckId/cards
router.get('/:deckId/cards', ctrl.getCards);

// POST /api/my-decks/:deckId/cards
router.post('/:deckId/cards', ctrl.addCard);

// 1.6 — POST /api/my-decks/:deckId/start
router.post('/:deckId/start', ctrl.startSession);

// DELETE /api/my-decks/:deckId
router.delete('/:deckId', ctrl.remove);

// DELETE /api/my-decks/:deckId/cards/:cardId
router.delete('/:deckId/cards/:cardId', ctrl.removeCard);

module.exports = router;
