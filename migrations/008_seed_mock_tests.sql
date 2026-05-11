-- =====================================================
-- SEED: Mock Tests - JLPT, IELTS, TOEIC, HSK, TOPIK
-- Mỗi đề có sections + questions với đáp án và giải thích.
-- =====================================================

SET NAMES utf8mb4;
SET @ja := (SELECT id FROM languages WHERE code='ja');
SET @en := (SELECT id FROM languages WHERE code='en');
SET @zh := (SELECT id FROM languages WHERE code='zh');
SET @ko := (SELECT id FROM languages WHERE code='ko');

-- =====================================================
-- 1. JLPT N5 — Đề thi thử
-- =====================================================
INSERT INTO mock_tests (id, title, language_id, `type`, level_code, duration_min, total_questions, pass_score, is_premium, description, lang_code, flag_emoji)
VALUES (1001, 'JLPT N5 — Đề thi thử số 1', @ja, 'JLPT', 'N5', 105, 12, 80, 0,
        'Đề thi thử JLPT N5 mô phỏng đề thi chính thức (Mojigoi + Bunpou + Dokkai + Choukai). Tổng điểm tối đa 180.',
        'ja', '🇯🇵');

-- Sections
INSERT INTO mock_test_sections (id, mock_test_id, order_index, title, duration_min, description) VALUES
(10011, 1001, 1, '言語知識（文字・語彙）/ Văn tự - Từ vựng', 20, 'Kiểm tra cách đọc Hiragana, Kanji và từ vựng N5'),
(10012, 1001, 2, '言語知識（文法）・読解 / Ngữ pháp - Đọc hiểu', 40, 'Ngữ pháp cơ bản và đọc hiểu đoạn văn ngắn'),
(10013, 1001, 3, '聴解 / Nghe hiểu', 30, 'Nghe hội thoại đơn giản và chọn đáp án');

-- Questions for Section 10011 (Văn tự - Từ vựng)
INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(10011, 1, 'MCQ', 'この __車__ は新しいです。 (Cách đọc Kanji 「車」 là gì?)',
 'この __車__ は新しいです。',
 '{"text":"この __車__ は新しいです。","focus":"車"}',
 '["くるま","でんしゃ","じてんしゃ","じどうしゃ"]', 'くるま', '"くるま"',
 '車 đọc là "くるま" (kuruma) nghĩa là xe ô tô.'),

(10011, 2, 'MCQ', '私は __がくせい__ です。 (Kanji nào tương ứng?)',
 '私は __がくせい__ です。',
 '{"text":"私は __がくせい__ です。","focus":"がくせい"}',
 '["学生","学校","先生","学習"]', '学生', '"学生"',
 'がくせい = 学生 (học sinh).'),

(10011, 3, 'MCQ', '___を飲みます。 (Điền từ phù hợp)',
 '___を飲みます。',
 '{"text":"___を飲みます。"}',
 '["みず","ほん","くるま","いえ"]', 'みず', '"みず"',
 '飲みます = uống → mizu (nước) là đáp án phù hợp.'),

(10011, 4, 'MCQ', 'やすみの ひに なにを しますか。— "やすみ" có nghĩa là gì?',
 'やすみの ひに なにを しますか。',
 '{"text":"やすみの ひに なにを しますか。"}',
 '["ngày nghỉ","ngày làm việc","sáng","đêm"]', 'ngày nghỉ', '"ngày nghỉ"',
 'やすみ = 休み = ngày nghỉ.');

-- Questions for Section 10012 (Ngữ pháp - Đọc hiểu)
INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(10012, 1, 'MCQ', '私___学生です。 (Chọn trợ từ đúng)',
 '私___学生です。',
 '{"text":"私___学生です。"}',
 '["は","が","を","に"]', 'は', '"は"',
 '「は」 là trợ từ chủ đề trong câu khẳng định "A là B".'),

(10012, 2, 'MCQ', '本___あります。 (Chọn trợ từ đúng)',
 '本___あります。',
 '{"text":"本___あります。"}',
 '["は","が","を","に"]', 'が', '"が"',
 'Với 「あります／います」, đối tượng dùng trợ từ 「が」.'),

