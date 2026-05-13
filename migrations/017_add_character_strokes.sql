-- 3.1 FIX: thêm cột `strokes` để lưu KanjiVG SVG path data cho từng nét.
-- Format JSON: ["M10 20 L30 40", "M50 60 L70 80", ...]
-- Cho phép Android render animation các nét chữ Kanji/Hán tự.
--
-- Tương thích ngược: cột nullable, các record cũ không có dữ liệu sẽ trả về
-- null và Android sẽ fallback sang vẽ ký tự tĩnh.

ALTER TABLE characters
    ADD COLUMN IF NOT EXISTS strokes JSON NULL COMMENT 'KanjiVG SVG path data per stroke (JSON array)';

-- Nếu MySQL version cũ không hỗ trợ IF NOT EXISTS với ADD COLUMN, dùng:
-- ALTER TABLE characters ADD COLUMN strokes JSON NULL;
