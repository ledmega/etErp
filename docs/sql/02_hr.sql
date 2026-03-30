-- ============================================================
-- etERP 인사관리 테이블
-- 대상 DB: eterp
-- 작성일: 2026-03-30
-- ============================================================

USE eterp;

-- ============================================================
-- 1. 부서 (hr_dept)
-- ============================================================
CREATE TABLE IF NOT EXISTS hr_dept (
    dept_id       BIGINT        NOT NULL AUTO_INCREMENT COMMENT '부서 ID',
    parent_id     BIGINT        NULL COMMENT '상위 부서 ID',
    dept_code     VARCHAR(20)   NOT NULL COMMENT '부서 코드',
    dept_name     VARCHAR(100)  NOT NULL COMMENT '부서명',
    manager_id    BIGINT        NULL COMMENT '부서장 직원 ID',
    sort_order    INT           NOT NULL DEFAULT 0 COMMENT '정렬순서',
    use_yn        CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (dept_id),
    UNIQUE KEY uq_dept_code (dept_code),
    CONSTRAINT fk_dept_parent FOREIGN KEY (parent_id) REFERENCES hr_dept(dept_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='부서';


-- ============================================================
-- 2. 직원 (hr_employee)
-- ============================================================
CREATE TABLE IF NOT EXISTS hr_employee (
    emp_id        BIGINT        NOT NULL AUTO_INCREMENT COMMENT '직원 ID',
    emp_no        VARCHAR(20)   NOT NULL COMMENT '사번',
    emp_name      VARCHAR(100)  NOT NULL COMMENT '직원명',
    dept_id       BIGINT        NULL COMMENT '부서 ID',
    position_code VARCHAR(20)   NULL COMMENT '직급 코드 (공통코드)',
    job_title     VARCHAR(100)  NULL COMMENT '직책',
    hire_date     DATE          NOT NULL COMMENT '입사일',
    resign_date   DATE          NULL COMMENT '퇴사일',
    emp_status    CHAR(1)       NOT NULL DEFAULT 'A' COMMENT '재직상태 (A:재직, R:퇴직)',
    email         VARCHAR(200)  NULL COMMENT '이메일',
    phone         VARCHAR(20)   NULL COMMENT '직통번호',
    mobile        VARCHAR(20)   NULL COMMENT '휴대폰',
    birth_date    DATE          NULL COMMENT '생년월일',
    gender        CHAR(1)       NULL COMMENT '성별 (M/F)',
    address       VARCHAR(500)  NULL COMMENT '주소',
    bank_code     VARCHAR(10)   NULL COMMENT '은행 코드',
    bank_account  VARCHAR(50)   NULL COMMENT '계좌번호',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (emp_id),
    UNIQUE KEY uq_emp_no (emp_no),
    INDEX idx_emp_dept (dept_id),
    INDEX idx_emp_status (emp_status),
    CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id) REFERENCES hr_dept(dept_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='직원';

-- 부서 테이블 manager_id FK (hr_employee 생성 후 추가)
ALTER TABLE hr_dept
    ADD CONSTRAINT fk_dept_manager FOREIGN KEY (manager_id) REFERENCES hr_employee(emp_id);

-- sys_user 테이블 dept_id FK (hr_dept 생성 후 추가)
ALTER TABLE sys_user
    ADD CONSTRAINT fk_user_dept FOREIGN KEY (dept_id) REFERENCES hr_dept(dept_id);


-- ============================================================
-- 3. 직원 발령 이력 (hr_emp_history)
-- ============================================================
CREATE TABLE IF NOT EXISTS hr_emp_history (
    history_id    BIGINT        NOT NULL AUTO_INCREMENT COMMENT '이력 ID',
    emp_id        BIGINT        NOT NULL COMMENT '직원 ID',
    history_type  VARCHAR(20)   NOT NULL COMMENT '이력 유형 (DEPT/POSITION/TITLE)',
    before_value  VARCHAR(200)  NULL COMMENT '변경 전 값',
    after_value   VARCHAR(200)  NULL COMMENT '변경 후 값',
    change_date   DATE          NOT NULL COMMENT '발령일',
    reason        VARCHAR(500)  NULL COMMENT '사유',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    PRIMARY KEY (history_id),
    INDEX idx_emp_history (emp_id),
    CONSTRAINT fk_emp_history_emp FOREIGN KEY (emp_id) REFERENCES hr_employee(emp_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='직원 발령 이력';


-- ============================================================
-- 4. 근태 (hr_attendance)
-- ============================================================
CREATE TABLE IF NOT EXISTS hr_attendance (
    att_id        BIGINT        NOT NULL AUTO_INCREMENT COMMENT '근태 ID',
    emp_id        BIGINT        NOT NULL COMMENT '직원 ID',
    att_date      DATE          NOT NULL COMMENT '근태일',
    check_in      DATETIME      NULL COMMENT '출근 시각',
    check_out     DATETIME      NULL COMMENT '퇴근 시각',
    att_type      VARCHAR(20)   NOT NULL DEFAULT 'NORMAL' COMMENT '근태 유형 (NORMAL/LATE/EARLY/ABSENT)',
    overtime_hours DECIMAL(4,1) NOT NULL DEFAULT 0 COMMENT '초과근무 시간',
    note          VARCHAR(500)  NULL COMMENT '비고',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (att_id),
    UNIQUE KEY uq_att_emp_date (emp_id, att_date),
    INDEX idx_att_date (att_date),
    CONSTRAINT fk_att_emp FOREIGN KEY (emp_id) REFERENCES hr_employee(emp_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='근태';


-- ============================================================
-- 5. 휴가 신청 (hr_leave)
-- ============================================================
CREATE TABLE IF NOT EXISTS hr_leave (
    leave_id      BIGINT        NOT NULL AUTO_INCREMENT COMMENT '휴가 ID',
    emp_id        BIGINT        NOT NULL COMMENT '신청자 직원 ID',
    leave_type    VARCHAR(20)   NOT NULL COMMENT '휴가 유형 (ANNUAL/HALF/SPECIAL)',
    start_date    DATE          NOT NULL COMMENT '시작일',
    end_date      DATE          NOT NULL COMMENT '종료일',
    leave_days    DECIMAL(4,1)  NOT NULL COMMENT '휴가 일수',
    reason        VARCHAR(500)  NULL COMMENT '신청 사유',
    status        VARCHAR(20)   NOT NULL DEFAULT 'PENDING' COMMENT '상태 (PENDING/APPROVED/REJECTED/CANCELLED)',
    approver_id   BIGINT        NULL COMMENT '승인자 직원 ID',
    approved_at   DATETIME      NULL COMMENT '승인/반려 일시',
    reject_reason VARCHAR(500)  NULL COMMENT '반려 사유',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (leave_id),
    INDEX idx_leave_emp (emp_id),
    INDEX idx_leave_date (start_date, end_date),
    INDEX idx_leave_status (status),
    CONSTRAINT fk_leave_emp      FOREIGN KEY (emp_id)      REFERENCES hr_employee(emp_id),
    CONSTRAINT fk_leave_approver FOREIGN KEY (approver_id) REFERENCES hr_employee(emp_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='휴가 신청';


-- ============================================================
-- 6. 연차 현황 (hr_annual_leave)
-- ============================================================
CREATE TABLE IF NOT EXISTS hr_annual_leave (
    annual_id     BIGINT        NOT NULL AUTO_INCREMENT COMMENT 'ID',
    emp_id        BIGINT        NOT NULL COMMENT '직원 ID',
    year          CHAR(4)       NOT NULL COMMENT '연도',
    total_days    DECIMAL(5,1)  NOT NULL DEFAULT 0 COMMENT '총 연차 일수',
    used_days     DECIMAL(5,1)  NOT NULL DEFAULT 0 COMMENT '사용 일수',
    remain_days   DECIMAL(5,1)  GENERATED ALWAYS AS (total_days - used_days) STORED COMMENT '잔여 일수',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    PRIMARY KEY (annual_id),
    UNIQUE KEY uq_annual_emp_year (emp_id, year),
    CONSTRAINT fk_annual_emp FOREIGN KEY (emp_id) REFERENCES hr_employee(emp_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='연차 현황';


-- ============================================================
-- 7. 급여 항목 설정 (hr_salary_item)
-- ============================================================
CREATE TABLE IF NOT EXISTS hr_salary_item (
    item_id       BIGINT        NOT NULL AUTO_INCREMENT COMMENT '급여 항목 ID',
    item_code     VARCHAR(20)   NOT NULL COMMENT '항목 코드',
    item_name     VARCHAR(100)  NOT NULL COMMENT '항목명',
    item_type     VARCHAR(10)   NOT NULL COMMENT '유형 (PAY:지급/DED:공제)',
    calc_type     VARCHAR(20)   NOT NULL DEFAULT 'FIXED' COMMENT '계산 유형 (FIXED/RATE/AUTO)',
    sort_order    INT           NOT NULL DEFAULT 0 COMMENT '정렬순서',
    use_yn        CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (item_id),
    UNIQUE KEY uq_salary_item_code (item_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='급여 항목';


-- ============================================================
-- 8. 월별 급여 (hr_payroll)
-- ============================================================
CREATE TABLE IF NOT EXISTS hr_payroll (
    payroll_id    BIGINT        NOT NULL AUTO_INCREMENT COMMENT '급여 ID',
    emp_id        BIGINT        NOT NULL COMMENT '직원 ID',
    pay_year      CHAR(4)       NOT NULL COMMENT '지급 연도',
    pay_month     CHAR(2)       NOT NULL COMMENT '지급 월',
    total_pay     DECIMAL(15,0) NOT NULL DEFAULT 0 COMMENT '총 지급액',
    total_ded     DECIMAL(15,0) NOT NULL DEFAULT 0 COMMENT '총 공제액',
    net_pay       DECIMAL(15,0) NOT NULL DEFAULT 0 COMMENT '실수령액',
    status        VARCHAR(20)   NOT NULL DEFAULT 'DRAFT' COMMENT '상태 (DRAFT/CONFIRMED/PAID)',
    paid_at       DATETIME      NULL COMMENT '지급일시',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (payroll_id),
    UNIQUE KEY uq_payroll_emp_month (emp_id, pay_year, pay_month),
    CONSTRAINT fk_payroll_emp FOREIGN KEY (emp_id) REFERENCES hr_employee(emp_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='월별 급여';


-- ============================================================
-- 9. 급여 상세 (hr_payroll_detail)
-- ============================================================
CREATE TABLE IF NOT EXISTS hr_payroll_detail (
    detail_id     BIGINT        NOT NULL AUTO_INCREMENT COMMENT '상세 ID',
    payroll_id    BIGINT        NOT NULL COMMENT '급여 ID',
    item_id       BIGINT        NOT NULL COMMENT '급여 항목 ID',
    amount        DECIMAL(15,0) NOT NULL DEFAULT 0 COMMENT '금액',
    PRIMARY KEY (detail_id),
    INDEX idx_payroll_detail (payroll_id),
    CONSTRAINT fk_payroll_detail_payroll FOREIGN KEY (payroll_id) REFERENCES hr_payroll(payroll_id),
    CONSTRAINT fk_payroll_detail_item    FOREIGN KEY (item_id)    REFERENCES hr_salary_item(item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='급여 상세';
