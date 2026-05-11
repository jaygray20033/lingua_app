-- =====================================================
-- SEED: Courses, Sections, Units, Lessons, Exercises
-- Tạo lộ trình học (course path) đầy đủ cho 4 ngôn ngữ.
-- =====================================================

SET NAMES utf8mb4;
SET @ja := (SELECT id FROM languages WHERE code='ja');
SET @en := (SELECT id FROM languages WHERE code='en');
SET @zh := (SELECT id FROM languages WHERE code='zh');
SET @ko := (SELECT id FROM languages WHERE code='ko');
SET @vi := (SELECT id FROM languages WHERE code='vi');

-- =====================================================
-- COURSES
-- =====================================================
INSERT INTO courses (id, title, slug, description, source_lang_id, target_lang_id, level_code, certification, is_premium, status, total_lessons, rating) VALUES
(101, 'Tiếng Nhật từ con số 0 — JLPT N5', 'ja-n5-beginner', 'Khóa học tiếng Nhật từ cơ bản đến đạt trình độ JLPT N5. Học Hiragana, Katakana, từ vựng cơ bản và ngữ pháp nền tảng.', @vi, @ja, 'N5', 'JLPT', 0, 'PUBLISHED', 12, 4.85),
(102, 'Tiếng Nhật JLPT N4', 'ja-n4', 'Nâng cao kỹ năng tiếng Nhật lên JLPT N4 với 80 bài học bao quát ngữ pháp, từ vựng và Kanji thường dùng.', @vi, @ja, 'N4', 'JLPT', 1, 'PUBLISHED', 10, 4.78),
(103, 'Tiếng Nhật JLPT N3', 'ja-n3', 'Khóa học JLPT N3 dành cho người trung cấp - chuẩn bị cho công việc và đời sống tại Nhật.', @vi, @ja, 'N3', 'JLPT', 1, 'PUBLISHED', 8, 4.72),
(201, 'English for Beginners (A1-A2)', 'en-beginner', 'Khóa tiếng Anh từ con số 0, dành cho người mới bắt đầu. Tập trung giao tiếp hằng ngày.', @vi, @en, 'A1', 'CEFR', 0, 'PUBLISHED', 10, 4.80),
(202, 'IELTS Preparation 6.0+', 'en-ielts', 'Chuẩn bị thi IELTS với 4 kỹ năng: Listening, Reading, Writing, Speaking. Mục tiêu band 6.0-7.5.', @vi, @en, 'B2', 'IELTS', 1, 'PUBLISHED', 8, 4.90),
(203, 'TOEIC 600+ Boost', 'en-toeic', 'Khoá luyện TOEIC L&R nhắm 600+. Bao gồm chiến lược phần thi, ngữ pháp & business vocab.', @vi, @en, 'B1', 'TOEIC', 1, 'PUBLISHED', 8, 4.75),
(301, 'Tiếng Trung HSK 1-2', 'zh-hsk1-2', 'Khóa nhập môn tiếng Trung. Pinyin, 300 từ vựng cơ bản, ngữ pháp HSK 1-2.', @vi, @zh, 'HSK1', 'HSK', 0, 'PUBLISHED', 10, 4.70),
(302, 'Tiếng Trung HSK 3-4', 'zh-hsk3-4', 'Trung cấp HSK 3-4 với 1200 từ vựng và ngữ pháp giao tiếp thực tế.', @vi, @zh, 'HSK3', 'HSK', 1, 'PUBLISHED', 8, 4.68),
(401, 'Tiếng Hàn TOPIK I', 'ko-topik1', 'Khoá tiếng Hàn sơ cấp đến TOPIK I (cấp 1-2). Học Hangul, từ vựng cơ bản, đuôi câu.', @vi, @ko, 'TOPIK1', 'TOPIK', 0, 'PUBLISHED', 10, 4.82),
(402, 'Tiếng Hàn TOPIK II', 'ko-topik2', 'Trung-cao cấp TOPIK II (cấp 3-6). Ngữ pháp phức tạp, đọc hiểu, viết bài luận.', @vi, @ko, 'TOPIK3', 'TOPIK', 1, 'PUBLISHED', 8, 4.65)
ON DUPLICATE KEY UPDATE title=VALUES(title), description=VALUES(description);

