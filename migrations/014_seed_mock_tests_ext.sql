-- =====================================================
-- SEED EXT: Mock Tests - Extended
-- Bổ sung thêm đề thi thử:
--   * JLPT N3, N2, N1 (mở rộng)
--   * TOEIC Listening + Reading full mini-test
--   * IELTS Reading + Writing Task
--   * HSK 4, HSK 5
--   * TOPIK II mở rộng
-- =====================================================

SET NAMES utf8mb4;
SET @ja := (SELECT id FROM languages WHERE code='ja');
SET @en := (SELECT id FROM languages WHERE code='en');
SET @zh := (SELECT id FROM languages WHERE code='zh');
SET @ko := (SELECT id FROM languages WHERE code='ko');

-- =====================================================
-- 8. JLPT N3 — Đề thi thử mở rộng
-- =====================================================
INSERT INTO mock_tests (id, title, language_id, `type`, level_code, duration_min, total_questions, pass_score, is_premium, description, lang_code, flag_emoji)
VALUES (1003, 'JLPT N3 — Đề thi thử số 1', @ja, 'JLPT', 'N3', 140, 8, 95, 0,
        'Đề thi thử JLPT N3 mô phỏng đầy đủ 3 phần: Văn tự-Từ vựng, Ngữ pháp-Đọc hiểu, Nghe hiểu.',
        'ja', '🇯🇵')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO mock_test_sections (id, mock_test_id, order_index, title, duration_min, description) VALUES
(10031, 1003, 1, '言語知識（文字・語彙）', 30, 'Văn tự - Từ vựng N3'),
(10032, 1003, 2, '言語知識（文法）・読解', 70, 'Ngữ pháp - Đọc hiểu N3'),
(10033, 1003, 3, '聴解', 40, 'Nghe hiểu N3')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(10031, 1, 'MCQ', '彼は __経験__ が豊富だ。 (Cách đọc?)',
 '経験',
 '{"text":"彼は 経験 が豊富だ。","focus":"経験"}',
 '["けいけん","きょうけん","けいげん","きょうげん"]', 'けいけん', '"けいけん"',
 '経験 = けいけん (kinh nghiệm).'),
(10031, 2, 'MCQ', '道が __混雑__ しています。',
 '混雑',
 '{"text":"道が 混雑 しています。","focus":"混雑"}',
 '["こんざつ","こんさつ","こんじゃつ","ざつ"]', 'こんざつ', '"こんざつ"',
 '混雑 = こんざつ (đông đúc, tắc nghẽn).'),
(10031, 3, 'MCQ', 'このデータは信用___できる。',
 '信用___できる',
 '{"text":"信用___できる。"}',
 '["に","が","を","と"]', 'が', '"が"',
 'Thể khả năng できる dùng が.');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(10032, 1, 'MCQ', 'たとえ雨が___、試合は行われる。',
 'たとえ雨が___、試合は行われる。',
 '{"text":"たとえ雨が___、試合は行われる。"}',
 '["降っても","降ったら","降って","降るので"]', '降っても', '"降っても"',
 'たとえ〜ても = cho dù ~.'),
(10032, 2, 'MCQ', '仕事___、勉強も忙しい。',
 '仕事___、勉強も忙しい。',
 '{"text":"仕事___、勉強も忙しい。"}',
 '["ばかりでなく","だけでなく","とともに","のほか"]', 'ばかりでなく', '"ばかりでなく"',
 '〜ばかりでなく = không chỉ ~.'),
(10032, 3, 'READ', '【Đọc hiểu】 Theo đoạn văn, tại sao tác giả thích mùa thu?',
 'Tại sao tác giả thích mùa thu?',
 '{"passage":"秋は一年で一番好きな季節だ。暑くも寒くもなく、紅葉がきれいだ。食べ物もおいしい。"}',
 '["Vì mát mẻ và cảnh đẹp","Vì ấm áp","Vì nhiều tuyết","Vì ngắn"]',
 'Vì mát mẻ và cảnh đẹp', '"Vì mát mẻ và cảnh đẹp"',
 '"暑くも寒くもなく、紅葉がきれい" = không nóng không lạnh, lá đỏ đẹp.');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, audio_url, answer_json, explanation) VALUES
