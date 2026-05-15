const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const db = require('../config/database');

// SHA-256 hash for O(1) refresh token lookup (TODO 2.1)
const hashToken = (token) => crypto.createHash('sha256').update(token).digest('hex');

const sign = (payload) => {
  const accessToken = jwt.sign(payload, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN || '15m',
  });
  const refreshToken = crypto.randomBytes(40).toString('hex');
  return { accessToken, refreshToken };
};

const register = async ({ email, password, displayName, nativeLanguage = 'vi' }) => {
  const [existing] = await db.query('SELECT id FROM users WHERE email = ?', [email]);
  if (existing.length) {
    const err = new Error('Email đã được sử dụng');
    err.status = 409; throw err;
  }

  const passwordHash = await bcrypt.hash(password, 12);
  const [result] = await db.query(
    'INSERT INTO users (email, password_hash, display_name, native_language_code) VALUES (?, ?, ?, ?)',
    [email, passwordHash, displayName, nativeLanguage]
  );
  const userId = result.insertId;

  // BUG L3 FIX: ne plus avaler silencieusement l'erreur d'insertion gamification.
  // Si la ligne n'est pas créée ici, updateStreak() retourne early et le streak
  // reste à 0 pour toujours. On laisse l'erreur remonter pour faire échouer
  // l'inscription proprement plutôt que de créer un user à moitié configuré.
  await db.query('INSERT IGNORE INTO user_gamification (user_id) VALUES (?)', [userId]);

  // BUG B18 FIX: Insert into user_languages with primary language=1 (English by default).
  // Without this row, setDailyGoal/getStats queries that join user_languages on
  // is_primary = 1 silently fail, and the user's daily goal is never persisted.
  await db.query(
    'INSERT IGNORE INTO user_languages (user_id, language_id, is_primary, daily_xp_goal) VALUES (?, 1, 1, 20)',
    [userId]
  );

  const tokens = sign({ userId, email, role: 'USER' });
  const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);
  await db.query(
    'INSERT INTO refresh_tokens (user_id, token_hash, expires_at) VALUES (?, ?, ?)',
    [userId, hashToken(tokens.refreshToken), expiresAt]
  );

  return { userId, accessToken: tokens.accessToken, refreshToken: tokens.refreshToken };
};

const login = async ({ email, password }) => {
  const [rows] = await db.query(
    'SELECT id, email, password_hash, display_name, role, status, avatar_url FROM users WHERE email = ?',
    [email]
  );
  if (!rows.length) { const e = new Error('Email hoặc mật khẩu không đúng'); e.status = 401; throw e; }

  const user = rows[0];
  if (user.status !== 'ACTIVE') { const e = new Error('Tài khoản đã bị khoá'); e.status = 403; throw e; }

  const valid = await bcrypt.compare(password, user.password_hash);
  if (!valid) { const e = new Error('Email hoặc mật khẩu không đúng'); e.status = 401; throw e; }

  const tokens = sign({ userId: user.id, email: user.email, role: user.role });
  const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);
  await db.query(
    'INSERT INTO refresh_tokens (user_id, token_hash, expires_at) VALUES (?, ?, ?)',
    [user.id, hashToken(tokens.refreshToken), expiresAt]
  );

  // BUG B3 FIX: Ajout de `userId` au niveau racine pour que LoginActivity.java
  // (Android) puisse lire `data.userId` directement, comme pour register.
  return {
    userId: user.id,
    user: { id: user.id, email: user.email, displayName: user.display_name, role: user.role, avatarUrl: user.avatar_url },
    accessToken: tokens.accessToken,
    refreshToken: tokens.refreshToken,
  };
};

const refreshTokens = async (oldRefreshToken) => {
  // O(1) lookup via SHA-256 hash instead of bcrypt loop (TODO 2.1)
  const hash = hashToken(oldRefreshToken);
  const [rows] = await db.query(
    'SELECT * FROM refresh_tokens WHERE token_hash = ? AND revoked_at IS NULL AND expires_at > NOW() LIMIT 1',
    [hash]
  );
  if (!rows.length) { const e = new Error('Refresh token không hợp lệ'); e.status = 401; throw e; }

  const row = rows[0];
  await db.query('UPDATE refresh_tokens SET revoked_at = NOW() WHERE id = ?', [row.id]);

  const tokens = sign({ userId: row.user_id });
  const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);
  await db.query(
    'INSERT INTO refresh_tokens (user_id, token_hash, expires_at) VALUES (?, ?, ?)',
    [row.user_id, hashToken(tokens.refreshToken), expiresAt]
  );

  return { accessToken: tokens.accessToken, refreshToken: tokens.refreshToken };
};

const logout = async (userId) => {
  await db.query(
    'UPDATE refresh_tokens SET revoked_at = NOW() WHERE user_id = ? AND revoked_at IS NULL',
    [userId]
  );
};

module.exports = { register, login, refreshTokens, logout };
