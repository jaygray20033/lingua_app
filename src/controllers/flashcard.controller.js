const srsService = require('../services/srs.service');
const gamService = require('../services/gamification.service');
const db = require('../config/database');

// BUG C9 FIX: table is `cards` not `flashcards`; review table is `flashcard_reviews`
const getDecks = async (req, res) => {
  const [rows] = await db.query(
    `SELECT d.*,
       l.code AS language_code,
       (SELECT COUNT(*) FROM cards c WHERE c.deck_id = d.id) as card_count,
       (SELECT COUNT(*) FROM cards c JOIN flashcard_reviews fr ON fr.card_id = c.id
        WHERE c.deck_id = d.id AND fr.user_id = ? AND fr.state != 'NEW') as reviewed_count
     FROM decks d
     LEFT JOIN languages l ON l.id = d.language_id
     WHERE d.owner_id = ? OR d.is_public = 1
     ORDER BY d.id`,
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

// BUG C10 FIX: decks.language_id (FK) au lieu de language_code
const createDeck = async (req, res) => {
  const { name, description, languageCode, isPublic } = req.body;
  if (!name) return res.status(400).json({ success: false, message: 'Tên bộ thẻ không được để trống' });

  const code = languageCode || 'ja';
  const [lang] = await db.query('SELECT id FROM languages WHERE code = ?', [code]);
  if (!lang.length) {
    return res.status(400).json({ success: false, message: `Ngôn ngữ '${code}' không hợp lệ` });
  }

  const [result] = await db.query(
    'INSERT INTO decks (owner_id, name, description, language_id, is_public) VALUES (?, ?, ?, ?, ?)',
    [req.user.id, name, description || '', lang[0].id, isPublic ? 1 : 0]
  );
  res.status(201).json({ success: true, data: { id: result.insertId } });
};

// BUG C9 FIX: insertion dans `cards` avec colonnes `front_text`/`back_text`
const addCard = async (req, res) => {
  const { deckId } = req.params;
  const { front, back, audioUrl } = req.body;
  if (!front || !back) return res.status(400).json({ success: false, message: 'Mặt trước và mặt sau không được để trống' });
  const [owner] = await db.query(
    'SELECT id FROM decks WHERE id = ? AND owner_id = ?', [deckId, req.user.id]
  );
  if (!owner.length) {
    return res.status(403).json({ success: false, message: 'Bạn không có quyền thêm thẻ vào bộ này' });
  }
  const [result] = await db.query(
    'INSERT INTO cards (deck_id, front_text, back_text, audio_url) VALUES (?, ?, ?, ?)',
    [deckId, front, back, audioUrl || null]
  );
  res.status(201).json({ success: true, data: { id: result.insertId } });
};

module.exports = { getDecks, getDeckCards, reviewCard, createDeck, addCard };
