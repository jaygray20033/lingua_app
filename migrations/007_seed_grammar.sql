-- =====================================================
-- SEED: Grammar Points - All Languages
-- JLPT (N5-N1), HSK (1-6), IELTS/TOEIC/CEFR, TOPIK
-- =====================================================

SET NAMES utf8mb4;
SET @ja := (SELECT id FROM languages WHERE code='ja');
SET @en := (SELECT id FROM languages WHERE code='en');
SET @zh := (SELECT id FROM languages WHERE code='zh');
SET @ko := (SELECT id FROM languages WHERE code='ko');

-- =====================================================
-- JAPANESE GRAMMAR (JLPT N5 → N1)
-- =====================================================

-- ===== JLPT N5 =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@ja, 'Aは Bです', 'A は B です', 'A là B', 'Cấu trúc câu khẳng định cơ bản trong tiếng Nhật. 「は」 là trợ từ chủ đề, 「です」 là động từ ''là'' lịch sự.', 'N5', 'JLPT', 'cơ bản,khẳng định'),
(@ja, 'Aは Bじゃありません', 'A は B じゃありません', 'A không phải là B', 'Phủ định của 「です」. 「じゃありません」 (thân mật) hoặc 「ではありません」 (lịch sự).', 'N5', 'JLPT', 'cơ bản,phủ định'),
(@ja, '〜があります / います', '〜が あります / います', 'Có ~', '「あります」 dùng cho vật vô tri (sách, xe...). 「います」 dùng cho người và động vật.', 'N5', 'JLPT', 'tồn tại'),
(@ja, '〜が好きです', '〜が 好きです', 'Thích ~', 'Diễn tả sở thích. Đối tượng yêu thích đi với trợ từ 「が」, không phải 「を」.', 'N5', 'JLPT', 'sở thích'),
(@ja, '〜たいです', 'V(masu) + たいです', 'Muốn làm ~', 'Diễn tả mong muốn của bản thân. Bỏ 「ます」 thêm 「たい」. Ví dụ: 食べたい (muốn ăn).', 'N5', 'JLPT', 'mong muốn'),
(@ja, '〜ましょう', 'V(masu) + ましょう', 'Cùng làm ~ thôi', 'Đề nghị, rủ rê làm gì cùng nhau.', 'N5', 'JLPT', 'rủ rê,đề nghị'),
(@ja, '〜てください', 'V(te) + ください', 'Hãy làm ~', 'Yêu cầu lịch sự ai đó làm gì.', 'N5', 'JLPT', 'yêu cầu'),
(@ja, '〜ています', 'V(te) + います', 'Đang làm ~ / trạng thái duy trì', 'Diễn tả hành động đang diễn ra hoặc trạng thái kéo dài (đã kết hôn, đang sống...).', 'N5', 'JLPT', 'tiếp diễn'),
(@ja, '〜から、〜', 'A から、 B', 'Vì A, nên B', 'Diễn tả lý do. Vế lý do đặt trước 「から」, vế kết quả đặt sau.', 'N5', 'JLPT', 'lý do');

