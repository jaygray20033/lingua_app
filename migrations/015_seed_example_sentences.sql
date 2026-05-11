-- =====================================================
-- SEED: Example Sentences Corpus (Tatoeba-style)
-- Bổ sung câu ví dụ đa ngôn ngữ cho các từ vựng phổ biến
-- Nguồn tham khảo: Tatoeba (CC-BY 2.0 FR), curated examples
-- =====================================================

SET NAMES utf8mb4;
SET @ja := (SELECT id FROM languages WHERE code='ja');
SET @en := (SELECT id FROM languages WHERE code='en');
SET @zh := (SELECT id FROM languages WHERE code='zh');
SET @ko := (SELECT id FROM languages WHERE code='ko');

-- =====================================================
-- Ví dụ bổ sung cho từ vựng tiếng Nhật
-- =====================================================
INSERT IGNORE INTO word_examples (word_id, sentence, reading, translation, level_code, source) VALUES
((SELECT id FROM words WHERE `text`='食べる' AND language_id=@ja LIMIT 1),
 '毎朝、パンを食べます。', 'まいあさ、パンをたべます。',
 'Mỗi sáng tôi ăn bánh mì.', 'N5', 'tatoeba'),
((SELECT id FROM words WHERE `text`='食べる' AND language_id=@ja LIMIT 1),
 '昨日、寿司を食べました。', 'きのう、すしをたべました。',
 'Hôm qua tôi đã ăn sushi.', 'N5', 'tatoeba'),
((SELECT id FROM words WHERE `text`='行く' AND language_id=@ja LIMIT 1),
 '毎日学校へ行きます。', 'まいにちがっこうへいきます。',
 'Hàng ngày tôi đi học.', 'N5', 'tatoeba'),
((SELECT id FROM words WHERE `text`='見る' AND language_id=@ja LIMIT 1),
 '週末に映画を見ます。', 'しゅうまつにえいがをみます。',
 'Cuối tuần tôi xem phim.', 'N5', 'tatoeba'),
((SELECT id FROM words WHERE `text`='学校' AND language_id=@ja LIMIT 1),
 '学校は家から近いです。', 'がっこうはいえからちかいです。',
 'Trường học gần nhà tôi.', 'N5', 'tatoeba'),
((SELECT id FROM words WHERE `text`='先生' AND language_id=@ja LIMIT 1),
 '田中先生はやさしいです。', 'たなかせんせいはやさしいです。',
 'Thầy Tanaka rất hiền.', 'N5', 'tatoeba'),
((SELECT id FROM words WHERE `text`='友達' AND language_id=@ja LIMIT 1),
 '友達と一緒に映画を見ました。', 'ともだちといっしょにえいがをみました。',
 'Tôi đi xem phim với bạn.', 'N5', 'tatoeba'),
((SELECT id FROM words WHERE `text`='仕事' AND language_id=@ja LIMIT 1),
 '仕事が忙しくて、疲れています。', 'しごとがいそがしくて、つかれています。',
 'Công việc bận rộn nên tôi mệt.', 'N4', 'tatoeba'),
((SELECT id FROM words WHERE `text`='勉強' AND language_id=@ja LIMIT 1),
 '毎晩日本語を勉強しています。', 'まいばんにほんごをべんきょうしています。',
 'Tối nào tôi cũng học tiếng Nhật.', 'N5', 'tatoeba'),
((SELECT id FROM words WHERE `text`='時間' AND language_id=@ja LIMIT 1),
 '時間がないので、タクシーで行きましょう。', 'じかんがないので、タクシーでいきましょう。',
 'Không có thời gian nên đi taxi đi.', 'N4', 'tatoeba');

-- =====================================================
-- Ví dụ bổ sung cho từ vựng tiếng Trung
-- =====================================================
INSERT IGNORE INTO word_examples (word_id, sentence, reading, translation, level_code, source) VALUES
((SELECT id FROM words WHERE `text`='你好' AND language_id=@zh LIMIT 1),
 '你好，很高兴认识你。', 'Nǐ hǎo, hěn gāoxìng rènshi nǐ.',
 'Xin chào, rất vui được gặp bạn.', 'HSK1', 'tatoeba'),
((SELECT id FROM words WHERE `text`='吃' AND language_id=@zh LIMIT 1),
 '你吃饭了吗？', 'Nǐ chīfàn le ma?',
 'Bạn ăn cơm chưa?', 'HSK1', 'tatoeba'),
((SELECT id FROM words WHERE `text`='喝' AND language_id=@zh LIMIT 1),
 '我喜欢喝茶。', 'Wǒ xǐhuān hē chá.',
 'Tôi thích uống trà.', 'HSK1', 'tatoeba'),
((SELECT id FROM words WHERE `text`='学校' AND language_id=@zh LIMIT 1),
 '我每天去学校。', 'Wǒ měitiān qù xuéxiào.',
 'Hàng ngày tôi đến trường.', 'HSK1', 'tatoeba'),