(10033, 1, 'LISTEN', '【Nghe】 男の人は何時に会議に行きますか。',
 '何時に会議に行きますか。',
 '{"transcript":"A: 会議は三時からですね。 B: はい、でも私は少し早く、二時半に行きます。"}',
 '["2:00","2:30","3:00","3:30"]', '2:30', NULL, '"2:30"',
 '二時半 = 2:30.'),
(10033, 2, 'LISTEN', '【Nghe】 女の人はどうして欠席しましたか。',
 'どうして欠席しましたか。',
 '{"transcript":"すみません、熱があるので今日は休ませてください。"}',
 '["Bận việc","Đi du lịch","Bị sốt","Bị kẹt xe"]', 'Bị sốt', NULL, '"Bị sốt"',
 '熱がある = có sốt.');

-- =====================================================
-- 9. JLPT N2 — Đề thi thử
-- =====================================================
INSERT INTO mock_tests (id, title, language_id, `type`, level_code, duration_min, total_questions, pass_score, is_premium, description, lang_code, flag_emoji)
VALUES (1004, 'JLPT N2 — Đề thi thử số 1', @ja, 'JLPT', 'N2', 155, 6, 90, 1,
        'Đề thi thử JLPT N2 — cấp độ trung cao. Yêu cầu hiểu báo chí, tin tức.',
        'ja', '🇯🇵')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO mock_test_sections (id, mock_test_id, order_index, title, duration_min, description) VALUES
(10041, 1004, 1, '言語知識・読解', 105, 'Văn tự - Từ vựng - Ngữ pháp - Đọc hiểu'),
(10042, 1004, 2, '聴解', 50, 'Nghe hiểu N2')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(10041, 1, 'MCQ', '彼の発言は批判___値する。',
 '彼の発言は批判___値する。',
 '{"text":"彼の発言は批判___値する。"}',
 '["に","が","を","で"]', 'に', '"に"',
 '〜に値する = đáng để ~.'),
(10041, 2, 'MCQ', 'いくら努力___、彼には勝てない。',
 'いくら努力___、彼には勝てない。',
 '{"text":"いくら努力___、彼には勝てない。"}',
 '["しても","したら","すれば","して"]', 'しても', '"しても"',
 'いくら〜ても = dù ~ đến đâu.'),
(10041, 3, 'MCQ', '成功する___、毎日努力が必要だ。',
 '成功する___、毎日努力が必要だ。',
 '{"text":"成功する___、毎日努力が必要だ。"}',
 '["ためには","ために","ように","からには"]', 'ためには', '"ためには"',
 '〜ためには = để đạt được ~ thì cần ~.'),
(10041, 4, 'READ', '【Đọc hiểu】 Ý chính của đoạn văn là gì?',
 'Ý chính đoạn văn?',
 '{"passage":"最近、若者の読書離れが進んでいる。スマートフォンの普及により、本を読む時間が減っている。しかし、読書は想像力を育てる大切な活動である。"}',
 '["Điện thoại tốt hơn sách","Giới trẻ ít đọc sách vì điện thoại","Sách không cần thiết","Ai cũng đọc sách"]',
 'Giới trẻ ít đọc sách vì điện thoại',
 '"Giới trẻ ít đọc sách vì điện thoại"',
 '読書離れ = xa rời việc đọc sách, do スマホ普及.');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, audio_url, answer_json, explanation) VALUES
(10042, 1, 'LISTEN', '【Nghe】 この会社が新しく始める事業は何ですか。',
 '新しく始める事業は?',
 '{"transcript":"弊社は来月からオンライン教育サービスを開始します。対象は社会人向けです。"}',
 '["Giáo dục online","Bán hàng","Xây dựng","Du lịch"]',
 'Giáo dục online', NULL, '"Giáo dục online"',
 'オンライン教育サービス = dịch vụ giáo dục trực tuyến.'),
(10042, 2, 'LISTEN', '【Nghe】 発表者の主張は何ですか。',
 '発表者の主張?',
 '{"transcript":"在宅勤務は生産性を高めるだけでなく、社員の幸福度も向上させると考えられます。"}',
 '["WFH tốt cho năng suất","WFH không có lợi","WFH tăng chi phí","Không có ý kiến"]',
 'WFH tốt cho năng suất', NULL, '"WFH tốt cho năng suất"',
 '在宅勤務 = làm việc tại nhà, 生産性 = năng suất, 幸福度 = mức độ hạnh phúc.');

