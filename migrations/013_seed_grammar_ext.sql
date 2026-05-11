-- =====================================================
-- SEED EXT: Grammar Points - Comprehensive Extension
-- JLPT (N5-N1), HSK (1-6), IELTS, TOEIC
-- Sources: JLPT Sensei, Bunpro (CC-BY hints), HSK Standard Course,
--          Cambridge English Grammar in Use, Barron's TOEIC.
-- =====================================================

SET NAMES utf8mb4;
SET @ja := (SELECT id FROM languages WHERE code='ja');
SET @en := (SELECT id FROM languages WHERE code='en');
SET @zh := (SELECT id FROM languages WHERE code='zh');

-- =====================================================
-- JAPANESE GRAMMAR EXTENSION (JLPT N5 → N1)
-- =====================================================

-- ===== JLPT N5 - Extended =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@ja, '〜も', 'N + も', 'Cũng ~', 'Trợ từ "も" thay thế cho は/が để diễn tả "cũng vậy". Ví dụ: 私も学生です。(Tôi cũng là học sinh).', 'N5', 'JLPT', 'cơ bản,trợ từ'),
(@ja, '〜の (sở hữu)', 'N1 + の + N2', 'N1 của N2', 'Trợ từ "の" liên kết hai danh từ chỉ sở hữu hoặc thuộc tính. 私の本 (sách của tôi).', 'N5', 'JLPT', 'sở hữu,trợ từ'),
(@ja, '〜で (phương tiện/nơi chốn)', 'N + で', 'Bằng ~ / Tại ~', '「で」 chỉ phương tiện (バスで行く - đi bằng xe buýt) hoặc nơi diễn ra hành động (公園で遊ぶ - chơi ở công viên).', 'N5', 'JLPT', 'trợ từ'),
(@ja, '〜へ (hướng đến)', 'N + へ', 'Đến ~', 'Trợ từ chỉ hướng di chuyển. 学校へ行く (đi đến trường).', 'N5', 'JLPT', 'trợ từ,phương hướng'),
(@ja, '〜と (cùng với)', 'N + と', 'Cùng với ~', 'Diễn tả "cùng với ai đó". 友達と映画を見る (xem phim cùng bạn).', 'N5', 'JLPT', 'trợ từ'),
(@ja, '〜から〜まで', 'N + から + N + まで', 'Từ ~ đến ~', 'Diễn tả phạm vi thời gian/không gian. 9時から5時まで (từ 9 giờ đến 5 giờ).', 'N5', 'JLPT', 'phạm vi'),
(@ja, '〜ません', 'V(masu) → V(masen)', 'Không làm ~', 'Phủ định lịch sự của động từ thể ます. 食べません (không ăn).', 'N5', 'JLPT', 'phủ định'),
(@ja, '〜ました', 'V(masu) → V(mashita)', 'Đã làm ~ (quá khứ)', 'Quá khứ lịch sự. 食べました (đã ăn).', 'N5', 'JLPT', 'quá khứ'),
(@ja, '〜ませんでした', 'V(masu) → V(masendeshita)', 'Đã không làm ~', 'Quá khứ phủ định. 食べませんでした (đã không ăn).', 'N5', 'JLPT', 'quá khứ,phủ định'),
(@ja, 'i-Adj 形容詞', 'A(i) + です', 'Tính từ đuôi い', 'Tính từ kết thúc bằng い. Phủ định: い→くない. 高い→高くない.', 'N5', 'JLPT', 'tính từ'),
(@ja, 'na-Adj 形容詞', 'A(na) + です', 'Tính từ đuôi な', 'Tính từ đứng trước danh từ thêm な. きれいな花 (hoa đẹp).', 'N5', 'JLPT', 'tính từ'),
(@ja, '〜が、〜', 'A が、 B', 'A nhưng B', 'Liên từ "nhưng". 安いですが、おいしくないです (rẻ nhưng không ngon).', 'N5', 'JLPT', 'liên từ'),
(@ja, '〜より〜の方が', 'A より B の方が ~', 'B ~ hơn A', 'So sánh hơn. 夏より冬の方が好きです (Tôi thích mùa đông hơn mùa hè).', 'N5', 'JLPT', 'so sánh');

