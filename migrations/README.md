# 📚 Lingua — Data Seeds & Migrations

Thư mục này chứa toàn bộ **schema** và **dữ liệu mẫu** (vocabulary, grammar, mock tests, exercises) cho nền tảng học ngôn ngữ **Lingua**.

## 📊 Tổng quan dữ liệu

| Dataset | Số lượng |
|---|---:|
| **Languages** (Ngôn ngữ) | 5 (vi, ja, en, zh, ko) |
| **Words** (Từ vựng) | **1,583** |
| **Word examples** (Câu ví dụ) | 77 |
| **Grammar points** (Điểm ngữ pháp) | **244** |
| **Grammar examples** | 47 |
| **Grammar exercises** | 18 |
| **Mock tests** (Đề thi thử) | **14** |
| **Mock test sections** | 39 |
| **Mock test questions** | **107** |
| **Courses** (Khoá học) | 10 |
| **Sections / Units / Lessons** | 10 / 13 / 21 |
| **Exercises** (Bài tập) | 48 |
| **Question bank** (Ngân hàng câu hỏi) | 55 |

### Từ vựng theo ngôn ngữ

| Ngôn ngữ | Số từ | Phạm vi |
|---|---:|---|
| 🇯🇵 Tiếng Nhật (JLPT) | **690** | N5 → N1 |
| 🇨🇳 Tiếng Trung (HSK) | **424** | HSK 1 → HSK 6 |
| 🇬🇧 Tiếng Anh (CEFR/IELTS/TOEIC) | **379** | A1 → C1 |
| 🇰🇷 Tiếng Hàn (TOPIK) | **90** | TOPIK I → TOPIK II |

### Ngữ pháp theo ngôn ngữ

| Ngôn ngữ | Điểm ngữ pháp |
|---|---:|
| 🇯🇵 Tiếng Nhật | 105 |
| 🇬🇧 Tiếng Anh | 71 |
| 🇨🇳 Tiếng Trung | 53 |
| 🇰🇷 Tiếng Hàn | 15 |

### Đề thi thử

| Loại | Số đề | Tổng câu hỏi |
|---|---:|---:|
| JLPT (N5, N4, N3, N2, N1) | 5 | 37 |
| HSK (1, 4, 5) | 3 | 19 |
| IELTS (Listening, Reading, Writing) | 2 | 20 |
| TOEIC (Part 5, 6, 7) | 2 | 20 |
| TOPIK (I, II) | 2 | 13 |

---

## 📁 Cấu trúc file

| File | Mô tả |
|---|---|
| `init.sql` | Schema gốc (users, courses, payments, gamification, v.v.) |
| `002_schema_extensions.sql` | Bảng bổ sung: `grammar_points`, `grammar_examples`, `grammar_exercises`, `word_examples`, `favorites`, `user_progress` |
| `003_seed_vocab_japanese.sql` | Vocab JP gốc (~330 từ JLPT N5-N1) |
| `010_seed_vocab_japanese_ext.sql` | Vocab JP mở rộng (~390 từ + ví dụ) |
| `004_seed_vocab_chinese.sql` | Vocab CN gốc (~165 từ HSK 1-6) |
| `011_seed_vocab_chinese_ext.sql` | Vocab CN mở rộng (~285 từ) |
| `005_seed_vocab_english.sql` | Vocab EN gốc (~125 từ) |
| `012_seed_vocab_english_ext.sql` | Vocab EN mở rộng IELTS/TOEIC (~290 từ) |
| `006_seed_vocab_korean.sql` | Vocab KR TOPIK (~100 từ) |
| `007_seed_grammar.sql` | Grammar points cơ bản (4 ngôn ngữ) |
| `013_seed_grammar_ext.sql` | Grammar mở rộng + ví dụ + bài tập |
| `008_seed_mock_tests.sql` | Mock tests cơ bản (JLPT N5, HSK 1-3, IELTS, TOEIC, TOPIK I) |
| `014_seed_mock_tests_ext.sql` | Mock tests mở rộng (JLPT N3/N2/N1, TOEIC Part 5-7, IELTS Academic, HSK 4/5, TOPIK II) |
| `015_seed_example_sentences.sql` | Câu ví dụ bổ sung (Tatoeba-style) |
| `016_seed_exercises_bank.sql` | Ngân hàng câu hỏi (55 câu 4 ngôn ngữ, đa skill) |
| `009_seed_courses_lessons.sql` | Courses, Sections, Units, Lessons, Exercises |
| `run_all_seeds.sh` | **Script chạy toàn bộ seed** theo đúng thứ tự |

