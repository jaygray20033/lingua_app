const authService = require('../services/auth.service');

const register = async (req, res) => {
  const { email, password, displayName, nativeLanguage } = req.body;
  if (!email || !password || !displayName) {
    return res.status(400).json({ success: false, message: 'Champs requis manquants' });
  }
  const result = await authService.register({ email, password, displayName, nativeLanguage });
  res.status(201).json({ success: true, data: result });
};

const login = async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ success: false, message: 'Email et mot de passe requis' });
  }
  const result = await authService.login({ email, password });
  res.json({ success: true, data: result });
};

const refresh = async (req, res) => {
  const { refreshToken } = req.body;
  if (!refreshToken) return res.status(400).json({ success: false, message: 'refreshToken requis' });
  const result = await authService.refreshTokens(refreshToken);
  res.json({ success: true, data: result });
};

const logout = async (req, res) => {
  await authService.logout(req.user.id);
  res.json({ success: true, message: 'Déconnecté avec succès' });
};

const me = async (req, res) => {
  res.json({ success: true, data: req.user });
};

module.exports = { register, login, refresh, logout, me };