-- ===== JLPT N4 - Extended =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@ja, '〜なくてもいい', 'V(nai) + くてもいい', 'Không cần phải ~', 'Diễn tả không cần thiết. 行かなくてもいい (không cần phải đi).', 'N4', 'JLPT', 'không bắt buộc'),
(@ja, '〜ばよかった', 'V(ba) + よかった', 'Giá mà đã ~', 'Tiếc nuối về điều đã không xảy ra. 早く行けばよかった (giá mà đã đi sớm).', 'N4', 'JLPT', 'tiếc nuối'),
(@ja, '〜つもり', 'V(辞書) + つもり', 'Dự định ~', 'Ý định, dự định của người nói. 来年日本に行くつもりです.', 'N4', 'JLPT', 'dự định'),
(@ja, '〜と〜と、どちらが', 'A と B と、どちらが ~', 'Trong A và B, cái nào ~?', 'Câu hỏi so sánh hai đối tượng.', 'N4', 'JLPT', 'so sánh'),
(@ja, '〜方がいい', 'V(ta) + 方がいい', 'Nên làm ~', 'Khuyên bảo, đề xuất. 早く寝た方がいい (nên ngủ sớm).', 'N4', 'JLPT', 'khuyên bảo'),
(@ja, '〜ば', 'V(ba) / A(kereba)', 'Nếu ~', 'Điều kiện. 雨が降れば、行きません (nếu trời mưa, tôi sẽ không đi).', 'N4', 'JLPT', 'điều kiện'),
(@ja, '〜なら', 'N / V(普通) + なら', 'Nếu là ~ thì', 'Điều kiện gắn với chủ đề. お酒なら、ビールが好きです (nếu nói về rượu thì tôi thích bia).', 'N4', 'JLPT', 'điều kiện'),
(@ja, '〜あげる/くれる/もらう', 'Vて + あげる/くれる/もらう', 'Cho/Nhận hành động', 'Trao đổi hành động. 助けてくれる (giúp tôi), 教えてあげる (chỉ cho ai).', 'N4', 'JLPT', 'trao đổi,quan hệ'),
(@ja, '〜ようと思う', 'V(意志) + ようと思う', 'Định sẽ ~', 'Ý định, quyết định gần đây. 旅行しようと思っています.', 'N4', 'JLPT', 'dự định'),
(@ja, '〜らしい (đặc trưng)', 'N + らしい', 'Đúng kiểu ~', 'Mang đặc trưng tiêu biểu. 男らしい (đậm chất đàn ông).', 'N4', 'JLPT', 'đặc trưng'),
(@ja, '〜そうだ (truyền đạt)', 'Câu(普通) + そうだ', 'Nghe nói rằng ~', 'Truyền đạt thông tin nghe được. 雨が降るそうです.', 'N4', 'JLPT', 'truyền đạt'),
(@ja, '〜そうだ (suy đoán)', 'V(masu語幹/A語幹) + そうだ', 'Trông có vẻ ~', 'Suy đoán dựa trên nhìn. おいしそう (trông ngon).', 'N4', 'JLPT', 'suy đoán'),
(@ja, '〜かもしれない', 'V/A/N(普通) + かもしれない', 'Có thể là ~', 'Phán đoán có khả năng (~50%).', 'N4', 'JLPT', 'phán đoán'),
(@ja, '〜でしょう', 'V/A/N(普通) + でしょう', 'Có lẽ ~', 'Phán đoán chắc chắn hơn. 明日は雨でしょう.', 'N4', 'JLPT', 'phán đoán');

-- ===== JLPT N3 - Extended =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@ja, '〜うちに', 'V(辞書/ない) + うちに', 'Trong khi còn ~', 'Tận dụng khoảng thời gian. 若いうちに勉強する (học khi còn trẻ).', 'N3', 'JLPT', 'thời gian'),
(@ja, '〜ところ', 'V + ところ', 'Đang ở giai đoạn ~', 'V(辞書)+ところ: sắp; V(て)+ところ: đang; V(た)+ところ: vừa mới.', 'N3', 'JLPT', 'thời gian'),
(@ja, '〜ように', 'V(辞書/ない) + ように', 'Để ~', 'Mục đích để đạt được trạng thái. 聞こえるように大きく話す.', 'N3', 'JLPT', 'mục đích'),
(@ja, '〜ようにする', 'V(辞書/ない) + ようにする', 'Cố gắng để ~', 'Nỗ lực duy trì thói quen. 毎日運動するようにしている.', 'N3', 'JLPT', 'nỗ lực'),
(@ja, '〜ようになる', 'V(辞書/ない) + ようになる', 'Trở nên có thể ~', 'Sự thay đổi khả năng/trạng thái. 漢字が読めるようになった.', 'N3', 'JLPT', 'thay đổi'),
(@ja, '〜さ (danh từ hóa)', 'A(語幹) + さ', 'Mức độ ~', 'Biến tính từ thành danh từ. 高さ (chiều cao), 美しさ (vẻ đẹp).', 'N3', 'JLPT', 'danh từ hóa'),
(@ja, '〜らしい (theo lẽ thường)', 'N + らしい', 'Có dáng vẻ ~', 'Phù hợp với hình tượng/lệ thường. 春らしい天気.', 'N3', 'JLPT', 'đặc trưng'),
(@ja, '〜らしい (suy đoán)', 'V/A(普通) + らしい', 'Hình như ~', 'Suy đoán dựa trên thông tin gián tiếp.', 'N3', 'JLPT', 'suy đoán'),
(@ja, '〜という', 'N1 + という + N2', 'N2 tên là N1', 'Giới thiệu tên gọi. 「ラーメン」という料理.', 'N3', 'JLPT', 'giới thiệu'),
(@ja, '〜って', '~ って', 'Là ~ / Nghe nói', 'Dạng nói thông tục của というの/と言う.', 'N3', 'JLPT', 'thông tục'),
(@ja, '〜ば〜ほど', 'V(ば) + V(辞書) + ほど', 'Càng ~ càng ~', 'Mức độ tăng tỷ lệ. 食べれば食べるほど太る.', 'N3', 'JLPT', 'tỷ lệ'),
(@ja, '〜くせに', 'V/A(普通) + くせに', 'Vốn ~ mà lại ~', 'Phê phán, châm biếm. 知っているくせに教えてくれない.', 'N3', 'JLPT', 'phê phán'),
(@ja, '〜わけだ', 'V/A(普通) + わけだ', 'Hèn chi ~', 'Lý do, đương nhiên. 留学していたから上手なわけだ.', 'N3', 'JLPT', 'lý do'),
(@ja, '〜わけがない', 'V/A(普通) + わけがない', 'Không thể nào ~', 'Khẳng định mạnh sự không thể.', 'N3', 'JLPT', 'phủ định mạnh'),
(@ja, '〜たまま', 'V(ta) + まま / N + のまま', 'Vẫn cứ ~', 'Trạng thái giữ nguyên. 電気をつけたまま寝た.', 'N3', 'JLPT', 'trạng thái'),
(@ja, '〜にとって', 'N + にとって', 'Đối với ~', 'Quan điểm. 私にとって家族は大切だ.', 'N3', 'JLPT', 'quan điểm');