-- =====================================================
-- 10. JLPT N1 — Đề thi thử
-- =====================================================
INSERT INTO mock_tests (id, title, language_id, `type`, level_code, duration_min, total_questions, pass_score, is_premium, description, lang_code, flag_emoji)
VALUES (1005, 'JLPT N1 — Đề thi thử số 1', @ja, 'JLPT', 'N1', 170, 5, 100, 1,
        'Đề thi thử JLPT N1 — cấp độ cao cấp. Yêu cầu hiểu văn bản học thuật.',
        'ja', '🇯🇵')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO mock_test_sections (id, mock_test_id, order_index, title, duration_min, description) VALUES
(10051, 1005, 1, '言語知識・読解', 110, 'Văn tự - Từ vựng - Ngữ pháp - Đọc hiểu N1'),
(10052, 1005, 2, '聴解', 60, 'Nghe hiểu N1')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(10051, 1, 'MCQ', '努力もせず___、成功できるはずがない。',
 '努力もせず___、成功できるはずがない。',
 '{"text":"努力もせず___、成功できるはずがない。"}',
 '["にして","にあって","にあたり","ばかりか"]', 'にして', '"にして"',
 '〜ずにして = nếu không ~ thì (không thể).'),
(10051, 2, 'MCQ', '社長___、決定を下すのは難しい。',
 '社長___、決定を下すのは難しい。',
 '{"text":"社長___、決定を下すのは難しい。"}',
 '["をもってしても","をおいて","をめぐって","をよそに"]', 'をもってしても', '"をもってしても"',
 '〜をもってしても = ngay cả với ~.'),
(10051, 3, 'READ', '【Đọc hiểu】 Theo tác giả, AI sẽ tác động thế nào đến việc làm?',
 'AI sẽ ảnh hưởng thế nào?',
 '{"passage":"AI技術の発展は、単純労働を代替する一方で、新たな職種を生み出す可能性がある。しかし、教育制度の見直しが急務である。"}',
 '["Thay thế lao động đơn giản và tạo nghề mới","Chỉ lấy mất việc làm","Không ảnh hưởng gì","Chỉ có lợi"]',
 'Thay thế lao động đơn giản và tạo nghề mới',
 '"Thay thế lao động đơn giản và tạo nghề mới"',
 '単純労働を代替 = thay thế LĐ đơn giản; 新たな職種 = nghề mới.');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, audio_url, answer_json, explanation) VALUES
(10052, 1, 'LISTEN', '【Nghe】 専門家が最も強調していることは何ですか。',
 '専門家が最も強調していること?',
 '{"transcript":"環境問題において、個人の努力も重要ですが、何よりも政府の政策が決定的な役割を果たすのです。"}',
 '["Nỗ lực cá nhân","Chính sách chính phủ","Công nghệ","Truyền thông"]',
 'Chính sách chính phủ', NULL, '"Chính sách chính phủ"',
 '何よりも〜が決定的 = hơn tất cả ~ mang tính quyết định.'),
(10052, 2, 'LISTEN', '【Nghe】 話し手の立場はどれですか。',
 '話し手の立場?',
 '{"transcript":"最低賃金の引き上げは必要だと考えますが、中小企業への影響も慎重に検討すべきです。"}',
 '["Ủng hộ tăng lương TT nhưng lo cho DN nhỏ","Phản đối tăng lương","Không có ý kiến","Chỉ lo cho DN lớn"]',
 'Ủng hộ tăng lương TT nhưng lo cho DN nhỏ', NULL, '"Ủng hộ tăng lương TT nhưng lo cho DN nhỏ"',
 '必要だと考えますが、〜も慎重に検討 = cần thiết nhưng cần thận trọng xem xét ~.');

-- =====================================================
-- 11. TOEIC — Mini full test
-- =====================================================
INSERT INTO mock_tests (id, title, language_id, `type`, level_code, duration_min, total_questions, pass_score, is_premium, description, lang_code, flag_emoji)
VALUES (2002, 'TOEIC — Đề thi thử mở rộng (Part 5-7)', @en, 'TOEIC', 'B2', 75, 10, 70, 0,
        'Đề thi thử TOEIC mở rộng tập trung Part 5 (Incomplete Sentences), Part 6 (Text Completion), Part 7 (Reading Comprehension).',
        'en', '🇺🇸')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO mock_test_sections (id, mock_test_id, order_index, title, duration_min, description) VALUES