-- =====================================================
-- SECTIONS, UNITS, LESSONS — Course 101 (JLPT N5)
-- =====================================================
INSERT INTO sections (id, course_id, order_index, title, cefr_mapping) VALUES
(1011, 101, 1, 'Phần 1: Bảng chữ cái và chào hỏi', 'A1'),
(1012, 101, 2, 'Phần 2: Gia đình và bản thân', 'A1'),
(1013, 101, 3, 'Phần 3: Cuộc sống hàng ngày', 'A1')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO units (id, section_id, order_index, title, communication_goal, icon, xp_reward) VALUES
(10111, 1011, 1, 'Hiragana cơ bản', 'Đọc và viết được Hiragana あ-ん', '🔤', 50),
(10112, 1011, 2, 'Chào hỏi cơ bản', 'Chào hỏi đúng tình huống', '👋', 50),
(10121, 1012, 1, 'Giới thiệu bản thân', 'Tự giới thiệu tên, tuổi, quốc tịch', '🙋', 60),
(10122, 1012, 2, 'Gia đình tôi', 'Mô tả thành viên gia đình', '👨‍👩‍👧', 60),
(10131, 1013, 1, 'Mua sắm', 'Hỏi giá, mua đồ', '🛒', 70)
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO lessons (id, unit_id, order_index, title, `type`, xp_reward, exercise_count, is_free_preview) VALUES
(101111, 10111, 1, 'Hiragana hàng あ', 'NORMAL', 10, 5, 1),
(101112, 10111, 2, 'Hiragana hàng か', 'NORMAL', 10, 5, 0),
(101113, 10111, 3, 'Checkpoint hàng あ-か', 'CHECKPOINT', 20, 8, 0),
(101121, 10112, 1, 'おはようございます', 'NORMAL', 10, 5, 1),
(101122, 10112, 2, 'すみません, ありがとう', 'NORMAL', 10, 5, 0),
(101211, 10121, 1, '私は〜です', 'NORMAL', 10, 6, 1),
(101212, 10121, 2, '〜さい (Tuổi)', 'NORMAL', 10, 5, 0),
(101213, 10121, 3, 'Story: Cuộc gặp đầu tiên', 'STORY', 20, 7, 0),
(101221, 10122, 1, 'Thành viên gia đình', 'NORMAL', 10, 6, 0),
(101311, 10131, 1, 'いくらですか？', 'NORMAL', 10, 5, 0)
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- =====================================================
-- SECTIONS, UNITS, LESSONS — Course 201 (English Beginner)
-- =====================================================
INSERT INTO sections (id, course_id, order_index, title, cefr_mapping) VALUES
(2011, 201, 1, 'Unit 1: Greetings & Introductions', 'A1'),
(2012, 201, 2, 'Unit 2: Daily routines', 'A1'),
(2013, 201, 3, 'Unit 3: Shopping & Travel', 'A2')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO units (id, section_id, order_index, title, communication_goal, icon, xp_reward) VALUES
(20111, 2011, 1, 'Saying hello', 'Greet people in different situations', '👋', 50),
(20112, 2011, 2, 'Talking about yourself', 'Introduce yourself confidently', '🙋', 60),
(20121, 2012, 1, 'My morning routine', 'Describe daily activities', '☕', 60),
(20131, 2013, 1, 'At the store', 'Buy items and ask for prices', '🛒', 70)
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO lessons (id, unit_id, order_index, title, `type`, xp_reward, exercise_count, is_free_preview) VALUES
(201111, 20111, 1, 'Hello, How are you?', 'NORMAL', 10, 5, 1),
(201112, 20111, 2, 'Goodbye phrases', 'NORMAL', 10, 5, 0),
(201121, 20112, 1, 'My name is...', 'NORMAL', 10, 6, 1),
(201122, 20112, 2, 'I''m from...', 'NORMAL', 10, 5, 0),
(201211, 20121, 1, 'Present Simple', 'NORMAL', 10, 6, 0),
(201311, 20131, 1, 'How much is it?', 'NORMAL', 10, 5, 0)
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- =====================================================
-- SECTIONS, UNITS, LESSONS — Course 301 (HSK 1-2)
-- =====================================================
INSERT INTO sections (id, course_id, order_index, title, cefr_mapping) VALUES
(3011, 301, 1, '第一部分：拼音和问候', 'A1'),
(3012, 301, 2, '第二部分：自我介绍', 'A1')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO units (id, section_id, order_index, title, communication_goal, icon, xp_reward) VALUES
(30111, 3011, 1, '拼音基础 Pinyin', 'Đọc đúng 4 thanh và ghép vần', '🔤', 50),
(30121, 3012, 1, '我叫... Tôi tên là...', 'Tự giới thiệu cơ bản', '🙋', 60)
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO lessons (id, unit_id, order_index, title, `type`, xp_reward, exercise_count, is_free_preview) VALUES
(301111, 30111, 1, 'Bốn thanh điệu', 'NORMAL', 10, 5, 1),
(301112, 30111, 2, 'Phụ âm b, p, m, f', 'NORMAL', 10, 5, 0),
(301211, 30121, 1, '你好！我叫...', 'NORMAL', 10, 6, 1)
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- =====================================================
-- SECTIONS, UNITS, LESSONS — Course 401 (TOPIK I)
-- =====================================================
INSERT INTO sections (id, course_id, order_index, title, cefr_mapping) VALUES
(4011, 401, 1, '제1부: 한글과 인사', 'A1'),
(4012, 401, 2, '제2부: 자기소개', 'A1')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO units (id, section_id, order_index, title, communication_goal, icon, xp_reward) VALUES
(40111, 4011, 1, '한글 모음', 'Đọc đúng 10 nguyên âm cơ bản', '🔤', 50),
(40121, 4012, 1, '저는 ~입니다', 'Tự giới thiệu cơ bản', '🙋', 60)
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO lessons (id, unit_id, order_index, title, `type`, xp_reward, exercise_count, is_free_preview) VALUES
(401111, 40111, 1, 'Nguyên âm ㅏ ㅓ ㅗ ㅜ', 'NORMAL', 10, 5, 1),
(401211, 40121, 1, '안녕하세요!', 'NORMAL', 10, 5, 1)
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- =====================================================
-- EXERCISES (bài tập trong từng lesson)
-- =====================================================

