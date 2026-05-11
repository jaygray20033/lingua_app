const srsService = require('../services/srs.service');
const gamService = require('../services/gamification.service');
const db = require('../config/database');

const getDecks = async (req, res) => {
  const [rows] = await db.query(
    `SELECT d.*, (SELECT COUNT(*) FROM flashcards f WHERE f.deck_id = d.id) as card_count,
      (SELECT COUNT(*) FROM flashcards f JOIN srs_data s ON s.flashcard_id = f.id
       WHERE f.deck_id = d.id AND s.user_id = ? AND s.state != 'NEW') as reviewed_count
     FROM decks d WHERE d.owner_id = ? OR d.is_public = 1 ORDER BY d.id`,
    [req.user.id, req.user.id]
  );
  res.json({ success: true, data: rows });
};

const getDeckCards = async (req, res) => {
  const { deckId } = req.params;
  const due = await srsService.getDueCards(req.user.id, deckId);
  const newCards = await srsService.getNewCards(req.user.id, deckId, 10);
  res.json({ success: true, data: { due, new: newCards } });
};

const reviewCard = async (req, res) => {
  const { cardId } = req.params;
  const { quality } = req.body; // 0-5 SM-2 quality
  if (quality === undefined || quality < 0 || quality > 5) {
    return res.status(400).json({ success: false, message: 'Chất lượng trả lời phải từ 0-5' });
  }
  const result = await srsService.reviewCard(req.user.id, parseInt(cardId), quality);
  await gamService.addXP(req.user.id, 5, 'FLASHCARD_REVIEW');
  res.json({ success: true, data: result });
};

const createDeck = async (req, res) => {
  const { name, description, languageCode, isPublic } = req.body;
  if (!name) return res.status(400).json({ success: false, message: 'Tên bộ thẻ không được để trống' });
  const [result] = await db.query(
    'INSERT INTO decks (owner_id, name, description, language_code, is_public) VALUES (?, ?, ?, ?, ?)',
    [req.user.id, name, description || '', languageCode || 'ja', isPublic ? 1 : 0]
  );
  res.status(201).json({ success: true, data: { id: result.insertId } });
};

const addCard = async (req, res) => {
  const { deckId } = req.params;
  const { front, back, audioUrl } = req.body;
  if (!front || !back) return res.status(400).json({ success: false, message: 'Mặt trước và mặt sau không được để trống' });
  const [result] = await db.query(
    'INSERT INTO flashcards (deck_id, front, back, audio_url) VALUES (?, ?, ?, ?)',
    [deckId, front, back, audioUrl || null]
  );
  res.status(201).json({ success: true, data: { id: result.insertId } });
};

module.exports = { getDecks, getDeckCards, reviewCard, createDeck, addCard };