(10012, 3, 'MCQ', 'いえ___かえります。',
 'いえ___かえります。',
 '{"text":"いえ___かえります。"}',
 '["を","へ","で","の"]', 'へ', '"へ"',
 '「へ」 chỉ phương hướng "đi đến đâu".'),

(10012, 4, 'MCQ', 'コーヒー___のみたいです。',
 'コーヒー___のみたいです。',
 '{"text":"コーヒー___のみたいです。"}',
 '["を","が","に","で"]', 'が', '"が"',
 'Với 「〜たい」, tân ngữ thường đi với 「が」 (cũng chấp nhận を).');

-- Questions for Section 10013 (Nghe hiểu)
INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, audio_url, answer_json, explanation) VALUES
(10013, 1, 'LISTEN', '【Nghe đoạn hội thoại】 Người phụ nữ sẽ làm gì vào sáng mai?',
 'Người phụ nữ sẽ làm gì vào sáng mai?',
 '{"transcript":"A: 明日の朝、何をしますか？ B: 公園で走ります。"}',
 '["Đi học","Chạy ở công viên","Đi mua sắm","Ngủ"]', 'Chạy ở công viên',
 NULL, '"Chạy ở công viên"',
 'Trong đoạn hội thoại: 「公園で走ります」 = chạy ở công viên.'),

(10013, 2, 'LISTEN', '【Nghe】 Cuộc họp bắt đầu lúc mấy giờ?',
 'Cuộc họp bắt đầu lúc mấy giờ?',
 '{"transcript":"会議は午後3時に始まります。"}',
 '["10 giờ sáng","2 giờ chiều","3 giờ chiều","6 giờ tối"]', '3 giờ chiều',
 NULL, '"3 giờ chiều"',
 '「午後3時」 = 3 giờ chiều.'),

(10013, 3, 'LISTEN', '【Nghe】 Nam giới muốn ăn gì?',
 'Nam giới muốn ăn gì?',
 '{"transcript":"今日はラーメンを食べたいです。"}',
 '["Sushi","Ramen","Tempura","Cơm"]', 'Ramen',
 NULL, '"Ramen"',
 'Nam giới nói: ラーメンを食べたい.'),

(10013, 4, 'LISTEN', '【Nghe】 Cô gái sẽ gặp ai?',
 'Cô gái sẽ gặp ai?',
 '{"transcript":"明日、ともだちにあいます。"}',
 '["Bố","Mẹ","Bạn","Giáo viên"]', 'Bạn',
 NULL, '"Bạn"',
 '「ともだち」 = bạn bè.');

-- =====================================================
-- 2. JLPT N3 — Đề thi thử
-- =====================================================
INSERT INTO mock_tests (id, title, language_id, `type`, level_code, duration_min, total_questions, pass_score, is_premium, description, lang_code, flag_emoji)
VALUES (1003, 'JLPT N3 — Đề thi thử số 1', @ja, 'JLPT', 'N3', 140, 8, 95, 1,
        'Đề thi thử N3 độ khó trung bình - cao. Bao gồm Văn tự, Từ vựng, Ngữ pháp, Đọc hiểu, Nghe hiểu.',
        'ja', '🇯🇵');

INSERT INTO mock_test_sections (id, mock_test_id, order_index, title, duration_min, description) VALUES
(10031, 1003, 1, 'Ngữ pháp - Từ vựng', 70, 'Phần ngữ pháp và từ vựng N3'),
(10032, 1003, 2, 'Đọc hiểu', 40, 'Bài đọc trung bình ~ 400 ký tự'),
(10033, 1003, 3, 'Nghe hiểu', 30, 'Nghe hội thoại trong các tình huống thực tế');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(10031, 1, 'MCQ', '雨___、試合は中止になりました。',
 '雨___、試合は中止になりました。',
 '{"text":"雨___、試合は中止になりました。"}',
 '["のために","のように","によって","にとって"]', 'のために', '"のために"',
 '「Nのために」 chỉ nguyên nhân = vì N nên ~.'),

(10031, 2, 'MCQ', 'この本は子供___易しいです。',
 'この本は子供___易しいです。',
 '{"text":"この本は子供___易しいです。"}',
 '["によって","にとって","に対して","として"]', 'にとって', '"にとって"',
 '「Nにとって」 = đối với N, theo quan điểm của N.'),

