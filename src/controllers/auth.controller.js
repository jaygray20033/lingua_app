const authService = require('../services/auth.service');
const db = require('../config/database');
const cache = require('../config/redis');
const bcrypt = require('bcryptjs');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

// U13 FIX: répertoire public pour les avatars uploadés via base64 / multipart.
// Servi statiquement par server.js (app.use('/uploads', express.static(...))).
const AVATAR_DIR = path.join(__dirname, '..', '..', 'uploads', 'avatars');
try { fs.mkdirSync(AVATAR_DIR, { recursive: true }); } catch (_) {}

const ALLOWED_CT = { 'image/jpeg': 'jpg', 'image/png': 'png', 'image/webp': 'webp' };
const MAX_AVATAR_BYTES = 2 * 1024 * 1024; // 2 MB

/**
 * U13 helper — sauvegarde un avatar en base64 sur le disque et retourne l'URL publique.
 * Utilisé par updateProfile (champ avatarBase64) et par /upload/avatar.
 */
const saveBase64Avatar = (userId, base64, contentType) => {
  const ct = (contentType || 'image/jpeg').toLowerCase();
  const ext = ALLOWED_CT[ct];
  if (!ext) throw new Error('Định dạng ảnh không hợp lệ (chỉ JPEG/PNG/WebP)');

  // Nettoyer un éventuel préfixe "data:image/...;base64,"
  const clean = base64.replace(/^data:[^;]+;base64,/, '');
  const buf = Buffer.from(clean, 'base64');
  if (!buf.length) throw new Error('Ảnh trống');
  if (buf.length > MAX_AVATAR_BYTES) throw new Error('Ảnh quá lớn (tối đa 2MB)');

  const name = `u${userId}_${Date.now()}_${crypto.randomBytes(4).toString('hex')}.${ext}`;
  const full = path.join(AVATAR_DIR, name);
  fs.writeFileSync(full, buf);
  return `/uploads/avatars/${name}`;
};

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
  const {
    displayName,
    avatarUrl,
    nativeLanguageCode,
    targetLanguage,
    currentLevel,
    // U13 FIX: nouveaux champs acceptés depuis Android
    avatarBase64,
    avatarContentType,
  } = req.body;

  const sets = []; const vals = [];
  if (displayName) { sets.push('display_name = ?'); vals.push(displayName); }
  if (nativeLanguageCode) { sets.push('native_language_code = ?'); vals.push(nativeLanguageCode); }

  // U13 FIX: si l'Android envoie `avatarBase64`, on décode, sauvegarde sur disque
  // et stocke l'URL publique — plus de content://... inutilisable.
  let savedAvatarUrl = null;
  if (avatarBase64) {
    try {
      savedAvatarUrl = saveBase64Avatar(req.user.id, avatarBase64, avatarContentType);
      sets.push('avatar_url = ?'); vals.push(savedAvatarUrl);
    } catch (e) {
      return res.status(400).json({ success: false, message: e.message || 'Không thể lưu ảnh' });
    }
  } else if (avatarUrl !== undefined) {
    // Garde-fou: on refuse les URI locales Android (content://, file://) — elles
    // ne sont pas accessibles par le serveur et corrompraient le profil.
    const isLocalUri = typeof avatarUrl === 'string' &&
      /^(content:|file:|android\.resource:)/i.test(avatarUrl.trim());
    if (isLocalUri) {
      return res.status(400).json({
        success: false,
        message: 'URL ảnh không hợp lệ — vui lòng upload ảnh qua avatarBase64',
      });
    }
    sets.push('avatar_url = ?'); vals.push(avatarUrl);
  }

  // Note: targetLanguage / currentLevel sont envoyés par l'onboarding Android mais
  // stockés dans user_languages plutôt que users → on les accepte silencieusement
  // (pour ne pas retourner 400 quand seuls ces champs sont envoyés) et on met à
  // jour user_languages si les colonnes y existent.
  if (targetLanguage) {
    try {
      await db.query(
        `INSERT INTO user_languages (user_id, lang_code, is_primary)
         VALUES (?, ?, 1)
         ON DUPLICATE KEY UPDATE is_primary = 1`,
        [req.user.id, targetLanguage]
      );
    } catch (_) { /* ignore si schéma différent */ }
  }
  if (currentLevel) {
    try {
      await db.query(
        `UPDATE user_languages SET level = ? WHERE user_id = ? AND is_primary = 1`,
        [currentLevel, req.user.id]
      );
    } catch (_) { /* ignore */ }
  }

  if (!sets.length && !targetLanguage && !currentLevel) {
    return res.status(400).json({ success: false, message: 'Không có gì để cập nhật' });
  }

  if (sets.length) {
    vals.push(req.user.id);
    await db.query(`UPDATE users SET ${sets.join(', ')} WHERE id = ?`, vals);
  }
  await cache.del(`user:${req.user.id}`);

  const [rows] = await db.query(
    'SELECT id, email, display_name, role, status, avatar_url, native_language_code FROM users WHERE id = ?',
    [req.user.id]
  );
  res.json({
    success: true,
    message: 'Đã cập nhật hồ sơ',
    data: { ...rows[0], uploadedAvatarUrl: savedAvatarUrl },
  });
};

/**
 * U13 FIX — POST /api/upload/avatar
 * Accepte deux formats :
 *   1) multipart/form-data avec champ "avatar" (file)
 *   2) application/json avec { avatarBase64, contentType }
 * Retourne { url } (URL publique accessible via /uploads/avatars/...).
 */
const uploadAvatar = async (req, res) => {
  try {
    let savedUrl = null;

    // Cas 1 — multipart (si multer attache req.file)
    if (req.file && req.file.buffer && req.file.buffer.length) {
      const ct = (req.file.mimetype || '').toLowerCase();
      const ext = ALLOWED_CT[ct];
      if (!ext) {
        return res.status(400).json({ success: false, message: 'Định dạng ảnh không hợp lệ' });
      }
      if (req.file.buffer.length > MAX_AVATAR_BYTES) {
        return res.status(400).json({ success: false, message: 'Ảnh quá lớn (tối đa 2MB)' });
      }
      const name = `u${req.user.id}_${Date.now()}_${crypto.randomBytes(4).toString('hex')}.${ext}`;
      fs.writeFileSync(path.join(AVATAR_DIR, name), req.file.buffer);
      savedUrl = `/uploads/avatars/${name}`;
    }
    // Cas 2 — base64 en JSON
    else if (req.body && req.body.avatarBase64) {
      savedUrl = saveBase64Avatar(
        req.user.id,
        req.body.avatarBase64,
        req.body.contentType || req.body.avatarContentType
      );
    } else {
      return res.status(400).json({
        success: false,
        message: 'Thiếu ảnh — gửi file "avatar" (multipart) hoặc "avatarBase64" (JSON)',
      });
    }

    await db.query('UPDATE users SET avatar_url = ? WHERE id = ?', [savedUrl, req.user.id]);
    await cache.del(`user:${req.user.id}`);

    res.json({ success: true, data: { url: savedUrl, avatarUrl: savedUrl } });
  } catch (e) {
    res.status(400).json({ success: false, message: e.message || 'Upload thất bại' });
  }
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

module.exports = { register, login, refresh, logout, me, updateProfile, changePassword, uploadAvatar };
