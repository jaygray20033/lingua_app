-- Tạo các bảng cần thiết
SET NAMES utf8mb4;

-- Thêm columns cho words (bỏ qua lỗi nếu đã tồn tại)
ALTER TABLE words ADD COLUMN meaning_vi TEXT NULL;
ALTER TABLE words ADD COLUMN meaning_en TEXT NULL;

-- Tạo bảng word_examples
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

-- Tạo bảng grammar_points
CREATE TABLE IF NOT EXISTS grammar_points (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  language_id INT UNSIGNED NOT NULL,
  title VARCHAR(255) NOT NULL,
  structure VARCHAR(500),
  meaning TEXT,
  explanation TEXT,
  level_code VARCHAR(20),
  certification ENUM('JLPT','TOPIK','CEFR','HSK','IELTS','TOEIC','NONE') DEFAULT 'NONE',
  audio_url VARCHAR(500),
  tags VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tạo bảng grammar_examples
CREATE TABLE IF NOT EXISTS grammar_examples (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  grammar_id BIGINT UNSIGNED NOT NULL,
  sentence TEXT NOT NULL,
  translation TEXT,
  note TEXT NULL,
  order_index INT DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (grammar_id) REFERENCES grammar_points(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tạo bảng grammar_exercises
CREATE TABLE IF NOT EXISTS grammar_exercises (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  grammar_id BIGINT UNSIGNED NOT NULL,
  question TEXT NOT NULL,
  type VARCHAR(50) DEFAULT 'MULTIPLE_CHOICE',
  options_json TEXT,
  correct_answer VARCHAR(500),
  explanation TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (grammar_id) REFERENCES grammar_points(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tạo bảng favorites
CREATE TABLE IF NOT EXISTS favorites (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  item_type ENUM('WORD','GRAMMAR','SENTENCE') NOT NULL,
  item_id BIGINT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY unique_favorite (user_id, item_type, item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Thêm columns cho courses
ALTER TABLE courses ADD COLUMN cover_url VARCHAR(500) NULL;

-- Thêm columns cho mock_tests
ALTER TABLE mock_tests ADD COLUMN lang_code VARCHAR(10) NULL;

-- Thêm columns cho lessons
ALTER TABLE lessons ADD COLUMN lesson_type VARCHAR(50) DEFAULT 'STANDARD';

-- Sửa enum cho enrollments
ALTER TABLE enrollments MODIFY COLUMN status ENUM('ACTIVE','COMPLETED','DROPPED','CANCELLED') DEFAULT 'ACTIVE';
