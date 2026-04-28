const express = require('express');
const router = express.Router();

const { authenticate } = require('../middleware/auth');

// Health check
router.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString(), service: 'Lingua API v1.0' });
});

// Auth routes
router.use('/auth', require('./auth.routes'));

// Protected routes
router.use('/words', authenticate, require('./words.routes'));
router.use('/flashcards', authenticate, require('./flashcard.routes'));
router.use('/gamification', authenticate, require('./gamification.routes'));
router.use('/ai', authenticate, require('./ai.routes'));
router.use('/lessons', authenticate, require('./lesson.routes'));
router.use('/courses', authenticate, require('./course.routes'));

module.exports = router;
