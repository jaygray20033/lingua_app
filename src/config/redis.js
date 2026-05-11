const redis = require('redis');

const url = `redis://${process.env.REDIS_HOST || 'localhost'}:${process.env.REDIS_PORT || 6379}`;
const client = redis.createClient({ url });

client.on('error', (err) => console.error('Redis Error:', err));
client.on('connect', () => console.log('✅ Redis connected'));
client.connect().catch(() => console.warn('⚠️ Redis unavailable — cache disabled'));

// Safe wrapper: never crash if Redis is down
const safe = {
  async get(key) { try { return client.isReady ? await client.get(key) : null; } catch { return null; } },
  async set(key, val, opts) { try { if (client.isReady) await client.set(key, val, opts); } catch {} },
  async del(key) { try { if (client.isReady) await client.del(key); } catch {} },
};

module.exports = safe;