(20021, 2002, 1, 'Part 5 — Incomplete Sentences', 20, 'Grammar + Vocabulary single sentences'),
(20022, 2002, 2, 'Part 6 — Text Completion', 20, 'Fill in the blanks in a passage'),
(20023, 2002, 3, 'Part 7 — Reading Comprehension', 35, 'Read passages and answer questions')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(20021, 1, 'MCQ', 'The manager ___ the report by tomorrow morning.',
 'The manager ___ the report.',
 '{"text":"The manager ___ the report by tomorrow morning."}',
 '["will finish","finish","finishing","finished"]', 'will finish', '"will finish"',
 '"by tomorrow morning" → tương lai → will finish.'),
(20021, 2, 'MCQ', 'Our new product is ___ than our competitor''s.',
 'Our new product is ___ than ours.',
 '{"text":"Our new product is ___ than our competitor''s."}',
 '["cheaper","cheapest","cheap","more cheap"]', 'cheaper', '"cheaper"',
 'So sánh hơn + than → cheaper.'),
(20021, 3, 'MCQ', 'Please ___ the attached document before the meeting.',
 'Please ___ the attached document.',
 '{"text":"Please ___ the attached document before the meeting."}',
 '["review","reviewing","reviewed","reviews"]', 'review', '"review"',
 'Please + V nguyên mẫu.'),
(20021, 4, 'MCQ', 'The hotel offers ___ rooms at reasonable prices.',
 'The hotel offers ___ rooms.',
 '{"text":"The hotel offers ___ rooms at reasonable prices."}',
 '["comfortable","comfort","comfortably","comforted"]', 'comfortable', '"comfortable"',
 'Tính từ đứng trước danh từ.');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(20022, 1, 'MCQ', '【Text】 "Dear customer, we regret to inform you that your order ___ due to stock shortage."',
 'Fill in the blank',
 '{"passage":"Dear customer, we regret to inform you that your order ___ due to stock shortage."}',
 '["has been delayed","delays","is delaying","delay"]', 'has been delayed', '"has been delayed"',
 'Thì hiện tại hoàn thành bị động: has been delayed.'),
(20022, 2, 'MCQ', '【Text】 "We ___ to offer you a 10% discount on your next purchase."',
 'Fill in the blank',
 '{"passage":"We ___ to offer you a 10% discount on your next purchase."}',
 '["would like","like","liked","will like"]', 'would like', '"would like"',
 '"would like to" = lịch sự để đề xuất.');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(20023, 1, 'READ', '【Reading】 What is the main purpose of the email?',
 'Main purpose?',
 '{"passage":"Dear Mr. Smith, We are writing to confirm your reservation at Grand Hotel for 3 nights from June 10th to June 13th. Check-in time is 3:00 PM. Please bring a valid ID. Thank you for choosing us."}',
 '["To cancel a reservation","To confirm a hotel booking","To request payment","To advertise hotel"]',
 'To confirm a hotel booking',
 '"To confirm a hotel booking"',
 '"We are writing to confirm your reservation" = để xác nhận đặt phòng.'),
(20023, 2, 'READ', '【Reading】 When is the check-in time?',
 'Check-in time?',
 '{"passage":"Dear Mr. Smith, We are writing to confirm your reservation at Grand Hotel for 3 nights from June 10th to June 13th. Check-in time is 3:00 PM."}',
 '["10:00 AM","12:00 PM","3:00 PM","6:00 PM"]',
 '3:00 PM', '"3:00 PM"',
 '"Check-in time is 3:00 PM".'),
(20023, 3, 'READ', '【Reading】 According to the notice, who can apply for the scholarship?',
 'Who can apply?',
 '{"passage":"NOTICE: The Global Leadership Scholarship is open to students who have achieved a GPA of 3.5 or higher and demonstrate strong leadership qualities. Deadline: March 31st."}',
 '["All students","Students with GPA 3.5+ and leadership","Only foreigners","Only staff"]',
 'Students with GPA 3.5+ and leadership',
 '"Students with GPA 3.5+ and leadership"',
 '"GPA of 3.5 or higher and demonstrate strong leadership".'),
(20023, 4, 'READ', '【Reading】 What is the deadline?',
 'Deadline?',
 '{"passage":"NOTICE: The Global Leadership Scholarship. Deadline: March 31st."}',
 '["March 1st","March 15th","March 31st","April 1st"]',
 'March 31st', '"March 31st"',
 'Deadline: March 31st.');

