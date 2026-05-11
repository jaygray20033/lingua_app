-- =====================================================
-- LINGUA PLATFORM - Database Schema
-- MySQL 8.0 | UTF8MB4 | Version 1.0
-- =====================================================

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
SET time_zone = '+00:00';

-- =====================================================
-- MODULE: AUTH & USER
-- =====================================================

CREATE TABLE IF NOT EXISTS users (
  id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  email         VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255),
  display_name  VARCHAR(100) NOT NULL,
  avatar_url    VARCHAR(500),
  auth_provider ENUM('EMAIL','GOOGLE','FACEBOOK','APPLE') DEFAULT 'EMAIL',
  provider_uid  VARCHAR(255),
  native_language_code VARCHAR(10) DEFAULT 'vi',
  timezone      VARCHAR(50) DEFAULT 'Asia/Ho_Chi_Minh',
  ui_language   VARCHAR(10) DEFAULT 'vi',
  `role`        ENUM('LEARNER','PREMIUM','CONTENT_CREATOR','ADMIN') DEFAULT 'LEARNER',
  email_verified TINYINT(1) DEFAULT 0,
  `status`      ENUM('ACTIVE','SUSPENDED','BANNED') DEFAULT 'ACTIVE',
  created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_email (email),
  INDEX idx_status (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS refresh_tokens (
  id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id    BIGINT UNSIGNED NOT NULL,
  token_hash VARCHAR(500) NOT NULL,
  expires_at DATETIME NOT NULL,
  revoked_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_token_hash (token_hash(100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS otp_codes (
  id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  email      VARCHAR(255) NOT NULL,
  code       VARCHAR(10) NOT NULL,
  purpose    ENUM('REGISTER','RESET_PW') NOT NULL,
  expires_at DATETIME NOT NULL,
  used       TINYINT(1) DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_email_purpose (email, purpose)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- MODULE: LANGUAGE & COURSE
-- =====================================================

CREATE TABLE IF NOT EXISTS languages (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `code`      VARCHAR(10) UNIQUE NOT NULL,
  `name`      VARCHAR(100) NOT NULL,
  native_name VARCHAR(100),
  flag_emoji  VARCHAR(10),
  `direction` ENUM('LTR','RTL') DEFAULT 'LTR'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO languages (code, name, native_name, flag_emoji) VALUES
('ja', 'Japanese', '日本語', '🇯🇵'),
('en', 'English', 'English', '🇬🇧'),
('zh', 'Chinese', '中文', '🇨🇳'),
('ko', 'Korean', '한국어', '🇰🇷'),
('vi', 'Vietnamese', 'Tiếng Việt', '🇻🇳')
ON DUPLICATE KEY UPDATE name=VALUES(name);

CREATE TABLE IF NOT EXISTS user_languages (
  id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id       BIGINT UNSIGNED NOT NULL,
  language_id   INT UNSIGNED NOT NULL,
  level_code    VARCHAR(20) DEFAULT 'A1',
  daily_xp_goal INT DEFAULT 20,
  reason        ENUM('TRAVEL','WORK','STUDY','CULTURE','OTHER') DEFAULT 'OTHER',
  is_primary    TINYINT(1) DEFAULT 0,
  created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (language_id) REFERENCES languages(id),
  UNIQUE KEY uq_user_lang (user_id, language_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS courses (
  id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  title           VARCHAR(255) NOT NULL,
  slug            VARCHAR(255) UNIQUE NOT NULL,
  description     TEXT,
  source_lang_id  INT UNSIGNED,
  target_lang_id  INT UNSIGNED NOT NULL,
  level_code      VARCHAR(20),
  certification   ENUM('JLPT','TOPIK','CEFR','HSK','IELTS','TOEIC','NONE') DEFAULT 'NONE',
  is_premium      TINYINT(1) DEFAULT 0,
  thumbnail_url   VARCHAR(500),
  author_id       BIGINT UNSIGNED,
  `status`        ENUM('DRAFT','PENDING','PUBLISHED','ARCHIVED') DEFAULT 'DRAFT',
  total_lessons   INT DEFAULT 0,
  total_enrollments INT DEFAULT 0,
  rating          DECIMAL(3,2) DEFAULT 0.00,
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (source_lang_id) REFERENCES languages(id),
  FOREIGN KEY (target_lang_id) REFERENCES languages(id),
  FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_target_lang (target_lang_id),
  INDEX idx_status (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS enrollments (
  id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id         BIGINT UNSIGNED NOT NULL,
  course_id       BIGINT UNSIGNED NOT NULL,
  `status`        ENUM('ACTIVE','COMPLETED','DROPPED') DEFAULT 'ACTIVE',
  progress_percent TINYINT DEFAULT 0,
  enrolled_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
  completed_at    DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  UNIQUE KEY uq_enrollment (user_id, course_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- MODULE: LEARNING PATH
-- =====================================================

CREATE TABLE IF NOT EXISTS sections (
  id           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  course_id    BIGINT UNSIGNED NOT NULL,
  order_index  INT NOT NULL,
  title        VARCHAR(255) NOT NULL,
  cefr_mapping VARCHAR(20),
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  INDEX idx_course_order (course_id, order_index)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS units (
  id                 BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  section_id         BIGINT UNSIGNED NOT NULL,
  order_index        INT NOT NULL,
  title              VARCHAR(255) NOT NULL,
  communication_goal TEXT,
  icon               VARCHAR(50),
  xp_reward          INT DEFAULT 50,
  FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE CASCADE,
  INDEX idx_section_order (section_id, order_index)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS lessons (
  id                   BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  unit_id              BIGINT UNSIGNED NOT NULL,
  order_index          INT NOT NULL,
  title                VARCHAR(255) NOT NULL,
  `type`               ENUM('NORMAL','STORY','CHECKPOINT','LEGENDARY') DEFAULT 'NORMAL',
  xp_reward            INT DEFAULT 10,
  heart_cost_per_error INT DEFAULT 1,
  exercise_count       INT DEFAULT 0,
  is_free_preview      TINYINT(1) DEFAULT 0,
  FOREIGN KEY (unit_id) REFERENCES units(id) ON DELETE CASCADE,
  INDEX idx_unit_order (unit_id, order_index)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS exercises (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  lesson_id   BIGINT UNSIGNED NOT NULL,
  order_index INT NOT NULL,
  `type`      ENUM('TRANSLATE','LISTEN_SELECT','SPEAK','MATCH_PAIRS','FILL_BLANK','SENTENCE_ORDER','WRITE_CHAR','SELECT_IMG','TRUE_FALSE','DICTATION','DIALOGUE','READING_COMP') NOT NULL,
  prompt_json TEXT NOT NULL,
  answer_json TEXT NOT NULL,
  hint_json   TEXT,
  audio_url   VARCHAR(500),
  image_url   VARCHAR(500),
  difficulty  TINYINT DEFAULT 1,
  FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
  INDEX idx_lesson_order (lesson_id, order_index)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS lesson_attempts (
  id           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id      BIGINT UNSIGNED NOT NULL,
  lesson_id    BIGINT UNSIGNED NOT NULL,
  `status`     ENUM('IN_PROGRESS','COMPLETED','ABANDONED') DEFAULT 'IN_PROGRESS',
  score_percent TINYINT DEFAULT 0,
  xp_earned    INT DEFAULT 0,
  hearts_lost  INT DEFAULT 0,
  duration_sec INT DEFAULT 0,
  started_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
  completed_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
  INDEX idx_user_lesson (user_id, lesson_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS answer_logs (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  attempt_id  BIGINT UNSIGNED NOT NULL,
  exercise_id BIGINT UNSIGNED NOT NULL,
  user_answer TEXT,
  is_correct  TINYINT(1) DEFAULT 0,
  time_ms     INT DEFAULT 0,
  hints_used  INT DEFAULT 0,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (attempt_id) REFERENCES lesson_attempts(id) ON DELETE CASCADE,
  FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_lesson_progress (
  id                BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id           BIGINT UNSIGNED NOT NULL,
  lesson_id         BIGINT UNSIGNED NOT NULL,
  completion_count  INT DEFAULT 0,
  best_score        TINYINT DEFAULT 0,
  is_legendary      TINYINT(1) DEFAULT 0,
  last_completed_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
  UNIQUE KEY uq_user_lesson (user_id, lesson_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- MODULE: VOCABULARY & CHARACTER
-- =====================================================

CREATE TABLE IF NOT EXISTS words (
  id             BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  language_id    INT UNSIGNED NOT NULL,
  `text`         VARCHAR(500) NOT NULL,
  reading        VARCHAR(500),
  romaji         VARCHAR(500),
  pos            ENUM('NOUN','VERB','ADJ','ADV','PARTICLE','CONJ','PRON','NUM','INTJ','PHRASE') DEFAULT 'NOUN',
  jlpt_level     VARCHAR(5),
  topik_level    VARCHAR(10),
  cefr_level     VARCHAR(5),
  hsk_level      VARCHAR(10),
  audio_url      VARCHAR(500),
  frequency_rank INT,
  FOREIGN KEY (language_id) REFERENCES languages(id),
  INDEX idx_language_level (language_id, jlpt_level),
  FULLTEXT INDEX ft_word_text (`text`, reading, romaji)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS word_meanings (
  id                   BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  word_id              BIGINT UNSIGNED NOT NULL,
  translation_lang_id  INT UNSIGNED NOT NULL,
  meaning              TEXT NOT NULL,
  example_sentence     TEXT,
  example_translation  TEXT,
  example_audio_url    VARCHAR(500),
  FOREIGN KEY (word_id) REFERENCES words(id) ON DELETE CASCADE,
  FOREIGN KEY (translation_lang_id) REFERENCES languages(id),
  INDEX idx_word_lang (word_id, translation_lang_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS characters (
  id             BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  language_id    INT UNSIGNED NOT NULL,
  `char`         VARCHAR(10) NOT NULL,
  stroke_count   TINYINT,
  jlpt_level     VARCHAR(5),
  frequency_rank INT,
  meaning_vi     TEXT,
  meaning_en     TEXT,
  on_reading     VARCHAR(255),
  kun_reading    VARCHAR(255),
  han_viet       VARCHAR(255),
  mnemonic_text  TEXT,
  stroke_svg_url VARCHAR(500),
  FOREIGN KEY (language_id) REFERENCES languages(id),
  UNIQUE KEY uq_char_lang (language_id, `char`),
  FULLTEXT INDEX ft_char (`char`, on_reading, kun_reading, han_viet)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS character_components (
  id           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  character_id BIGINT UNSIGNED NOT NULL,
  component_id BIGINT UNSIGNED NOT NULL,
  `position`   VARCHAR(50),
  FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE,
  FOREIGN KEY (component_id) REFERENCES characters(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS word_characters (
  word_id      BIGINT UNSIGNED NOT NULL,
  character_id BIGINT UNSIGNED NOT NULL,
  order_index  INT DEFAULT 0,
  PRIMARY KEY (word_id, character_id),
  FOREIGN KEY (word_id) REFERENCES words(id) ON DELETE CASCADE,
  FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_known_words (
  id           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id      BIGINT UNSIGNED NOT NULL,
  word_id      BIGINT UNSIGNED NOT NULL,
  strength     TINYINT DEFAULT 0,
  first_seen_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  last_seen_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (word_id) REFERENCES words(id) ON DELETE CASCADE,
  UNIQUE KEY uq_user_word (user_id, word_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- MODULE: SRS / FLASHCARD
-- =====================================================

CREATE TABLE IF NOT EXISTS decks (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  owner_id    BIGINT UNSIGNED,
  `name`      VARCHAR(255) NOT NULL,
  description TEXT,
  language_id INT UNSIGNED,
  is_public   TINYINT(1) DEFAULT 0,
  card_count  INT DEFAULT 0,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE SET NULL,
  FOREIGN KEY (language_id) REFERENCES languages(id),
  INDEX idx_language_public (language_id, is_public)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS cards (
  id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  deck_id         BIGINT UNSIGNED NOT NULL,
  front_text      TEXT NOT NULL,
  back_text       TEXT NOT NULL,
  audio_url       VARCHAR(500),
  image_url       VARCHAR(500),
  ref_word_id     BIGINT UNSIGNED,
  ref_character_id BIGINT UNSIGNED,
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (deck_id) REFERENCES decks(id) ON DELETE CASCADE,
  FOREIGN KEY (ref_word_id) REFERENCES words(id) ON DELETE SET NULL,
  FOREIGN KEY (ref_character_id) REFERENCES characters(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flashcard_reviews (
  id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id         BIGINT UNSIGNED NOT NULL,
  card_id         BIGINT UNSIGNED NOT NULL,
  `state`         ENUM('NEW','LEARNING','REVIEW','RELEARNING','SUSPENDED') DEFAULT 'NEW',
  ease_factor     DECIMAL(4,2) DEFAULT 2.50,
  interval_days   INT DEFAULT 0,
  repetitions     INT DEFAULT 0,
  lapses          INT DEFAULT 0,
  next_review_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  last_reviewed_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (card_id) REFERENCES cards(id) ON DELETE CASCADE,
  UNIQUE KEY uq_user_card (user_id, card_id),
  INDEX idx_user_next_review (user_id, next_review_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS review_logs (
  id                   BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  flashcard_review_id  BIGINT UNSIGNED NOT NULL,
  rating               ENUM('AGAIN','HARD','GOOD','EASY') NOT NULL,
  previous_interval    INT DEFAULT 0,
  new_interval         INT DEFAULT 0,
  reviewed_at          DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (flashcard_review_id) REFERENCES flashcard_reviews(id) ON DELETE CASCADE,
  INDEX idx_review_date (reviewed_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- MODULE: GAMIFICATION
-- =====================================================

CREATE TABLE IF NOT EXISTS user_gamification (
  user_id              BIGINT UNSIGNED PRIMARY KEY,
  total_xp             BIGINT DEFAULT 0,
  `level`              INT DEFAULT 1,
  gems                 INT DEFAULT 0,
  hearts               TINYINT DEFAULT 5,
  hearts_updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
  streak_count         INT DEFAULT 0,
  longest_streak       INT DEFAULT 0,
  last_streak_date     DATE,
  streak_freeze_count  INT DEFAULT 1,
  updated_at           DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS heart_logs (
  id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id    BIGINT UNSIGNED NOT NULL,
  delta      TINYINT NOT NULL,
  reason     ENUM('WRONG_ANSWER','REFILL_GEM','REFILL_TIME','REFILL_PRACTICE','PREMIUM_INFINITE') NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_created (user_id, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS gem_transactions (
  id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id    BIGINT UNSIGNED NOT NULL,
  delta      INT NOT NULL,
  reason     ENUM('QUEST_REWARD','STREAK_BONUS','LEVEL_UP','PURCHASE','SPEND_HEART','SPEND_FREEZE') NOT NULL,
  ref_id     BIGINT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_created (user_id, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS daily_xp_logs (
  user_id    BIGINT UNSIGNED NOT NULL,
  `date`     DATE NOT NULL,
  xp_gained  INT DEFAULT 0,
  goal_met   TINYINT(1) DEFAULT 0,
  PRIMARY KEY (user_id, `date`),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS achievements (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `code`       VARCHAR(100) UNIQUE NOT NULL,
  title        VARCHAR(255) NOT NULL,
  description  TEXT,
  icon_url     VARCHAR(500),
  rarity       ENUM('COMMON','RARE','EPIC','LEGENDARY') DEFAULT 'COMMON',
  trigger_rule JSON
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_achievements (
  user_id        BIGINT UNSIGNED NOT NULL,
  achievement_id INT UNSIGNED NOT NULL,
  unlocked_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
  progress       INT DEFAULT 0,
  PRIMARY KEY (user_id, achievement_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (achievement_id) REFERENCES achievements(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS leagues (
  id                   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name`               VARCHAR(100) NOT NULL,
  tier                 TINYINT NOT NULL,
  icon_url             VARCHAR(500),
  promotion_threshold  INT DEFAULT 7
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO leagues (name, tier, icon_url, promotion_threshold) VALUES
('Bronze', 1, '🥉', 5),
('Silver', 2, '🥈', 5),
('Gold', 3, '🥇', 7),
('Sapphire', 4, '💎', 7),
('Ruby', 5, '🔴', 7),
('Emerald', 6, '💚', 7),
('Amethyst', 7, '💜', 7),
('Pearl', 8, '🤍', 7),
('Obsidian', 9, '⚫', 7),
('Diamond', 10, '💠', 7)
ON DUPLICATE KEY UPDATE name=VALUES(name);

CREATE TABLE IF NOT EXISTS league_groups (
  id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  league_id       INT UNSIGNED NOT NULL,
  week_start_date DATE NOT NULL,
  week_end_date   DATE NOT NULL,
  member_count    INT DEFAULT 0,
  FOREIGN KEY (league_id) REFERENCES leagues(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_leagues (
  id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id         BIGINT UNSIGNED NOT NULL,
  league_group_id BIGINT UNSIGNED NOT NULL,
  weekly_xp       INT DEFAULT 0,
  final_rank      INT,
  result          ENUM('PROMOTED','STAYED','DEMOTED'),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (league_group_id) REFERENCES league_groups(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS daily_quests (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id     BIGINT UNSIGNED NOT NULL,
  quest_code  VARCHAR(100) NOT NULL,
  target      INT NOT NULL,
  progress    INT DEFAULT 0,
  reward_gems INT DEFAULT 10,
  completed   TINYINT(1) DEFAULT 0,
  description VARCHAR(255) NULL,
  claimed_at  DATETIME NULL,
  `date`      DATE NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY uq_user_quest_date (user_id, quest_code, `date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- MODULE: AI TUTOR
-- =====================================================

CREATE TABLE IF NOT EXISTS roleplay_scenarios (
  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  language_id     INT UNSIGNED NOT NULL,
  level_code      VARCHAR(20),
  title           VARCHAR(255) NOT NULL,
  context_prompt  TEXT NOT NULL,
  goal            TEXT,
  is_premium      TINYINT(1) DEFAULT 0,
  FOREIGN KEY (language_id) REFERENCES languages(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS ai_sessions (
  id             BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id        BIGINT UNSIGNED NOT NULL,
  `type`         ENUM('ROLEPLAY','VIDEO_CALL','CHAT','EXPLAIN') NOT NULL,
  scenario_id    INT UNSIGNED,
  language_id    INT UNSIGNED,
  started_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
  ended_at       DATETIME,
  messages_count INT DEFAULT 0,
  total_tokens   INT DEFAULT 0,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (scenario_id) REFERENCES roleplay_scenarios(id) ON DELETE SET NULL,
  FOREIGN KEY (language_id) REFERENCES languages(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS ai_messages (
  id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  session_id BIGINT UNSIGNED NOT NULL,
  `role`     ENUM('USER','AI','SYSTEM') NOT NULL,
  content    TEXT NOT NULL,
  audio_url  VARCHAR(500),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES ai_sessions(id) ON DELETE CASCADE,
  INDEX idx_session_created (session_id, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS ai_explanations (
  id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id         BIGINT UNSIGNED NOT NULL,
  answer_log_id   BIGINT UNSIGNED,
  explanation_text TEXT NOT NULL,
  tokens_used     INT DEFAULT 0,
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (answer_log_id) REFERENCES answer_logs(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- MODULE: MOCK TEST
-- =====================================================

CREATE TABLE IF NOT EXISTS mock_tests (
  id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  title           VARCHAR(255) NOT NULL,
  language_id     INT UNSIGNED NOT NULL,
  `type`          ENUM('JLPT','TOPIK','EPS_TOPIK','IELTS','TOEIC','HSK') NOT NULL,
  level_code      VARCHAR(20),
  duration_min    INT DEFAULT 60,
  total_questions INT DEFAULT 0,
  pass_score      INT DEFAULT 0,
  is_premium      TINYINT(1) DEFAULT 0,
  FOREIGN KEY (language_id) REFERENCES languages(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS mock_test_sections (
  id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  mock_test_id  BIGINT UNSIGNED NOT NULL,
  order_index   INT NOT NULL,
  title         VARCHAR(255) NOT NULL,
  duration_min  INT DEFAULT 20,
  FOREIGN KEY (mock_test_id) REFERENCES mock_tests(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS mock_test_questions (
  id           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  section_id   BIGINT UNSIGNED NOT NULL,
  order_index  INT NOT NULL,
  prompt_json  TEXT NOT NULL,
  answer_json  TEXT NOT NULL,
  explanation  TEXT,
  difficulty   TINYINT DEFAULT 1,
  FOREIGN KEY (section_id) REFERENCES mock_test_sections(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS mock_test_attempts (
  id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id       BIGINT UNSIGNED NOT NULL,
  mock_test_id  BIGINT UNSIGNED NOT NULL,
  total_score   INT DEFAULT 0,
  passed        TINYINT(1) DEFAULT 0,
  answers_json  TEXT,
  started_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
  submitted_at  DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (mock_test_id) REFERENCES mock_tests(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- MODULE: SHADOWING & PRONUNCIATION
-- =====================================================

CREATE TABLE IF NOT EXISTS shadowing_contents (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  language_id INT UNSIGNED NOT NULL,
  title       VARCHAR(255) NOT NULL,
  text        TEXT NOT NULL,
  audio_url   VARCHAR(500) NOT NULL,
  level_code  VARCHAR(20),
  duration_ms INT,
  FOREIGN KEY (language_id) REFERENCES languages(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS pronunciation_attempts (
  id                   BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id              BIGINT UNSIGNED NOT NULL,
  shadowing_content_id BIGINT UNSIGNED,
  original_text        TEXT NOT NULL,
  recognized_text      TEXT,
  score                TINYINT DEFAULT 0,
  audio_url            VARCHAR(500),
  feedback_json        TEXT,
  created_at           DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (shadowing_content_id) REFERENCES shadowing_contents(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- MODULE: COMMUNITY
-- =====================================================

CREATE TABLE IF NOT EXISTS user_follows (
  follower_id  BIGINT UNSIGNED NOT NULL,
  following_id BIGINT UNSIGNED NOT NULL,
  created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (follower_id, following_id),
  FOREIGN KEY (follower_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (following_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS forum_posts (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  author_id   BIGINT UNSIGNED NOT NULL,
  language_id INT UNSIGNED,
  title       VARCHAR(500) NOT NULL,
  content     TEXT NOT NULL,
  image_url   VARCHAR(500),
  audio_url   VARCHAR(500),
  upvotes     INT DEFAULT 0,
  `status`    ENUM('ACTIVE','CLOSED','FLAGGED','DELETED') DEFAULT 'ACTIVE',
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (language_id) REFERENCES languages(id),
  FULLTEXT INDEX ft_post (title, content)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS forum_comments (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  post_id     BIGINT UNSIGNED NOT NULL,
  author_id   BIGINT UNSIGNED NOT NULL,
  content     TEXT NOT NULL,
  is_best     TINYINT(1) DEFAULT 0,
  upvotes     INT DEFAULT 0,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES forum_posts(id) ON DELETE CASCADE,
  FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS course_reviews (
  id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id    BIGINT UNSIGNED NOT NULL,
  course_id  BIGINT UNSIGNED NOT NULL,
  rating     TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment    TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  UNIQUE KEY uq_user_course_review (user_id, course_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS reports (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  reporter_id BIGINT UNSIGNED NOT NULL,
  target_type ENUM('POST','COMMENT','USER','COURSE','EXERCISE') NOT NULL,
  target_id   BIGINT UNSIGNED NOT NULL,
  reason      ENUM('WRONG_INFO','SPAM','TOXIC','COPYRIGHT','OTHER') NOT NULL,
  description TEXT,
  `status`    ENUM('PENDING','RESOLVED','DISMISSED') DEFAULT 'PENDING',
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (reporter_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- MODULE: PAYMENT & SUBSCRIPTION
-- =====================================================

CREATE TABLE IF NOT EXISTS subscriptions (
  id           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id      BIGINT UNSIGNED NOT NULL,
  plan         ENUM('FREE','PLUS','MAX') DEFAULT 'FREE',
  started_at   DATETIME NOT NULL,
  expires_at   DATETIME,
  auto_renew   TINYINT(1) DEFAULT 1,
  payment_method ENUM('VNPAY','MOMO','STRIPE','PAYPAL'),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY uq_user_sub (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS payments (
  id                BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id           BIGINT UNSIGNED NOT NULL,
  amount            DECIMAL(10,2) NOT NULL,
  currency          VARCHAR(10) DEFAULT 'VND',
  payment_method    ENUM('VNPAY','MOMO','STRIPE','PAYPAL') NOT NULL,
  transaction_id    VARCHAR(255),
  `status`          ENUM('PENDING','SUCCESS','FAILED','REFUNDED') DEFAULT 'PENDING',
  plan              ENUM('PLUS','MAX') NOT NULL,
  duration_months   INT DEFAULT 1,
  created_at        DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- SEED: Default Achievements
-- =====================================================

INSERT INTO achievements (code, title, description, rarity, trigger_rule) VALUES
('FIRST_STEP', 'First Step', 'Complete your first lesson', 'COMMON', '{"type":"lesson_complete","count":1}'),
('STREAK_7', 'Week Warrior', '7-day streak', 'COMMON', '{"type":"streak","count":7}'),
('STREAK_30', 'Monthly Master', '30-day streak', 'RARE', '{"type":"streak","count":30}'),
('STREAK_100', 'Century Club', '100-day streak', 'EPIC', '{"type":"streak","count":100}'),
('STREAK_365', 'Streak Legend', '365-day streak', 'LEGENDARY', '{"type":"streak","count":365}'),
('WORDS_100', 'Wordsmith 100', 'Learn 100 words', 'COMMON', '{"type":"words_learned","count":100}'),
('WORDS_500', 'Wordsmith 500', 'Learn 500 words', 'RARE', '{"type":"words_learned","count":500}'),
('WORDS_1000', 'Vocabulary Master', 'Learn 1000 words', 'EPIC', '{"type":"words_learned","count":1000}'),
('PERFECT_LESSON', 'Perfectionist', 'Complete a lesson with 100% score', 'COMMON', '{"type":"perfect_score","count":1}'),
('XP_1000', 'XP Hunter', 'Earn 1000 total XP', 'COMMON', '{"type":"total_xp","count":1000}'),
('XP_10000', 'XP Champion', 'Earn 10,000 total XP', 'RARE', '{"type":"total_xp","count":10000}')
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- =====================================================
-- SEED: Sample Roleplay Scenarios
-- =====================================================

INSERT INTO roleplay_scenarios (language_id, level_code, title, context_prompt, goal, is_premium) VALUES
((SELECT id FROM languages WHERE code='ja'), 'N4', 'Gọi món ở izakaya', 'Bạn đang đóng vai nhân viên phục vụ tại một izakaya truyền thống Nhật Bản. Hãy dùng tiếng Nhật lịch sự để phục vụ khách.', 'User đặt được món ăn và đồ uống bằng tiếng Nhật', 0),
((SELECT id FROM languages WHERE code='ja'), 'N3', 'Phỏng vấn xin việc', 'Bạn là nhà tuyển dụng tại một công ty Nhật Bản. Hỏi thăm kinh nghiệm và mục tiêu nghề nghiệp của ứng viên.', 'User hoàn thành cuộc phỏng vấn bằng tiếng Nhật trang trọng', 1),
((SELECT id FROM languages WHERE code='en'), 'B1', 'Airport Check-in', 'You are an airline check-in agent at an international airport. Help the passenger with their check-in process.', 'User successfully checks in using English', 0),
((SELECT id FROM languages WHERE code='zh'), 'HSK3', '在餐厅点餐', '你是一家中餐厅的服务员。请用普通话为顾客提供服务。', '用户能用中文点菜', 0)
ON DUPLICATE KEY UPDATE title=VALUES(title);