-- ===== JLPT N4 =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@ja, '〜ことができる', 'V(辞書形) + ことができる', 'Có thể làm ~', 'Diễn tả khả năng. Tương đương với thể khả năng (可能形).', 'N4', 'JLPT', 'khả năng'),
(@ja, '〜と思う', 'Câu(普通形) + と思う', 'Tôi nghĩ rằng ~', 'Diễn tả suy nghĩ, ý kiến của người nói.', 'N4', 'JLPT', 'ý kiến'),
(@ja, '〜なければならない', 'V(ない形) + なければならない', 'Phải làm ~', 'Diễn tả nghĩa vụ, bắt buộc. Dạng rút gọn: 〜なきゃ.', 'N4', 'JLPT', 'bắt buộc'),
(@ja, '〜てもいい', 'V(te) + もいい', 'Có thể, được phép làm ~', 'Cho phép hoặc xin phép làm gì đó.', 'N4', 'JLPT', 'cho phép'),
(@ja, '〜てはいけない', 'V(te) + はいけない', 'Không được làm ~', 'Cấm đoán, không được phép.', 'N4', 'JLPT', 'cấm đoán'),
(@ja, '〜たことがある', 'V(ta) + ことがある', 'Đã từng làm ~', 'Diễn tả kinh nghiệm trong quá khứ.', 'N4', 'JLPT', 'kinh nghiệm'),
(@ja, '〜ながら', 'V(masu) + ながら', 'Vừa ~ vừa ~', 'Diễn tả hai hành động xảy ra đồng thời do cùng một chủ thể.', 'N4', 'JLPT', 'đồng thời'),
(@ja, '〜たら', 'V(ta) + ら', 'Nếu/Khi ~', 'Diễn tả điều kiện hoặc trình tự thời gian.', 'N4', 'JLPT', 'điều kiện');

-- ===== JLPT N3 =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@ja, '〜らしい', 'N / V(普通形) + らしい', 'Nghe nói ~ / Có vẻ ~', 'Phán đoán dựa trên thông tin nghe được hoặc đặc trưng tiêu biểu.', 'N3', 'JLPT', 'phán đoán'),
(@ja, '〜ようだ', 'V/A(普通形) + ようだ', 'Có vẻ như ~', 'Phán đoán chủ quan dựa trên giác quan của người nói.', 'N3', 'JLPT', 'phán đoán'),
(@ja, '〜ばかり', 'V(ta) + ばかり / N + ばかり', 'Vừa mới ~ / Toàn ~', 'Vừa mới làm gì xong, hoặc chỉ toàn cái gì đó.', 'N3', 'JLPT', 'thời gian'),
(@ja, '〜ても', 'V(te) + も', 'Dù ~ cũng ~', 'Diễn tả nghịch ý, dù điều kiện A vẫn xảy ra B.', 'N3', 'JLPT', 'nghịch ý'),
(@ja, '〜のに', 'Câu(普通形) + のに', 'Mặc dù ~ nhưng ~', 'Diễn tả sự bất ngờ, không như mong đợi.', 'N3', 'JLPT', 'nghịch ý'),
(@ja, '〜ために', 'V(辞書形) + ために / N + のために', 'Để ~ / Vì ~', 'Mục đích hoặc nguyên nhân.', 'N3', 'JLPT', 'mục đích');

-- ===== JLPT N2 =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@ja, '〜にもかかわらず', 'N / V(普通形) + にもかかわらず', 'Mặc dù ~', 'Diễn tả nghịch ý mạnh, "bất kể, mặc dù vậy".', 'N2', 'JLPT', 'nghịch ý'),
(@ja, '〜ばかりか', 'N / V + ばかりか', 'Không chỉ ~ mà còn ~', 'Tăng tiến, cấp độ cao hơn 〜だけでなく.', 'N2', 'JLPT', 'tăng tiến'),
(@ja, '〜わけではない', 'V/A(普通形) + わけではない', 'Không phải là ~', 'Phủ định một cách hợp lý hoặc làm rõ ý.', 'N2', 'JLPT', 'phủ định'),
(@ja, '〜あまり', 'V(辞書形) + あまり', 'Quá ~ đến mức ~', 'Vì quá làm gì đó nên dẫn đến hậu quả.', 'N2', 'JLPT', 'mức độ'),
(@ja, '〜ぬきで', 'N + ぬきで', 'Bỏ qua ~ / Không có ~', 'Lược bỏ điều gì đó.', 'N2', 'JLPT', 'lược bỏ');