-- ========== Lesson 101111 — Hiragana hàng あ (JLPT N5) ==========
INSERT INTO exercises (lesson_id, order_index, `type`, prompt_json, answer_json, options_json, correct_answer_json, hint_json, difficulty, explanation) VALUES
(101111, 1, 'FILL_BLANK', '{"prompt":"Cách đọc của ký tự あ?"}', '"a"', '["a","i","u","e"]', '"a"', '{"hint":"Là nguyên âm đầu tiên"}', 1, 'あ đọc là "a"'),
(101111, 2, 'FILL_BLANK', '{"prompt":"Cách đọc của ký tự い?"}', '"i"', '["a","i","u","e"]', '"i"', NULL, 1, 'い đọc là "i"'),
(101111, 3, 'TRANSLATE', '{"prompt":"Viết Hiragana cho âm \"u\""}', '"う"', '["あ","い","う","え"]', '"う"', NULL, 1, 'う = u'),
(101111, 4, 'MATCH_PAIRS', '{"pairs":[{"left":"あ","right":"a"},{"left":"い","right":"i"},{"left":"う","right":"u"},{"left":"え","right":"e"},{"left":"お","right":"o"}]}', '{"correct":true}', NULL, '{"correct":true}', NULL, 1, 'Ghép cặp Hiragana ↔ Romaji'),
(101111, 5, 'TRUE_FALSE', '{"prompt":"\"お\" đọc là \"o\""}', 'true', '["true","false"]', 'true', NULL, 1, 'Đúng. お = o.');