(10031, 3, 'MCQ', '勉強すれば___、合格できますよ。',
 '勉強すれば___、合格できますよ。',
 '{"text":"勉強すれば___、合格できますよ。"}',
 '["するほど","するばかり","するだけ","するわけ"]', 'するほど', '"するほど"',
 '「〜ば〜ほど」 = càng ~ càng ~.');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(10032, 1, 'READING', '【Đọc đoạn văn】「最近、若者の間でアウトドア活動が人気になっている。特にキャンプは、自然の中でリラックスできるため、ストレスの多い生活を送る人々に好まれている。」 → Vì sao キャンプ được ưa chuộng?',
 'Vì sao キャンプ được ưa chuộng?',
 '{"passage":"最近、若者の間でアウトドア活動が人気になっている。特にキャンプは、自然の中でリラックスできるため、ストレスの多い生活を送る人々に好まれている。"}',
 '["Vì rẻ","Vì có thể thư giãn trong thiên nhiên","Vì gần thành phố","Vì nhiều bạn bè"]',
 'Vì có thể thư giãn trong thiên nhiên', '"Vì có thể thư giãn trong thiên nhiên"',
 'Đoạn văn nói: 自然の中でリラックスできるため (vì có thể thư giãn trong tự nhiên).');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, audio_url, answer_json, explanation) VALUES
(10033, 1, 'LISTEN', '【Nghe】 Người đàn ông sẽ làm gì cuối tuần này?',
 'Người đàn ông sẽ làm gì cuối tuần này?',
 '{"transcript":"今週末、京都へ旅行に行く予定です。お寺を見たり、おいしいものを食べたりしたいです。"}',
 '["Đi du lịch Kyoto","Ở nhà","Đi làm","Học bài"]',
 'Đi du lịch Kyoto', NULL, '"Đi du lịch Kyoto"',
 '「京都へ旅行に行く予定」 = dự định đi du lịch Kyoto.');

-- =====================================================
-- 3. IELTS — Đề thi thử
-- =====================================================
INSERT INTO mock_tests (id, title, language_id, `type`, level_code, duration_min, total_questions, pass_score, is_premium, description, lang_code, flag_emoji)
VALUES (2001, 'IELTS Academic — Đề thi thử số 1', @en, 'IELTS', 'B2', 165, 12, 60, 1,
        'Đề thi thử IELTS Academic gồm Listening, Reading, Writing, Speaking. Band điểm mục tiêu 6.0-7.0.',
        'en', '🇬🇧');

INSERT INTO mock_test_sections (id, mock_test_id, order_index, title, duration_min, description) VALUES
(20011, 2001, 1, 'Listening', 30, '4 phần - 40 câu hỏi (rút gọn còn 4 trong demo)'),
(20012, 2001, 2, 'Reading', 60, '3 đoạn văn học thuật'),
(20013, 2001, 3, 'Writing', 60, 'Task 1: Mô tả biểu đồ. Task 2: Bài luận'),
(20014, 2001, 4, 'Speaking', 15, '3 phần - phỏng vấn cá nhân');

-- Listening
INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, audio_url, answer_json, explanation) VALUES
(20011, 1, 'LISTEN', '【Listen】 What time does the library open on Sundays?',
 'What time does the library open on Sundays?',
 '{"transcript":"The library is open from 9am to 8pm on weekdays, and from 10am to 5pm on Sundays."}',
 '["8am","9am","10am","11am"]', '10am', NULL, '"10am"',
 'On Sundays, opens at 10am.'),

(20011, 2, 'LISTEN', '【Listen】 Where does the speaker recommend staying?',
 'Where does the speaker recommend staying?',
 '{"transcript":"For budget travelers, I recommend the Riverside Hostel — it''s clean, central and affordable."}',
 '["Hotel Grand","Riverside Hostel","Mountain Lodge","Beach Resort"]',
 'Riverside Hostel', NULL, '"Riverside Hostel"',
 'Speaker says: I recommend the Riverside Hostel.');

-- Reading
INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(20012, 1, 'READING', '【Read】 "Climate change has accelerated dramatically over the past century, primarily due to human activities such as burning fossil fuels and deforestation. Scientists warn that immediate action is essential to mitigate its devastating effects." → According to the passage, what is the MAIN cause of accelerated climate change?',
 'What is the MAIN cause of accelerated climate change?',
 '{"passage":"Climate change has accelerated dramatically over the past century, primarily due to human activities such as burning fossil fuels and deforestation. Scientists warn that immediate action is essential to mitigate its devastating effects."}',
 '["Natural cycles","Human activities","Solar radiation","Volcanic eruptions"]',
 'Human activities', '"Human activities"',
 'The passage states "primarily due to human activities".'),