-- =====================================================
-- 12. IELTS — Reading + Writing Task
-- =====================================================
INSERT INTO mock_tests (id, title, language_id, `type`, level_code, duration_min, total_questions, pass_score, is_premium, description, lang_code, flag_emoji)
VALUES (2003, 'IELTS Academic — Reading + Writing Sample', @en, 'IELTS', 'C1', 120, 8, 65, 1,
        'Đề thi thử IELTS Academic với Reading Comprehension và Writing Task gợi ý.',
        'en', '🇬🇧')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO mock_test_sections (id, mock_test_id, order_index, title, duration_min, description) VALUES
(20031, 2003, 1, 'Reading Passage 1', 20, 'Academic reading passage with multiple questions'),
(20032, 2003, 2, 'Reading Passage 2', 20, 'Second academic passage'),
(20033, 2003, 3, 'Writing Task 1 & 2', 60, 'Describe a chart + Write an essay')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(20031, 1, 'READ', '【Reading】 According to the passage, what is the main cause of coral bleaching?',
 'Main cause of coral bleaching?',
 '{"passage":"Coral bleaching occurs primarily due to rising ocean temperatures. When water becomes too warm, corals expel the symbiotic algae living in their tissues, causing them to turn completely white. If temperatures remain high, corals can die within weeks."}',
 '["Pollution","Rising sea temperatures","Overfishing","Boat anchors"]',
 'Rising sea temperatures',
 '"Rising sea temperatures"',
 '"primarily due to rising ocean temperatures".'),
(20031, 2, 'TF', '【TRUE/FALSE/NOT GIVEN】 Corals die immediately once bleaching starts.',
 'Corals die immediately?',
 '{"passage":"Coral bleaching occurs primarily due to rising ocean temperatures. If temperatures remain high, corals can die within weeks."}',
 '["TRUE","FALSE","NOT GIVEN"]',
 'FALSE', '"FALSE"',
 'Đoạn văn nói "within weeks" không phải ngay lập tức.'),
(20031, 3, 'FILL', '【Complete】 When water becomes too warm, corals expel the _______ algae.',
 'Complete the sentence.',
 '{"passage":"corals expel the symbiotic algae living in their tissues"}',
 '["symbiotic","harmful","poisonous","colorful"]',
 'symbiotic', '"symbiotic"',
 '"symbiotic algae living in their tissues".');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(20032, 1, 'READ', '【Reading】 What does the author suggest about remote work?',
 'What about remote work?',
 '{"passage":"Remote work has transformed modern employment. While it offers flexibility and work-life balance, critics argue it reduces team cohesion and innovation. Nevertheless, most studies suggest productivity remains stable or even improves for many office-based jobs."}',
 '["It is always negative","It has both pros and cons","It is the only solution","It has no impact"]',
 'It has both pros and cons',
 '"It has both pros and cons"',
 '"flexibility" (pros) + "reduces team cohesion" (cons).'),
(20032, 2, 'TF', '【TRUE/FALSE/NOT GIVEN】 All types of jobs benefit from remote work.',
 'All jobs benefit?',
 '{"passage":"most studies suggest productivity remains stable or even improves for many office-based jobs"}',
 '["TRUE","FALSE","NOT GIVEN"]',
 'FALSE', '"FALSE"',
 'Chỉ "many office-based jobs" không phải tất cả.'),
(20032, 3, 'READ', '【Reading】 Which factor is highlighted as a drawback of remote work?',
 'Drawback?',
 '{"passage":"critics argue it reduces team cohesion and innovation"}',
 '["Higher salaries","Reduced team cohesion","Longer commutes","More meetings"]',
 'Reduced team cohesion',
 '"Reduced team cohesion"',
 '"reduces team cohesion and innovation".');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(20033, 1, 'WRITE', '【Writing Task 1】 The chart below shows the percentage of people using different modes of transport in City X from 2010 to 2020. Summarize the information by selecting and reporting the main features. (150 words, 20 minutes)',
 'Describe the chart (150 words)',
 '{"instructions":"Writing Task 1 — 150 words — 20 minutes","image":"https://example.com/chart.png"}',
 NULL, 'free_response',
 '{"sample_answer":"The chart illustrates the proportion of commuters using various transport modes in City X over a decade. Overall, there was a notable shift from private cars to public transportation. In 2010, cars dominated at 60%, while buses and trains accounted for only 25% combined. By 2020, car usage had dropped to 40%, whereas public transport rose to 45%. Cycling and walking remained stable at around 15%. These trends suggest a growing preference for sustainable commuting options.","band":"7.0-8.0"}',
 'Cần: Tổng quan + 2 nhóm xu hướng + số liệu cụ thể.'),