-- ===== JLPT N1 =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@ja, '〜を余儀なくされる', 'N + を余儀なくされる', 'Buộc phải ~', 'Bị ép buộc, không còn lựa chọn nào khác.', 'N1', 'JLPT', 'bắt buộc'),
(@ja, '〜にひきかえ', 'N + にひきかえ', 'Trái với ~', 'So sánh đối lập mạnh.', 'N1', 'JLPT', 'so sánh'),
(@ja, '〜が早いか', 'V(辞書形) + が早いか', 'Vừa ~ là liền ~', 'Hành động xảy ra ngay lập tức sau hành động khác.', 'N1', 'JLPT', 'thời gian'),
(@ja, '〜とあって', 'N / V + とあって', 'Vì là ~ nên ~', 'Lý do đặc biệt nên có kết quả tương xứng.', 'N1', 'JLPT', 'lý do');

-- =====================================================
-- ENGLISH GRAMMAR (CEFR / IELTS / TOEIC)
-- =====================================================

-- ===== A1/A2 =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@en, 'Present Simple', 'S + V(s/es) + O', 'Thì hiện tại đơn', 'Diễn tả thói quen, sự thật hiển nhiên, lịch trình. He/She/It thêm s/es.', 'A1', 'CEFR', 'tense,beginner'),
(@en, 'Present Continuous', 'S + am/is/are + V-ing', 'Thì hiện tại tiếp diễn', 'Diễn tả hành động đang xảy ra ngay bây giờ hoặc xung quanh hiện tại.', 'A1', 'CEFR', 'tense,beginner'),
(@en, 'Past Simple', 'S + V2/V-ed + O', 'Thì quá khứ đơn', 'Diễn tả hành động đã hoàn tất trong quá khứ với mốc thời gian xác định.', 'A2', 'CEFR', 'tense,beginner'),
(@en, 'Going to (Future)', 'S + am/is/are + going to + V', 'Sắp / Dự định ~', 'Diễn tả dự định đã có kế hoạch hoặc dự đoán dựa trên dấu hiệu hiện tại.', 'A2', 'CEFR', 'tense,future'),
(@en, 'Comparative Adjectives', 'S + V + ADJ-er + than / more ADJ than', 'So sánh hơn', 'Tính từ ngắn thêm -er, tính từ dài thêm "more".', 'A2', 'CEFR', 'comparison'),
(@en, 'Superlative Adjectives', 'S + V + the ADJ-est / the most ADJ', 'So sánh nhất', 'Tính từ ngắn thêm -est, tính từ dài thêm "the most".', 'A2', 'CEFR', 'comparison');

-- ===== B1/B2 (IELTS / TOEIC) =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@en, 'Present Perfect', 'S + have/has + V3/V-ed', 'Thì hiện tại hoàn thành', 'Hành động bắt đầu trong quá khứ và còn liên quan đến hiện tại; kinh nghiệm; vừa mới hoàn thành.', 'B1', 'CEFR', 'tense'),
(@en, 'Past Perfect', 'S + had + V3/V-ed', 'Thì quá khứ hoàn thành', 'Hành động xảy ra trước một mốc thời gian khác trong quá khứ.', 'B1', 'CEFR', 'tense'),
(@en, 'First Conditional', 'If + S + V (present), S + will + V', 'Câu điều kiện loại 1', 'Diễn tả điều kiện có thật, có khả năng xảy ra ở tương lai.', 'B1', 'CEFR', 'conditional'),
(@en, 'Second Conditional', 'If + S + V2/V-ed, S + would + V', 'Câu điều kiện loại 2', 'Giả định không có thật ở hiện tại/tương lai.', 'B1', 'CEFR', 'conditional'),
(@en, 'Third Conditional', 'If + S + had + V3, S + would have + V3', 'Câu điều kiện loại 3', 'Giả định không có thật ở quá khứ, hối tiếc.', 'B2', 'IELTS', 'conditional'),
(@en, 'Passive Voice', 'S + be + V3/V-ed (+ by O)', 'Thể bị động', 'Khi tân ngữ trở thành chủ ngữ; nhấn mạnh đối tượng nhận hành động.', 'B1', 'TOEIC', 'voice'),
(@en, 'Reported Speech', 'S + said (that) + S + V (lùi thì)', 'Câu tường thuật', 'Thuật lại lời người khác. Lùi thì, đổi đại từ và trạng từ thời gian.', 'B2', 'TOEIC', 'reported'),
(@en, 'Relative Clauses (who/which/that)', 'N + who/which/that + V/clause', 'Mệnh đề quan hệ', 'Bổ nghĩa cho danh từ. who/whom cho người, which cho vật, that cho cả hai.', 'B1', 'CEFR', 'clause'),
(@en, 'Modals (must/should/might)', 'S + modal + V (bare)', 'Động từ khuyết thiếu', 'must = phải, should = nên, might = có thể, could = có thể (lịch sự).', 'B1', 'CEFR', 'modal'),
(@en, 'Gerunds vs Infinitives', 'V + V-ing / V + to V', 'Danh động từ vs nguyên thể có to', 'Một số động từ đi với V-ing (enjoy, avoid), một số với to V (want, decide).', 'B2', 'IELTS', 'verb');