-- ===== JLPT N2 - Extended =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@ja, '〜っぱなし', 'V(masu語幹) + っぱなし', 'Cứ ~ mãi không thay đổi', 'Để nguyên hành động/trạng thái. 電気をつけっぱなし.', 'N2', 'JLPT', 'trạng thái'),
(@ja, '〜きり', 'V(ta) + きり', 'Sau khi ~ thì không ~ nữa', 'Hành động cuối cùng. 出かけたきり戻らない.', 'N2', 'JLPT', 'kết thúc'),
(@ja, '〜げ', 'A(語幹) + げ', 'Có vẻ ~', 'Vẻ bề ngoài cảm xúc. 寂しげな顔.', 'N2', 'JLPT', 'biểu cảm'),
(@ja, '〜ものだ', 'V/A(普通) + ものだ', 'Vốn dĩ ~ / Thường ~', 'Lẽ thường, hồi tưởng, mong muốn mạnh.', 'N2', 'JLPT', 'lẽ thường'),
(@ja, '〜まい', 'V(辞書) + まい', 'Quyết không ~', 'Quyết tâm phủ định. 二度と行くまい.', 'N2', 'JLPT', 'quyết tâm'),
(@ja, '〜ざるを得ない', 'V(ない) + ざるを得ない', 'Buộc phải ~', 'Bắt buộc dù không muốn. 認めざるを得ない.', 'N2', 'JLPT', 'bắt buộc'),
(@ja, '〜どころか', 'V/A/N + どころか', 'Đừng nói ~ thậm chí ~', 'Phủ nhận và nâng mức độ. 走るどころか歩けない.', 'N2', 'JLPT', 'so sánh'),
(@ja, '〜ものなら', 'V(可能) + ものなら', 'Nếu có thể thì ~', 'Mong ước khó thực hiện. できるものならやってみたい.', 'N2', 'JLPT', 'mong ước'),
(@ja, '〜つつ', 'V(masu語幹) + つつ', 'Vừa ~ vừa ~ (văn viết)', 'Tương đương ながら nhưng trang trọng.', 'N2', 'JLPT', 'đồng thời'),
(@ja, '〜つつある', 'V(masu語幹) + つつある', 'Đang dần ~', 'Sự thay đổi đang diễn ra. 経済が回復しつつある.', 'N2', 'JLPT', 'tiến triển'),
(@ja, '〜あげく', 'V(ta) + あげく / N + のあげく', 'Cuối cùng đã ~', 'Kết quả tiêu cực sau quá trình. 悩んだあげく断った.', 'N2', 'JLPT', 'kết quả'),
(@ja, '〜末に', 'V(ta) + 末に / N + の末に', 'Cuối cùng đã ~', 'Kết quả sau nhiều cố gắng. 努力の末に成功した.', 'N2', 'JLPT', 'kết quả'),
(@ja, '〜にしては', 'N / V(普通) + にしては', 'So với ~ thì ~', 'Đánh giá ngoài dự đoán. 子供にしては大人っぽい.', 'N2', 'JLPT', 'đánh giá'),
(@ja, '〜にしろ〜にしろ', 'N にしろ N にしろ', 'Dù là ~ hay ~', 'Liệt kê các lựa chọn. 行くにしろ行かないにしろ連絡して.', 'N2', 'JLPT', 'lựa chọn'),
(@ja, '〜ばかりに', 'V/A(普通) + ばかりに', 'Chỉ vì ~', 'Lý do tiêu cực. 知らないばかりに失敗した.', 'N2', 'JLPT', 'lý do tiêu cực'),
(@ja, '〜にすぎない', 'N / V(普通) + にすぎない', 'Chỉ là ~ thôi', 'Khiêm tốn hoặc đánh giá thấp. 言い訳にすぎない.', 'N2', 'JLPT', 'đánh giá');

-- ===== JLPT N1 - Extended =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@ja, '〜ながらに', 'N / V(masu語幹) + ながらに', 'Trong trạng thái ~', 'Văn viết trang trọng. 涙ながらに語った.', 'N1', 'JLPT', 'trạng thái'),
(@ja, '〜をおいて', 'N + をおいて', 'Ngoài ~ ra không có ai/gì khác', 'Tuyệt đối duy nhất. 彼をおいて適任者はいない.', 'N1', 'JLPT', 'duy nhất'),
(@ja, '〜なくしては', 'N + なくしては', 'Nếu không có ~ thì không thể ~', 'Điều kiện thiết yếu. 努力なくしては成功しない.', 'N1', 'JLPT', 'điều kiện'),
(@ja, '〜にあって', 'N + にあって', 'Ở trong ~', 'Trang trọng, chỉ thời điểm/hoàn cảnh. 困難な時期にあって.', 'N1', 'JLPT', 'hoàn cảnh'),
(@ja, '〜きらいがある', 'V(辞書) / N + のきらいがある', 'Có khuynh hướng ~ (xấu)', 'Khuynh hướng tiêu cực. 大げさに言うきらいがある.', 'N1', 'JLPT', 'khuynh hướng'),
(@ja, '〜まじき', 'V(辞書) + まじき + N', 'Không thể chấp nhận ~', 'Lên án mạnh. あるまじき行為.', 'N1', 'JLPT', 'lên án'),
(@ja, '〜ともなれば', 'N / V + ともなれば', 'Nếu trở thành ~ thì', 'Đến mức/giai đoạn nào đó. 大人ともなれば責任がある.', 'N1', 'JLPT', 'điều kiện'),
(@ja, '〜やいなや', 'V(辞書) + や否や', 'Vừa ~ thì ngay lập tức ~', 'Hai sự kiện liên tiếp. 着くやいなや雨が降った.', 'N1', 'JLPT', 'liên tiếp'),
(@ja, '〜が早いか', 'V(辞書) + が早いか', 'Vừa ~ là ~ ngay', 'Tương tự やいなや.', 'N1', 'JLPT', 'liên tiếp'),
(@ja, '〜にひきかえ', 'N / V + にひきかえ', 'Trái với ~', 'Tương phản mạnh. 兄にひきかえ弟は怠け者だ.', 'N1', 'JLPT', 'tương phản'),
(@ja, '〜とはいえ', 'V/A/N(普通) + とはいえ', 'Tuy ~ nhưng ~', 'Nhượng bộ trang trọng. 安いとはいえ品質はいい.', 'N1', 'JLPT', 'nhượng bộ'),
(@ja, '〜ところを', 'V/A(普通) + ところを', 'Trong lúc đang ~', 'Trang trọng. お忙しいところをありがとうございます.', 'N1', 'JLPT', 'trang trọng'),
(@ja, '〜にかたくない', 'N + にかたくない', 'Không khó để ~', 'Văn viết. 想像にかたくない.', 'N1', 'JLPT', 'dễ dàng'),
(@ja, '〜を禁じ得ない', 'N + を禁じ得ない', 'Không thể không ~', 'Cảm xúc khó kìm. 怒りを禁じ得ない.', 'N1', 'JLPT', 'cảm xúc');

