package com.et.erp.common.config;

import io.r2dbc.spi.ConnectionFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.domain.ReactiveAuditorAware;
import org.springframework.data.r2dbc.config.EnableR2dbcAuditing;
import org.springframework.r2dbc.connection.R2dbcTransactionManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.transaction.ReactiveTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import reactor.core.publisher.Mono;

/**
 * R2DBC (Reactive DB 연결) 설정 클래스
 *
 * ■ ReactiveAuditorAware: 현재 로그인한 사용자 ID를 가져와
 *   BaseEntity의 createdBy, updatedBy 에 자동으로 기록합니다.
 *
 * ■ R2dbcTransactionManager: 리액티브 트랜잭션 관리자
 *   @Transactional 어노테이션이 Reactive에서도 동작하도록 합니다.
 */
@Configuration
@EnableTransactionManagement // @Transactional 활성화 (Reactive 트랜잭션 지원)
public class R2dbcConfig {

    /**
     * ReactiveAuditorAware - 현재 로그인 사용자 ID 제공
     *
     * BaseEntity의 @CreatedBy, @LastModifiedBy 필드에
     * 현재 로그인한 사용자의 loginId를 자동으로 채워줍니다.
     *
     * ■ 처리 흐름:
     * 1. ReactiveSecurityContextHolder에서 현재 보안 컨텍스트 조회
     * 2. Authentication에서 로그인 사용자 이름(loginId) 추출
     * 3. 미인증 상태(비로그인)면 "system" 반환
     *
     * @return Mono<String> 현재 로그인 사용자의 loginId
     */
    @Bean
    public ReactiveAuditorAware<String> auditorAware() {
        return () -> ReactiveSecurityContextHolder
            .getContext()                                          // 현재 보안 컨텍스트 조회
            .map(SecurityContext::getAuthentication)               // Authentication 추출
            .filter(Authentication::isAuthenticated)              // 인증된 경우만
            .map(Authentication::getName)                         // 사용자 이름(loginId) 추출
            .defaultIfEmpty("system");                            // 미인증(비로그인)이면 "system"
    }

    /**
     * Reactive 트랜잭션 관리자
     *
     * R2DBC는 JDBC 기반 트랜잭션 관리자(JpaTransactionManager)와 다릅니다.
     * @Transactional이 WebFlux 환경에서도 동작하려면 이 Bean이 필요합니다.
     *
     * @param connectionFactory R2DBC 커넥션 팩토리 (자동 주입)
     * @return Reactive 트랜잭션 관리자
     */
    @Bean
    public ReactiveTransactionManager transactionManager(ConnectionFactory connectionFactory) {
        // R2dbcTransactionManager: R2DBC용 트랜잭션 관리자
        return new R2dbcTransactionManager(connectionFactory);
    }
}
