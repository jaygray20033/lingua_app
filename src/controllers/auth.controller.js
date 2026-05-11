const authService = require('../services/auth.service');
const db = require('../config/database');
const cache = require('../config/redis');
const bcrypt = require('bcryptjs');

const register = async (req, res) => {
  const { email, password, displayName, nativeLanguage } = req.body;
  if (!email || !password || !displayName) {
    return res.status(400).json({ success: false, message: 'Thiếu thông tin bắt buộc' });
  }
  const data = await authService.register({ email, password, displayName, nativeLanguage });
  res.status(201).json({ success: true, data });
};

const login = async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ success: false, message: 'Vui lòng nhập email và mật khẩu' });
  }
  const data = await authService.login({ email, password });
  res.json({ success: true, data });
};

const refresh = async (req, res) => {
  const { refreshToken } = req.body;
  if (!refreshToken) {
    return res.status(400).json({ success: false, message: 'Thiếu refresh token' });
  }
  const data = await authService.refreshTokens(refreshToken);
  res.json({ success: true, data });
};

const logout = async (req, res) => {
  await authService.logout(req.user.id);
  await cache.del(`user:${req.user.id}`);
  res.json({ success: true, message: 'Đã đăng xuất' });
};

const me = async (req, res) => {
  res.json({ success: true, data: req.user });
};

const updateProfile = async (req, res) => {
  const { displayName, avatarUrl, nativeLanguageCode } = req.body;
  const sets = []; const vals = [];
  if (displayName) { sets.push('display_name = ?'); vals.push(displayName); }
  if (avatarUrl !== undefined) { sets.push('avatar_url = ?'); vals.push(avatarUrl); }
  if (nativeLanguageCode) { sets.push('native_language_code = ?'); vals.push(nativeLanguageCode); }
  if (!sets.length) return res.status(400).json({ success: false, message: 'Không có gì để cập nhật' });

  vals.push(req.user.id);
  await db.query(`UPDATE users SET ${sets.join(', ')} WHERE id = ?`, vals);
  await cache.del(`user:${req.user.id}`);

  const [rows] = await db.query(
    'SELECT id, email, display_name, role, status, avatar_url, native_language_code FROM users WHERE id = ?',
    [req.user.id]
  );
  res.json({ success: true, message: 'Đã cập nhật hồ sơ', data: rows[0] });
};

// 2.1 — POST /api/auth/change-password
const changePassword = async (req, res) => {
  const { currentPassword, newPassword } = req.body;
  if (!currentPassword || !newPassword) {
    return res.status(400).json({ success: false, message: 'Thiếu mật khẩu hiện tại hoặc mật khẩu mới' });
  }
  if (newPassword.length < 6) {
    return res.status(400).json({ success: false, message: 'Mật khẩu mới phải có ít nhất 6 ký tự' });
  }

  const [rows] = await db.query('SELECT password_hash FROM users WHERE id = ?', [req.user.id]);
  if (!rows.length) return res.status(404).json({ success: false, message: 'Không tìm thấy người dùng' });

  const valid = await bcrypt.compare(currentPassword, rows[0].password_hash);
  if (!valid) return res.status(401).json({ success: false, message: 'Mật khẩu hiện tại không đúng' });

  const newHash = await bcrypt.hash(newPassword, 12);
  await db.query('UPDATE users SET password_hash = ? WHERE id = ?', [newHash, req.user.id]);

  // Revoke all refresh tokens to force re-login on other devices
  await db.query(
    'UPDATE refresh_tokens SET revoked_at = NOW() WHERE user_id = ? AND revoked_at IS NULL',
    [req.user.id]
  );
  await cache.del(`user:${req.user.id}`);

  res.json({ success: true, message: 'Đã đổi mật khẩu thành công' });
};

module.exports = { register, login, refresh, logout, me, updateProfile, changePassword };