(20012, 2, 'READING_TF', '【True/False/NG】 The passage states that climate change can be reversed easily.',
 'True/False/Not Given',
 '{"passage":"Climate change has accelerated dramatically over the past century..."}',
 '["True","False","Not Given"]', 'False', '"False"',
 'The passage emphasizes urgency and "devastating effects" → opposite of "easily reversible".'),

(20012, 3, 'GAP_FILL', '【Complete the sentence】 Scientists call for ___ action to mitigate climate change.',
 'Fill in the blank',
 '{"text":"Scientists call for ___ action."}',
 '["delayed","immediate","optional","minimal"]', 'immediate', '"immediate"',
 'The passage says: "immediate action is essential".');

-- Writing (rubric-based)
INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(20013, 1, 'ESSAY', '【Task 2 - 250 words】 "Some people believe that university education should be free for all students. To what extent do you agree or disagree?"',
 'Write a 250-word essay',
 '{"task":"Task 2","words":250,"rubric":["Task Response","Coherence","Vocabulary","Grammar"]}',
 '[]', 'rubric', '"rubric"',
 'Chấm theo 4 tiêu chí (TR/CC/LR/GRA). AI sẽ chấm tự động qua /api/ai/explain với prompt đặc biệt.');

-- Speaking
INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, audio_url, answer_json, explanation) VALUES
(20014, 1, 'SPEAK', '【Part 2 - Cue card】 Describe a place you would like to visit. You should say: where it is, why you want to go, what you would do there, and explain how you feel about it.',
 'Speak for 1-2 minutes',
 '{"part":"Part 2","prep_time":60,"speak_time":120}',
 '[]', 'rubric', NULL, '"rubric"',
 'Chấm theo Fluency, Lexical Resource, Grammatical Range, Pronunciation.');

-- =====================================================
-- 4. TOEIC — Đề thi thử
-- =====================================================
INSERT INTO mock_tests (id, title, language_id, `type`, level_code, duration_min, total_questions, pass_score, is_premium, description, lang_code, flag_emoji)
VALUES (3001, 'TOEIC L&R — Đề thi thử số 1', @en, 'TOEIC', 'B1', 120, 10, 600, 1,
        'Đề thi thử TOEIC Listening & Reading. 200 câu trong đề thật, demo 10 câu. Mục tiêu 600+.',
        'en', '🇺🇸');

INSERT INTO mock_test_sections (id, mock_test_id, order_index, title, duration_min, description) VALUES
(30011, 3001, 1, 'Listening Part 1-4', 45, 'Photographs, Q&A, Conversations, Talks'),
(30012, 3001, 2, 'Reading Part 5-7', 75, 'Incomplete sentences, Text completion, Reading comprehension');

-- Listening
INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, audio_url, answer_json, explanation) VALUES
(30011, 1, 'LISTEN', '【Part 2 - Q&A】 Question: "When is the meeting scheduled?"',
 'Choose the best response',
 '{"transcript":"Q: When is the meeting scheduled?"}',
 '["At 3 PM tomorrow","In the conference room","Mr. Brown is the chairperson","Yes, I attended"]',
 'At 3 PM tomorrow', NULL, '"At 3 PM tomorrow"',
 'Câu hỏi When → trả lời thời gian.'),

(30011, 2, 'LISTEN', '【Part 3 - Conversation】 Where is the conversation taking place?',
 'Where is the conversation taking place?',
 '{"transcript":"M: I''d like to check in. W: Of course, may I have your reservation number please?"}',
 '["Restaurant","Hotel","Airport","Library"]',
 'Hotel', NULL, '"Hotel"',
 '"Check-in" + "reservation number" → khách sạn.'),

(30011, 3, 'LISTEN', '【Part 4 - Announcement】 What is the announcement about?',
 'What is the announcement about?',
 '{"transcript":"Attention passengers, flight VN302 to Tokyo has been delayed by 30 minutes due to weather conditions."}',
 '["Flight cancellation","Flight delay","Gate change","Baggage claim"]',
 'Flight delay', NULL, '"Flight delay"',
 '"delayed by 30 minutes" → flight delay.');

