const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/examples.controller');

// 2.5 — GET /api/examples?language=ja&level=N5&limit=20
router.get('/', ctrl.list);

module.exports = router;
