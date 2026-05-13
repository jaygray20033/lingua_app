require('dotenv').config();
require('express-async-errors');

const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');

const app = express();
const PORT = process.env.PORT || 3000;

// Parse allowed origins from env
const allowedOrigins = (process.env.CORS_ORIGINS || '')
  .split(',').map(s => s.trim()).filter(Boolean);

// Security
app.use(helmet());
app.use(cors({
  origin: allowedOrigins.length ? allowedOrigins : '*',
  credentials: true,
}));

// Rate limiting
app.use('/api/auth', rateLimit({ windowMs: 15 * 60 * 1000, max: 20, message: { success: false, message: 'Quá nhiều yêu cầu, vui lòng thử lại sau' } }));
app.use('/api/', rateLimit({ windowMs: 15 * 60 * 1000, max: 200 }));

// Body parsing
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));
if (process.env.NODE_ENV !== 'production') app.use(morgan('dev'));

// U13 FIX — Static serving for uploaded avatars (POST /api/upload/avatar writes here).
const path = require('path');
app.use('/uploads', express.static(path.join(__dirname, '..', 'uploads')));

// Routes
app.use('/api', require('./routes/index'));

// 404
app.use((req, res) => {
  res.status(404).json({ success: false, message: `Không tìm thấy route ${req.method} ${req.url}` });
});

// Global error handler
app.use((err, req, res, _next) => {
  console.error('❌ Error:', err.message);
  const status = err.status || err.statusCode || 500;
  res.status(status).json({
    success: false,
    message: err.expose ? err.message : (err.message || 'Lỗi máy chủ nội bộ'),
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
  });
});

const server = app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Lingua API khởi động tại http://0.0.0.0:${PORT}`);
});

// Graceful shutdown
const shutdown = (signal) => () => {
  console.log(`\n${signal} received — shutting down…`);
  server.close(() => process.exit(0));
  setTimeout(() => process.exit(1), 5000);
};
process.on('SIGTERM', shutdown('SIGTERM'));
process.on('SIGINT', shutdown('SIGINT'));
process.on('unhandledRejection', (r) => console.error('UNHANDLED', r));

module.exports = app;