-- Reading
INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(30012, 1, 'MCQ', '【Part 5】 The new policy will be ___ effective from next Monday.',
 'Fill in the blank',
 '{"text":"The new policy will be ___ effective from next Monday."}',
 '["fully","full","fullness","fullest"]', 'fully', '"fully"',
 'Trạng từ "fully" bổ nghĩa cho tính từ "effective".'),

(30012, 2, 'MCQ', '【Part 5】 Please ___ the report by Friday.',
 'Fill in the blank',
 '{"text":"Please ___ the report by Friday."}',
 '["submit","submitted","submitting","submission"]', 'submit', '"submit"',
 'Câu mệnh lệnh dùng V nguyên thể.'),

(30012, 3, 'MCQ', '【Part 6】 We are pleased to announce that our company has reached a new ___ in revenue.',
 'Fill in the blank',
 '{"text":"new ___ in revenue"}',
 '["mile","milestone","milestones","milestoning"]', 'milestone', '"milestone"',
 'Cần danh từ số ít sau "a new".'),

(30012, 4, 'READING', '【Part 7】 Email: "Dear Mr. Smith, We confirm your reservation at Grand Hotel for 3 nights starting March 15th. Check-in time is 3 PM." → When is check-in?',
 'When is check-in?',
 '{"passage":"Dear Mr. Smith, We confirm your reservation at Grand Hotel for 3 nights starting March 15th. Check-in time is 3 PM."}',
 '["12 PM","1 PM","3 PM","6 PM"]', '3 PM', '"3 PM"',
 'Email ghi: "Check-in time is 3 PM".'),

(30012, 5, 'READING', '【Part 7】 Same email: How long is the stay?',
 'How long is the stay?',
 '{"passage":"reservation at Grand Hotel for 3 nights starting March 15th"}',
 '["1 night","2 nights","3 nights","4 nights"]', '3 nights', '"3 nights"',
 '"for 3 nights" - đáp án rõ ràng.'),

(30012, 6, 'READING', '【Part 7】 Notice: "All employees must complete the cybersecurity training by April 30th. Failure to comply will result in restricted system access." → What happens if employees do NOT complete training?',
 'What happens if employees do NOT complete training?',
 '{"passage":"All employees must complete the cybersecurity training by April 30th. Failure to comply will result in restricted system access."}',
 '["Promotion","Bonus","Restricted system access","Termination"]',
 'Restricted system access', '"Restricted system access"',
 'Notice rõ ràng: "result in restricted system access".'),

(30012, 7, 'MCQ', '【Part 5】 The conference room ___ for 50 people.',
 'Fill in the blank',
 '{"text":"The conference room ___ for 50 people."}',
 '["accommodate","accommodates","accommodating","to accommodate"]',
 'accommodates', '"accommodates"',
 'Chủ ngữ ngôi 3 số ít → V thêm s.');

-- =====================================================
-- 5. HSK 3 — Đề thi thử
-- =====================================================
INSERT INTO mock_tests (id, title, language_id, `type`, level_code, duration_min, total_questions, pass_score, is_premium, description, lang_code, flag_emoji)
VALUES (4001, 'HSK 3 — Đề thi thử số 1', @zh, 'HSK', 'HSK3', 90, 6, 180, 1,
        'Đề thi thử HSK 3: Nghe (听力), Đọc hiểu (阅读), Viết (书写). Tổng điểm 300, đậu 180.',
        'zh', '🇨🇳');

INSERT INTO mock_test_sections (id, mock_test_id, order_index, title, duration_min, description) VALUES
(40011, 4001, 1, '听力 Listening', 35, '40 câu nghe (demo 2 câu)'),
(40012, 4001, 2, '阅读 Reading', 30, '30 câu đọc hiểu (demo 3 câu)'),
(40013, 4001, 3, '书写 Writing', 15, '10 câu viết (demo 1 câu)');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, audio_url, answer_json, explanation) VALUES
(40011, 1, 'LISTEN', '【听力】 男的在哪里？',
 '男的在哪里？',
 '{"transcript":"女：今天天气真好，我们去公园吧。男：好啊，我已经在公园等你了。"}',
 '["家里","公园","商店","学校"]', '公园', NULL, '"公园"',
 '男的说: 我已经在公园等你了 → 在公园.'),

