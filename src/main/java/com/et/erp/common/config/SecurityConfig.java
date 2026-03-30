package com.et.erp.common.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.method.configuration.EnableReactiveMethodSecurity;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.server.SecurityWebFilterChain;

/**
 * Spring Security Reactive 설정
 *
 * ■ WebFlux 환경에서는 @EnableWebFluxSecurity 를 사용합니다.
 *   (MVC의 @EnableWebSecurity 와 다름)
 *
 * ■ ServerHttpSecurity: WebFlux용 보안 설정 빌더
 *   (MVC의 HttpSecurity 와 대응)
 *
 * ■ @EnableReactiveMethodSecurity: 메서드 레벨 보안 활성화
 *   (@PreAuthorize, @PostAuthorize 사용 가능)
 */
@Configuration
@EnableWebFluxSecurity              // WebFlux 보안 활성화
@EnableReactiveMethodSecurity       // @PreAuthorize 등 메서드 레벨 보안 활성화
public class SecurityConfig {

    /**
     * 보안 필터 체인 설정
     *
     * 각 URL 패턴에 대한 접근 권한을 설정합니다.
     * JWT 인증 필터는 추후 auth 모듈 개발 시 추가합니다.
     *
     * @param http ServerHttpSecurity (WebFlux용)
     * @return SecurityWebFilterChain
     */
    @Bean
    public SecurityWebFilterChain securityWebFilterChain(ServerHttpSecurity http) {
        return http
            // CSRF 비활성화 (REST API + JWT 방식이므로 불필요)
            .csrf(ServerHttpSecurity.CsrfSpec::disable)

            // CORS 설정 (개발 환경 - 추후 운영에서 제한 필요)
            .cors(ServerHttpSecurity.CorsSpec::disable)

            // URL별 접근 권한 설정
            .authorizeExchange(exchanges -> exchanges

                // =============================================
                // 인증 없이 접근 가능한 URL
                // =============================================
                .pathMatchers("/api/v1/auth/**").permitAll()       // 로그인, 토큰 갱신
                .pathMatchers("/login", "/error").permitAll()       // 로그인 페이지, 에러 페이지
                .pathMatchers("/css/**", "/js/**", "/images/**", "/favicon.ico").permitAll() // 정적 파일
                .pathMatchers("/actuator/health", "/actuator/info").permitAll() // 헬스체크
                .pathMatchers("/swagger-ui/**", "/v3/api-docs/**").permitAll() // Swagger UI (개발환경)

                // =============================================
                // HTTP 메서드별 접근 권한 (나중에 세분화)
                // =============================================
                .pathMatchers(HttpMethod.GET, "/api/v1/**").authenticated()  // GET: 인증 필요
                .pathMatchers("/api/v1/**").authenticated()                   // 나머지: 인증 필요

                // Thymeleaf 뷰 페이지 - 인증 필요
                .pathMatchers("/dashboard/**").authenticated()
                .pathMatchers("/system/**").authenticated()
                .pathMatchers("/hr/**").authenticated()
                .pathMatchers("/accounting/**").authenticated()
                .pathMatchers("/purchase/**").authenticated()
                .pathMatchers("/sales/**").authenticated()
                .pathMatchers("/inventory/**").authenticated()

                // 위에서 정의되지 않은 모든 요청 - 인증 필요
                .anyExchange().authenticated()
            )

            // 기본 HTTP 로그인 폼 비활성화 (JWT 방식으로 대체)
            .formLogin(ServerHttpSecurity.FormLoginSpec::disable)

            // HTTP Basic 인증 비활성화
            .httpBasic(ServerHttpSecurity.HttpBasicSpec::disable)

            .build();
    }

    /**
     * 비밀번호 암호화 인코더
     *
     * BCrypt: 단방향 해시 알고리즘 (복호화 불가)
     * strength=12: 해싱 강도 (높을수록 안전하지만 느림, 기본값=10)
     *
     * ■ 사용 예시:
     * passwordEncoder.encode("rawPassword")       // 비밀번호 암호화
     * passwordEncoder.matches("raw", "encoded")   // 비밀번호 검증
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12); // strength=12
    }
}