---

## 🚀 Cách chạy

### Option 1: Dùng `docker-compose`
```bash
# Từ thư mục lingua-backend/
docker-compose up -d db

# Đợi DB sẵn sàng ~10s, sau đó chạy migrations:
cd migrations
chmod +x run_all_seeds.sh
DB_HOST=localhost DB_PORT=3306 DB_USER=root DB_PASS=rootpassword DB_NAME=lingua \
  ./run_all_seeds.sh
```

### Option 2: Chạy từng file thủ công
```bash
mysql -h localhost -u root -prootpassword --default-character-set=utf8mb4 lingua < init.sql
mysql -h localhost -u root -prootpassword --default-character-set=utf8mb4 lingua < 002_schema_extensions.sql
# ... tiếp tục các file theo thứ tự trong run_all_seeds.sh
```

### Thứ tự chạy bắt buộc (đã hardcode trong script)
```
1. init.sql                             (schema gốc)
2. 002_schema_extensions.sql            (schema mở rộng)
3. 003_seed_vocab_japanese.sql
4. 004_seed_vocab_chinese.sql
5. 005_seed_vocab_english.sql
6. 006_seed_vocab_korean.sql
7. 010_seed_vocab_japanese_ext.sql
8. 011_seed_vocab_chinese_ext.sql
9. 012_seed_vocab_english_ext.sql
10. 007_seed_grammar.sql
11. 013_seed_grammar_ext.sql
12. 009_seed_courses_lessons.sql
13. 008_seed_mock_tests.sql
14. 014_seed_mock_tests_ext.sql
15. 015_seed_example_sentences.sql
16. 016_seed_exercises_bank.sql
```

---

## ✅ Đã validate

Toàn bộ 16 file đã được **kiểm tra và chạy thành công trên MariaDB 11.8** (tương thích MySQL 8+).

**Lưu ý quan trọng khi chạy:**
- Dùng **`--default-character-set=utf8mb4`** khi kết nối để tránh lỗi ký tự Unicode (Nhật/Hàn/Trung).
- Database phải được tạo với `CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci`.

---

## 📖 Nguồn dữ liệu tham khảo

- **JLPT vocabulary**: [jamsinclair/open-anki-jlpt-decks](https://github.com/jamsinclair/open-anki-jlpt-decks) (CC0), [Tanos.co.uk](https://www.tanos.co.uk/jlpt/)
- **JMdict / EDICT**: [The JMDict Project](https://www.edrdg.org/jmdict/edict.html) (CC-BY-SA)
- **HSK vocabulary**: [drkameleon/complete-hsk-vocabulary](https://github.com/drkameleon/complete-hsk-vocabulary) (CC0), [ivankra/hsk30](https://github.com/ivankra/hsk30)
- **English CEFR**: Oxford 3000/5000 (CC-BY-NC-SA), CEFR-J wordlist, COCA frequency
- **Tatoeba corpus**: [tatoeba.org](https://tatoeba.org) (CC-BY 2.0 FR) — dùng tham khảo cho example sentences
- **TOPIK**: TOPIK official sample questions

Tất cả dữ liệu đã được **Việt hoá và curate thủ công** — không sao chép nguyên vẹn mà chọn lọc và dịch/giải thích bằng tiếng Việt phù hợp với người học Việt Nam.

---

## 🧪 Kiểm tra sau khi chạy

```sql
-- Thống kê tổng quan
SELECT 'Words' AS t, COUNT(*) FROM words
UNION ALL SELECT 'Grammar', COUNT(*) FROM grammar_points
UNION ALL SELECT 'Mock tests', COUNT(*) FROM mock_tests
UNION ALL SELECT 'Questions', COUNT(*) FROM mock_test_questions
UNION ALL SELECT 'Exercises', COUNT(*) FROM exercises;

-- Theo ngôn ngữ
SELECT l.code, COUNT(w.id) FROM languages l
LEFT JOIN words w ON w.language_id=l.id GROUP BY l.code;
```

---

## 📝 Ghi chú

- **`ON DUPLICATE KEY UPDATE`**: Tất cả các file seed đều idempotent — có thể chạy lại nhiều lần mà không gây duplicate.
- **`INSERT IGNORE`**: Dùng cho `word_examples` để bỏ qua những câu tham chiếu tới từ không tồn tại.
- **Dữ liệu tiếng Việt (vi)**: Hiện chưa có vocab/grammar vì `vi` đang được dùng làm ngôn ngữ đích dịch.

---

Version: **v2.1.0** — Last updated: 2026-05-07
