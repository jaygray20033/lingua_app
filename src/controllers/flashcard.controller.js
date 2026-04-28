const srsService = require('../services/srs.service');
const gamService = require('../services/gamification.service');
const db = require('../config/database');

const getDecks = async (req, res) => {
  const { language } = req.query;
  let query = `
    SELECT d.*, l.code as language_code, l.flag_emoji,
      (SELECT COUNT(*) FROM flashcard_reviews fr WHERE fr.user_id = ? AND fr.card_id IN (SELECT id FROM cards WHERE deck_id = d.id)) as reviewed_count
    FROM decks d
    LEFT JOIN languages l ON l.id = d.language_id
    WHERE d.owner_id = ? OR d.is_public = 1
  `;
  const params = [req.user.id, req.user.id];
  if (language) { query += ' AND l.code = ?'; params.push(language); }
  query += ' ORDER BY d.owner_id = ? DESC, d.id ASC';
  params.push(req.user.id);

  const [rows] = await db.query(query, params);
  res.json({ success: true, data: rows });
};

const getDeckCards = async (req, res) => {
  const { deckId } = req.params;
  const dueCards = await srsService.getDueCards(req.user.id, deckId);
  const newCards = await srsService.getNewCards(req.user.id, deckId, 10);

  res.json({
    success: true,
    data: {
      dueCards,
      newCards,
      totalDue: dueCards.length,
      totalNew: newCards.length
    }
  });
};

const reviewCard = async (req, res) => {
  const { cardId } = req.params;
  const { rating } = req.body;

  const result = await srsService.reviewCard(req.user.id, parseInt(cardId), rating);

  // Add streak update
  await gamService.updateStreak(req.user.id);

  res.json({ success: true, data: result });
};

const createDeck = async (req, res) => {
  const { name, description, languageId, isPublic = false } = req.body;
  if (!name) return res.status(400).json({ success: false, message: 'Nom requis' });

  const [result] = await db.query(
    'INSERT INTO decks (owner_id, name, description, language_id, is_public) VALUES (?, ?, ?, ?, ?)',
    [req.user.id, name, description, languageId, isPublic ? 1 : 0]
  );

  res.status(201).json({ success: true, data: { id: result.insertId, name, description } });
};

const addCard = async (req, res) => {
  const { deckId } = req.params;
  const { frontText, backText, audioUrl, imageUrl } = req.body;

  if (!frontText || !backText) {
    return res.status(400).json({ success: false, message: 'frontText et backText requis' });
  }

  const [result] = await db.query(
    'INSERT INTO cards (deck_id, front_text, back_text, audio_url, image_url) VALUES (?, ?, ?, ?, ?)',
    [deckId, frontText, backText, audioUrl, imageUrl]
  );

  await db.query('UPDATE decks SET card_count = card_count + 1 WHERE id = ?', [deckId]);

  res.status(201).json({ success: true, data: { id: result.insertId } });
};

module.exports = { getDecks, getDeckCards, reviewCard, createDeck, addCard };
