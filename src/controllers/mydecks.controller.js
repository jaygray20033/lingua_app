const db = require('../config/database');
const srsService = require('../services/srs.service');
const gamService = require('../services/gamification.service');

// GET /api/my-decks — Decks de l'utilisateur (owned ou public)
const list = async (req, res) => {
  const [rows] = await db.query(
    `SELECT d.*,
       (SELECT COUNT(*) FROM cards c WHERE c.deck_id = d.id) as card_count,
       (SELECT COUNT(*) FROM cards c
          JOIN flashcard_reviews fr ON fr.card_id = c.id
        WHERE c.deck_id = d.id AND fr.user_id = ? AND fr.next_review_at <= NOW()
          AND fr.state != 'SUSPENDED') as due_count
     FROM decks d WHERE d.owner_id = ? OR d.is_public = 1
     ORDER BY d.id DESC`,
    [req.user.id, req.user.id]
  );
  res.json({ success: true, data: rows });
};

// POST /api/my-decks — Créer un nouveau deck
const create = async (req, res) => {
  const { name, description, languageCode, isPublic } = req.body;
  if (!name) return res.status(400).json({ success: false, message: 'Tên bộ thẻ không được để trống' });
  const [result] = await db.query(
    'INSERT INTO decks (owner_id, name, description, language_code, is_public) VALUES (?, ?, ?, ?, ?)',
    [req.user.id, name, description || '', languageCode || 'ja', isPublic ? 1 : 0]
  );
  res.status(201).json({ success: true, data: { id: result.insertId } });
};

// GET /api/my-decks/:deckId/cards
const getCards = async (req, res) => {
  const { deckId } = req.params;
  const due = await srsService.getDueCards(req.user.id, deckId);
  const newCards = await srsService.getNewCards(req.user.id, deckId, 10);
  res.json({ success: true, data: { due, new: newCards } });
};

// POST /api/my-decks/:deckId/cards
const addCard = async (req, res) => {
  const { deckId } = req.params;
  const { front, back, audioUrl } = req.body;
  if (!front || !back) {
    return res.status(400).json({ success: false, message: 'Mặt trước và mặt sau không được để trống' });
  }
  const [result] = await db.query(
    'INSERT INTO cards (deck_id, front, back, audio_url) VALUES (?, ?, ?, ?)',
    [deckId, front, back, audioUrl || null]
  );
  res.status(201).json({ success: true, data: { id: result.insertId } });
};

// 1.6 — POST /api/my-decks/:deckId/start
const startSession = async (req, res) => {
  const { deckId } = req.params;
  const [deck] = await db.query(
    'SELECT id, name, language_code FROM decks WHERE id = ? AND (owner_id = ? OR is_public = 1)',
    [deckId, req.user.id]
  );
  if (!deck.length) {
    return res.status(404).json({ success: false, message: 'Không tìm thấy bộ thẻ' });
  }

  const due = await srsService.getDueCards(req.user.id, deckId, 30);
  const newCards = await srsService.getNewCards(req.user.id, deckId, 10);

  res.json({
    success: true,
    data: {
      deck: deck[0],
      sessionId: Date.now(),  // Simple session id côté client
      cards: [...due, ...newCards],
      dueCount: due.length,
      newCount: newCards.length,
    },
  });
};

// DELETE /api/my-decks/:deckId
const remove = async (req, res) => {
  const { deckId } = req.params;
  const [rows] = await db.query(
    'SELECT id FROM decks WHERE id = ? AND owner_id = ?',
    [deckId, req.user.id]
  );
  if (!rows.length) {
    return res.status(403).json({ success: false, message: 'Bạn không có quyền xoá bộ thẻ này' });
  }
  await db.query('DELETE FROM decks WHERE id = ?', [deckId]);
  res.json({ success: true, message: 'Đã xoá bộ thẻ' });
};

// DELETE /api/my-decks/:deckId/cards/:cardId
const removeCard = async (req, res) => {
  const { deckId, cardId } = req.params;
  const [owner] = await db.query(
    'SELECT id FROM decks WHERE id = ? AND owner_id = ?', [deckId, req.user.id]
  );
  if (!owner.length) {
    return res.status(403).json({ success: false, message: 'Bạn không có quyền xoá thẻ này' });
  }
  await db.query('DELETE FROM cards WHERE id = ? AND deck_id = ?', [cardId, deckId]);
  res.json({ success: true, message: 'Đã xoá thẻ' });
};

// GET /api/srs/due?deckId=&limit=
const srsDue = async (req, res) => {
  const deckId = req.query.deckId ? parseInt(req.query.deckId, 10) : null;
  const limit = req.query.limit ? parseInt(req.query.limit, 10) : 20;
  const cards = await srsService.getDueCards(req.user.id, deckId, limit);
  res.json({ success: true, data: { cards, total: cards.length } });
};

// POST /api/srs/:cardId/review { rating }
const srsReview = async (req, res) => {
  const cardId = parseInt(req.params.reviewId, 10);
  const { rating, quality } = req.body;

  // Accepter à la fois rating='GOOD' (SM-2 string) et quality=0..5 (legacy)
  let finalRating = rating;
  if (!finalRating && quality !== undefined) {
    if (quality <= 1) finalRating = 'AGAIN';
    else if (quality === 2) finalRating = 'HARD';
    else if (quality === 3 || quality === 4) finalRating = 'GOOD';
    else if (quality >= 5) finalRating = 'EASY';
  }
  if (!finalRating) finalRating = 'GOOD';

  const result = await srsService.reviewCard(req.user.id, cardId, finalRating);
  await gamService.addXP(req.user.id, 1, 'SRS_REVIEW');
  res.json({ success: true, data: result });
};

// GET /api/srs/decks (alias /api/my-decks)
const srsDecks = (req, res) => list(req, res);

module.exports = {
  list, create, getCards, addCard, startSession, remove, removeCard,
  srsDue, srsReview, srsDecks,
};
