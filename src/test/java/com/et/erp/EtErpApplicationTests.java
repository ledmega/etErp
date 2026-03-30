package com.et.erp;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

/**
 * 애플리케이션 기본 구동 테스트
 *
 * ■ 이 테스트는 Spring 컨텍스트가 정상적으로 로딩되는지 확인합니다.
 * ■ 테스트 환경은 H2 인메모리 DB를 사용합니다. (application-test.yml 참고)
 */
@SpringBootTest
class EtErpApplicationTests {

    /**
     * Spring 컨텍스트 로딩 테스트
     * - 모든 Bean이 정상적으로 생성되는지 확인
     * - 설정 파일 오류 여부 확인
     */
    @Test
    void contextLoads() {
        // Spring 컨텍스트가 정상적으로 로딩되면 이 테스트는 통과됩니다.
    }
}
