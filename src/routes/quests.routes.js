const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/gamification.controller');

// 1.8 — POST /api/quests/event { event, value }
router.post('/event', ctrl.triggerQuestEvent);

module.exports = router;
