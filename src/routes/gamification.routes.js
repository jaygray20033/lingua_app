const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/gamification.controller');

router.get('/stats', ctrl.getMyStats);
router.post('/hearts/lose', ctrl.loseHeart);
router.post('/hearts/refill', ctrl.refillHearts);
router.post('/xp', ctrl.addXP);
router.get('/leaderboard', ctrl.getLeaderboard);
router.get('/achievements', ctrl.getAchievements);
router.get('/quests', ctrl.getDailyQuests);

module.exports = router;
