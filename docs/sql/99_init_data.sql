-- ============================================================
-- etERP 초기 기초 데이터
-- 대상 DB: eterp
-- 작성일: 2026-03-30
-- ※ 테이블 생성(01~05) 완료 후 실행하세요.
-- ============================================================

USE eterp;

-- ============================================================
-- 1. 공통코드 초기 데이터
-- ============================================================

-- 직급 코드
INSERT INTO sys_common_code (code_group, code_value, code_name, sort_order) VALUES
('POSITION', 'P01', '사원',   10),
('POSITION', 'P02', '주임',   20),
('POSITION', 'P03', '대리',   30),
('POSITION', 'P04', '과장',   40),
('POSITION', 'P05', '차장',   50),
('POSITION', 'P06', '부장',   60),
('POSITION', 'P07', '이사',   70),
('POSITION', 'P08', '상무',   80),
('POSITION', 'P09', '전무',   90),
('POSITION', 'P10', '대표이사', 100);

-- 근태 유형
INSERT INTO sys_common_code (code_group, code_value, code_name, sort_order) VALUES
('ATT_TYPE', 'NORMAL', '정상',    10),
('ATT_TYPE', 'LATE',   '지각',    20),
('ATT_TYPE', 'EARLY',  '조퇴',    30),
('ATT_TYPE', 'ABSENT', '결근',    40),
('ATT_TYPE', 'LEAVE',  '휴가',    50),
('ATT_TYPE', 'BUSI',   '출장',    60);

-- 휴가 유형
INSERT INTO sys_common_code (code_group, code_value, code_name, sort_order) VALUES
('LEAVE_TYPE', 'ANNUAL',  '연차',   10),
('LEAVE_TYPE', 'HALF_AM', '오전반차', 20),
('LEAVE_TYPE', 'HALF_PM', '오후반차', 30),
('LEAVE_TYPE', 'SPECIAL', '특별휴가', 40),
('LEAVE_TYPE', 'SICK',    '병가',   50);

-- 품목 유형
INSERT INTO sys_common_code (code_group, code_value, code_name, sort_order) VALUES
('ITEM_TYPE', 'PRODUCT',  '제품',   10),
('ITEM_TYPE', 'MATERIAL', '원자재', 20),
('ITEM_TYPE', 'SEMI',     '반제품', 30),
('ITEM_TYPE', 'SUPPLY',   '소모품', 40);

-- 단위 코드
INSERT INTO sys_common_code (code_group, code_value, code_name, sort_order) VALUES
('UNIT', 'EA',  'EA(개)',  10),
('UNIT', 'BOX', 'BOX(박스)', 20),
('UNIT', 'KG',  'KG(킬로그램)', 30),
('UNIT', 'G',   'G(그램)',  40),
('UNIT', 'M',   'M(미터)',  50),
('UNIT', 'L',   'L(리터)',  60),
('UNIT', 'SET', 'SET(세트)', 70);

-- 은행 코드
INSERT INTO sys_common_code (code_group, code_value, code_name, sort_order) VALUES
('BANK', '004', 'KB국민은행',  10),
('BANK', '020', '우리은행',    20),
('BANK', '088', '신한은행',    30),
('BANK', '081', 'KEB하나은행', 40),
('BANK', '003', 'IBK기업은행', 50),
('BANK', '011', 'NH농협은행',  60),
('BANK', '023', 'SC제일은행',  70),
('BANK', '027', '씨티은행',    80),
('BANK', '090', '카카오뱅크',  90),
('BANK', '089', '케이뱅크',    100);

-- 계정과목 유형
INSERT INTO sys_common_code (code_group, code_value, code_name, sort_order) VALUES
('ACC_TYPE', 'ASSET',     '자산',     10),
('ACC_TYPE', 'LIABILITY', '부채',     20),
('ACC_TYPE', 'EQUITY',    '자본',     30),
('ACC_TYPE', 'REVENUE',   '수익',     40),
('ACC_TYPE', 'EXPENSE',   '비용',     50);


