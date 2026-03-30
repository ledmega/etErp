-- ============================================================
-- etERP 데이터베이스 초기화 스크립트
-- DB: MariaDB
-- Host: 218.237.70.67:33306
-- 작성일: 2026-03-30
-- ============================================================
-- ※ root 계정으로 실행하세요.
-- ============================================================

-- 1. 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS eterp
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- 2. 계정 생성 (모든 외부 접속 허용)
CREATE USER IF NOT EXISTS 'eterp'@'%' IDENTIFIED BY 'diablo4213@#$';

-- 3. 권한 부여
GRANT ALL PRIVILEGES ON eterp.* TO 'eterp'@'%';

-- 4. 권한 적용
FLUSH PRIVILEGES;

-- 5. 확인
SHOW DATABASES;
SELECT user, host FROM mysql.user WHERE user = 'eterp';
