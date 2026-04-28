const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/flashcard.controller');

router.get('/decks', ctrl.getDecks);
router.post('/decks', ctrl.createDeck);
router.get('/decks/:deckId/cards', ctrl.getDeckCards);
router.post('/decks/:deckId/cards', ctrl.addCard);
router.post('/cards/:cardId/review', ctrl.reviewCard);

module.exports = router;
