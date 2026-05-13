const express = require('express');
const router = express.Router();
const multer = require('multer');

const { authenticate } = require('../middleware/auth');

// Health check
router.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString(), service: 'Lingua API v1.1' });
});

// Auth routes (publiques + /change-password protégée)
router.use('/auth', require('./auth.routes'));

// U13 FIX — POST /api/upload/avatar (multipart/form-data OR JSON avatarBase64).
// Monté ici (pas dans auth.routes) pour suivre la spec `/api/upload/avatar`.
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 2 * 1024 * 1024 }, // 2 MB
});
const authCtrl = require('../controllers/auth.controller');
router.post(
  '/upload/avatar',
  authenticate,
  upload.single('avatar'),
  authCtrl.uploadAvatar
);

// Protected routes
router.use('/words', authenticate, require('./words.routes'));

// Flashcards — legacy (rétrocompatibilité)
router.use('/flashcards', authenticate, require('./flashcard.routes'));

// 1.6 — Nouvelle API my-decks + SRS
router.use('/my-decks', authenticate, require('./mydecks.routes'));
router.use('/srs', authenticate, require('./srs.routes'));

// Gamification + analytics + quests/event
router.use('/gamification', authenticate, require('./gamification.routes'));
router.use('/quests', authenticate, require('./quests.routes'));

// AI
router.use('/ai', authenticate, require('./ai.routes'));

// Lessons + courses + enrollments
router.use('/lessons', authenticate, require('./lesson.routes'));
router.use('/courses', authenticate, require('./course.routes'));
router.use('/enrollments', authenticate, require('./enrollments.routes'));

// 1.2 — Favorites + 1.4 — Mock Tests + Grammar
router.use('/favorites', authenticate, require('./favorites.routes'));
router.use('/mock-tests', authenticate, require('./mocktest.routes'));
router.use('/grammars', authenticate, require('./grammar.routes'));

// 2.5 — Example sentences (Shadowing)
router.use('/examples', authenticate, require('./examples.routes'));

module.exports = router;
