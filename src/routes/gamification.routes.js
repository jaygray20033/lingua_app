const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/gamification.controller');

router.get('/stats', ctrl.getMyStats);

// 1.1 — Analytics, evaluate, languages
router.get('/analytics', ctrl.getAnalytics);
router.post('/achievements/evaluate', ctrl.evaluateAchievements);
router.get('/languages', ctrl.getLanguages);

// Hearts & XP
router.post('/hearts/lose', ctrl.loseHeart);
router.post('/hearts/refill', ctrl.refillHearts);
router.post('/xp', ctrl.addXP);

router.get('/leaderboard', ctrl.getLeaderboard);
router.get('/achievements', ctrl.getAchievements);

// Quests
router.get('/quests', ctrl.getDailyQuests);
router.post('/quests/:questId/claim', ctrl.claimQuest);

// 1.8 — Daily goal & streak freeze
router.put('/daily-goal', ctrl.setDailyGoal);
router.post('/streak-freeze/buy', ctrl.buyStreakFreeze);

module.exports = router;