(40011, 2, 'LISTEN', '【听力】 他们要做什么？',
 '他们要做什么？',
 '{"transcript":"我们今天晚上一起去看电影吧。"}',
 '["吃饭","看电影","买东西","睡觉"]', '看电影', NULL, '"看电影"',
 '一起去看电影 = đi xem phim cùng nhau.');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(40012, 1, 'MCQ', '【阅读】 选词填空: 他每天___ 公园跑步。',
 '选词填空',
 '{"text":"他每天___ 公园跑步。"}',
 '["在","和","对","跟"]', '在', '"在"',
 '在 + 地点 = ở + nơi chốn.'),

(40012, 2, 'MCQ', '【阅读】 这个手机比那个___。',
 '选词填空',
 '{"text":"这个手机比那个___。"}',
 '["很贵","贵","贵了","太贵"]', '贵', '"贵"',
 'Cấu trúc 比 + danh từ + tính từ (không dùng 很).'),

(40012, 3, 'READING', '【阅读】 短文: 王老师非常喜欢运动，每天早上六点起床去跑步。 → 王老师早上几点起床？',
 '王老师早上几点起床？',
 '{"passage":"王老师非常喜欢运动，每天早上六点起床去跑步。"}',
 '["五点","六点","七点","八点"]', '六点', '"六点"',
 '每天早上六点起床.');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(40013, 1, 'WRITE', '【书写】 Sắp xếp thành câu hoàn chỉnh: "我 / 学 / 在 / 中文 / 大学"',
 '排序',
 '{"words":["我","在","大学","学","中文"]}',
 '["我在大学学中文","我学中文在大学","在大学我学中文","中文我学在大学"]',
 '我在大学学中文', '"我在大学学中文"',
 'Cấu trúc: S + 在 + 地点 + V + O.');

-- =====================================================
-- 6. TOPIK I — Đề thi thử
-- =====================================================
INSERT INTO mock_tests (id, title, language_id, `type`, level_code, duration_min, total_questions, pass_score, is_premium, description, lang_code, flag_emoji)
VALUES (5001, 'TOPIK I — Đề thi thử số 1', @ko, 'TOPIK', 'TOPIK1', 100, 6, 80, 0,
        'Đề thi thử TOPIK I (sơ cấp). Nghe + Đọc. Tổng điểm 200. Đạt cấp 1: 80, cấp 2: 140.',
        'ko', '🇰🇷');

INSERT INTO mock_test_sections (id, mock_test_id, order_index, title, duration_min, description) VALUES
(50011, 5001, 1, '듣기 Listening', 40, '30 câu nghe (demo 3 câu)'),
(50012, 5001, 2, '읽기 Reading', 60, '40 câu đọc (demo 3 câu)');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, audio_url, answer_json, explanation) VALUES
(50011, 1, 'LISTEN', '【듣기】 여자는 어디에 가요?',
 '여자는 어디에 가요?',
 '{"transcript":"남: 어디에 가요? 여: 학교에 가요."}',
 '["회사","학교","집","병원"]', '학교', NULL, '"학교"',
 '여자: 학교에 가요 → đi đến trường.'),

(50011, 2, 'LISTEN', '【듣기】 남자는 무엇을 마셔요?',
 '남자는 무엇을 마셔요?',
 '{"transcript":"여: 뭐 마실 거예요? 남: 커피 한 잔 주세요."}',
 '["물","차","커피","주스"]', '커피', NULL, '"커피"',
 '커피 한 잔 주세요 = cho tôi một ly cà phê.'),

(50011, 3, 'LISTEN', '【듣기】 지금 몇 시예요?',
 '지금 몇 시예요?',
 '{"transcript":"지금은 오후 두 시 삼십 분이에요."}',
 '["1:30 PM","2:30 PM","3:30 PM","4:30 PM"]', '2:30 PM', NULL, '"2:30 PM"',
 '오후 두 시 삼십 분 = 2 giờ 30 phút chiều.');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(50012, 1, 'MCQ', '【읽기】 빈칸에 알맞은 것: 저는 한국 ___ 좋아해요.',
 '저는 한국 ___ 좋아해요.',
 '{"text":"저는 한국 ___ 좋아해요."}',
 '["을","를","이","가"]', '을', '"을"',
 '한국 (kết thúc bằng 받침 ㄱ) → 을. Trợ từ tân ngữ.'),

