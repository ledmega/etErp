-- ============================================================
-- etERP 재무/회계 테이블
-- 대상 DB: eterp
-- 작성일: 2026-03-30
-- ============================================================

USE eterp;

-- ============================================================
-- 1. 계정과목 (acc_account)
-- ============================================================
CREATE TABLE IF NOT EXISTS acc_account (
    account_id    BIGINT        NOT NULL AUTO_INCREMENT COMMENT '계정과목 ID',
    parent_id     BIGINT        NULL COMMENT '상위 계정과목 ID',
    account_code  VARCHAR(20)   NOT NULL COMMENT '계정코드',
    account_name  VARCHAR(100)  NOT NULL COMMENT '계정과목명',
    account_type  VARCHAR(20)   NOT NULL COMMENT '계정 유형 (ASSET/LIABILITY/EQUITY/REVENUE/EXPENSE)',
    level_no      INT           NOT NULL DEFAULT 1 COMMENT '계층 레벨',
    use_yn        CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (account_id),
    UNIQUE KEY uq_account_code (account_code),
    INDEX idx_account_type (account_type),
    CONSTRAINT fk_account_parent FOREIGN KEY (parent_id) REFERENCES acc_account(account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='계정과목';


-- ============================================================
-- 2. 전표 헤더 (acc_voucher)
-- ============================================================
CREATE TABLE IF NOT EXISTS acc_voucher (
    voucher_id    BIGINT        NOT NULL AUTO_INCREMENT COMMENT '전표 ID',
    voucher_no    VARCHAR(30)   NOT NULL COMMENT '전표번호 (자동생성: VYYYYMMDD-NNNN)',
    voucher_date  DATE          NOT NULL COMMENT '전표일자',
    voucher_type  VARCHAR(20)   NOT NULL COMMENT '전표 유형 (GENERAL/PURCHASE/SALES/CASH)',
    description   VARCHAR(500)  NULL COMMENT '적요',
    dept_id       BIGINT        NULL COMMENT '부서 ID',
    total_debit   DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '총 차변 금액',
    total_credit  DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '총 대변 금액',
    status        VARCHAR(20)   NOT NULL DEFAULT 'DRAFT' COMMENT '상태 (DRAFT/APPROVED/CANCELLED)',
    approved_by   BIGINT        NULL COMMENT '승인자 사용자 ID',
    approved_at   DATETIME      NULL COMMENT '승인일시',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (voucher_id),
    UNIQUE KEY uq_voucher_no (voucher_no),
    INDEX idx_voucher_date (voucher_date),
    INDEX idx_voucher_type (voucher_type),
    INDEX idx_voucher_status (status),
    CONSTRAINT fk_voucher_dept FOREIGN KEY (dept_id) REFERENCES hr_dept(dept_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='전표';


-- ============================================================
-- 3. 전표 라인 (acc_voucher_line)
-- ============================================================
CREATE TABLE IF NOT EXISTS acc_voucher_line (
    line_id       BIGINT        NOT NULL AUTO_INCREMENT COMMENT '라인 ID',
    voucher_id    BIGINT        NOT NULL COMMENT '전표 ID',
    line_no       INT           NOT NULL COMMENT '라인 번호',
    account_id    BIGINT        NOT NULL COMMENT '계정과목 ID',
    debit_amount  DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '차변 금액',
    credit_amount DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '대변 금액',
    description   VARCHAR(500)  NULL COMMENT '적요',
    dept_id       BIGINT        NULL COMMENT '부서 ID (원가 배분)',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    PRIMARY KEY (line_id),
    INDEX idx_voucher_line (voucher_id),
    INDEX idx_voucher_line_account (account_id),
    CONSTRAINT fk_voucher_line_voucher FOREIGN KEY (voucher_id)  REFERENCES acc_voucher(voucher_id),
    CONSTRAINT fk_voucher_line_account FOREIGN KEY (account_id)  REFERENCES acc_account(account_id),
    CONSTRAINT fk_voucher_line_dept    FOREIGN KEY (dept_id)     REFERENCES hr_dept(dept_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='전표 라인';


-- ============================================================
-- 4. 예산 (acc_budget)
-- ============================================================
CREATE TABLE IF NOT EXISTS acc_budget (
    budget_id     BIGINT        NOT NULL AUTO_INCREMENT COMMENT '예산 ID',
    budget_year   CHAR(4)       NOT NULL COMMENT '예산 연도',
    dept_id       BIGINT        NOT NULL COMMENT '부서 ID',
    account_id    BIGINT        NOT NULL COMMENT '계정과목 ID',
    budget_amount DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '예산 금액',
    status        VARCHAR(20)   NOT NULL DEFAULT 'DRAFT' COMMENT '상태 (DRAFT/CONFIRMED)',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (budget_id),
    UNIQUE KEY uq_budget (budget_year, dept_id, account_id),
    CONSTRAINT fk_budget_dept    FOREIGN KEY (dept_id)    REFERENCES hr_dept(dept_id),
    CONSTRAINT fk_budget_account FOREIGN KEY (account_id) REFERENCES acc_account(account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='예산';
