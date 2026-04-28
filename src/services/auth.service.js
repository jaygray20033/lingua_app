const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const db = require('../config/database');

const generateTokens = (userId) => {
  const accessToken = jwt.sign({ userId }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN || '15m'
  });
  const refreshToken = uuidv4();
  return { accessToken, refreshToken };
};

const register = async ({ email, password, displayName, nativeLanguage = 'vi' }) => {
  const [existing] = await db.query('SELECT id FROM users WHERE email = ?', [email]);
  if (existing.length) throw new Error('Email déjà utilisé');

  const passwordHash = await bcrypt.hash(password, 12);
  const [result] = await db.query(
    'INSERT INTO users (email, password_hash, display_name, native_language_code) VALUES (?, ?, ?, ?)',
    [email, passwordHash, displayName, nativeLanguage]
  );
  const userId = result.insertId;

  // Init gamification
  await db.query('INSERT INTO user_gamification (user_id) VALUES (?)', [userId]);

  const { accessToken, refreshToken } = generateTokens(userId);
  const refreshTokenHash = await bcrypt.hash(refreshToken, 10);
  const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);
  await db.query(
    'INSERT INTO refresh_tokens (user_id, token_hash, expires_at) VALUES (?, ?, ?)',
    [userId, refreshTokenHash, expiresAt]
  );

  return { userId, accessToken, refreshToken };
};

const login = async ({ email, password }) => {
  const [rows] = await db.query(
    'SELECT id, email, password_hash, display_name, role, status FROM users WHERE email = ?',
    [email]
  );
  if (!rows.length) throw new Error('Email ou mot de passe incorrect');

  const user = rows[0];
  if (user.status !== 'ACTIVE') throw new Error('Compte suspendu ou banni');

  const valid = await bcrypt.compare(password, user.password_hash);
  if (!valid) throw new Error('Email ou mot de passe incorrect');

  const { accessToken, refreshToken } = generateTokens(user.id);
  const refreshTokenHash = await bcrypt.hash(refreshToken, 10);
  const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);
  await db.query(
    'INSERT INTO refresh_tokens (user_id, token_hash, expires_at) VALUES (?, ?, ?)',
    [user.id, refreshTokenHash, expiresAt]
  );

  return {
    user: { id: user.id, email: user.email, displayName: user.display_name, role: user.role },
    accessToken,
    refreshToken
  };
};

const refreshTokens = async (refreshToken) => {
  const [rows] = await db.query(
    'SELECT * FROM refresh_tokens WHERE revoked_at IS NULL AND expires_at > NOW() ORDER BY created_at DESC LIMIT 50'
  );
  let validRow = null;
  for (const row of rows) {
    const match = await bcrypt.compare(refreshToken, row.token_hash);
    if (match) { validRow = row; break; }
  }
  if (!validRow) throw new Error('Refresh token invalide');

  // Revoke old token
  await db.query('UPDATE refresh_tokens SET revoked_at = NOW() WHERE id = ?', [validRow.id]);

  const { accessToken, refreshToken: newRefreshToken } = generateTokens(validRow.user_id);
  const newHash = await bcrypt.hash(newRefreshToken, 10);
  const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);
  await db.query(
    'INSERT INTO refresh_tokens (user_id, token_hash, expires_at) VALUES (?, ?, ?)',
    [validRow.user_id, newHash, expiresAt]
  );

  return { accessToken, refreshToken: newRefreshToken };
};

const logout = async (userId) => {
  await db.query('UPDATE refresh_tokens SET revoked_at = NOW() WHERE user_id = ? AND revoked_at IS NULL', [userId]);
};

module.exports = { register, login, refreshTokens, logout };