-- ===== C1 (IELTS Advanced) =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@en, 'Inversion', 'Negative adverb + Aux + S + V', 'Đảo ngữ', 'Đặt trạng từ phủ định lên đầu câu rồi đảo trợ động từ. Ví dụ: "Never have I seen..."', 'C1', 'IELTS', 'advanced'),
(@en, 'Cleft Sentences', 'It is/was + ... + that/who + clause', 'Câu chẻ', 'Nhấn mạnh một thành phần trong câu. "It was John who broke the vase".', 'C1', 'IELTS', 'emphasis'),
(@en, 'Mixed Conditionals', 'If + past perfect, S + would + V (now)', 'Câu điều kiện hỗn hợp', 'Kết hợp loại 2 và loại 3 để diễn tả điều kiện quá khứ ảnh hưởng đến hiện tại.', 'C1', 'IELTS', 'conditional');

-- =====================================================
-- CHINESE GRAMMAR (HSK 1-6)
-- =====================================================
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@zh, '是 (shì) — Câu khẳng định', 'A + 是 + B', 'A là B', 'Động từ "là" cơ bản. Phủ định: A 不是 B.', 'HSK1', 'HSK', 'cơ bản'),
(@zh, '有 (yǒu) — Có', 'S + 有 + N', 'Có ~', 'Diễn tả sở hữu hoặc tồn tại. Phủ định: 没有 (méiyǒu).', 'HSK1', 'HSK', 'tồn tại'),
(@zh, '吗 (ma) — Câu hỏi Yes/No', 'Câu khẳng định + 吗?', 'Trợ từ nghi vấn', 'Thêm 吗 vào cuối câu khẳng định để tạo câu hỏi yes/no.', 'HSK1', 'HSK', 'câu hỏi'),
(@zh, '在 (zài) — Đang ~', 'S + 在 + V', 'Đang làm ~', 'Diễn tả hành động đang diễn ra. Cũng có nghĩa "ở (đâu đó)".', 'HSK2', 'HSK', 'tiếp diễn'),
(@zh, '了 (le) — Hoàn thành', 'V + 了', 'Đã làm ~', 'Trợ từ thể hiện hành động đã xảy ra hoặc thay đổi trạng thái.', 'HSK2', 'HSK', 'quá khứ'),
(@zh, '把 (bǎ) — Câu chữ 把', 'S + 把 + O + V + bổ ngữ', 'Cấu trúc nhấn mạnh đối tượng', 'Đưa tân ngữ lên trước động từ để nhấn mạnh sự xử lý đối tượng.', 'HSK3', 'HSK', 'cấu trúc'),
(@zh, '被 (bèi) — Bị động', 'S(bị tác động) + 被 + (chủ thể) + V', 'Bị ~', 'Cấu trúc bị động. Tương đương "be + V3" trong tiếng Anh.', 'HSK4', 'HSK', 'bị động'),
(@zh, '虽然...但是...', '虽然 A, 但是 B', 'Mặc dù A nhưng B', 'Liên từ thể hiện quan hệ nghịch ý.', 'HSK3', 'HSK', 'liên từ'),
(@zh, '因为...所以...', '因为 A, 所以 B', 'Vì A nên B', 'Liên từ chỉ nguyên nhân - kết quả.', 'HSK2', 'HSK', 'liên từ'),
(@zh, '比 (bǐ) — So sánh', 'A + 比 + B + ADJ', 'A hơn B (về ADJ)', 'Cấu trúc so sánh hơn cơ bản. VD: 我比他高 (Tôi cao hơn anh ấy).', 'HSK2', 'HSK', 'so sánh'),
(@zh, '越来越 (yuè lái yuè)', '越来越 + ADJ', 'Càng ngày càng ~', 'Diễn tả sự thay đổi tiến triển theo thời gian.', 'HSK3', 'HSK', 'tiến triển'),
(@zh, '不但...而且...', '不但 A, 而且 B', 'Không những A mà còn B', 'Liên từ tăng tiến.', 'HSK4', 'HSK', 'tăng tiến');