-- ========== Lesson 101121 — おはようございます ==========
INSERT INTO exercises (lesson_id, order_index, `type`, prompt_json, answer_json, options_json, correct_answer_json, difficulty, explanation) VALUES
(101121, 1, 'TRANSLATE', '{"prompt":"Dịch: \"Chào buổi sáng\" sang tiếng Nhật"}', '"おはようございます"', '["こんにちは","おはようございます","こんばんは","おやすみなさい"]', '"おはようございます"', 1, 'おはようございます = chào buổi sáng (lịch sự)'),
(101121, 2, 'TRANSLATE', '{"prompt":"\"こんにちは\" có nghĩa là gì?"}', '"Xin chào (ban ngày)"', '["Chào buổi sáng","Xin chào (ban ngày)","Chào buổi tối","Tạm biệt"]', '"Xin chào (ban ngày)"', 1, 'こんにちは dùng từ trưa đến chiều'),
(101121, 3, 'LISTEN_SELECT', '{"prompt":"Nghe và chọn câu chào tương ứng (buổi tối)","audio":"placeholder.mp3"}', '"こんばんは"', '["おはよう","こんにちは","こんばんは","さようなら"]', '"こんばんは"', 1, 'こんばんは = chào buổi tối'),
(101121, 4, 'FILL_BLANK', '{"prompt":"Điền: \"___, 田中さん。\" (Chào buổi sáng anh Tanaka)"}', '"おはようございます"', NULL, '"おはようございます"', 1, NULL),
(101121, 5, 'SENTENCE_ORDER', '{"prompt":"Sắp xếp: \"ございます / おはよう\"","tokens":["ございます","おはよう"]}', '"おはようございます"', NULL, '"おはようございます"', 1, 'Đúng thứ tự: おはよう + ございます');

-- ========== Lesson 101211 — 私は〜です ==========
INSERT INTO exercises (lesson_id, order_index, `type`, prompt_json, answer_json, options_json, correct_answer_json, difficulty, explanation) VALUES
(101211, 1, 'FILL_BLANK', '{"prompt":"私___学生です。"}', '"は"', '["は","が","を","に"]', '"は"', 1, 'Trợ từ chủ đề「は」'),
(101211, 2, 'TRANSLATE', '{"prompt":"Dịch: \"Tôi là người Việt Nam\""}', '"私はベトナム人です。"', NULL, '"私はベトナム人です。"', 2, NULL),
(101211, 3, 'FILL_BLANK', '{"prompt":"Câu nào ĐÚNG?"}', '"私は田中です。"', '["私が田中です","私は田中です。","私を田中です","私に田中です"]', '"私は田中です。"', 1, NULL),
(101211, 4, 'SENTENCE_ORDER', '{"prompt":"Sắp xếp câu","tokens":["私","は","学生","です"]}', '"私は学生です"', NULL, '"私は学生です"', 1, NULL),
(101211, 5, 'TRUE_FALSE', '{"prompt":"\"私は学生じゃありません\" có nghĩa là \"Tôi không phải học sinh\""}', 'true', '["true","false"]', 'true', 1, 'じゃありません là phủ định của です'),
(101211, 6, 'DICTATION', '{"prompt":"Nghe và viết lại","audio":"placeholder.mp3"}', '"私は学生です"', NULL, '"私は学生です"', 2, NULL);

-- ========== Lesson 201111 — Hello, How are you? ==========
INSERT INTO exercises (lesson_id, order_index, `type`, prompt_json, answer_json, options_json, correct_answer_json, difficulty, explanation) VALUES
(201111, 1, 'TRANSLATE', '{"prompt":"Translate: \"Xin chào\""}', '"Hello"', '["Hello","Goodbye","Thanks","Sorry"]', '"Hello"', 1, NULL),
(201111, 2, 'FILL_BLANK', '{"prompt":"Phù hợp nhất khi gặp ai lần đầu?"}', '"Nice to meet you"', '["See you later","Nice to meet you","Take care","Long time no see"]', '"Nice to meet you"', 1, NULL),
(201111, 3, 'FILL_BLANK', '{"prompt":"___ are you? (Hỏi thăm sức khỏe)"}', '"How"', '["What","How","Who","Where"]', '"How"', 1, NULL),
(201111, 4, 'LISTEN_SELECT', '{"prompt":"Listen and choose","audio":"placeholder.mp3"}', '"I''m fine, thanks"', '["I''m fine, thanks","I am John","I am 25","I live in Hanoi"]', '"I''m fine, thanks"', 1, NULL),
(201111, 5, 'SENTENCE_ORDER', '{"prompt":"Sắp xếp","tokens":["are","you","How","today","?"]}', '"How are you today?"', NULL, '"How are you today?"', 1, NULL);

