const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/ai.controller');

router.post('/explain', ctrl.explainGrammar);
router.get('/scenarios', ctrl.getScenarios);
router.post('/sessions', ctrl.startSession);
router.post('/sessions/:sessionId/chat', ctrl.chatStream);
router.post('/explain-answer', ctrl.explainAnswer);
router.post('/study-plan', ctrl.generateStudyPlan);

module.exports = router;