(50012, 2, 'MCQ', '【읽기】 다음 글의 주제: "저는 매일 아침 일찍 일어나서 운동을 합니다. 건강에 좋기 때문입니다."',
 '글의 주제는?',
 '{"passage":"저는 매일 아침 일찍 일어나서 운동을 합니다. 건강에 좋기 때문입니다."}',
 '["식사","운동","공부","쇼핑"]', '운동', '"운동"',
 'Chủ đề chính là 운동 (tập thể dục).'),

(50012, 3, 'MCQ', '【읽기】 "한국 음식이 ___ 매워요." 빈칸에 알맞은 것은?',
 '빈칸에 알맞은 것?',
 '{"text":"한국 음식이 ___ 매워요."}',
 '["많이","많은","많","많고"]', '많이', '"많이"',
 '많이 = trạng từ "rất, nhiều".');

-- =====================================================
-- 7. JLPT N4 — Mini test (free preview)
-- =====================================================
INSERT INTO mock_tests (id, title, language_id, `type`, level_code, duration_min, total_questions, pass_score, is_premium, description, lang_code, flag_emoji)
VALUES (1002, 'JLPT N4 — Đề thi thử số 1', @ja, 'JLPT', 'N4', 125, 6, 90, 0,
        'Đề thi thử N4 mức độ trung bình. Bao gồm Văn tự, Từ vựng, Ngữ pháp.',
        'ja', '🇯🇵');

INSERT INTO mock_test_sections (id, mock_test_id, order_index, title, duration_min, description) VALUES
(10021, 1002, 1, 'Văn tự - Từ vựng', 30, NULL),
(10022, 1002, 2, 'Ngữ pháp - Đọc hiểu', 60, NULL),
(10023, 1002, 3, 'Nghe hiểu', 35, NULL);

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(10021, 1, 'MCQ', '__安全__ な場所へ行きましょう。 (Cách đọc?)',
 'Cách đọc của 安全',
 '{"text":"安全 な場所へ行きましょう。"}',
 '["あんぜん","あんしん","へいわ","しずか"]', 'あんぜん', '"あんぜん"',
 '安全 = あんぜん (an toàn).'),

(10021, 2, 'MCQ', '___ がたくさんあります。',
 '___ がたくさんあります。',
 '{"text":"___ がたくさんあります。"}',
 '["問題","写真","コーヒー","お金"]', 'お金', '"お金"',
 'Tất cả đều hợp ngữ pháp; ngữ cảnh phổ biến nhất là お金 (tiền).'),

(10022, 1, 'MCQ', 'まだ宿題が ___ 終わっていません。',
 'まだ宿題が ___ 終わっていません。',
 '{"text":"まだ宿題が ___ 終わっていません。"}',
 '["全然","ぜんぶ","だんだん","もう"]', '全然', '"全然"',
 '全然 + phủ định = hoàn toàn không.'),

(10022, 2, 'MCQ', '日本語 ___ 話せます。',
 '日本語 ___ 話せます。',
 '{"text":"日本語 ___ 話せます。"}',
 '["を","が","は","に"]', 'が', '"が"',
 'Thể khả năng dùng が thay vì を.');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, audio_url, answer_json, explanation) VALUES
(10023, 1, 'LISTEN', '【Nghe】 男の人は何を買いますか。',
 '男の人は何を買いますか。',
 '{"transcript":"店員：何にしますか？ 男：すみません、コーヒー二つください。"}',
 '["1 cà phê","2 cà phê","1 trà","2 trà"]', '2 cà phê', NULL, '"2 cà phê"',
 'コーヒー二つ = 2 ly cà phê.'),

(10023, 2, 'LISTEN', '【Nghe】 女の人は何時に駅へ行きますか。',
 '女の人は何時に駅へ行きますか。',
 '{"transcript":"明日、八時半に駅で会いましょう。"}',
 '["7:30","8:00","8:30","9:00"]', '8:30', NULL, '"8:30"',
 '八時半 = 8 giờ rưỡi = 8:30.');