((SELECT id FROM words WHERE `text`='老师' AND language_id=@zh LIMIT 1),
 '老师很好。', 'Lǎoshī hěn hǎo.',
 'Thầy cô rất tốt.', 'HSK1', 'tatoeba'),
((SELECT id FROM words WHERE `text`='朋友' AND language_id=@zh LIMIT 1),
 '他是我的好朋友。', 'Tā shì wǒ de hǎo péngyǒu.',
 'Anh ấy là bạn tốt của tôi.', 'HSK1', 'tatoeba'),
((SELECT id FROM words WHERE `text`='工作' AND language_id=@zh LIMIT 1),
 '我的工作很忙。', 'Wǒ de gōngzuò hěn máng.',
 'Công việc của tôi rất bận.', 'HSK2', 'tatoeba'),
((SELECT id FROM words WHERE `text`='学习' AND language_id=@zh LIMIT 1),
 '我在学习汉语。', 'Wǒ zài xuéxí Hànyǔ.',
 'Tôi đang học tiếng Trung.', 'HSK1', 'tatoeba');

-- =====================================================
-- Ví dụ bổ sung cho từ vựng tiếng Anh
-- =====================================================
INSERT IGNORE INTO word_examples (word_id, sentence, reading, translation, level_code, source) VALUES
((SELECT id FROM words WHERE `text`='hello' AND language_id=@en LIMIT 1),
 'Hello, how are you today?', NULL,
 'Xin chào, hôm nay bạn thế nào?', 'A1', 'tatoeba'),
((SELECT id FROM words WHERE `text`='eat' AND language_id=@en LIMIT 1),
 'I usually eat breakfast at 7 AM.', NULL,
 'Tôi thường ăn sáng lúc 7h.', 'A1', 'tatoeba'),
((SELECT id FROM words WHERE `text`='study' AND language_id=@en LIMIT 1),
 'She studies English every evening.', NULL,
 'Cô ấy học tiếng Anh mỗi tối.', 'A1', 'tatoeba'),
((SELECT id FROM words WHERE `text`='work' AND language_id=@en LIMIT 1),
 'He works at a bank in London.', NULL,
 'Anh ấy làm việc tại ngân hàng ở London.', 'A1', 'tatoeba'),
((SELECT id FROM words WHERE `text`='friend' AND language_id=@en LIMIT 1),
 'My best friend lives in Paris.', NULL,
 'Bạn thân nhất của tôi sống ở Paris.', 'A1', 'tatoeba'),
((SELECT id FROM words WHERE `text`='believe' AND language_id=@en LIMIT 1),
 'I believe that hard work pays off.', NULL,
 'Tôi tin rằng làm việc chăm chỉ sẽ được đền đáp.', 'A2', 'tatoeba'),
((SELECT id FROM words WHERE `text`='forget' AND language_id=@en LIMIT 1),
 'Don''t forget to lock the door.', NULL,
 'Đừng quên khóa cửa.', 'A2', 'tatoeba'),
((SELECT id FROM words WHERE `text`='expensive' AND language_id=@en LIMIT 1),
 'This watch is too expensive for me.', NULL,
 'Chiếc đồng hồ này quá đắt với tôi.', 'A2', 'tatoeba');

-- =====================================================
-- Ví dụ bổ sung cho từ vựng tiếng Hàn
-- =====================================================
INSERT IGNORE INTO word_examples (word_id, sentence, reading, translation, level_code, source) VALUES
((SELECT id FROM words WHERE `text`='안녕하세요' AND language_id=@ko LIMIT 1),
 '안녕하세요, 만나서 반가워요.', 'annyeonghaseyo, mannaseo bangawoyo.',
 'Xin chào, rất vui được gặp bạn.', 'TOPIK1', 'tatoeba'),
((SELECT id FROM words WHERE `text`='먹다' AND language_id=@ko LIMIT 1),
 '저는 아침에 빵을 먹어요.', 'jeoneun achime ppangeul meogeoyo.',
 'Buổi sáng tôi ăn bánh mì.', 'TOPIK1', 'tatoeba'),
((SELECT id FROM words WHERE `text`='가다' AND language_id=@ko LIMIT 1),
 '매일 학교에 가요.', 'maeil hakgyoe gayo.',
 'Hàng ngày tôi đi học.', 'TOPIK1', 'tatoeba'),
((SELECT id FROM words WHERE `text`='친구' AND language_id=@ko LIMIT 1),
 '친구와 함께 영화를 봤어요.', 'chinguwa hamkke yeonghwareul bwasseoyo.',
 'Tôi xem phim với bạn.', 'TOPIK1', 'tatoeba'),
((SELECT id FROM words WHERE `text`='공부하다' AND language_id=@ko LIMIT 1),
 '매일 한국어를 공부해요.', 'maeil hangugeoreul gongbuhaeyo.',
 'Hàng ngày tôi học tiếng Hàn.', 'TOPIK1', 'tatoeba');