-- =====================================================
-- CHINESE GRAMMAR (HSK 1 → HSK 6)
-- =====================================================

-- ===== HSK 1-2 =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@zh, 'Subject + 是 + Object', 'S + 是 + O', 'S là O', 'Câu khẳng định cơ bản với 是. 我是学生 (Tôi là học sinh).', 'HSK1', 'HSK', 'cơ bản,khẳng định'),
(@zh, 'Subject + 不 + Verb', 'S + 不 + V', 'S không V (thì hiện tại)', 'Phủ định bằng 不. 我不喝咖啡 (Tôi không uống cà phê).', 'HSK1', 'HSK', 'phủ định'),
(@zh, 'Subject + 没(有) + Verb', 'S + 没(有) + V', 'S đã không V (quá khứ)', 'Phủ định quá khứ/经验. 我没去 (Tôi đã không đi).', 'HSK1', 'HSK', 'phủ định,quá khứ'),
(@zh, '...吗?', 'Câu khẳng định + 吗?', 'Câu hỏi yes/no', 'Đặt câu hỏi đơn giản. 你是学生吗? (Bạn có phải là học sinh không?).', 'HSK1', 'HSK', 'câu hỏi'),
(@zh, '请问 + Câu hỏi', '请问 + Q', 'Xin hỏi ~', 'Lịch sự khi hỏi. 请问，洗手间在哪儿?', 'HSK1', 'HSK', 'lịch sự'),
(@zh, '太...了', '太 + Adj + 了', 'Quá ~', 'Diễn tả mức độ. 太好了! (Tuyệt quá!).', 'HSK2', 'HSK', 'mức độ'),
(@zh, '有点儿 + Adj', '有点儿 + Adj', 'Hơi ~', 'Mức độ nhẹ, thường tiêu cực. 有点儿贵 (hơi đắt).', 'HSK2', 'HSK', 'mức độ'),
(@zh, '一点儿 / 一些', 'Adj + 一点儿', '~ một chút', 'So sánh nhẹ. 便宜一点儿 (rẻ hơn một chút).', 'HSK2', 'HSK', 'so sánh'),
(@zh, '想 + V', '想 + V', 'Muốn ~', 'Diễn tả mong muốn. 我想去中国.', 'HSK2', 'HSK', 'mong muốn'),
(@zh, '要 + V', '要 + V', 'Định ~ / Phải ~', 'Sẽ làm/cần làm. 我要走了.', 'HSK2', 'HSK', 'dự định'),
(@zh, '会 + V', '会 + V', 'Biết / Sẽ ~', 'Khả năng do học hoặc dự đoán. 我会说汉语.', 'HSK2', 'HSK', 'khả năng'),
(@zh, '能 + V', '能 + V', 'Có thể ~', 'Khả năng do điều kiện. 我能游泳.', 'HSK2', 'HSK', 'khả năng'),
(@zh, '可以 + V', '可以 + V', 'Có thể / Được phép ~', 'Cho phép. 我可以进来吗?', 'HSK2', 'HSK', 'cho phép');

-- ===== HSK 3 =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@zh, '一边...一边...', '一边 + V1 + 一边 + V2', 'Vừa ~ vừa ~', 'Hai hành động đồng thời. 一边吃饭一边看电视.', 'HSK3', 'HSK', 'đồng thời'),
(@zh, '...的时候', 'V + 的时候', 'Khi ~', 'Mệnh đề thời gian. 我吃饭的时候不说话.', 'HSK3', 'HSK', 'thời gian'),
(@zh, '虽然...但是...', '虽然 A 但是 B', 'Mặc dù A nhưng B', 'Nhượng bộ. 虽然下雨, 但是我去.', 'HSK3', 'HSK', 'nhượng bộ'),
(@zh, '因为...所以...', '因为 A 所以 B', 'Vì A nên B', 'Nhân quả. 因为很累, 所以早睡了.', 'HSK3', 'HSK', 'nhân quả'),
(@zh, '不但...而且...', '不但 A 而且 B', 'Không những A mà còn B', 'Tăng cấp. 不但聪明而且努力.', 'HSK3', 'HSK', 'tăng cấp'),
(@zh, '把字句', 'S + 把 + O + V + 其他', 'Cấu trúc 把', 'Nhấn mạnh xử lý đối tượng. 我把书放在桌子上.', 'HSK3', 'HSK', 'cấu trúc đặc biệt'),
(@zh, '被字句', 'S + 被 + O + V', 'Cấu trúc bị động', 'Bị động với 被. 杯子被他打破了.', 'HSK3', 'HSK', 'bị động'),
(@zh, '比 (so sánh)', 'A + 比 + B + Adj', 'A ~ hơn B', 'So sánh. 他比我高 (Anh ấy cao hơn tôi).', 'HSK3', 'HSK', 'so sánh'),
(@zh, 'V + 过', 'V + 过', 'Đã từng ~', 'Kinh nghiệm. 我去过中国.', 'HSK3', 'HSK', 'kinh nghiệm'),
(@zh, '快(要)...了', '快(要) + V + 了', 'Sắp ~ rồi', 'Sự việc sắp xảy ra. 火车快要开了.', 'HSK3', 'HSK', 'thời gian'),
(@zh, '只要...就...', '只要 A 就 B', 'Chỉ cần A thì B', 'Điều kiện đủ. 只要努力就能成功.', 'HSK3', 'HSK', 'điều kiện'),
(@zh, '只有...才...', '只有 A 才 B', 'Chỉ có A mới B', 'Điều kiện cần. 只有努力才能成功.', 'HSK3', 'HSK', 'điều kiện');

