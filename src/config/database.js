const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT) || 3306,
  database: process.env.DB_NAME || 'lingua_db',
  user: process.env.DB_USER || 'lingua_user',
  password: process.env.DB_PASS || 'lingua_pass123',
  waitForConnections: true,
  connectionLimit: 20,
  queueLimit: 0,
  charset: 'utf8mb4',
  timezone: '+00:00',
});

pool.on('connection', (conn) => {
  conn.query("SET time_zone='+00:00'");
});

module.exports = pool;