-- ============================================================
-- 2. 역할 초기 데이터
-- ============================================================
INSERT INTO sys_role (role_code, role_name, description) VALUES
('ROLE_ADMIN',      '시스템 관리자', '전체 메뉴 접근 가능'),
('ROLE_HR',         '인사 담당자',   '인사/근태/급여 모듈 접근'),
('ROLE_ACCOUNTING', '재무 담당자',   '회계/예산 모듈 접근'),
('ROLE_PURCHASE',   '구매 담당자',   '구매/재고 모듈 접근'),
('ROLE_SALES',      '영업 담당자',   '영업 모듈 접근'),
('ROLE_USER',       '일반 사용자',   '개인 근태/휴가만 접근');


-- ============================================================
-- 3. 메뉴 초기 데이터
-- ============================================================

-- 1Depth 메뉴
INSERT INTO sys_menu (menu_id, parent_id, menu_name, menu_url, icon_class, sort_order) VALUES
(1,  NULL, '대시보드',   '/dashboard',   'bi bi-speedometer2', 10),
(2,  NULL, '시스템관리', NULL,           'bi bi-gear',         20),
(3,  NULL, '인사관리',   NULL,           'bi bi-people',       30),
(4,  NULL, '재무/회계',  NULL,           'bi bi-calculator',   40),
(5,  NULL, '구매관리',   NULL,           'bi bi-cart',         50),
(6,  NULL, '영업관리',   NULL,           'bi bi-graph-up',     60),
(7,  NULL, '재고관리',   NULL,           'bi bi-box-seam',     70);

-- 2Depth 메뉴 - 시스템관리
INSERT INTO sys_menu (parent_id, menu_name, menu_url, icon_class, sort_order) VALUES
(2, '사용자 관리',   '/system/users',        'bi bi-person',          10),
(2, '역할/권한 관리', '/system/roles',       'bi bi-shield-check',    20),
(2, '메뉴 관리',     '/system/menus',        'bi bi-list',            30),
(2, '공통코드 관리', '/system/common-codes', 'bi bi-tags',            40),
(2, '접속 로그',     '/system/login-logs',   'bi bi-clock-history',   50);

-- 2Depth 메뉴 - 인사관리
INSERT INTO sys_menu (parent_id, menu_name, menu_url, icon_class, sort_order) VALUES
(3, '직원 관리',   '/hr/employees',   'bi bi-person-badge',  10),
(3, '부서 관리',   '/hr/departments', 'bi bi-diagram-3',     20),
(3, '근태 관리',   '/hr/attendance',  'bi bi-calendar-check', 30),
(3, '휴가 관리',   '/hr/leaves',      'bi bi-calendar-heart', 40),
(3, '급여 관리',   '/hr/payroll',     'bi bi-cash-coin',     50);

-- 2Depth 메뉴 - 재무/회계
INSERT INTO sys_menu (parent_id, menu_name, menu_url, icon_class, sort_order) VALUES
(4, '계정과목 관리', '/accounting/accounts',  'bi bi-card-list',    10),
(4, '전표 관리',     '/accounting/vouchers',  'bi bi-receipt',      20),
(4, '예산 관리',     '/accounting/budgets',   'bi bi-piggy-bank',   30),
(4, '재무 보고서',   '/accounting/reports',   'bi bi-file-earmark-bar-graph', 40);

-- 2Depth 메뉴 - 구매관리
INSERT INTO sys_menu (parent_id, menu_name, menu_url, icon_class, sort_order) VALUES
(5, '거래처 관리', '/purchase/vendors',  'bi bi-building',       10),
(5, '구매 요청',   '/purchase/requests', 'bi bi-file-earmark-plus', 20),
(5, '발주 관리',   '/purchase/orders',   'bi bi-file-earmark-text', 30),
(5, '입고 처리',   '/purchase/receives', 'bi bi-box-arrow-in-down', 40);