-- =====================================================
-- KOREAN GRAMMAR (TOPIK I, II)
-- =====================================================
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@ko, '~입니다 / ~이에요', 'N + 입니다 (formal) / 이에요 (polite)', 'Là ~', 'Vị từ "là" cơ bản. 입니다 trang trọng, 이에요/예요 thân thiện.', 'TOPIK1', 'TOPIK', 'cơ bản'),
(@ko, '~이/가 있다', 'N + 이/가 있다', 'Có N', 'Diễn tả sở hữu/tồn tại. Phủ định: 없다.', 'TOPIK1', 'TOPIK', 'tồn tại'),
(@ko, '~을/를 V', 'N + 을/를 + V', 'Trợ từ tân ngữ', 'Đánh dấu tân ngữ trực tiếp. 을 sau phụ âm, 를 sau nguyên âm.', 'TOPIK1', 'TOPIK', 'trợ từ'),
(@ko, '~고 싶다', 'V(stem) + 고 싶다', 'Muốn ~', 'Diễn tả mong muốn của bản thân. VD: 먹고 싶어요 (muốn ăn).', 'TOPIK1', 'TOPIK', 'mong muốn'),
(@ko, '~아/어요', 'V(stem) + 아/어요', 'Đuôi câu lịch sự', 'Đuôi kết thúc câu thân thiện - lịch sự. Quan trọng nhất ở TOPIK I.', 'TOPIK1', 'TOPIK', 'đuôi câu'),
(@ko, '~았/었어요', 'V(stem) + 았/었어요', 'Đã ~', 'Thì quá khứ đuôi lịch sự. VD: 갔어요 (đã đi).', 'TOPIK1', 'TOPIK', 'quá khứ'),
(@ko, '~겠어요', 'V(stem) + 겠어요', 'Sẽ ~ / Có lẽ ~', 'Diễn tả ý định, dự đoán hoặc lịch sự khi nói về cảm xúc.', 'TOPIK2', 'TOPIK', 'tương lai'),
(@ko, '~지만', 'V/A(stem) + 지만', 'Nhưng ~', 'Liên từ chỉ nghịch ý. VD: 비싸지만 좋아요 (đắt nhưng tốt).', 'TOPIK2', 'TOPIK', 'liên từ'),
(@ko, '~아/어서', 'V(stem) + 아/어서', 'Vì ~ nên ~ / ~ rồi ~', 'Lý do hoặc trình tự thời gian.', 'TOPIK2', 'TOPIK', 'lý do'),
(@ko, '~으면', 'V/A(stem) + 으면', 'Nếu ~', 'Câu điều kiện cơ bản.', 'TOPIK2', 'TOPIK', 'điều kiện'),
(@ko, '~고 있다', 'V(stem) + 고 있다', 'Đang ~', 'Diễn tả hành động đang diễn ra.', 'TOPIK2', 'TOPIK', 'tiếp diễn'),
(@ko, '~(으)ㄴ 적이 있다', 'V(stem) + (으)ㄴ 적이 있다', 'Đã từng ~', 'Diễn tả kinh nghiệm trong quá khứ.', 'TOPIK3', 'TOPIK', 'kinh nghiệm'),
(@ko, '~기 때문에', 'V/A(stem) + 기 때문에', 'Bởi vì ~', 'Lý do trang trọng hơn -아/어서.', 'TOPIK3', 'TOPIK', 'lý do'),
(@ko, '~(으)ㄹ 수 있다', 'V(stem) + (으)ㄹ 수 있다', 'Có thể ~', 'Diễn tả khả năng. Phủ định: 없다.', 'TOPIK2', 'TOPIK', 'khả năng'),
(@ko, '~았/었으면 좋겠다', 'V(stem) + 았/었으면 좋겠다', 'Mong rằng ~', 'Mong ước, ước muốn.', 'TOPIK4', 'TOPIK', 'mong ước');