-- ========== Lesson 201211 — Present Simple ==========
INSERT INTO exercises (lesson_id, order_index, `type`, prompt_json, answer_json, options_json, correct_answer_json, difficulty, explanation) VALUES
(201211, 1, 'FILL_BLANK', '{"prompt":"She ___ (work) at a hospital."}', '"works"', '["work","works","working","worked"]', '"works"', 1, 'Ngôi 3 số ít → V + s'),
(201211, 2, 'FILL_BLANK', '{"prompt":"They ___ (live) in Hanoi."}', '"live"', '["live","lives","living","lived"]', '"live"', 1, 'Ngôi 3 số nhiều → V nguyên thể'),
(201211, 3, 'FILL_BLANK', '{"prompt":"Câu nào đúng?"}', '"He goes to school every day."', '["He go to school","He goes to school every day.","He going to school","He gone to school"]', '"He goes to school every day."', 1, NULL),
(201211, 4, 'TRANSLATE', '{"prompt":"Dịch: Tôi không thích cà phê"}', '"I don''t like coffee"', NULL, '"I don''t like coffee"', 2, 'Phủ định: don''t/doesn''t + V'),
(201211, 5, 'TRUE_FALSE', '{"prompt":"Câu \"She don''t go to school\" là đúng."}', 'false', '["true","false"]', 'false', 1, 'Phải là "doesn''t" cho ngôi 3 số ít'),
(201211, 6, 'SENTENCE_ORDER', '{"prompt":"Arrange the words","tokens":["I","read","every","books","day"]}', '"I read books every day"', NULL, '"I read books every day"', 1, NULL);

-- ========== Lesson 301111 — Bốn thanh điệu (HSK1) ==========
INSERT INTO exercises (lesson_id, order_index, `type`, prompt_json, answer_json, options_json, correct_answer_json, difficulty, explanation) VALUES
(301111, 1, 'FILL_BLANK', '{"prompt":"Tiếng Trung có bao nhiêu thanh điệu chính?"}', '"4"', '["3","4","5","6"]', '"4"', 1, '4 thanh + 1 thanh nhẹ'),
(301111, 2, 'FILL_BLANK', '{"prompt":"\"妈\" thuộc thanh nào?"}', '"Thanh 1"', '["Thanh 1","Thanh 2","Thanh 3","Thanh 4"]', '"Thanh 1"', 1, 'mā = thanh 1 (cao và bằng)'),
(301111, 3, 'LISTEN_SELECT', '{"prompt":"Nghe và chọn pinyin đúng cho \"妈\"","audio":"placeholder.mp3"}', '"mā"', '["mā","má","mǎ","mà"]', '"mā"', 1, NULL),
(301111, 4, 'TRUE_FALSE', '{"prompt":"妈 và 马 cùng cách đọc"}', 'false', '["true","false"]', 'false', 1, 'mā (mẹ) khác mǎ (ngựa)'),
(301111, 5, 'TRANSLATE', '{"prompt":"\"你好\" đọc là?"}', '"nǐ hǎo"', '["ní hǎo","nǐ hǎo","nì hào","nī hāo"]', '"nǐ hǎo"', 1, '你 = nǐ (thanh 3), 好 = hǎo (thanh 3)');

-- ========== Lesson 301211 — 你好！我叫... (HSK1) ==========
INSERT INTO exercises (lesson_id, order_index, `type`, prompt_json, answer_json, options_json, correct_answer_json, difficulty, explanation) VALUES
(301211, 1, 'TRANSLATE', '{"prompt":"\"你好\" có nghĩa là gì?"}', '"Xin chào"', '["Xin chào","Tạm biệt","Cảm ơn","Xin lỗi"]', '"Xin chào"', 1, NULL),
(301211, 2, 'FILL_BLANK', '{"prompt":"我___ Tom。 (Tôi tên Tom)"}', '"叫"', '["是","叫","有","在"]', '"叫"', 1, '叫 = tên là (giới thiệu tên)'),
(301211, 3, 'FILL_BLANK', '{"prompt":"Câu nào tự giới thiệu đúng?"}', '"我叫王小明，我是中国人。"', '["我叫王小明","我叫王小明，我是中国人。","王小明叫我","我是叫王小明"]', '"我叫王小明，我是中国人。"', 1, NULL),
(301211, 4, 'SENTENCE_ORDER', '{"prompt":"Sắp xếp","tokens":["我","学生","是"]}', '"我是学生"', NULL, '"我是学生"', 1, NULL),
(301211, 5, 'DICTATION', '{"prompt":"Nghe và viết Pinyin","audio":"placeholder.mp3"}', '"wǒ shì xuésheng"', NULL, '"wǒ shì xuésheng"', 2, NULL),
(301211, 6, 'TRUE_FALSE', '{"prompt":"\"我是中国人\" nghĩa là \"Tôi là người Trung Quốc\""}', 'true', '["true","false"]', 'true', 1, NULL);