-- 2Depth 메뉴 - 영업관리
INSERT INTO sys_menu (parent_id, menu_name, menu_url, icon_class, sort_order) VALUES
(6, '견적 관리',   '/sales/quotes',     'bi bi-file-earmark-ruled', 10),
(6, '수주 관리',   '/sales/orders',     'bi bi-file-earmark-check', 20),
(6, '납품 관리',   '/sales/deliveries', 'bi bi-box-arrow-up',       30);

-- 2Depth 메뉴 - 재고관리
INSERT INTO sys_menu (parent_id, menu_name, menu_url, icon_class, sort_order) VALUES
(7, '품목 관리',   '/inventory/items',       'bi bi-upc-scan',    10),
(7, '창고 관리',   '/inventory/warehouses',  'bi bi-house',       20),
(7, '재고 현황',   '/inventory/stocks',      'bi bi-stack',       30),
(7, '입출고 이력', '/inventory/movements',   'bi bi-arrow-left-right', 40);


-- ============================================================
-- 4. 부서 초기 데이터
-- ============================================================
INSERT INTO hr_dept (dept_id, parent_id, dept_code, dept_name, sort_order) VALUES
(1, NULL, 'D000', '(주)etCompany',  0),
(2, 1,    'D100', '경영지원본부',   10),
(3, 2,    'D110', '인사팀',         10),
(4, 2,    'D120', '재무팀',         20),
(5, 2,    'D130', '총무팀',         30),
(6, 1,    'D200', '영업본부',       20),
(7, 6,    'D210', '영업1팀',        10),
(8, 6,    'D220', '영업2팀',        20),
(9, 1,    'D300', '개발본부',       30),
(10, 9,   'D310', 'IT팀',           10);


-- ============================================================
-- 5. 관리자 계정 초기 데이터
-- ============================================================
-- 비밀번호: Admin1234! (BCrypt 해시값 - 실제 배포 전 변경 필요!)
INSERT INTO sys_user (login_id, password, user_name, email, dept_id) VALUES
('admin', '$2a$12$L9sjRqOvVHmtHXGbIjgXIOZY3maBr/KVcQnWxvBMPrDqHxhXiKaWC', '시스템관리자', 'admin@company.com', 10);

-- 관리자에게 ROLE_ADMIN 부여
INSERT INTO sys_user_role (user_id, role_id)
SELECT u.user_id, r.role_id
FROM sys_user u, sys_role r
WHERE u.login_id = 'admin' AND r.role_code = 'ROLE_ADMIN';

-- ROLE_ADMIN 에게 전체 메뉴 권한 부여
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT r.role_id, m.menu_id
FROM sys_role r, sys_menu m
WHERE r.role_code = 'ROLE_ADMIN' AND m.deleted_yn = 'N';


-- ============================================================
-- 6. 계정과목 기초 데이터 (간략)
-- ============================================================

-- 자산
INSERT INTO acc_account (account_code, account_name, account_type, level_no) VALUES
('1000', '자산',     'ASSET', 1),
('1100', '유동자산', 'ASSET', 2),
('1110', '현금및현금성자산', 'ASSET', 3),
('1120', '매출채권', 'ASSET', 3),
('1130', '재고자산', 'ASSET', 3),
('1200', '비유동자산', 'ASSET', 2),
('1210', '유형자산', 'ASSET', 3),
('1220', '무형자산', 'ASSET', 3);

-- 부채
INSERT INTO acc_account (account_code, account_name, account_type, level_no) VALUES
('2000', '부채',     'LIABILITY', 1),
('2100', '유동부채', 'LIABILITY', 2),
('2110', '매입채무', 'LIABILITY', 3),
('2120', '단기차입금', 'LIABILITY', 3),
('2200', '비유동부채', 'LIABILITY', 2),
('2210', '장기차입금', 'LIABILITY', 3);

-- 자본
INSERT INTO acc_account (account_code, account_name, account_type, level_no) VALUES
('3000', '자본',    'EQUITY', 1),
('3100', '자본금',  'EQUITY', 2),
('3200', '이익잉여금', 'EQUITY', 2);