(20033, 2, 'WRITE', '【Writing Task 2】 Some people think that all university students should study whatever they like. Others believe that they should only be allowed to study subjects that will be useful for employment. Discuss both views and give your opinion. (250 words, 40 minutes)',
 'Write an essay (250 words)',
 '{"instructions":"Writing Task 2 — 250 words — 40 minutes"}',
 NULL, 'free_response',
 '{"sample_answer":"The debate over whether university students should pursue any subject or focus on employable ones is longstanding. Both perspectives have merit. On one hand, studying what one is passionate about fosters creativity, motivation, and intellectual growth. On the other hand, practical subjects such as engineering or medicine directly contribute to national development and individual financial stability. In my view, a balanced approach is preferable: students should have autonomy in choosing their majors, while universities provide career guidance and interdisciplinary options. Ultimately, education should develop both the person and their contribution to society.","band":"7.0-8.5"}',
 'Cấu trúc: Introduction + Body 1 (view 1) + Body 2 (view 2) + Opinion + Conclusion.');

-- =====================================================
-- 13. HSK 4 — Đề thi thử
-- =====================================================
INSERT INTO mock_tests (id, title, language_id, `type`, level_code, duration_min, total_questions, pass_score, is_premium, description, lang_code, flag_emoji)
VALUES (3002, 'HSK 4 — Đề thi thử số 1', @zh, 'HSK', 'HSK4', 105, 8, 180, 0,
        'Đề thi thử HSK 4 — Nghe 听力, Đọc 阅读, Viết 书写. Tổng điểm 300.',
        'zh', '🇨🇳')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO mock_test_sections (id, mock_test_id, order_index, title, duration_min, description) VALUES
(30021, 3002, 1, '听力 (Nghe)', 30, 'Listening HSK 4'),
(30022, 3002, 2, '阅读 (Đọc)', 40, 'Reading HSK 4'),
(30023, 3002, 3, '书写 (Viết)', 25, 'Writing HSK 4')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, audio_url, answer_json, explanation) VALUES
(30021, 1, 'LISTEN', '【听力】 男的打算做什么？',
 '男的打算做什么？',
 '{"transcript":"女：你周末有什么计划？ 男：我打算去爬山。"}',
 '["看电影","爬山","睡觉","学习"]',
 '爬山', NULL, '"爬山"',
 '打算去爬山 = định đi leo núi.'),
(30021, 2, 'LISTEN', '【听力】 女的认为这本书怎么样？',
 '女的认为这本书怎么样？',
 '{"transcript":"男：这本书有意思吗？ 女：非常有趣，我推荐你看。"}',
 '["无聊","一般","有趣","太难"]',
 '有趣', NULL, '"有趣"',
 '非常有趣 = rất thú vị.');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(30022, 1, 'MCQ', '【阅读】 请完成句子：虽然今天下雨了，___ 我还是要出门。',
 '选择正确答案',
 '{"text":"虽然今天下雨了，___ 我还是要出门。"}',
 '["但是","因为","所以","如果"]', '但是', '"但是"',
 '虽然 ~ 但是 ~ cặp nghịch ý.'),
(30022, 2, 'MCQ', '【阅读】 "他学习很努力"的意思是什么？',
 '意思?',
 '{"text":"他学习很努力。"}',
 '["他不喜欢学习","他很认真学习","他学习不好","他在玩"]',
 '他很认真学习', '"他很认真学习"',
 '努力 = chăm chỉ, nỗ lực.'),
(30022, 3, 'MCQ', '【阅读】 根据短文，作者周末去了哪里？',
 '作者周末去了哪里？',
 '{"passage":"上个周末我和家人一起去了北京。我们参观了长城和故宫，还尝了北京烤鸭。"}',
 '["上海","北京","广州","南京"]', '北京', '"北京"',
 '"上个周末我和家人一起去了北京".');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(30023, 1, 'ORDER', '【书写】 请把下列词语组成一个句子：我 / 很 / 吃 / 饺子 / 喜欢',
 '组句',
 '{"words":["我","很","吃","饺子","喜欢"]}',
 '["我很喜欢吃饺子","我饺子吃很喜欢","吃很喜欢我饺子","饺子很喜欢我吃"]',
 '我很喜欢吃饺子', '"我很喜欢吃饺子"',
 'Cấu trúc: Chủ + Trạng + 喜欢 + ĐT + TN.'),
