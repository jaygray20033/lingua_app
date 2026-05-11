Write-Host "Seeding Japanese vocabulary..." -ForegroundColor Green
Get-Content migrations/003_seed_vocab_japanese.sql | docker exec -i lingua_mysql mysql -u root -plinguaroot123 --default-character-set=utf8mb4 lingua_db

Write-Host "Seeding Chinese vocabulary..." -ForegroundColor Green
Get-Content migrations/004_seed_vocab_chinese.sql | docker exec -i lingua_mysql mysql -u root -plinguaroot123 --default-character-set=utf8mb4 lingua_db

Write-Host "Seeding English vocabulary..." -ForegroundColor Green
Get-Content migrations/005_seed_vocab_english.sql | docker exec -i lingua_mysql mysql -u root -plinguaroot123 --default-character-set=utf8mb4 lingua_db

Write-Host "Seeding Korean vocabulary..." -ForegroundColor Green
Get-Content migrations/006_seed_vocab_korean.sql | docker exec -i lingua_mysql mysql -u root -plinguaroot123 --default-character-set=utf8mb4 lingua_db

Write-Host "Seeding grammar..." -ForegroundColor Green
Get-Content migrations/007_seed_grammar.sql | docker exec -i lingua_mysql mysql -u root -plinguaroot123 --default-character-set=utf8mb4 lingua_db

Write-Host "Seeding mock tests..." -ForegroundColor Green
Get-Content migrations/008_seed_mock_tests.sql | docker exec -i lingua_mysql mysql -u root -plinguaroot123 --default-character-set=utf8mb4 lingua_db

Write-Host "Seeding courses and lessons..." -ForegroundColor Green
Get-Content migrations/009_seed_courses_lessons.sql | docker exec -i lingua_mysql mysql -u root -plinguaroot123 --default-character-set=utf8mb4 lingua_db

Write-Host "Done! Checking counts..." -ForegroundColor Cyan
docker exec lingua_mysql mysql -u root -plinguaroot123 lingua_db -e "SELECT COUNT(*) as courses FROM courses; SELECT COUNT(*) as words FROM words;"