-- ===== HSK 4-5 =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@zh, '越来越...', '越来越 + Adj/V', 'Càng ngày càng ~', 'Diễn biến tăng dần. 天气越来越冷.', 'HSK4', 'HSK', 'tăng tiến'),
(@zh, '越...越...', '越 + V1 + 越 + V2/Adj', 'Càng ~ càng ~', 'Tỷ lệ thuận. 越学越喜欢.', 'HSK4', 'HSK', 'tỷ lệ'),
(@zh, '不管...都...', '不管 A 都 B', 'Bất kể A đều B', 'Bất kể điều kiện. 不管多忙我都会去.', 'HSK4', 'HSK', 'điều kiện'),
(@zh, '即使...也...', '即使 A 也 B', 'Cho dù A cũng B', 'Giả thiết nhượng bộ. 即使下雨也要去.', 'HSK4', 'HSK', 'nhượng bộ'),
(@zh, 'V + 起来', 'V + 起来', 'Xét về mặt ~', 'Đánh giá khi làm. 听起来不错.', 'HSK4', 'HSK', 'đánh giá'),
(@zh, 'V + 下去', 'V + 下去', 'Tiếp tục ~', 'Hành động kéo dài. 坚持下去.', 'HSK4', 'HSK', 'tiếp tục'),
(@zh, '与其...不如...', '与其 A 不如 B', 'Thà B còn hơn A', 'So sánh lựa chọn. 与其等不如去找他.', 'HSK5', 'HSK', 'lựa chọn'),
(@zh, '宁可...也不...', '宁可 A 也不 B', 'Thà A chứ không B', 'Chọn cái khó hơn cái không thể chấp nhận.', 'HSK5', 'HSK', 'lựa chọn'),
(@zh, '难道...吗?', '难道 + Câu + 吗?', 'Lẽ nào ~?', 'Câu hỏi phản vấn. 难道你不知道吗?', 'HSK5', 'HSK', 'phản vấn'),
(@zh, '何况', '何况', 'Huống hồ', 'Tăng cấp. 连他都不会, 何况我.', 'HSK5', 'HSK', 'tăng cấp'),
(@zh, '不仅...还...', '不仅 A 还 B', 'Không chỉ A còn B', 'Tăng cấp. 不仅聪明还很谦虚.', 'HSK5', 'HSK', 'tăng cấp');

-- ===== HSK 6 =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@zh, '以...而著称', '以 N1 而著称', 'Nổi tiếng với N1', 'Trang trọng. 该城以美食而著称.', 'HSK6', 'HSK', 'trang trọng'),
(@zh, '...之所以...是因为...', 'A 之所以 B 是因为 C', 'Sở dĩ A B là vì C', 'Giải thích nguyên nhân.', 'HSK6', 'HSK', 'nhân quả'),
(@zh, '凡是...都...', '凡是 A 都 B', 'Phàm là A đều B', 'Khái quát. 凡是认识他的人都喜欢他.', 'HSK6', 'HSK', 'khái quát'),
(@zh, '哪怕...也...', '哪怕 A 也 B', 'Dù cho A cũng B', 'Nhượng bộ mạnh. 哪怕再难也要试.', 'HSK6', 'HSK', 'nhượng bộ'),
(@zh, '一旦...就...', '一旦 A 就 B', 'Một khi A thì B', 'Điều kiện. 一旦决定就不会改变.', 'HSK6', 'HSK', 'điều kiện');

-- =====================================================
-- ENGLISH GRAMMAR (IELTS / TOEIC / CEFR)
-- =====================================================

-- ===== Basic A1-A2 =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@en, 'Present Simple', 'S + V(s/es) + O', 'Thì hiện tại đơn', 'Diễn tả thói quen, sự thật. She works in a bank. (Cô ấy làm việc trong ngân hàng).', 'A1', 'CEFR', 'tense,basic'),
(@en, 'Present Continuous', 'S + am/is/are + V-ing', 'Thì hiện tại tiếp diễn', 'Hành động đang diễn ra. They are studying now.', 'A1', 'CEFR', 'tense,basic'),
(@en, 'Past Simple', 'S + V2/V-ed', 'Thì quá khứ đơn', 'Hành động đã xảy ra trong quá khứ. I visited Paris last year.', 'A1', 'CEFR', 'tense,basic'),
(@en, 'Future Simple (will)', 'S + will + V', 'Thì tương lai đơn', 'Quyết định ngay, dự đoán. I will help you.', 'A2', 'CEFR', 'tense,basic'),
(@en, 'Future (be going to)', 'S + am/is/are + going to + V', 'Tương lai dự định', 'Kế hoạch đã định. We are going to travel.', 'A2', 'CEFR', 'tense,basic'),
(@en, 'Modal: Can/Could', 'S + can/could + V', 'Có thể (khả năng)', 'Khả năng và xin phép. Could you help me?', 'A2', 'CEFR', 'modal'),
(@en, 'There is/are', 'There + is/are + N', 'Có (tồn tại)', 'There is a book. There are two cats.', 'A1', 'CEFR', 'existence'),
(@en, 'Comparative & Superlative', 'Adj-er than / the most Adj', 'So sánh hơn/nhất', 'taller than / the tallest.', 'A2', 'CEFR', 'comparison'),
(@en, 'Articles a/an/the', 'a/an + N (count) / the + N', 'Mạo từ', 'a book, an apple, the sun (unique).', 'A1', 'CEFR', 'article'),
(@en, 'Question words', 'Wh-word + aux + S + V', 'Từ để hỏi', 'What/Where/When/Why/How. What do you do?', 'A1', 'CEFR', 'question');