-- =====================================================
-- GRAMMAR EXAMPLES
-- =====================================================
-- Ví dụ cho ngữ pháp tiếng Nhật
INSERT INTO grammar_examples (grammar_id, sentence, translation, note, order_index) VALUES
((SELECT id FROM grammar_points WHERE title='Aは Bです' AND language_id=@ja LIMIT 1),
 '私は学生です。', 'Tôi là học sinh.', 'Câu khẳng định cơ bản', 1),
((SELECT id FROM grammar_points WHERE title='Aは Bです' AND language_id=@ja LIMIT 1),
 '彼は先生です。', 'Anh ấy là giáo viên.', NULL, 2),
((SELECT id FROM grammar_points WHERE title='〜たいです' AND language_id=@ja LIMIT 1),
 '日本へ行きたいです。', 'Tôi muốn đi Nhật Bản.', 'Trợ từ へ chỉ phương hướng', 1),
((SELECT id FROM grammar_points WHERE title='〜たいです' AND language_id=@ja LIMIT 1),
 'ラーメンを食べたいです。', 'Tôi muốn ăn ramen.', NULL, 2),
((SELECT id FROM grammar_points WHERE title='〜てください' AND language_id=@ja LIMIT 1),
 'もう一度言ってください。', 'Hãy nói lại một lần nữa.', NULL, 1),
((SELECT id FROM grammar_points WHERE title='〜ことができる' AND language_id=@ja LIMIT 1),
 '日本語を話すことができます。', 'Tôi có thể nói tiếng Nhật.', NULL, 1),
((SELECT id FROM grammar_points WHERE title='〜たことがある' AND language_id=@ja LIMIT 1),
 '富士山に登ったことがあります。', 'Tôi đã từng leo núi Phú Sĩ.', NULL, 1),
((SELECT id FROM grammar_points WHERE title='〜らしい' AND language_id=@ja LIMIT 1),
 '田中さんは結婚するらしいです。', 'Nghe nói anh Tanaka sắp kết hôn.', NULL, 1),
((SELECT id FROM grammar_points WHERE title='〜にもかかわらず' AND language_id=@ja LIMIT 1),
 '雨にもかかわらず、試合は行われた。', 'Mặc dù trời mưa, trận đấu vẫn diễn ra.', NULL, 1),
((SELECT id FROM grammar_points WHERE title='〜を余儀なくされる' AND language_id=@ja LIMIT 1),
 '台風で、旅行の中止を余儀なくされた。', 'Vì bão, tôi buộc phải hủy chuyến du lịch.', NULL, 1);

