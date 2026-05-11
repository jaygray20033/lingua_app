#!/usr/bin/env bash
# =====================================================
# Lingua — Run all data migrations
# Usage:
#   DB_HOST=localhost DB_USER=root DB_PASS=secret DB_NAME=lingua ./run_all_seeds.sh
# Hoặc với docker-compose đang chạy:
#   ./run_all_seeds.sh
# =====================================================
set -euo pipefail

DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-3306}
DB_USER=${DB_USER:-root}
DB_PASS=${DB_PASS:-rootpassword}
DB_NAME=${DB_NAME:-lingua}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MYSQL_CMD="mysql -h$DB_HOST -P$DB_PORT -u$DB_USER -p$DB_PASS --default-character-set=utf8mb4 $DB_NAME"

echo "=========================================="
echo "  Lingua — Run all migrations & seeds"
echo "  DB: $DB_USER@$DB_HOST:$DB_PORT/$DB_NAME"
echo "=========================================="

# Thứ tự chạy:
FILES=(
  "init.sql"
  "002_schema_extensions.sql"
  "003_seed_vocab_japanese.sql"
  "004_seed_vocab_chinese.sql"
  "005_seed_vocab_english.sql"
  "006_seed_vocab_korean.sql"
  "010_seed_vocab_japanese_ext.sql"
  "011_seed_vocab_chinese_ext.sql"
  "012_seed_vocab_english_ext.sql"
  "007_seed_grammar.sql"
  "013_seed_grammar_ext.sql"
  "009_seed_courses_lessons.sql"
  "008_seed_mock_tests.sql"
  "014_seed_mock_tests_ext.sql"
  "015_seed_example_sentences.sql"
  "016_seed_exercises_bank.sql"
)

for f in "${FILES[@]}"; do
  FILE_PATH="$SCRIPT_DIR/$f"
  if [[ ! -f "$FILE_PATH" ]]; then
    echo "⚠️  Skip: $f (không tồn tại)"
    continue
  fi
  echo "▶️  Running: $f"
  $MYSQL_CMD < "$FILE_PATH"
  echo "✅  Done: $f"
done

echo ""
echo "=========================================="
echo "  🎉 Tất cả migrations đã hoàn tất!"
echo "=========================================="

# In thống kê tổng quan
$MYSQL_CMD -e "
  SELECT 'Languages' AS dataset, COUNT(*) AS total FROM languages
  UNION ALL SELECT 'Words', COUNT(*) FROM words
  UNION ALL SELECT 'Word examples', COUNT(*) FROM word_examples
  UNION ALL SELECT 'Grammar points', COUNT(*) FROM grammar_points
  UNION ALL SELECT 'Grammar examples', COUNT(*) FROM grammar_examples
  UNION ALL SELECT 'Grammar exercises', COUNT(*) FROM grammar_exercises
  UNION ALL SELECT 'Mock tests', COUNT(*) FROM mock_tests
  UNION ALL SELECT 'Mock test sections', COUNT(*) FROM mock_test_sections
  UNION ALL SELECT 'Mock test questions', COUNT(*) FROM mock_test_questions
  UNION ALL SELECT 'Courses', COUNT(*) FROM courses
  UNION ALL SELECT 'Lessons', COUNT(*) FROM lessons
  UNION ALL SELECT 'Exercises', COUNT(*) FROM exercises
  UNION ALL SELECT 'Question bank', COUNT(*) FROM question_bank;
"
