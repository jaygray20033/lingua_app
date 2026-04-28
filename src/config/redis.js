const redis = require('redis');

const client = redis.createClient({
  socket: {
    host: process.env.REDIS_HOST || 'localhost',
    port: parseInt(process.env.REDIS_PORT) || 6379
  }
});

client.on('error', (err) => console.error('Redis Error:', err));
client.on('connect', () => console.log('✅ Redis connected'));

client.connect().catch(console.error);

module.exports = client;
