import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("org.springframework.boot") version "3.4.4"
    id("io.spring.dependency-management") version "1.1.7"
    java
}

group = "com.et"
version = "0.0.1-SNAPSHOT"

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(24)
    }
}

// Lombok 어노테이션 프로세서 설정
configurations {
    compileOnly {
        extendsFrom(configurations.annotationProcessor.get())
    }
}

repositories {
    mavenCentral()
}

dependencies {

    // =============================================
    // Spring WebFlux (Reactive 웹 - Tomcat 대신 Netty 사용)
    // =============================================
    implementation("org.springframework.boot:spring-boot-starter-webflux")

    // =============================================
    // Spring Data R2DBC (Reactive DB 접근 - JPA 대신 사용)
    // =============================================
    implementation("org.springframework.boot:spring-boot-starter-data-r2dbc")

    // MariaDB R2DBC 드라이버 (논블로킹 DB 연결)
    runtimeOnly("org.mariadb:r2dbc-mariadb:1.2.2")

    // MariaDB JDBC 드라이버 (Flyway 마이그레이션 전용 - R2DBC와 별개)
    runtimeOnly("org.mariadb.jdbc:mariadb-java-client:3.5.1")

    // =============================================
    // Flyway (DB 스키마 버전 관리 / 마이그레이션)
    // =============================================
    implementation("org.flywaydb:flyway-core")
    implementation("org.flywaydb:flyway-mysql")  // MariaDB 지원

    // =============================================
    // Spring Security Reactive (논블로킹 인증/인가)
    // =============================================
    implementation("org.springframework.boot:spring-boot-starter-security")

    // =============================================
    // JWT (JSON Web Token - 인증 토큰)
    // =============================================
    implementation("io.jsonwebtoken:jjwt-api:0.12.6")
    runtimeOnly("io.jsonwebtoken:jjwt-impl:0.12.6")
    runtimeOnly("io.jsonwebtoken:jjwt-jackson:0.12.6")

    // =============================================
    // Thymeleaf (서버사이드 HTML 렌더링)
    // =============================================
    implementation("org.springframework.boot:spring-boot-starter-thymeleaf")
    implementation("org.thymeleaf.extras:thymeleaf-extras-springsecurity6") // 뷰에서 권한 체크
    implementation("nz.net.ultraq.thymeleaf:thymeleaf-layout-dialect:3.3.0") // 레이아웃 템플릿

    // =============================================
    // Spring Data Redis Reactive (캐시/세션)
    // =============================================
    implementation("org.springframework.boot:spring-boot-starter-data-redis-reactive")

    // =============================================
    // 입력값 검증 (@Valid, @NotBlank 등)
    // =============================================
    implementation("org.springframework.boot:spring-boot-starter-validation")

    // =============================================
    // Spring Actuator (헬스체크, 메트릭 모니터링)
    // =============================================
    implementation("org.springframework.boot:spring-boot-starter-actuator")

    // =============================================
    // SpringDoc OpenAPI (Swagger UI - WebFlux 전용)
    // =============================================
    implementation("org.springdoc:springdoc-openapi-starter-webflux-ui:2.8.3")

    // =============================================
    // Lombok (보일러플레이트 코드 제거)
    // =============================================
    compileOnly("org.projectlombok:lombok")
    annotationProcessor("org.projectlombok:lombok")

    // =============================================
    // Jasypt (DB 접속 정보 등 프로퍼티 암호화)
    // =============================================
    implementation("com.github.ulisesbocchio:jasypt-spring-boot-starter:3.0.5")


    // =============================================
    // 테스트 의존성
    // =============================================
    testImplementation("org.springframework.boot:spring-boot-starter-test") {
        exclude(group = "org.junit.vintage", module = "junit-vintage-engine")
    }
    // StepVerifier: Reactive 스트림 테스트 도구 (필수!)
    testImplementation("io.projectreactor:reactor-test")
    // WebTestClient: 리액티브 HTTP 통합 테스트
    testImplementation("org.springframework.security:spring-security-test")
    // R2DBC H2: 테스트용 인메모리 DB
    testImplementation("io.r2dbc:r2dbc-h2:1.0.0.RELEASE")
    testRuntimeOnly("com.h2database:h2")
}

tasks.withType<Test> {
    useJUnitPlatform()
}
