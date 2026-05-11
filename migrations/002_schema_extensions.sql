-- =====================================================
-- LINGUA PLATFORM - Schema Extensions (v2)
-- Thêm các bảng còn thiếu để hỗ trợ:
--   • Grammar (Ngữ pháp + ví dụ)
--   • Favorites (Yêu thích đa loại: WORD/GRAMMAR/SENTENCE)
--   • Word Examples (Câu ví dụ cho từ — để Shadowing dùng)
--   • Exercise Responses (Bảng tương thích với code controller)
--   • Mock Test Sections + Sample Lessons
--   • Bổ sung cột tương thích với controller (words.word, words.level, words.meaning_vi)
-- =====================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----- Bổ sung cột tương thích cho bảng words -----
ALTER TABLE words
  ADD COLUMN IF NOT EXISTS word VARCHAR(500) GENERATED ALWAYS AS (`text`) VIRTUAL,
  ADD COLUMN IF NOT EXISTS `level` VARCHAR(10) GENERATED ALWAYS AS
      (COALESCE(jlpt_level, cefr_level, hsk_level, topik_level)) VIRTUAL,
  ADD COLUMN IF NOT EXISTS meaning_vi TEXT NULL,
  ADD COLUMN IF NOT EXISTS meaning_en TEXT NULL,
  ADD COLUMN IF NOT EXISTS topik_level VARCHAR(10) NULL;

-- ----- Bảng câu ví dụ cho từ (dùng cho Shadowing và Detail) -----
CREATE TABLE IF NOT EXISTS word_examples (
  id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  word_id       BIGINT UNSIGNED NOT NULL,
  sentence      TEXT NOT NULL,
  reading       TEXT,
  translation   TEXT,
  audio_url     VARCHAR(500),
  level_code    VARCHAR(20),
  source        VARCHAR(100) DEFAULT 'curated',
  created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (word_id) REFERENCES words(id) ON DELETE CASCADE,
  INDEX idx_word (word_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----- Bảng ngữ pháp -----
CREATE TABLE IF NOT EXISTS grammar_points (
  id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  language_id   INT UNSIGNED NOT NULL,
  title         VARCHAR(255) NOT NULL,
  structure     VARCHAR(500),
  meaning       TEXT,
  explanation   TEXT,
  level_code    VARCHAR(20),
  certification ENUM('JLPT','TOPIK','CEFR','HSK','IELTS','TOEIC','NONE') DEFAULT 'NONE',
  audio_url     VARCHAR(500),
  tags          VARCHAR(255),
  created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (language_id) REFERENCES languages(id),
  INDEX idx_lang_level (language_id, level_code),
  FULLTEXT INDEX ft_grammar (title, structure, explanation)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----- Bảng ví dụ cho ngữ pháp -----
CREATE TABLE IF NOT EXISTS grammar_examples (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  grammar_id  BIGINT UNSIGNED NOT NULL,
  sentence    TEXT NOT NULL,
  translation TEXT,
  audio_url   VARCHAR(500),
  note        TEXT,
  order_index INT DEFAULT 0,
  FOREIGN KEY (grammar_id) REFERENCES grammar_points(id) ON DELETE CASCADE,
  INDEX idx_grammar (grammar_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----- Bài tập gắn với grammar (cho GrammarDetail.exercises) -----
CREATE TABLE IF NOT EXISTS grammar_exercises (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  grammar_id  BIGINT UNSIGNED NOT NULL,
  `type`      VARCHAR(50) DEFAULT 'MULTI_CHOICE',
  prompt      TEXT NOT NULL,
  options_json TEXT,
  answer      VARCHAR(500),
  explanation TEXT,
  FOREIGN KEY (grammar_id) REFERENCES grammar_points(id) ON DELETE CASCADE,
  INDEX idx_grammar (grammar_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----- Bảng yêu thích đa loại -----
CREATE TABLE IF NOT EXISTS favorites (
  id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id    BIGINT UNSIGNED NOT NULL,
  `type`     ENUM('WORD','GRAMMAR','SENTENCE','MOCK_TEST') NOT NULL,
  item_id    BIGINT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY uq_user_type_item (user_id, `type`, item_id),
  INDEX idx_user_type (user_id, `type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----- Bảng lưu câu trả lời bài tập (controller dùng tên này) -----
CREATE TABLE IF NOT EXISTS exercise_responses (
  id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  attempt_id      BIGINT UNSIGNED NOT NULL,
  exercise_id     BIGINT UNSIGNED NOT NULL,
  user_answer     TEXT,
  is_correct      TINYINT(1) DEFAULT 0,
  response_time_ms INT DEFAULT 0,
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (attempt_id) REFERENCES lesson_attempts(id) ON DELETE CASCADE,
  FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE,
  INDEX idx_attempt (attempt_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----- Bổ sung cột exercises để khớp model TestQuestion / Exercise -----
ALTER TABLE exercises
  ADD COLUMN IF NOT EXISTS options_json TEXT NULL,
  ADD COLUMN IF NOT EXISTS correct_answer_json TEXT NULL,
  ADD COLUMN IF NOT EXISTS explanation TEXT NULL;

-- ----- Bổ sung cho mock_tests -----
ALTER TABLE mock_tests
  ADD COLUMN IF NOT EXISTS description TEXT NULL,
  ADD COLUMN IF NOT EXISTS lang_code VARCHAR(10) NULL,
  ADD COLUMN IF NOT EXISTS flag_emoji VARCHAR(10) NULL;

-- ----- Bổ sung cho mock_test_sections -----
ALTER TABLE mock_test_sections
  ADD COLUMN IF NOT EXISTS description TEXT NULL;

-- ----- Bổ sung cho mock_test_questions để khớp TestQuestion model -----
ALTER TABLE mock_test_questions
  ADD COLUMN IF NOT EXISTS `type` VARCHAR(50) DEFAULT 'MCQ',
  ADD COLUMN IF NOT EXISTS prompt TEXT NULL,
  ADD COLUMN IF NOT EXISTS question TEXT NULL,
  ADD COLUMN IF NOT EXISTS options_json TEXT NULL,
  ADD COLUMN IF NOT EXISTS correct_answer VARCHAR(500) NULL,
  ADD COLUMN IF NOT EXISTS audio_url VARCHAR(500) NULL,
  ADD COLUMN IF NOT EXISTS image_url VARCHAR(500) NULL;

SET FOREIGN_KEY_CHECKS = 1;