(30023, 2, 'ORDER', '【书写】 请把下列词语组成一个句子：他 / 是 / 学生 / 大学',
 '组句',
 '{"words":["他","是","学生","大学"]}',
 '["他是大学学生","他是学生大学","大学是学生他","学生是他大学"]',
 '他是大学学生', '"他是大学学生"',
 'S + 是 + (ĐN) + DT.');

-- =====================================================
-- 14. HSK 5 — Đề thi thử
-- =====================================================
INSERT INTO mock_tests (id, title, language_id, `type`, level_code, duration_min, total_questions, pass_score, is_premium, description, lang_code, flag_emoji)
VALUES (3003, 'HSK 5 — Đề thi thử số 1', @zh, 'HSK', 'HSK5', 125, 5, 180, 1,
        'Đề thi thử HSK 5 — tương đương trung cao cấp.',
        'zh', '🇨🇳')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO mock_test_sections (id, mock_test_id, order_index, title, duration_min, description) VALUES
(30031, 3003, 1, '听力', 30, NULL),
(30032, 3003, 2, '阅读', 45, NULL),
(30033, 3003, 3, '书写', 40, NULL)
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, audio_url, answer_json, explanation) VALUES
(30031, 1, 'LISTEN', '【听力】 根据对话，男的为什么迟到？',
 '为什么迟到？',
 '{"transcript":"女：你怎么才来？ 男：不好意思，路上堵车了。"}',
 '["睡过了","堵车","迷路","生病"]',
 '堵车', NULL, '"堵车"',
 '堵车 = kẹt xe.');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(30032, 1, 'MCQ', '【阅读】 根据下文，作者对现代科技的态度是？',
 '作者的态度?',
 '{"passage":"虽然现代科技给我们的生活带来了很多便利，但也让人们变得越来越依赖手机。我认为，我们应该合理使用科技，而不是被它控制。"}',
 '["完全支持","完全反对","应该合理使用","无所谓"]',
 '应该合理使用', '"应该合理使用"',
 '"应该合理使用科技"。'),
(30032, 2, 'MCQ', '【阅读】 "合理"的意思最接近?',
 '"合理"?',
 '{"text":"合理"}',
 '["不正确","符合常识","奇怪","困难"]',
 '符合常识', '"符合常识"',
 '合理 = hợp lý.');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(30033, 1, 'WRITE', '【书写】 请用下列词语(至少80字)写一篇短文：环境保护、重要、未来、行动',
 '写短文',
 '{"keywords":["环境保护","重要","未来","行动"]}',
 NULL, 'free_response',
 '{"sample":"环境保护对我们的未来非常重要。如果我们现在不采取行动，地球的环境会变得越来越糟。每个人都应该从小事做起，比如节约用水、少用塑料袋、多种树。只有大家一起努力，才能保护好我们的地球。"}',
 'Gợi ý: Mở bài nêu tầm quan trọng, thân bài hành động cụ thể, kết bài kêu gọi.');

-- =====================================================
-- 15. TOPIK II — Đề thi thử
-- =====================================================
INSERT INTO mock_tests (id, title, language_id, `type`, level_code, duration_min, total_questions, pass_score, is_premium, description, lang_code, flag_emoji)
VALUES (5002, 'TOPIK II — Đề thi thử (Nghe + Đọc + Viết)', @ko, 'TOPIK', 'TOPIK2', 180, 7, 150, 1,
        'Đề thi thử TOPIK II (trung-cao cấp) với đầy đủ 3 phần.',
        'ko', '🇰🇷')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO mock_test_sections (id, mock_test_id, order_index, title, duration_min, description) VALUES
(50021, 5002, 1, '듣기 (Nghe)', 60, NULL),
(50022, 5002, 2, '읽기 (Đọc)', 70, NULL),
(50023, 5002, 3, '쓰기 (Viết)', 50, NULL)
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, audio_url, answer_json, explanation) VALUES
(50021, 1, 'LISTEN', '【듣기】 여자는 왜 회사에 늦었습니까?',
 '왜 늦었습니까?',
 '{"transcript":"남: 왜 이렇게 늦었어요? 여: 죄송해요, 지하철이 고장 나서요."}',
 '["잤어요","지하철 고장","길을 잃었어요","다쳤어요"]',
 '지하철 고장', NULL, '"지하철 고장"',
 '지하철이 고장 나서 = vì tàu điện bị hỏng.'),
