CREATE TABLE IF NOT EXISTS word_examples (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  word_id BIGINT UNSIGNED NOT NULL,
  sentence TEXT NOT NULL,
  reading TEXT,
  translation TEXT,
  audio_url VARCHAR(500),
  level_code VARCHAR(20),
  source VARCHAR(100) DEFAULT 'curated',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (word_id) REFERENCES words(id) ON DELETE CASCADE,
  INDEX idx_word (word_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
