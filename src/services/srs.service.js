const db = require('../config/database');

// SM-2 Algorithm Implementation
const RATING_VALUES = { AGAIN: 0, HARD: 1, GOOD: 3, EASY: 5 };

const calculateSM2 = (current, rating) => {
  const ratingValue = RATING_VALUES[rating] || 0;
  let { ease_factor, interval_days, repetitions, lapses } = current;
  ease_factor = parseFloat(ease_factor);

  if (rating === 'AGAIN') {
    repetitions = 0;
    interval_days = 1;
    ease_factor = Math.max(1.3, ease_factor - 0.2);
    lapses = (lapses || 0) + 1;
  } else {
    if (repetitions === 0) interval_days = 1;
    else if (repetitions === 1) interval_days = 6;
    else interval_days = Math.round(interval_days * ease_factor);

    repetitions += 1;
    const efDelta = 0.1 - (5 - ratingValue) * (0.08 + (5 - ratingValue) * 0.02);
    ease_factor = Math.max(1.3, ease_factor + efDelta);
  }

  const nextReview = new Date(Date.now() + interval_days * 24 * 60 * 60 * 1000);

  let state = 'REVIEW';
  if (rating === 'AGAIN') state = repetitions > 0 ? 'RELEARNING' : 'LEARNING';
  else if (repetitions <= 2) state = 'LEARNING';

  return {
    ease_factor: parseFloat(ease_factor.toFixed(2)),
    interval_days,
    repetitions,
    lapses,
    state,
    next_review_at: nextReview
  };
};

const reviewCard = async (userId, cardId, rating) => {
  if (!['AGAIN', 'HARD', 'GOOD', 'EASY'].includes(rating)) {
    throw new Error('Rating invalide. Utiliser: AGAIN, HARD, GOOD, EASY');
  }

  // Get or create flashcard review
  let [rows] = await db.query(
    'SELECT * FROM flashcard_reviews WHERE user_id = ? AND card_id = ?',
    [userId, cardId]
  );

  let current;
  if (!rows.length) {
    // Create new entry
    await db.query(
      'INSERT INTO flashcard_reviews (user_id, card_id) VALUES (?, ?)',
      [userId, cardId]
    );
    [rows] = await db.query(
      'SELECT * FROM flashcard_reviews WHERE user_id = ? AND card_id = ?',
      [userId, cardId]
    );
  }
  current = rows[0];

  const updated = calculateSM2(current, rating);
  const previousInterval = current.interval_days;

  await db.query(
    `UPDATE flashcard_reviews SET
      state = ?, ease_factor = ?, interval_days = ?,
      repetitions = ?, lapses = ?, next_review_at = ?,
      last_reviewed_at = NOW()
     WHERE user_id = ? AND card_id = ?`,
    [
      updated.state, updated.ease_factor, updated.interval_days,
      updated.repetitions, updated.lapses, updated.next_review_at,
      userId, cardId
    ]
  );

  // Log review
  await db.query(
    'INSERT INTO review_logs (flashcard_review_id, rating, previous_interval, new_interval) VALUES (?, ?, ?, ?)',
    [current.id, rating, previousInterval, updated.interval_days]
  );

  // Add XP for review
  await db.query(
    'UPDATE user_gamification SET total_xp = total_xp + 1 WHERE user_id = ?',
    [userId]
  );

  return updated;
};

const getDueCards = async (userId, deckId = null, limit = 20) => {
  // BUG B6 FIX: inclure fr.id AS reviewId pour que l'app Android puisse
  // soumettre une révision via POST /api/srs/{reviewId}/review.
  // Sans cela, reviewId = 0 → fallback legacy → SRS moderne cassé.
  let query = `
    SELECT c.*, fr.id AS reviewId, fr.state, fr.ease_factor, fr.interval_days,
           fr.repetitions, fr.next_review_at,
           w.text as word_text, w.reading
    FROM flashcard_reviews fr
    JOIN cards c ON c.id = fr.card_id
    LEFT JOIN words w ON w.id = c.ref_word_id
    WHERE fr.user_id = ? AND fr.next_review_at <= NOW()
    AND fr.state != 'SUSPENDED'
  `;
  const params = [userId];

  if (deckId) {
    query += ' AND c.deck_id = ?';
    params.push(deckId);
  }

  query += ' ORDER BY fr.next_review_at ASC LIMIT ?';
  params.push(limit);

  const [rows] = await db.query(query, params);
  return rows;
};

const getNewCards = async (userId, deckId, limit = 10) => {
  const [rows] = await db.query(
    `SELECT c.* FROM cards c
     WHERE c.deck_id = ?
     AND c.id NOT IN (
       SELECT card_id FROM flashcard_reviews WHERE user_id = ?
     )
     LIMIT ?`,
    [deckId, userId, limit]
  );
  return rows;
};

module.exports = { reviewCard, getDueCards, getNewCards, calculateSM2 };