(50021, 2, 'LISTEN', '【듣기】 남자의 의견은 무엇입니까?',
 '남자의 의견?',
 '{"transcript":"요즘 젊은 사람들은 책을 많이 안 읽는 것 같아요. 대신 스마트폰만 보고 있어요. 정말 안타깝네요."}',
 '["젊은이들이 책을 안 읽어서 안타깝다","책이 너무 비싸다","스마트폰이 좋다","도서관이 없다"]',
 '젊은이들이 책을 안 읽어서 안타깝다', NULL, '"젊은이들이 책을 안 읽어서 안타깝다"',
 '"안타깝네요" = tiếc nuối.');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(50022, 1, 'MCQ', '【읽기】 "한국 문화를 이해하려면 한국어를 배워야 합니다." 이 문장의 의미는?',
 '문장의 의미?',
 '{"text":"한국 문화를 이해하려면 한국어를 배워야 합니다."}',
 '["Hàn ngữ không cần thiết","Để hiểu văn hóa Hàn, cần học tiếng Hàn","Văn hóa Hàn khó","Tiếng Hàn dễ học"]',
 'Để hiểu văn hóa Hàn, cần học tiếng Hàn',
 '"Để hiểu văn hóa Hàn, cần học tiếng Hàn"',
 '〜(으)려면 ~ 아/어야 하다 = muốn ~ thì phải ~.'),
(50022, 2, 'MCQ', '【읽기】 다음 중 빈칸에 알맞은 것은: "날씨가 추우니까 ___ 입으세요."',
 '빈칸?',
 '{"text":"날씨가 추우니까 ___ 입으세요."}',
 '["따뜻하게","춥게","차갑게","시원하게"]',
 '따뜻하게', '"따뜻하게"',
 '춥다 → nên mặc 따뜻하게 (ấm).'),
(50022, 3, 'MCQ', '【읽기】 글의 주제는 무엇입니까?',
 '글의 주제?',
 '{"passage":"현대 사회에서 운동은 매우 중요합니다. 운동을 하면 건강해질 뿐만 아니라 스트레스도 풀 수 있습니다. 그래서 매일 30분이라도 운동하는 것이 좋습니다."}',
 '["운동의 중요성","음식의 중요성","공부의 중요성","여행의 즐거움"]',
 '운동의 중요성', '"운동의 중요성"',
 '"운동은 매우 중요합니다" = vận động rất quan trọng.');

INSERT INTO mock_test_questions (section_id, order_index, `type`, prompt, question, prompt_json, options_json, correct_answer, answer_json, explanation) VALUES
(50023, 1, 'WRITE', '【쓰기】 다음 주제에 대해 200-300자로 글을 쓰십시오: "여러분이 생각하는 행복한 삶이란 무엇입니까?"',
 '행복한 삶에 대해 쓰세요',
 '{"topic":"행복한 삶","min_words":200,"max_words":300}',
 NULL, 'free_response',
 '{"sample":"저는 행복한 삶이란 가족과 친구들과 함께 시간을 보내는 것이라고 생각합니다. 돈이 많거나 성공하는 것도 중요하지만, 사랑하는 사람들과 함께 웃고 이야기하는 것이 진정한 행복입니다. 또한 자신이 좋아하는 일을 하며 건강하게 사는 것도 행복한 삶의 중요한 부분입니다."}',
 'Cấu trúc: Mở bài (định nghĩa) + Thân bài (lý do/ví dụ) + Kết bài (khái quát).'),
(50023, 2, 'WRITE', '【쓰기】 다음 문장을 완성하십시오: "저는 한국에 가면 ___".',
 '문장 완성',
 '{"starter":"저는 한국에 가면 ___"}',
 NULL, 'free_response',
 '{"samples":["저는 한국에 가면 친구를 만나고 싶어요.","저는 한국에 가면 맛있는 음식을 먹을 거예요.","저는 한국에 가면 한복을 입어보고 싶습니다."]}',
 '-(으)면 + V 고 싶다/V ㄹ/을 거예요.');