-- Ví dụ cho ngữ pháp tiếng Anh
INSERT INTO grammar_examples (grammar_id, sentence, translation, note, order_index) VALUES
((SELECT id FROM grammar_points WHERE title='Present Simple' AND language_id=@en LIMIT 1),
 'She works at a hospital.', 'Cô ấy làm việc ở bệnh viện.', 'V thêm s với ngôi 3 số ít', 1),
((SELECT id FROM grammar_points WHERE title='Present Continuous' AND language_id=@en LIMIT 1),
 'They are studying English now.', 'Họ đang học tiếng Anh bây giờ.', NULL, 1),
((SELECT id FROM grammar_points WHERE title='Present Perfect' AND language_id=@en LIMIT 1),
 'I have lived in Hanoi for 5 years.', 'Tôi đã sống ở Hà Nội được 5 năm.', 'for + khoảng thời gian', 1),
((SELECT id FROM grammar_points WHERE title='Present Perfect' AND language_id=@en LIMIT 1),
 'She has just finished her homework.', 'Cô ấy vừa làm xong bài tập.', 'just = vừa mới', 2),
((SELECT id FROM grammar_points WHERE title='First Conditional' AND language_id=@en LIMIT 1),
 'If it rains, I will stay at home.', 'Nếu trời mưa, tôi sẽ ở nhà.', NULL, 1),
((SELECT id FROM grammar_points WHERE title='Second Conditional' AND language_id=@en LIMIT 1),
 'If I were rich, I would travel the world.', 'Nếu tôi giàu, tôi sẽ đi du lịch khắp thế giới.', 'were dùng cho mọi ngôi (formal)', 1),
((SELECT id FROM grammar_points WHERE title='Third Conditional' AND language_id=@en LIMIT 1),
 'If I had studied harder, I would have passed the exam.', 'Nếu tôi học chăm hơn, tôi đã đỗ kỳ thi.', NULL, 1),
((SELECT id FROM grammar_points WHERE title='Passive Voice' AND language_id=@en LIMIT 1),
 'The report was written by the manager.', 'Báo cáo được viết bởi người quản lý.', NULL, 1),
((SELECT id FROM grammar_points WHERE title='Inversion' AND language_id=@en LIMIT 1),
 'Never have I seen such a beautiful sunset.', 'Tôi chưa từng thấy hoàng hôn đẹp đến vậy.', 'Trạng từ phủ định lên đầu câu', 1),
((SELECT id FROM grammar_points WHERE title='Cleft Sentences' AND language_id=@en LIMIT 1),
 'It was Mary who solved the problem.', 'Chính Mary là người đã giải quyết vấn đề.', NULL, 1);

-- Ví dụ cho ngữ pháp tiếng Trung
INSERT INTO grammar_examples (grammar_id, sentence, translation, note, order_index) VALUES
((SELECT id FROM grammar_points WHERE title='是 (shì) — Câu khẳng định' AND language_id=@zh LIMIT 1),
 '我是学生。', 'Tôi là học sinh.', 'Wǒ shì xuésheng', 1),
((SELECT id FROM grammar_points WHERE title='吗 (ma) — Câu hỏi Yes/No' AND language_id=@zh LIMIT 1),
 '你是中国人吗？', 'Bạn là người Trung Quốc phải không?', NULL, 1),
((SELECT id FROM grammar_points WHERE title='了 (le) — Hoàn thành' AND language_id=@zh LIMIT 1),
 '我吃了三个苹果。', 'Tôi đã ăn ba quả táo.', NULL, 1),
((SELECT id FROM grammar_points WHERE title='把 (bǎ) — Câu chữ 把' AND language_id=@zh LIMIT 1),
 '我把书放在桌子上。', 'Tôi đặt cuốn sách lên bàn.', NULL, 1),
((SELECT id FROM grammar_points WHERE title='被 (bèi) — Bị động' AND language_id=@zh LIMIT 1),
 '我的钱包被偷了。', 'Ví của tôi bị trộm rồi.', NULL, 1),
