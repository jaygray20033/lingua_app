const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/favorites.controller');

// GET /api/favorites?type=word
router.get('/', ctrl.list);

// 1.2 — GET /api/favorites/check?type=word&itemId=123
//  Doit être déclaré AVANT la route /:type/:itemId pour éviter les collisions
router.get('/check', ctrl.check);

// POST /api/favorites { type, itemId }
router.post('/', ctrl.add);

// DELETE /api/favorites/:type/:itemId
router.delete('/:type/:itemId', ctrl.remove);

module.exports = router;