-- ========== Lesson 401111 — Hangul vowels ==========
INSERT INTO exercises (lesson_id, order_index, `type`, prompt_json, answer_json, options_json, correct_answer_json, difficulty, explanation) VALUES
(401111, 1, 'FILL_BLANK', '{"prompt":"Cách đọc nguyên âm ㅏ?"}', '"a"', '["a","eo","o","u"]', '"a"', 1, 'ㅏ = a'),
(401111, 2, 'FILL_BLANK', '{"prompt":"Cách đọc ㅓ?"}', '"eo"', '["a","eo","o","u"]', '"eo"', 1, 'ㅓ = eo (giống "ơ" tiếng Việt)'),
(401111, 3, 'TRUE_FALSE', '{"prompt":"ㅗ đọc là \"o\""}', 'true', '["true","false"]', 'true', 1, NULL),
(401111, 4, 'MATCH_PAIRS', '{"pairs":[{"left":"ㅏ","right":"a"},{"left":"ㅓ","right":"eo"},{"left":"ㅗ","right":"o"},{"left":"ㅜ","right":"u"}]}', '{"correct":true}', NULL, '{"correct":true}', 1, 'Ghép cặp nguyên âm Hangul'),
(401111, 5, 'LISTEN_SELECT', '{"prompt":"Nghe và chọn nguyên âm","audio":"placeholder.mp3"}', '"ㅏ"', '["ㅏ","ㅓ","ㅗ","ㅜ"]', '"ㅏ"', 1, NULL);

-- ========== Lesson 401211 — 안녕하세요 (TOPIK1) ==========
INSERT INTO exercises (lesson_id, order_index, `type`, prompt_json, answer_json, options_json, correct_answer_json, difficulty, explanation) VALUES
(401211, 1, 'TRANSLATE', '{"prompt":"\"안녕하세요\" nghĩa là gì?"}', '"Xin chào (lịch sự)"', '["Xin chào (lịch sự)","Tạm biệt","Cảm ơn","Xin lỗi"]', '"Xin chào (lịch sự)"', 1, NULL),
(401211, 2, 'FILL_BLANK', '{"prompt":"저는 학생___."}', '"입니다"', '["입니다","이에요","예요","습니다"]', '"입니다"', 1, '학생 + 입니다 (formal)'),
(401211, 3, 'FILL_BLANK', '{"prompt":"Câu cảm ơn lịch sự?"}', '"감사합니다"', '["미안합니다","감사합니다","안녕히 계세요","좋아요"]', '"감사합니다"', 1, NULL),
(401211, 4, 'DICTATION', '{"prompt":"Nghe và viết","audio":"placeholder.mp3"}', '"안녕하세요"', NULL, '"안녕하세요"', 2, NULL),
(401211, 5, 'SENTENCE_ORDER', '{"prompt":"Sắp xếp","tokens":["저","는","학생","입니다"]}', '"저는 학생입니다"', NULL, '"저는 학생입니다"', 1, NULL);

-- =====================================================
-- AUTO-UPDATE: cập nhật total_lessons cho courses
-- =====================================================
UPDATE courses c SET total_lessons = (
  SELECT COUNT(*) FROM lessons l
  JOIN units u ON u.id = l.unit_id
  JOIN sections s ON s.id = u.section_id
  WHERE s.course_id = c.id
);

-- Cập nhật exercise_count
UPDATE lessons l SET exercise_count = (
  SELECT COUNT(*) FROM exercises e WHERE e.lesson_id = l.id
);