-- ===== Intermediate B1-B2 (TOEIC, IELTS 5.0-6.5) =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@en, 'Present Perfect', 'S + have/has + V3', 'Thì hiện tại hoàn thành', 'Hành động đã hoàn tất có liên quan hiện tại. I have lived here for 5 years.', 'B1', 'CEFR', 'tense'),
(@en, 'Present Perfect Continuous', 'S + have/has + been + V-ing', 'Thì hiện tại hoàn thành tiếp diễn', 'Hành động bắt đầu trong quá khứ và còn tiếp diễn. I have been working since 9am.', 'B1', 'CEFR', 'tense'),
(@en, 'Past Continuous', 'S + was/were + V-ing', 'Thì quá khứ tiếp diễn', 'Đang xảy ra trong quá khứ. While I was reading, the phone rang.', 'B1', 'CEFR', 'tense'),
(@en, 'Past Perfect', 'S + had + V3', 'Thì quá khứ hoàn thành', 'Xảy ra trước một mốc quá khứ. By the time he arrived, I had finished.', 'B1', 'CEFR', 'tense'),
(@en, 'Future Continuous', 'S + will + be + V-ing', 'Thì tương lai tiếp diễn', 'Sẽ đang xảy ra. This time tomorrow I will be flying.', 'B2', 'CEFR', 'tense'),
(@en, 'Future Perfect', 'S + will + have + V3', 'Thì tương lai hoàn thành', 'Hoàn tất trước thời điểm tương lai. By 2030, AI will have transformed industries.', 'B2', 'CEFR', 'tense,IELTS'),
(@en, 'Conditional Type 1', 'If + S + V (present), S + will + V', 'Câu điều kiện loại 1 (có thực)', 'Có khả năng xảy ra. If it rains, I will stay home.', 'B1', 'CEFR', 'conditional'),
(@en, 'Conditional Type 2', 'If + S + V2/were, S + would + V', 'Câu điều kiện loại 2 (giả định)', 'Trái với hiện tại. If I were rich, I would travel.', 'B2', 'CEFR', 'conditional'),
(@en, 'Conditional Type 3', 'If + S + had + V3, S + would have + V3', 'Câu điều kiện loại 3', 'Trái với quá khứ. If I had studied, I would have passed.', 'B2', 'CEFR', 'conditional'),
(@en, 'Mixed Conditional', 'If + S + had + V3, S + would + V', 'Điều kiện hỗn hợp', 'Quá khứ ảnh hưởng hiện tại. If I had slept early, I would feel better now.', 'C1', 'CEFR', 'conditional'),
(@en, 'Passive Voice', 'S + be + V3 + (by + agent)', 'Câu bị động', 'The book was written by him. (Cuốn sách đã được anh ấy viết).', 'B1', 'CEFR', 'voice'),
(@en, 'Reported Speech', 'S + said (that) + S + V (lùi thì)', 'Tường thuật', 'He said he was tired. (Anh ấy nói rằng anh ấy mệt).', 'B1', 'CEFR', 'reported'),
(@en, 'Relative Clauses (Defining)', 'N + who/which/that + V', 'Mệnh đề quan hệ xác định', 'The man who called is my brother.', 'B1', 'CEFR', 'relative'),
(@en, 'Relative Clauses (Non-defining)', 'N, who/which, ...', 'Mệnh đề quan hệ không xác định', 'My brother, who lives in NY, is a doctor.', 'B2', 'CEFR', 'relative'),
(@en, 'Modal: must / have to', 'S + must/have to + V', 'Phải', 'You must wear a uniform. (bắt buộc nội tại / bên ngoài).', 'B1', 'CEFR', 'modal'),
(@en, 'Modal: should / ought to', 'S + should + V', 'Nên', 'You should rest. Lời khuyên.', 'B1', 'CEFR', 'modal'),
(@en, 'Modal: might / may', 'S + might/may + V', 'Có thể (xác suất)', 'It might rain. Khả năng ~50%.', 'B2', 'CEFR', 'modal'),
(@en, 'Gerund vs Infinitive', 'V + V-ing / V + to V', 'Danh động từ vs nguyên thể', 'enjoy doing, want to do. Mỗi động từ theo sau loại khác nhau.', 'B1', 'CEFR', 'verb pattern'),
(@en, 'Used to / Be used to', 'used to + V / be used to + V-ing', 'Đã từng / Quen với', 'I used to smoke (đã từng). I am used to working late (quen với).', 'B2', 'CEFR', 'expression'),
(@en, 'Wish / If only', 'wish + S + V2/had V3', 'Ước', 'I wish I were taller. (ước hiện tại). I wish I had studied. (ước quá khứ).', 'B2', 'CEFR', 'wish'),
(@en, 'Causative (have/get sth done)', 'S + have/get + O + V3', 'Sai khiến', 'I got my car repaired. (Tôi cho người sửa xe).', 'B2', 'CEFR', 'causative'),
(@en, 'Question Tags', 'positive, neg tag? / negative, pos tag?', 'Câu hỏi đuôi', 'You like coffee, dont you?', 'B1', 'CEFR', 'question');

