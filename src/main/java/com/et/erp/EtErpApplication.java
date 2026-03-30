package com.et.erp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.r2dbc.config.EnableR2dbcAuditing;

/**
 * etERP 메인 애플리케이션 진입점
 *
 * ■ Spring WebFlux 기반 Reactive 애플리케이션
 * ■ 내장 서버: Netty (Tomcat 아님)
 * ■ DB 연결: R2DBC (논블로킹 MariaDB 드라이버)
 *
 * @EnableR2dbcAuditing: BaseEntity의 createdAt, updatedAt 자동 기록 활성화
 */
@SpringBootApplication
@EnableR2dbcAuditing // R2DBC 감사(Audit) 기능 활성화 - createdAt, updatedBy 등 자동 처리
public class EtErpApplication {

    public static void main(String[] args) {
        SpringApplication.run(EtErpApplication.class, args);
    }
}
