-- =====================================================
-- SEED: Exercises Bank - Large Question Bank
-- Ngân hàng bài tập bổ sung cho các bài học theo cấp độ.
-- Hỗ trợ 4 dạng: MULTI_CHOICE, FILL_BLANK, MATCHING, TRANSLATE
-- =====================================================

SET NAMES utf8mb4;
SET @ja := (SELECT id FROM languages WHERE code='ja');
SET @en := (SELECT id FROM languages WHERE code='en');
SET @zh := (SELECT id FROM languages WHERE code='zh');
SET @ko := (SELECT id FROM languages WHERE code='ko');

-- =====================================================
-- Tạo bảng question_bank nếu chưa tồn tại
-- (Ngân hàng câu hỏi độc lập, có thể dùng ngẫu nhiên)
-- =====================================================
CREATE TABLE IF NOT EXISTS question_bank (
  id INT PRIMARY KEY AUTO_INCREMENT,
  language_id INT UNSIGNED NOT NULL,
  skill ENUM('VOCAB','GRAMMAR','LISTEN','READ','WRITE','SPEAK') DEFAULT 'VOCAB',
  level_code VARCHAR(20),
  certification VARCHAR(20),
  `type` ENUM('MULTI_CHOICE','FILL_BLANK','MATCHING','TRANSLATE','TRUE_FALSE') DEFAULT 'MULTI_CHOICE',
  question TEXT NOT NULL,
  prompt_json JSON NULL,
  options_json JSON,
  correct_answer TEXT NOT NULL,
  explanation TEXT,
  difficulty TINYINT DEFAULT 3,
  tags JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_qb_lang_level (language_id, level_code),
  INDEX idx_qb_skill (skill, `type`),
  FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- JAPANESE - Vocabulary Exercises (N5-N3)
-- =====================================================
INSERT INTO question_bank (language_id, skill, level_code, certification, `type`, question, options_json, correct_answer, explanation, difficulty) VALUES
(@ja, 'VOCAB', 'N5', 'JLPT', 'MULTI_CHOICE', '「本」の読み方は？',
 '["ほん","ぼん","もと","ふみ"]', 'ほん', '本 (hon) = quyển sách (N5).', 1),
(@ja, 'VOCAB', 'N5', 'JLPT', 'MULTI_CHOICE', '「水」の読み方は？',
 '["みず","すい","みな","みつ"]', 'みず', '水 (mizu) = nước (N5).', 1),
(@ja, 'VOCAB', 'N5', 'JLPT', 'MULTI_CHOICE', '「火曜日」の読み方は？',
 '["かようび","すいようび","もくようび","きんようび"]', 'かようび',
 '火曜日 = thứ ba.', 1),
(@ja, 'VOCAB', 'N5', 'JLPT', 'MULTI_CHOICE', '「来る」の読み方は？',
 '["くる","きる","こる","かる"]', 'くる', '来る (kuru) = đến.', 1),
(@ja, 'VOCAB', 'N5', 'JLPT', 'FILL_BLANK', 'わたしは ___ を のみます。(uống nước)',
 '["みず","ほん","えんぴつ","つくえ"]', 'みず',
 '「みず」 = nước.', 1),
(@ja, 'VOCAB', 'N4', 'JLPT', 'MULTI_CHOICE', '「経験」の意味は？',
 '["trải nghiệm/kinh nghiệm","khó khăn","vui vẻ","buồn"]', 'trải nghiệm/kinh nghiệm',
 '経験 (けいけん) = kinh nghiệm.', 2),
(@ja, 'VOCAB', 'N4', 'JLPT', 'MULTI_CHOICE', '「約束」の読み方は？',
 '["やくそく","やくしょく","やくぞく","やくしゅく"]', 'やくそく',
 '約束 (yakusoku) = lời hứa.', 2),
(@ja, 'VOCAB', 'N3', 'JLPT', 'MULTI_CHOICE', '「努力」の意味は？',
 '["nỗ lực","nghỉ ngơi","đi chơi","ăn uống"]', 'nỗ lực',
 '努力 (どりょく) = nỗ lực, cố gắng.', 3),
(@ja, 'VOCAB', 'N3', 'JLPT', 'MULTI_CHOICE', '「成功」の意味は？',
 '["thành công","thất bại","bắt đầu","kết thúc"]', 'thành công',
 '成功 (せいこう) = thành công.', 3),
(@ja, 'VOCAB', 'N2', 'JLPT', 'MULTI_CHOICE', '「遺憾」の意味に近いのは？',
 '["残念","嬉しい","楽しい","普通"]', '残念',
 '遺憾 (いかん) ≒ 残念 = đáng tiếc.', 4);

-- =====================================================
-- JAPANESE - Grammar Exercises
-- =====================================================
INSERT INTO question_bank (language_id, skill, level_code, certification, `type`, question, options_json, correct_answer, explanation, difficulty) VALUES
(@ja, 'GRAMMAR', 'N5', 'JLPT', 'FILL_BLANK', 'わたし ___ 学生です。',
 '["は","が","を","に"]', 'は', '「は」 = trợ từ chủ đề.', 1),
(@ja, 'GRAMMAR', 'N5', 'JLPT', 'FILL_BLANK', '本 ___ あります。',
 '["は","が","を","に"]', 'が', 'あります/います dùng が.', 1),
(@ja, 'GRAMMAR', 'N5', 'JLPT', 'FILL_BLANK', '毎日 コーヒー ___ のみます。',
 '["は","を","で","に"]', 'を', 'Tân ngữ trực tiếp của 飲みます dùng を.', 1),
(@ja, 'GRAMMAR', 'N5', 'JLPT', 'FILL_BLANK', '学校 ___ いきます。',
 '["は","を","で","へ"]', 'へ', 'へ chỉ phương hướng đi đến.', 1),
(@ja, 'GRAMMAR', 'N4', 'JLPT', 'FILL_BLANK', '漢字 ___ 書けます。',
 '["を","が","は","に"]', 'が', 'Thể khả năng 〜られます/〜えます dùng が.', 2),
(@ja, 'GRAMMAR', 'N4', 'JLPT', 'FILL_BLANK', 'あめ ___ ふっているから、かさを持っていく。',
 '["が","を","に","で"]', 'が', 'あめがふる = trời mưa.', 2),
(@ja, 'GRAMMAR', 'N3', 'JLPT', 'FILL_BLANK', '勉強 ___ 、遊ぶ時間もない。',
 '["ばかりで","だけで","のみで","しかで"]', 'ばかりで',
 '〜ばかりで = chỉ toàn ~.', 3),
(@ja, 'GRAMMAR', 'N3', 'JLPT', 'MULTI_CHOICE', 'たとえ雨が ___ 、試合は行われる。',
 '["降っても","降ったら","降って","降るので"]', '降っても',
 'たとえ〜ても = dù ~.', 3),
(@ja, 'GRAMMAR', 'N2', 'JLPT', 'MULTI_CHOICE', 'いくら ___ も、彼には勝てない。',
 '["努力して","努力した","努力する","努力"]', '努力して',
 'いくら〜ても = dù ~ đến đâu.', 4),
(@ja, 'GRAMMAR', 'N1', 'JLPT', 'MULTI_CHOICE', '努力 ___ しては、成功できない。',
 '["せず","しない","しません","しなくて"]', 'せず',
 '〜ずして = nếu không ~ thì.', 5);

-- =====================================================
-- JAPANESE - Translation Exercises
-- =====================================================
INSERT INTO question_bank (language_id, skill, level_code, certification, `type`, question, options_json, correct_answer, explanation, difficulty) VALUES
(@ja, 'VOCAB', 'N5', 'JLPT', 'TRANSLATE', 'Dịch sang tiếng Nhật: "Tôi là sinh viên."',
 '["わたしは がくせいです。","わたしは せんせいです。","わたしは にほんじんです。","わたしは きょうしです。"]',
 'わたしは がくせいです。', 'わたし = tôi, がくせい = sinh viên.', 1),
(@ja, 'VOCAB', 'N5', 'JLPT', 'TRANSLATE', 'Dịch sang tiếng Nhật: "Tôi thích ăn sushi."',
 '["すしを たべるのが すきです。","すしを のむのが すきです。","すしを つくるのが すきです。","すしを かうのが すきです。"]',
 'すしを たべるのが すきです。', 'V(nguyên dạng)+のが好きだ = thích làm gì.', 2),
(@ja, 'VOCAB', 'N4', 'JLPT', 'TRANSLATE', 'Dịch: "Trời mưa nên tôi không đi."',
 '["あめが ふっているから、いきません。","あめが ふっているのに、いきません。","あめが ふっていれば、いきます。","あめが ふったら、いきました。"]',
 'あめが ふっているから、いきません。', '〜から = vì, nên.', 2);

-- =====================================================
-- CHINESE - Vocabulary & Grammar
-- =====================================================
INSERT INTO question_bank (language_id, skill, level_code, certification, `type`, question, options_json, correct_answer, explanation, difficulty) VALUES
(@zh, 'VOCAB', 'HSK1', 'HSK', 'MULTI_CHOICE', '"你好" 的意思是？',
 '["Xin chào","Tạm biệt","Cảm ơn","Xin lỗi"]', 'Xin chào',
 '你好 (nǐ hǎo) = xin chào.', 1),
(@zh, 'VOCAB', 'HSK1', 'HSK', 'MULTI_CHOICE', '"谢谢" 的意思是？',
 '["Xin lỗi","Cảm ơn","Xin chào","Tạm biệt"]', 'Cảm ơn',
 '谢谢 (xièxie) = cảm ơn.', 1),
(@zh, 'VOCAB', 'HSK1', 'HSK', 'MULTI_CHOICE', '"对不起" 的意思是？',
 '["Cảm ơn","Xin chào","Xin lỗi","Vâng"]', 'Xin lỗi',
 '对不起 (duìbuqǐ) = xin lỗi.', 1),
(@zh, 'VOCAB', 'HSK2', 'HSK', 'MULTI_CHOICE', '"朋友" 的意思是？',
 '["bạn bè","gia đình","thầy cô","đồng nghiệp"]', 'bạn bè',
 '朋友 (péngyǒu) = bạn bè.', 1),
(@zh, 'VOCAB', 'HSK3', 'HSK', 'MULTI_CHOICE', '"经验" 的意思是？',
 '["kinh nghiệm","cảm xúc","thất bại","cơ hội"]', 'kinh nghiệm',
 '经验 (jīngyàn) = kinh nghiệm.', 3),
(@zh, 'VOCAB', 'HSK4', 'HSK', 'MULTI_CHOICE', '"合理" 的意思是？',
 '["hợp lý","khó khăn","nhanh chóng","chậm chạp"]', 'hợp lý',
 '合理 (hélǐ) = hợp lý.', 3),
(@zh, 'GRAMMAR', 'HSK1', 'HSK', 'FILL_BLANK', '我 ___ 中国人。 (tôi là người TQ)',
 '["是","不是","有","在"]', '是', '是 = là (S + 是 + N).', 1),
(@zh, 'GRAMMAR', 'HSK2', 'HSK', 'FILL_BLANK', '___ 好吃！ (Rất ngon!)',
 '["很","也","都","还"]', '很', '很 + tính từ = rất ~.', 1),
(@zh, 'GRAMMAR', 'HSK3', 'HSK', 'FILL_BLANK', '虽然今天下雨了，___ 我还是要出门。',
 '["但是","因为","所以","如果"]', '但是', '虽然 ~ 但是 ~ cặp nghịch ý.', 2),
(@zh, 'GRAMMAR', 'HSK4', 'HSK', 'FILL_BLANK', '只要努力，___ 能成功。',
 '["就","才","也","不"]', '就', '只要 ~ 就 ~ = chỉ cần ~ thì ~.', 3),
(@zh, 'VOCAB', 'HSK1', 'HSK', 'TRANSLATE', 'Dịch sang tiếng Trung: "Tôi thích ăn cơm."',
 '["我喜欢吃饭。","我不喜欢吃饭。","我想吃饭。","我在吃饭。"]',
 '我喜欢吃饭。', '喜欢 = thích, 吃饭 = ăn cơm.', 1);

-- =====================================================
-- ENGLISH - Vocabulary & Grammar (IELTS/TOEIC)
-- =====================================================
INSERT INTO question_bank (language_id, skill, level_code, certification, `type`, question, options_json, correct_answer, explanation, difficulty) VALUES
(@en, 'VOCAB', 'A1', 'CEFR', 'MULTI_CHOICE', 'What does "friend" mean in Vietnamese?',
 '["bạn","gia đình","thầy cô","đồng nghiệp"]', 'bạn',
 'friend = bạn.', 1),
(@en, 'VOCAB', 'A2', 'CEFR', 'MULTI_CHOICE', 'Choose the opposite of "cheap":',
 '["expensive","small","fast","new"]', 'expensive',
 'cheap (rẻ) ↔ expensive (đắt).', 1),
(@en, 'VOCAB', 'B1', 'CEFR', 'MULTI_CHOICE', 'The synonym of "important" is:',
 '["significant","small","empty","weak"]', 'significant',
 'important ≈ significant.', 2),
(@en, 'VOCAB', 'B2', 'IELTS', 'MULTI_CHOICE', 'The word "mitigate" means:',
 '["to make less severe","to increase","to destroy","to forget"]', 'to make less severe',
 'mitigate = làm giảm nhẹ.', 3),
(@en, 'VOCAB', 'C1', 'IELTS', 'MULTI_CHOICE', '"Ubiquitous" most nearly means:',
 '["present everywhere","rare","small","dangerous"]', 'present everywhere',
 'ubiquitous = phổ biến khắp nơi.', 4),
(@en, 'VOCAB', 'B2', 'TOEIC', 'MULTI_CHOICE', 'In business, "revenue" refers to:',
 '["income","expense","debt","staff"]', 'income',
 'revenue = doanh thu.', 3),
(@en, 'GRAMMAR', 'A1', 'CEFR', 'FILL_BLANK', 'She ___ a doctor.',
 '["is","am","are","be"]', 'is', 'She + is (tobe hiện tại đơn, ngôi 3 số ít).', 1),
(@en, 'GRAMMAR', 'A2', 'CEFR', 'FILL_BLANK', 'I ___ to the park yesterday.',
 '["went","go","gone","going"]', 'went', 'yesterday → quá khứ đơn: went.', 1),
(@en, 'GRAMMAR', 'B1', 'CEFR', 'FILL_BLANK', 'If I had money, I ___ buy a car.',
 '["would","will","can","have"]', 'would', 'Câu điều kiện loại 2: If + V2, S + would + V.', 2),
(@en, 'GRAMMAR', 'B2', 'IELTS', 'FILL_BLANK', 'The book ___ by the student was interesting.',
 '["written","writing","wrote","writes"]', 'written',
 'Mệnh đề quan hệ rút gọn (bị động) → V3.', 3),
(@en, 'GRAMMAR', 'B2', 'TOEIC', 'FILL_BLANK', 'The manager ___ the report by tomorrow.',
 '["will have finished","finished","finish","finishing"]', 'will have finished',
 'Tương lai hoàn thành: will have + V3.', 3),
(@en, 'GRAMMAR', 'C1', 'IELTS', 'MULTI_CHOICE', 'Had it not been for her help, we ___ failed.',
 '["would have","have","had","will"]', 'would have',
 'Câu điều kiện đảo loại 3.', 4),
(@en, 'VOCAB', 'B1', 'IELTS', 'TRANSLATE', 'Translate: "Tôi muốn học du học."',
 '["I want to study abroad.","I want to travel.","I like foreign food.","I visit abroad."]',
 'I want to study abroad.', 'study abroad = đi du học.', 2);

-- =====================================================
-- KOREAN - Vocabulary & Grammar
-- =====================================================
INSERT INTO question_bank (language_id, skill, level_code, certification, `type`, question, options_json, correct_answer, explanation, difficulty) VALUES
(@ko, 'VOCAB', 'TOPIK1', 'TOPIK', 'MULTI_CHOICE', '"안녕하세요" 의 뜻은?',
 '["Xin chào","Tạm biệt","Cảm ơn","Xin lỗi"]', 'Xin chào',
 '안녕하세요 = xin chào (lịch sự).', 1),
(@ko, 'VOCAB', 'TOPIK1', 'TOPIK', 'MULTI_CHOICE', '"감사합니다" 의 뜻은?',
 '["Cảm ơn","Xin lỗi","Xin chào","Tạm biệt"]', 'Cảm ơn',
 '감사합니다 = cảm ơn (trang trọng).', 1),
(@ko, 'VOCAB', 'TOPIK1', 'TOPIK', 'MULTI_CHOICE', '"친구" 의 뜻은?',
 '["bạn","gia đình","thầy","đồng nghiệp"]', 'bạn',
 '친구 (chingu) = bạn.', 1),
(@ko, 'VOCAB', 'TOPIK2', 'TOPIK', 'MULTI_CHOICE', '"경험" 의 뜻은?',
 '["kinh nghiệm","cơ hội","hy vọng","khó khăn"]', 'kinh nghiệm',
 '경험 (gyeongheom) = kinh nghiệm.', 3),
(@ko, 'GRAMMAR', 'TOPIK1', 'TOPIK', 'FILL_BLANK', '저는 학생___.',
 '["이에요","예요","는","를"]', '이에요',
 'Danh từ kết thúc bằng phụ âm → 이에요.', 1),
(@ko, 'GRAMMAR', 'TOPIK1', 'TOPIK', 'FILL_BLANK', '한국 음식을 ___.',
 '["먹고 싶어요","먹어요","먹었어요","먹습니다"]', '먹고 싶어요',
 'V(stem) + 고 싶다 = muốn làm gì.', 2),
(@ko, 'GRAMMAR', 'TOPIK2', 'TOPIK', 'FILL_BLANK', '비가 오___ 우산을 가져가세요.',
 '["니까","면서","고","지만"]', '니까',
 '-(으)니까 = vì (nên ...).', 3),
(@ko, 'VOCAB', 'TOPIK1', 'TOPIK', 'TRANSLATE', 'Dịch: "Tôi là người Việt Nam."',
 '["저는 베트남 사람이에요.","저는 한국 사람이에요.","저는 학생이에요.","저는 선생님이에요."]',
 '저는 베트남 사람이에요.', '베트남 사람 = người Việt Nam.', 1);