((SELECT id FROM grammar_points WHERE title='比 (bǐ) — So sánh' AND language_id=@zh LIMIT 1),
 '今天比昨天热。', 'Hôm nay nóng hơn hôm qua.', NULL, 1);

-- Ví dụ cho ngữ pháp tiếng Hàn
INSERT INTO grammar_examples (grammar_id, sentence, translation, note, order_index) VALUES
((SELECT id FROM grammar_points WHERE title='~입니다 / ~이에요' AND language_id=@ko LIMIT 1),
 '저는 학생입니다.', 'Tôi là học sinh.', 'jeoneun haksaeng-imnida', 1),
((SELECT id FROM grammar_points WHERE title='~고 싶다' AND language_id=@ko LIMIT 1),
 '한국에 가고 싶어요.', 'Tôi muốn đến Hàn Quốc.', NULL, 1),
((SELECT id FROM grammar_points WHERE title='~았/었어요' AND language_id=@ko LIMIT 1),
 '어제 영화를 봤어요.', 'Hôm qua tôi đã xem phim.', NULL, 1),
((SELECT id FROM grammar_points WHERE title='~지만' AND language_id=@ko LIMIT 1),
 '한국어는 어렵지만 재미있어요.', 'Tiếng Hàn khó nhưng thú vị.', NULL, 1),
((SELECT id FROM grammar_points WHERE title='~으면' AND language_id=@ko LIMIT 1),
 '시간이 있으면 같이 가요.', 'Nếu có thời gian thì đi cùng nhé.', NULL, 1),
((SELECT id FROM grammar_points WHERE title='~(으)ㄹ 수 있다' AND language_id=@ko LIMIT 1),
 '저는 한국어를 할 수 있어요.', 'Tôi có thể nói tiếng Hàn.', NULL, 1);

-- =====================================================
-- GRAMMAR EXERCISES (cho Detail screen)
-- =====================================================
INSERT INTO grammar_exercises (grammar_id, `type`, prompt, options_json, answer, explanation) VALUES
((SELECT id FROM grammar_points WHERE title='Aは Bです' AND language_id=@ja LIMIT 1),
 'MULTI_CHOICE', '私___学生___。',
 '["は/です","が/です","を/ます","に/だ"]', 'は/です',
 'Cấu trúc cơ bản A は B です'),
((SELECT id FROM grammar_points WHERE title='〜たいです' AND language_id=@ja LIMIT 1),
 'MULTI_CHOICE', '日本語を___。 (Tôi muốn học tiếng Nhật)',
 '["勉強したいです","勉強します","勉強しました","勉強しません"]', '勉強したいです',
 'V(masu) + たい thể hiện mong muốn'),
((SELECT id FROM grammar_points WHERE title='Present Perfect' AND language_id=@en LIMIT 1),
 'MULTI_CHOICE', 'I ___ never ___ to Paris.',
 '["have / been","had / been","am / been","was / been"]', 'have / been',
 'Hiện tại hoàn thành dùng have/has + V3'),
((SELECT id FROM grammar_points WHERE title='Second Conditional' AND language_id=@en LIMIT 1),
 'MULTI_CHOICE', 'If I ___ you, I would accept the offer.',
 '["was","were","am","be"]', 'were',
 'Loại 2 dùng "were" cho mọi ngôi (formal)'),
((SELECT id FROM grammar_points WHERE title='把 (bǎ) — Câu chữ 把' AND language_id=@zh LIMIT 1),
 'MULTI_CHOICE', '请___门关上。',
 '["把","被","在","了"]', '把',
 'Câu chữ 把 nhấn mạnh sự xử lý đối tượng'),
((SELECT id FROM grammar_points WHERE title='~고 싶다' AND language_id=@ko LIMIT 1),
 'MULTI_CHOICE', '한국 음식을 ___.',
 '["먹고 싶어요","먹어요","먹었어요","먹습니다"]', '먹고 싶어요',
 'V(stem) + 고 싶다 = muốn làm gì');
