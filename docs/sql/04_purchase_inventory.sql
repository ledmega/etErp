-- ============================================================
-- etERP 구매/재고 테이블
-- 대상 DB: eterp
-- 작성일: 2026-03-30
-- ============================================================

USE eterp;

-- ============================================================
-- 1. 거래처 (pur_vendor)
-- ============================================================
CREATE TABLE IF NOT EXISTS pur_vendor (
    vendor_id     BIGINT        NOT NULL AUTO_INCREMENT COMMENT '거래처 ID',
    vendor_code   VARCHAR(20)   NOT NULL COMMENT '거래처 코드',
    vendor_name   VARCHAR(200)  NOT NULL COMMENT '거래처명',
    vendor_type   VARCHAR(20)   NOT NULL DEFAULT 'BOTH' COMMENT '거래처 유형 (PURCHASE/SALES/BOTH)',
    biz_no        VARCHAR(20)   NULL COMMENT '사업자등록번호',
    ceo_name      VARCHAR(100)  NULL COMMENT '대표자명',
    biz_type      VARCHAR(100)  NULL COMMENT '업태',
    biz_item      VARCHAR(100)  NULL COMMENT '종목',
    phone         VARCHAR(20)   NULL COMMENT '전화번호',
    fax           VARCHAR(20)   NULL COMMENT '팩스번호',
    email         VARCHAR(200)  NULL COMMENT '이메일',
    address       VARCHAR(500)  NULL COMMENT '주소',
    manager_name  VARCHAR(100)  NULL COMMENT '담당자명',
    manager_phone VARCHAR(20)   NULL COMMENT '담당자 연락처',
    use_yn        CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (vendor_id),
    UNIQUE KEY uq_vendor_code (vendor_code),
    INDEX idx_vendor_type (vendor_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='거래처';


-- ============================================================
-- 2. 품목 (inv_item)
-- ============================================================
CREATE TABLE IF NOT EXISTS inv_item (
    item_id       BIGINT        NOT NULL AUTO_INCREMENT COMMENT '품목 ID',
    item_code     VARCHAR(20)   NOT NULL COMMENT '품목 코드',
    item_name     VARCHAR(200)  NOT NULL COMMENT '품목명',
    item_type     VARCHAR(20)   NOT NULL COMMENT '품목 유형 (PRODUCT/MATERIAL/SEMI)',
    unit          VARCHAR(20)   NOT NULL COMMENT '단위 (EA/KG/M/BOX)',
    unit_price    DECIMAL(18,2) NULL DEFAULT 0 COMMENT '기준 단가',
    safety_qty    DECIMAL(14,3) NOT NULL DEFAULT 0 COMMENT '안전재고 수량',
    description   VARCHAR(500)  NULL COMMENT '설명',
    use_yn        CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (item_id),
    UNIQUE KEY uq_item_code (item_code),
    INDEX idx_item_type (item_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='품목';


-- ============================================================
-- 3. 창고 (inv_warehouse)
-- ============================================================
CREATE TABLE IF NOT EXISTS inv_warehouse (
    warehouse_id  BIGINT        NOT NULL AUTO_INCREMENT COMMENT '창고 ID',
    warehouse_code VARCHAR(20)  NOT NULL COMMENT '창고 코드',
    warehouse_name VARCHAR(100) NOT NULL COMMENT '창고명',
    location      VARCHAR(200)  NULL COMMENT '위치',
    use_yn        CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (warehouse_id),
    UNIQUE KEY uq_warehouse_code (warehouse_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='창고';


-- ============================================================
-- 4. 재고 현황 (inv_stock)
-- ============================================================
CREATE TABLE IF NOT EXISTS inv_stock (
    stock_id      BIGINT        NOT NULL AUTO_INCREMENT COMMENT '재고 ID',
    item_id       BIGINT        NOT NULL COMMENT '품목 ID',
    warehouse_id  BIGINT        NOT NULL COMMENT '창고 ID',
    current_qty   DECIMAL(14,3) NOT NULL DEFAULT 0 COMMENT '현재고 수량',
    updated_at    DATETIME      NOT NULL DEFAULT NOW() ON UPDATE NOW() COMMENT '최종 갱신',
    PRIMARY KEY (stock_id),
    UNIQUE KEY uq_stock (item_id, warehouse_id),
    CONSTRAINT fk_stock_item      FOREIGN KEY (item_id)      REFERENCES inv_item(item_id),
    CONSTRAINT fk_stock_warehouse FOREIGN KEY (warehouse_id) REFERENCES inv_warehouse(warehouse_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='재고 현황';


-- ============================================================
-- 5. 재고 이동 이력 (inv_stock_movement)
-- ============================================================
CREATE TABLE IF NOT EXISTS inv_stock_movement (
    movement_id   BIGINT        NOT NULL AUTO_INCREMENT COMMENT '이동 ID',
    item_id       BIGINT        NOT NULL COMMENT '품목 ID',
    warehouse_id  BIGINT        NOT NULL COMMENT '창고 ID',
    move_type     VARCHAR(20)   NOT NULL COMMENT '이동 유형 (IN/OUT/TRANSFER/ADJUST)',
    qty           DECIMAL(14,3) NOT NULL COMMENT '수량 (입고:+, 출고:-)',
    unit_price    DECIMAL(18,2) NULL COMMENT '단가',
    ref_type      VARCHAR(20)   NULL COMMENT '참조 유형 (PURCHASE/SALES/MANUAL)',
    ref_id        BIGINT        NULL COMMENT '참조 ID (발주ID, 수주ID 등)',
    note          VARCHAR(500)  NULL COMMENT '비고',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    PRIMARY KEY (movement_id),
    INDEX idx_movement_item (item_id),
    INDEX idx_movement_date (created_at),
    CONSTRAINT fk_movement_item      FOREIGN KEY (item_id)      REFERENCES inv_item(item_id),
    CONSTRAINT fk_movement_warehouse FOREIGN KEY (warehouse_id) REFERENCES inv_warehouse(warehouse_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='재고 이동 이력';


-- ============================================================
-- 6. 구매 요청 (pur_request)
-- ============================================================
CREATE TABLE IF NOT EXISTS pur_request (
    request_id    BIGINT        NOT NULL AUTO_INCREMENT COMMENT '구매 요청 ID',
    request_no    VARCHAR(30)   NOT NULL COMMENT '요청번호 (PRYYYYMMDD-NNNN)',
    request_date  DATE          NOT NULL COMMENT '요청일',
    dept_id       BIGINT        NOT NULL COMMENT '요청 부서',
    need_date     DATE          NULL COMMENT '필요일',
    status        VARCHAR(20)   NOT NULL DEFAULT 'PENDING' COMMENT '상태 (PENDING/APPROVED/REJECTED/ORDERED)',
    note          VARCHAR(500)  NULL COMMENT '비고',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (request_id),
    UNIQUE KEY uq_request_no (request_no),
    CONSTRAINT fk_pur_request_dept FOREIGN KEY (dept_id) REFERENCES hr_dept(dept_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='구매 요청';


-- ============================================================
-- 7. 구매 요청 상세 (pur_request_detail)
-- ============================================================
CREATE TABLE IF NOT EXISTS pur_request_detail (
    detail_id     BIGINT        NOT NULL AUTO_INCREMENT COMMENT '상세 ID',
    request_id    BIGINT        NOT NULL COMMENT '구매요청 ID',
    item_id       BIGINT        NOT NULL COMMENT '품목 ID',
    req_qty       DECIMAL(14,3) NOT NULL COMMENT '요청 수량',
    unit_price    DECIMAL(18,2) NULL COMMENT '예상 단가',
    note          VARCHAR(500)  NULL COMMENT '비고',
    PRIMARY KEY (detail_id),
    INDEX idx_pur_req_detail (request_id),
    CONSTRAINT fk_pur_req_detail_req  FOREIGN KEY (request_id) REFERENCES pur_request(request_id),
    CONSTRAINT fk_pur_req_detail_item FOREIGN KEY (item_id)    REFERENCES inv_item(item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='구매 요청 상세';


-- ============================================================
-- 8. 발주 (pur_order)
-- ============================================================
CREATE TABLE IF NOT EXISTS pur_order (
    order_id      BIGINT        NOT NULL AUTO_INCREMENT COMMENT '발주 ID',
    order_no      VARCHAR(30)   NOT NULL COMMENT '발주번호 (POYYYYMMDD-NNNN)',
    order_date    DATE          NOT NULL COMMENT '발주일',
    vendor_id     BIGINT        NOT NULL COMMENT '거래처 ID',
    delivery_date DATE          NULL COMMENT '납기일',
    total_amount  DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '발주 총액',
    status        VARCHAR(20)   NOT NULL DEFAULT 'ORDERED' COMMENT '상태 (ORDERED/PARTIAL/COMPLETED/CANCELLED)',
    note          VARCHAR(500)  NULL COMMENT '비고',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (order_id),
    UNIQUE KEY uq_order_no (order_no),
    CONSTRAINT fk_pur_order_vendor FOREIGN KEY (vendor_id) REFERENCES pur_vendor(vendor_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='발주';


-- ============================================================
-- 9. 발주 상세 (pur_order_detail)
-- ============================================================
CREATE TABLE IF NOT EXISTS pur_order_detail (
    detail_id     BIGINT        NOT NULL AUTO_INCREMENT COMMENT '상세 ID',
    order_id      BIGINT        NOT NULL COMMENT '발주 ID',
    item_id       BIGINT        NOT NULL COMMENT '품목 ID',
    order_qty     DECIMAL(14,3) NOT NULL COMMENT '발주 수량',
    unit_price    DECIMAL(18,2) NOT NULL COMMENT '발주 단가',
    amount        DECIMAL(18,2) NOT NULL COMMENT '금액',
    received_qty  DECIMAL(14,3) NOT NULL DEFAULT 0 COMMENT '입고 완료 수량',
    PRIMARY KEY (detail_id),
    INDEX idx_pur_order_detail (order_id),
    CONSTRAINT fk_pur_order_detail_order FOREIGN KEY (order_id) REFERENCES pur_order(order_id),
    CONSTRAINT fk_pur_order_detail_item  FOREIGN KEY (item_id)  REFERENCES inv_item(item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='발주 상세';


-- ============================================================
-- 10. 입고 (pur_receive)
-- ============================================================
CREATE TABLE IF NOT EXISTS pur_receive (
    receive_id    BIGINT        NOT NULL AUTO_INCREMENT COMMENT '입고 ID',
    receive_no    VARCHAR(30)   NOT NULL COMMENT '입고번호 (GRYYYYMMDD-NNNN)',
    receive_date  DATE          NOT NULL COMMENT '입고일',
    order_id      BIGINT        NULL COMMENT '발주 ID',
    vendor_id     BIGINT        NOT NULL COMMENT '거래처 ID',
    warehouse_id  BIGINT        NOT NULL COMMENT '입고 창고 ID',
    total_amount  DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '입고 총액',
    note          VARCHAR(500)  NULL COMMENT '비고',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (receive_id),
    UNIQUE KEY uq_receive_no (receive_no),
    CONSTRAINT fk_receive_order     FOREIGN KEY (order_id)     REFERENCES pur_order(order_id),
    CONSTRAINT fk_receive_vendor    FOREIGN KEY (vendor_id)    REFERENCES pur_vendor(vendor_id),
    CONSTRAINT fk_receive_warehouse FOREIGN KEY (warehouse_id) REFERENCES inv_warehouse(warehouse_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='입고';


-- ============================================================
-- 11. 입고 상세 (pur_receive_detail)
-- ============================================================
CREATE TABLE IF NOT EXISTS pur_receive_detail (
    detail_id     BIGINT        NOT NULL AUTO_INCREMENT COMMENT '입고 상세 ID',
    receive_id    BIGINT        NOT NULL COMMENT '입고 ID',
    item_id       BIGINT        NOT NULL COMMENT '품목 ID',
    receive_qty   DECIMAL(14,3) NOT NULL COMMENT '입고 수량',
    unit_price    DECIMAL(18,2) NOT NULL COMMENT '입고 단가',
    amount        DECIMAL(18,2) NOT NULL COMMENT '금액',
    PRIMARY KEY (detail_id),
    INDEX idx_receive_detail (receive_id),
    CONSTRAINT fk_receive_detail_receive FOREIGN KEY (receive_id) REFERENCES pur_receive(receive_id),
    CONSTRAINT fk_receive_detail_item    FOREIGN KEY (item_id)    REFERENCES inv_item(item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='입고 상세';