-- ===== Advanced C1-C2 (IELTS 7.0+) =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@en, 'Inversion (Negative)', 'Never/Rarely/Hardly + aux + S + V', 'Đảo ngữ phủ định', 'Never have I seen such beauty. (Nhấn mạnh).', 'C1', 'IELTS', 'inversion,advanced'),
(@en, 'Inversion (Conditional)', 'Had/Were/Should + S + V', 'Đảo ngữ điều kiện', 'Had I known, I would have helped. = If I had known...', 'C1', 'IELTS', 'inversion'),
(@en, 'Cleft Sentences (It-cleft)', 'It is/was + X + that/who + ...', 'Câu chẻ', 'It was John who broke the window. (Nhấn mạnh).', 'C1', 'IELTS', 'emphasis'),
(@en, 'Cleft Sentences (What-cleft)', 'What + S + V + is/was + ...', 'Câu chẻ what', 'What I need is a vacation.', 'C1', 'IELTS', 'emphasis'),
(@en, 'Subjunctive Mood', 'It is essential that S + V (base form)', 'Thức giả định', 'It is essential that he be on time. (formal).', 'C1', 'IELTS', 'subjunctive'),
(@en, 'Participle Clauses', 'V-ing/V-ed + ...', 'Mệnh đề phân từ', 'Walking down the street, I saw him. = While I was walking...', 'C1', 'IELTS', 'participle'),
(@en, 'Reduced Relative Clauses', 'N + V-ing/V-ed + ...', 'Rút gọn mệnh đề quan hệ', 'The book written by Tom is bestselling.', 'C1', 'IELTS', 'relative'),
(@en, 'Discourse Markers', 'Furthermore, Nevertheless, Nonetheless', 'Liên từ liên ý', 'Connectors for academic writing. Furthermore = moreover.', 'C1', 'IELTS', 'discourse'),
(@en, 'Hedging Language', 'It seems / It appears / arguably / tend to', 'Ngôn ngữ giảm nhẹ', 'For academic objectivity. The data appears to suggest...', 'C1', 'IELTS', 'academic'),
(@en, 'Nominalization', 'V → Noun phrase', 'Danh từ hóa', 'They decided → Their decision (formal/academic style).', 'C1', 'IELTS', 'academic'),
(@en, 'Concessive Clauses', 'Although / Even though / Despite + N/V-ing', 'Mệnh đề nhượng bộ', 'Despite the rain, we went out.', 'B2', 'IELTS', 'concession'),
(@en, 'Cause and Effect', 'due to / owing to / as a result of', 'Nhân quả', 'The flight was cancelled due to fog.', 'B2', 'IELTS', 'cause-effect'),
(@en, 'Comparison Connectors', 'whereas / while / on the other hand', 'So sánh tương phản', 'Whereas X is cheap, Y is expensive.', 'B2', 'IELTS', 'comparison');

-- ===== TOEIC-Specific (Business English) =====
INSERT INTO grammar_points (language_id, title, structure, meaning, explanation, level_code, certification, tags) VALUES
(@en, 'Business Email Phrases', 'I am writing to ... / Please find attached ...', 'Cụm email kinh doanh', 'I am writing to confirm our meeting. Please find attached the report.', 'B1', 'TOEIC', 'email,business'),
(@en, 'Polite Requests', 'Could you possibly ... / Would you mind V-ing', 'Yêu cầu lịch sự', 'Would you mind sending me the file?', 'B1', 'TOEIC', 'business,polite'),
(@en, 'Appointment Language', 'I would like to schedule / arrange / postpone', 'Lịch hẹn', 'I would like to schedule a meeting for Tuesday.', 'B1', 'TOEIC', 'meeting'),
(@en, 'Numbers & Dates', '$5,000 / Q3 / FY2025 / 15% increase', 'Số liệu trong báo cáo', 'Sales rose by 15% in Q3 FY2025.', 'B1', 'TOEIC', 'business,figures'),
(@en, 'Office Vocabulary in Context', 'memo / agenda / minutes / quarterly report', 'Từ vựng văn phòng', 'Use specific business words correctly in context.', 'B1', 'TOEIC', 'business,vocab'),
(@en, 'Contract & Legal Language', 'pursuant to / hereby / in accordance with', 'Ngôn ngữ hợp đồng', 'Pursuant to clause 5, the parties agree...', 'B2', 'TOEIC', 'legal,formal'),
(@en, 'Phrasal Verbs (Business)', 'set up / call off / put off / take over', 'Cụm động từ kinh doanh', 'They called off the merger.', 'B1', 'TOEIC', 'phrasal,business');

-- =====================================================
-- GRAMMAR EXAMPLES (gắn với grammar_points đã insert)
-- =====================================================

-- Japanese examples
INSERT INTO grammar_examples (grammar_id, sentence, translation, order_index) VALUES
((SELECT id FROM grammar_points WHERE title='〜たいです' AND language_id=@ja LIMIT 1),
 '日本へ行きたいです。', 'Tôi muốn đi Nhật.', 1),
((SELECT id FROM grammar_points WHERE title='〜なくてもいい' AND language_id=@ja LIMIT 1),
 '明日来なくてもいいです。', 'Ngày mai bạn không cần đến.', 1),
((SELECT id FROM grammar_points WHERE title='〜うちに' AND language_id=@ja LIMIT 1),
 '若いうちにいろいろなことを経験したい。', 'Tôi muốn trải nghiệm nhiều điều khi còn trẻ.', 1),
((SELECT id FROM grammar_points WHERE title='〜つつある' AND language_id=@ja LIMIT 1),
 '世界はグローバル化しつつある。', 'Thế giới đang dần toàn cầu hóa.', 1),
((SELECT id FROM grammar_points WHERE title='〜やいなや' AND language_id=@ja LIMIT 1),
 '彼は家に着くやいなや、寝てしまった。', 'Vừa về đến nhà anh ấy đã ngủ.', 1);

-- Chinese examples
INSERT INTO grammar_examples (grammar_id, sentence, translation, order_index) VALUES
((SELECT id FROM grammar_points WHERE title='把字句' AND language_id=@zh LIMIT 1),
 '请把门关上。', 'Vui lòng đóng cửa lại.', 1),
((SELECT id FROM grammar_points WHERE title='被字句' AND language_id=@zh LIMIT 1),
 '蛋糕被弟弟吃了。', 'Bánh đã bị em trai ăn rồi.', 1),
((SELECT id FROM grammar_points WHERE title='越来越...' AND language_id=@zh LIMIT 1),
 '汉语越来越有意思。', 'Tiếng Trung ngày càng thú vị.', 1),
((SELECT id FROM grammar_points WHERE title='与其...不如...' AND language_id=@zh LIMIT 1),
 '与其后悔，不如现在就行动。', 'Thà hành động ngay còn hơn hối hận sau này.', 1);