-- 수익
INSERT INTO acc_account (account_code, account_name, account_type, level_no) VALUES
('4000', '수익',     'REVENUE', 1),
('4100', '매출액',   'REVENUE', 2),
('4110', '제품매출', 'REVENUE', 3),
('4120', '상품매출', 'REVENUE', 3);

-- 비용
INSERT INTO acc_account (account_code, account_name, account_type, level_no) VALUES
('5000', '비용',     'EXPENSE', 1),
('5100', '매출원가', 'EXPENSE', 2),
('5200', '판매비와관리비', 'EXPENSE', 2),
('5210', '급여',     'EXPENSE', 3),
('5220', '복리후생비', 'EXPENSE', 3),
('5230', '여비교통비', 'EXPENSE', 3),
('5240', '통신비',   'EXPENSE', 3),
('5250', '소모품비', 'EXPENSE', 3),
('5260', '감가상각비', 'EXPENSE', 3);

-- 계정과목 parent_id 업데이트 (레벨별)
UPDATE acc_account SET parent_id = (SELECT account_id FROM (SELECT account_id FROM acc_account WHERE account_code = '1000') t) WHERE account_code IN ('1100','1200');
UPDATE acc_account SET parent_id = (SELECT account_id FROM (SELECT account_id FROM acc_account WHERE account_code = '1100') t) WHERE account_code IN ('1110','1120','1130');
UPDATE acc_account SET parent_id = (SELECT account_id FROM (SELECT account_id FROM acc_account WHERE account_code = '1200') t) WHERE account_code IN ('1210','1220');
UPDATE acc_account SET parent_id = (SELECT account_id FROM (SELECT account_id FROM acc_account WHERE account_code = '2000') t) WHERE account_code IN ('2100','2200');
UPDATE acc_account SET parent_id = (SELECT account_id FROM (SELECT account_id FROM acc_account WHERE account_code = '2100') t) WHERE account_code IN ('2110','2120');
UPDATE acc_account SET parent_id = (SELECT account_id FROM (SELECT account_id FROM acc_account WHERE account_code = '2200') t) WHERE account_code IN ('2210');
UPDATE acc_account SET parent_id = (SELECT account_id FROM (SELECT account_id FROM acc_account WHERE account_code = '3000') t) WHERE account_code IN ('3100','3200');
UPDATE acc_account SET parent_id = (SELECT account_id FROM (SELECT account_id FROM acc_account WHERE account_code = '4000') t) WHERE account_code IN ('4100');
UPDATE acc_account SET parent_id = (SELECT account_id FROM (SELECT account_id FROM acc_account WHERE account_code = '4100') t) WHERE account_code IN ('4110','4120');
UPDATE acc_account SET parent_id = (SELECT account_id FROM (SELECT account_id FROM acc_account WHERE account_code = '5000') t) WHERE account_code IN ('5100','5200');
UPDATE acc_account SET parent_id = (SELECT account_id FROM (SELECT account_id FROM acc_account WHERE account_code = '5200') t) WHERE account_code IN ('5210','5220','5230','5240','5250','5260');


-- ============================================================
-- 7. 창고 기초 데이터
-- ============================================================
INSERT INTO inv_warehouse (warehouse_code, warehouse_name, location) VALUES
('WH001', '본사창고',   '본사 1층'),
('WH002', '외부창고',   '외부 임대창고'),
('WH999', '불량창고',   '불량/반품 보관');


-- ============================================================
-- 최종 확인
-- ============================================================
SELECT '공통코드' AS tbl, COUNT(*) AS cnt FROM sys_common_code
UNION ALL SELECT '메뉴',        COUNT(*) FROM sys_menu
UNION ALL SELECT '역할',        COUNT(*) FROM sys_role
UNION ALL SELECT '사용자',      COUNT(*) FROM sys_user
UNION ALL SELECT '부서',        COUNT(*) FROM hr_dept
UNION ALL SELECT '계정과목',    COUNT(*) FROM acc_account
UNION ALL SELECT '창고',        COUNT(*) FROM inv_warehouse;
