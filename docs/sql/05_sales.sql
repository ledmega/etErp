-- ============================================================
-- etERP 영업/판매 테이블
-- 대상 DB: eterp
-- 작성일: 2026-03-30
-- ============================================================

USE eterp;

-- ============================================================
-- 1. 견적 (sal_quote)
-- ============================================================
CREATE TABLE IF NOT EXISTS sal_quote (
    quote_id      BIGINT        NOT NULL AUTO_INCREMENT COMMENT '견적 ID',
    quote_no      VARCHAR(30)   NOT NULL COMMENT '견적번호 (QTYYYYMMDD-NNNN)',
    quote_date    DATE          NOT NULL COMMENT '견적일',
    vendor_id     BIGINT        NOT NULL COMMENT '고객 거래처 ID',
    valid_date    DATE          NULL COMMENT '견적 유효일',
    total_amount  DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '견적 총액',
    status        VARCHAR(20)   NOT NULL DEFAULT 'DRAFT' COMMENT '상태 (DRAFT/SENT/ACCEPTED/REJECTED)',
    note          VARCHAR(500)  NULL COMMENT '비고',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (quote_id),
    UNIQUE KEY uq_quote_no (quote_no),
    CONSTRAINT fk_quote_vendor FOREIGN KEY (vendor_id) REFERENCES pur_vendor(vendor_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='견적';


-- ============================================================
-- 2. 견적 상세 (sal_quote_detail)
-- ============================================================
CREATE TABLE IF NOT EXISTS sal_quote_detail (
    detail_id     BIGINT        NOT NULL AUTO_INCREMENT COMMENT '상세 ID',
    quote_id      BIGINT        NOT NULL COMMENT '견적 ID',
    item_id       BIGINT        NOT NULL COMMENT '품목 ID',
    qty           DECIMAL(14,3) NOT NULL COMMENT '수량',
    unit_price    DECIMAL(18,2) NOT NULL COMMENT '단가',
    discount_rate DECIMAL(5,2)  NOT NULL DEFAULT 0 COMMENT '할인율 (%)',
    amount        DECIMAL(18,2) NOT NULL COMMENT '금액',
    PRIMARY KEY (detail_id),
    INDEX idx_quote_detail (quote_id),
    CONSTRAINT fk_quote_detail_quote FOREIGN KEY (quote_id) REFERENCES sal_quote(quote_id),
    CONSTRAINT fk_quote_detail_item  FOREIGN KEY (item_id)  REFERENCES inv_item(item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='견적 상세';


-- ============================================================
-- 3. 수주 (sal_order)
-- ============================================================
CREATE TABLE IF NOT EXISTS sal_order (
    order_id      BIGINT        NOT NULL AUTO_INCREMENT COMMENT '수주 ID',
    order_no      VARCHAR(30)   NOT NULL COMMENT '수주번호 (SOYYYYMMDD-NNNN)',
    order_date    DATE          NOT NULL COMMENT '수주일',
    vendor_id     BIGINT        NOT NULL COMMENT '고객 거래처 ID',
    quote_id      BIGINT        NULL COMMENT '견적 ID (연결 시)',
    delivery_date DATE          NULL COMMENT '납기일',
    total_amount  DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '수주 총액',
    status        VARCHAR(20)   NOT NULL DEFAULT 'ORDERED' COMMENT '상태 (ORDERED/PARTIAL/COMPLETED/CANCELLED)',
    note          VARCHAR(500)  NULL COMMENT '비고',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (order_id),
    UNIQUE KEY uq_sal_order_no (order_no),
    INDEX idx_sal_order_date (order_date),
    CONSTRAINT fk_sal_order_vendor FOREIGN KEY (vendor_id) REFERENCES pur_vendor(vendor_id),
    CONSTRAINT fk_sal_order_quote  FOREIGN KEY (quote_id)  REFERENCES sal_quote(quote_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='수주';


-- ============================================================
-- 4. 수주 상세 (sal_order_detail)
-- ============================================================
CREATE TABLE IF NOT EXISTS sal_order_detail (
    detail_id     BIGINT        NOT NULL AUTO_INCREMENT COMMENT '상세 ID',
    order_id      BIGINT        NOT NULL COMMENT '수주 ID',
    item_id       BIGINT        NOT NULL COMMENT '품목 ID',
    order_qty     DECIMAL(14,3) NOT NULL COMMENT '수주 수량',
    unit_price    DECIMAL(18,2) NOT NULL COMMENT '단가',
    amount        DECIMAL(18,2) NOT NULL COMMENT '금액',
    delivered_qty DECIMAL(14,3) NOT NULL DEFAULT 0 COMMENT '납품 완료 수량',
    PRIMARY KEY (detail_id),
    INDEX idx_sal_order_detail (order_id),
    CONSTRAINT fk_sal_order_detail_order FOREIGN KEY (order_id) REFERENCES sal_order(order_id),
    CONSTRAINT fk_sal_order_detail_item  FOREIGN KEY (item_id)  REFERENCES inv_item(item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='수주 상세';


-- ============================================================
-- 5. 납품 (sal_delivery)
-- ============================================================
CREATE TABLE IF NOT EXISTS sal_delivery (
    delivery_id   BIGINT        NOT NULL AUTO_INCREMENT COMMENT '납품 ID',
    delivery_no   VARCHAR(30)   NOT NULL COMMENT '납품번호 (DVYYYYMMDD-NNNN)',
    delivery_date DATE          NOT NULL COMMENT '납품일',
    order_id      BIGINT        NOT NULL COMMENT '수주 ID',
    vendor_id     BIGINT        NOT NULL COMMENT '고객 거래처 ID',
    warehouse_id  BIGINT        NOT NULL COMMENT '출고 창고 ID',
    total_amount  DECIMAL(18,2) NOT NULL DEFAULT 0 COMMENT '납품 총액',
    note          VARCHAR(500)  NULL COMMENT '비고',
    created_at    DATETIME      NOT NULL DEFAULT NOW() COMMENT '생성일시',
    created_by    VARCHAR(50)   NULL COMMENT '생성자',
    updated_at    DATETIME      NULL ON UPDATE NOW() COMMENT '수정일시',
    updated_by    VARCHAR(50)   NULL COMMENT '수정자',
    deleted_yn    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    PRIMARY KEY (delivery_id),
    UNIQUE KEY uq_delivery_no (delivery_no),
    CONSTRAINT fk_delivery_order     FOREIGN KEY (order_id)     REFERENCES sal_order(order_id),
    CONSTRAINT fk_delivery_vendor    FOREIGN KEY (vendor_id)    REFERENCES pur_vendor(vendor_id),
    CONSTRAINT fk_delivery_warehouse FOREIGN KEY (warehouse_id) REFERENCES inv_warehouse(warehouse_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='납품';


-- ============================================================
-- 6. 납품 상세 (sal_delivery_detail)
-- ============================================================
CREATE TABLE IF NOT EXISTS sal_delivery_detail (
    detail_id     BIGINT        NOT NULL AUTO_INCREMENT COMMENT '상세 ID',
    delivery_id   BIGINT        NOT NULL COMMENT '납품 ID',
    item_id       BIGINT        NOT NULL COMMENT '품목 ID',
    delivery_qty  DECIMAL(14,3) NOT NULL COMMENT '납품 수량',
    unit_price    DECIMAL(18,2) NOT NULL COMMENT '단가',
    amount        DECIMAL(18,2) NOT NULL COMMENT '금액',
    PRIMARY KEY (detail_id),
    INDEX idx_delivery_detail (delivery_id),
    CONSTRAINT fk_delivery_detail_delivery FOREIGN KEY (delivery_id) REFERENCES sal_delivery(delivery_id),
    CONSTRAINT fk_delivery_detail_item     FOREIGN KEY (item_id)     REFERENCES inv_item(item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='납품 상세';
