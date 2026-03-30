-- ============================================================
-- etERP 시스템 관리 테이블
-- 대상 DB: eterp
-- 작성일: 2026-03-30
-- ============================================================

USE eterp;

-- ============================================================
-- 1. 공통코드 (sys_common_code)
-- ============================================================
CREATE TABLE IF NOT EXISTS sys_common_code (
    code_group    VARCHAR(50)   NOT NULL COMMENT '코드 그룹',
    code_value    VARCHAR(50)   NOT NULL COMMENT '코드 값',
    code_name     VARCHAR(100)  NOT NULL COMMENT '코드 명칭',
    sort_order    INT           NOT NULL DEFAULT 0 COMMENT '정렬순서',
    use_yn        CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부 (Y/N)',
    description   VARCHAR(500)  NULL COMMENT '설명',
    PRIMARY KEY (code_group, code_value)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='공통코드';


-- ============================================================
-- 2. 메뉴 (sys_menu)
-- ============================================================
CREATE TABLE IF NOT EXISTS sys_menu (
    menu_id       BIGINT        NOT NULL AUTO_INCREMENT COMMENT '메뉴 ID',
    parent_id     BIGINT        NULL COMMENT '상위 메뉴 ID',
    menu_name     VARCHAR(100)  NOT NULL COMMENT '메뉴명',
    menu_url      VARCHAR(200)  NULL COMMENT '메뉴 URL',
    icon_class    VARCHAR(100)  NULL COMMENT '아이콘 CSS 클래스',
    sort_order    INT           NOT NULL DEFAULT 0 COMMENT '정렬순서',
    use_yn        CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (menu_id),
    CONSTRAINT fk_menu_parent FOREIGN KEY (parent_id) REFERENCES sys_menu(menu_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='메뉴';


-- ============================================================
-- 3. 역할 (sys_role)
-- ============================================================
CREATE TABLE IF NOT EXISTS sys_role (
    role_id       BIGINT        NOT NULL AUTO_INCREMENT COMMENT '역할 ID',
    role_code     VARCHAR(50)   NOT NULL COMMENT '역할 코드 (예: ROLE_ADMIN)',
    role_name     VARCHAR(100)  NOT NULL COMMENT '역할명',
    description   VARCHAR(500)  NULL COMMENT '설명',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (role_id),
    UNIQUE KEY uq_role_code (role_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='역할';


-- ============================================================
-- 4. 사용자 (sys_user)
-- ============================================================
CREATE TABLE IF NOT EXISTS sys_user (
    user_id       BIGINT        NOT NULL AUTO_INCREMENT COMMENT '사용자 ID',
    login_id      VARCHAR(50)   NOT NULL COMMENT '로그인 아이디',
    password      VARCHAR(255)  NOT NULL COMMENT '비밀번호 (BCrypt)',
    user_name     VARCHAR(100)  NOT NULL COMMENT '사용자 이름',
    email         VARCHAR(200)  NULL COMMENT '이메일',
    phone         VARCHAR(20)   NULL COMMENT '전화번호',
    dept_id       BIGINT        NULL COMMENT '부서 ID',
    use_yn        CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    pwd_changed_at DATETIME     NULL COMMENT '비밀번호 변경일시',
    last_login_at DATETIME      NULL COMMENT '최종 로그인 일시',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (user_id),
    UNIQUE KEY uq_login_id (login_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='시스템 사용자';


-- ============================================================
-- 5. 사용자-역할 매핑 (sys_user_role)
-- ============================================================
CREATE TABLE IF NOT EXISTS sys_user_role (
    user_role_id  BIGINT        NOT NULL AUTO_INCREMENT COMMENT 'ID',
    user_id       BIGINT        NOT NULL COMMENT '사용자 ID',
    role_id       BIGINT        NOT NULL COMMENT '역할 ID',
    PRIMARY KEY (user_role_id),
    UNIQUE KEY uq_user_role (user_id, role_id),
    CONSTRAINT fk_user_role_user FOREIGN KEY (user_id) REFERENCES sys_user(user_id),
    CONSTRAINT fk_user_role_role FOREIGN KEY (role_id) REFERENCES sys_role(role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='사용자-역할 매핑';


-- ============================================================
-- 6. 역할-메뉴 권한 매핑 (sys_role_menu)
-- ============================================================
CREATE TABLE IF NOT EXISTS sys_role_menu (
    role_menu_id  BIGINT        NOT NULL AUTO_INCREMENT COMMENT 'ID',
    role_id       BIGINT        NOT NULL COMMENT '역할 ID',
    menu_id       BIGINT        NOT NULL COMMENT '메뉴 ID',
    PRIMARY KEY (role_menu_id),
    UNIQUE KEY uq_role_menu (role_id, menu_id),
    CONSTRAINT fk_role_menu_role FOREIGN KEY (role_id) REFERENCES sys_role(role_id),
    CONSTRAINT fk_role_menu_menu FOREIGN KEY (menu_id) REFERENCES sys_menu(menu_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='역할-메뉴 권한';


-- ============================================================
-- 7. 감사 로그 (sys_audit_log)
-- ============================================================
CREATE TABLE IF NOT EXISTS sys_audit_log (
    log_id        BIGINT        NOT NULL AUTO_INCREMENT COMMENT '로그 ID',
    table_name    VARCHAR(100)  NOT NULL COMMENT '변경 테이블명',
    record_id     BIGINT        NULL COMMENT '변경 레코드 PK',
    action        VARCHAR(10)   NOT NULL COMMENT '작업 유형 (INSERT/UPDATE/DELETE)',
    changed_data  JSON          NULL COMMENT '변경 데이터 (전/후)',
    user_id       BIGINT        NULL COMMENT '작업자 사용자 ID',
    user_ip       VARCHAR(45)   NULL COMMENT '작업자 IP',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    PRIMARY KEY (log_id),
    INDEX idx_audit_table (table_name),
    INDEX idx_audit_record (table_name, record_id),
    INDEX idx_audit_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='감사 로그';


-- ============================================================
-- 8. 접속 로그 (sys_login_log)
-- ============================================================
CREATE TABLE IF NOT EXISTS sys_login_log (
    log_id        BIGINT        NOT NULL AUTO_INCREMENT COMMENT '로그 ID',
    login_id      VARCHAR(50)   NOT NULL COMMENT '로그인 ID',
    user_id       BIGINT        NULL COMMENT '사용자 ID',
    action        VARCHAR(20)   NOT NULL COMMENT 'LOGIN / LOGOUT / FAIL',
    user_ip       VARCHAR(45)   NULL COMMENT '접속 IP',
    user_agent    VARCHAR(500)  NULL COMMENT '브라우저 정보',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '일시',
    PRIMARY KEY (log_id),
    INDEX idx_login_log_user (login_id),
    INDEX idx_login_log_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='접속 로그';