-- English examples
INSERT INTO grammar_examples (grammar_id, sentence, translation, order_index) VALUES
((SELECT id FROM grammar_points WHERE title='Present Perfect' AND language_id=@en LIMIT 1),
 'I have visited Japan three times.', 'Tôi đã thăm Nhật ba lần.', 1),
((SELECT id FROM grammar_points WHERE title='Conditional Type 2' AND language_id=@en LIMIT 1),
 'If I had more time, I would learn another language.', 'Nếu tôi có nhiều thời gian hơn, tôi sẽ học một ngoại ngữ nữa.', 1),
((SELECT id FROM grammar_points WHERE title='Inversion (Negative)' AND language_id=@en LIMIT 1),
 'Never had I seen such a magnificent view before.', 'Chưa bao giờ tôi thấy một quang cảnh hùng vĩ như vậy.', 1),
((SELECT id FROM grammar_points WHERE title='Cleft Sentences (It-cleft)' AND language_id=@en LIMIT 1),
 'It was the manager who approved the project.', 'Chính giám đốc là người đã phê duyệt dự án.', 1),
((SELECT id FROM grammar_points WHERE title='Hedging Language' AND language_id=@en LIMIT 1),
 'The evidence appears to suggest a strong correlation.', 'Bằng chứng dường như cho thấy một mối tương quan mạnh.', 1),
((SELECT id FROM grammar_points WHERE title='Business Email Phrases' AND language_id=@en LIMIT 1),
 'I am writing to confirm our meeting on Friday.', 'Tôi viết thư để xác nhận cuộc họp của chúng ta vào thứ Sáu.', 1);

-- =====================================================
-- GRAMMAR EXERCISES (multi-choice)
-- =====================================================

INSERT INTO grammar_exercises (grammar_id, `type`, prompt, options_json, answer, explanation) VALUES
((SELECT id FROM grammar_points WHERE title='〜たいです' AND language_id=@ja LIMIT 1),
 'MULTI_CHOICE',
 '私は寿司を ___ です。',
 '["食べる","食べたい","食べました","食べて"]',
 '食べたい',
 'Sử dụng V(masu) + たい để diễn tả "muốn làm gì". 食べる→食べたい.'),

((SELECT id FROM grammar_points WHERE title='〜てもいい' AND language_id=@ja LIMIT 1),
 'MULTI_CHOICE',
 'ここで写真を ___ もいいですか。',
 '["撮る","撮って","撮った","撮ろう"]',
 '撮って',
 'V(te) + もいい xin phép. 撮る→撮って.'),

((SELECT id FROM grammar_points WHERE title='〜うちに' AND language_id=@ja LIMIT 1),
 'MULTI_CHOICE',
 '雨が降らない ___ 帰りましょう。',
 '["うちに","間に","ながら","あとで"]',
 'うちに',
 '〜ないうちに = trước khi tình huống thay đổi.'),

((SELECT id FROM grammar_points WHERE title='把字句' AND language_id=@zh LIMIT 1),
 'MULTI_CHOICE',
 '请 ___ 这本书还给我。',
 '["把","被","让","给"]',
 '把',
 'Cấu trúc 把 + tân ngữ + động từ + khác. Nhấn mạnh xử lý đối tượng.'),

((SELECT id FROM grammar_points WHERE title='越来越...' AND language_id=@zh LIMIT 1),
 'MULTI_CHOICE',
 '天气 ___ 冷了。',
 '["越来越","越","更加","太"]',
 '越来越',
 '越来越 + Adj/V = ngày càng.'),

((SELECT id FROM grammar_points WHERE title='Present Perfect' AND language_id=@en LIMIT 1),
 'MULTI_CHOICE',
 'I ___ in this city for ten years.',
 '["live","lived","have lived","am living"]',
 'have lived',
 'Present Perfect + for/since: hành động kéo dài đến hiện tại.'),

((SELECT id FROM grammar_points WHERE title='Conditional Type 2' AND language_id=@en LIMIT 1),
 'MULTI_CHOICE',
 'If I ___ you, I would accept the offer.',
 '["am","was","were","be"]',
 'were',
 'Trong câu điều kiện loại 2, dùng "were" cho mọi ngôi (formal).'),

((SELECT id FROM grammar_points WHERE title='Conditional Type 3' AND language_id=@en LIMIT 1),
 'MULTI_CHOICE',
 'If she ___ harder, she would have passed the exam.',
 '["studied","had studied","would study","studies"]',
 'had studied',
 'If + had + V3, would have + V3 → trái với quá khứ.'),

((SELECT id FROM grammar_points WHERE title='Inversion (Negative)' AND language_id=@en LIMIT 1),
 'MULTI_CHOICE',
 'Rarely ___ such a beautiful sunset.',
 '["I see","I have seen","have I seen","do I see"]',
 'have I seen',
 'Đảo ngữ phủ định: Rarely + aux + S + V. Hoán vị have + I.'),

((SELECT id FROM grammar_points WHERE title='Passive Voice' AND language_id=@en LIMIT 1),
 'MULTI_CHOICE',
 'The report ___ by the team next week.',
 '["will complete","will be completed","has completed","is completing"]',
 'will be completed',
 'Bị động tương lai: will + be + V3.'),

((SELECT id FROM grammar_points WHERE title='Polite Requests' AND language_id=@en LIMIT 1),
 'MULTI_CHOICE',
 '___ you mind closing the window?',
 '["Do","Would","Could","Will"]',
 'Would',
 'Would you mind + V-ing là yêu cầu lịch sự nhất.'),

((SELECT id FROM grammar_points WHERE title='Reported Speech' AND language_id=@en LIMIT 1),
 'MULTI_CHOICE',
 'She said that she ___ tired.',
 '["is","was","has been","be"]',
 'was',
 'Tường thuật lùi thì: said → was.');
