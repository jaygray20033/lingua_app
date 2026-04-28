const db = require('../config/database');

const getWords = async (req, res) => {
  const { language, level, search, page = 1, limit = 20 } = req.query;
  const offset = (parseInt(page) - 1) * parseInt(limit);

  let query = `
    SELECT w.id, w.text, w.reading, w.romaji, w.pos,
           w.jlpt_level, w.cefr_level, w.hsk_level, w.topik_level,
           w.audio_url, w.frequency_rank,
           l.code as language_code, l.name as language_name,
           JSON_ARRAYAGG(JSON_OBJECT(
             'meaning', wm.meaning,
             'example', wm.example_sentence,
             'example_translation', wm.example_translation,
             'example_audio', wm.example_audio_url
           )) as meanings
    FROM words w
    JOIN languages l ON l.id = w.language_id
    LEFT JOIN word_meanings wm ON wm.word_id = w.id
    WHERE 1=1
  `;
  const params = [];

  if (language) {
    query += ' AND l.code = ?';
    params.push(language);
  }
  if (level) {
    query += ' AND (w.jlpt_level = ? OR w.cefr_level = ? OR w.hsk_level = ? OR w.topik_level = ?)';
    params.push(level, level, level, level);
  }
  if (search) {
    query += ' AND MATCH(w.text, w.reading, w.romaji) AGAINST(? IN BOOLEAN MODE)';
    params.push(`${search}*`);
  }

  query += ' GROUP BY w.id ORDER BY w.frequency_rank ASC LIMIT ? OFFSET ?';
  params.push(parseInt(limit), offset);

  const [rows] = await db.query(query, params);

  // Count total
  let countQuery = 'SELECT COUNT(DISTINCT w.id) as total FROM words w JOIN languages l ON l.id = w.language_id WHERE 1=1';
  const countParams = [];
  if (language) { countQuery += ' AND l.code = ?'; countParams.push(language); }
  if (level) { countQuery += ' AND (w.jlpt_level = ? OR w.cefr_level = ? OR w.hsk_level = ? OR w.topik_level = ?)'; countParams.push(level, level, level, level); }
  if (search) { countQuery += ' AND MATCH(w.text, w.reading, w.romaji) AGAINST(? IN BOOLEAN MODE)'; countParams.push(`${search}*`); }

  const [countRow] = await db.query(countQuery, countParams);

  res.json({
    success: true,
    data: rows.map(r => ({
      ...r,
      meanings: typeof r.meanings === 'string' ? JSON.parse(r.meanings) : r.meanings
    })),
    pagination: {
      page: parseInt(page),
      limit: parseInt(limit),
      total: countRow[0]?.total || 0
    }
  });
};

const getWordById = async (req, res) => {
  const { id } = req.params;
  const [rows] = await db.query(
    `SELECT w.*, l.code as language_code,
     GROUP_CONCAT(DISTINCT c.char ORDER BY wc.order_index) as characters
     FROM words w
     JOIN languages l ON l.id = w.language_id
     LEFT JOIN word_characters wc ON wc.word_id = w.id
     LEFT JOIN characters c ON c.id = wc.character_id
     WHERE w.id = ?
     GROUP BY w.id`,
    [id]
  );

  if (!rows.length) return res.status(404).json({ success: false, message: 'Mot non trouvé' });

  const [meanings] = await db.query(
    `SELECT wm.*, l.code as lang_code FROM word_meanings wm
     JOIN languages l ON l.id = wm.translation_lang_id
     WHERE wm.word_id = ?`,
    [id]
  );

  res.json({ success: true, data: { ...rows[0], meanings } });
};

const getCharacter = async (req, res) => {
  const { char } = req.params;
  const { language = 'ja' } = req.query;

  const [rows] = await db.query(
    `SELECT c.*, l.code as language_code,
     (SELECT JSON_ARRAYAGG(JSON_OBJECT('char', cc.char, 'meaning_vi', cc.meaning_vi))
      FROM character_components comp
      JOIN characters cc ON cc.id = comp.component_id
      WHERE comp.character_id = c.id) as components
     FROM characters c
     JOIN languages l ON l.id = c.language_id
     WHERE c.char = ? AND l.code = ?`,
    [char, language]
  );

  if (!rows.length) return res.status(404).json({ success: false, message: 'Caractère non trouvé' });

  // Get words containing this character
  const [words] = await db.query(
    `SELECT w.text, w.reading, wm.meaning
     FROM word_characters wc
     JOIN words w ON w.id = wc.word_id
     LEFT JOIN word_meanings wm ON wm.word_id = w.id
     WHERE wc.character_id = ?
     LIMIT 10`,
    [rows[0].id]
  );

  res.json({ success: true, data: { ...rows[0], relatedWords: words } });
};

module.exports = { getWords, getWordById, getCharacter };
