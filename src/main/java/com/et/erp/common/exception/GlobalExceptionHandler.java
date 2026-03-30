package com.et.erp.common.exception;

import com.et.erp.common.response.ApiResponse;
import com.et.erp.common.response.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.bind.support.WebExchangeBindException;
import org.springframework.web.server.ServerWebInputException;
import reactor.core.publisher.Mono;

/**
 * 전역 예외 처리 핸들러
 *
 * @RestControllerAdvice: 모든 @RestController에서 발생하는 예외를 여기서 처리합니다.
 *
 * ■ WebFlux 환경이므로 반환 타입이 Mono<ResponseEntity<...>> 입니다.
 * ■ 각 예외 유형별로 적절한 HTTP 상태코드와 ApiResponse를 반환합니다.
 */
@Slf4j
@RestControllerAdvice // 모든 컨트롤러의 예외를 일괄 처리
public class GlobalExceptionHandler {

    /**
     * ErpException 처리 - 비즈니스 로직 예외
     *
     * Service에서 throw new ErpException(ErrorCode.XXX) 할 때 호출됩니다.
     * 클라이언트에서 의도적으로 발생시킨 오류이므로 WARN 레벨로 로깅합니다.
     */
    @ExceptionHandler(ErpException.class)
    public Mono<ResponseEntity<ApiResponse<Void>>> handleErpException(ErpException e) {
        // 비즈니스 예외는 WARN 레벨로 로깅 (에러 스택트레이스 불필요)
        log.warn("[비즈니스 예외] code={}, message={}", e.getErrorCode().getCode(), e.getMessage());

        // 에러 코드에 따라 HTTP 상태코드 결정
        HttpStatus status = switch (e.getErrorCode()) {
            case NOT_FOUND, EMPLOYEE_NOT_FOUND, DEPT_NOT_FOUND,
                 USER_NOT_FOUND, ACCOUNT_NOT_FOUND, VOUCHER_NOT_FOUND,
                 VENDOR_NOT_FOUND, ITEM_NOT_FOUND, ORDER_NOT_FOUND,
                 SALES_ORDER_NOT_FOUND -> HttpStatus.NOT_FOUND;          // 404

            case UNAUTHORIZED, TOKEN_EXPIRED, TOKEN_INVALID -> HttpStatus.UNAUTHORIZED; // 401
            case ACCESS_DENIED -> HttpStatus.FORBIDDEN;                  // 403
            case DUPLICATE_DATA, DUPLICATE_LOGIN_ID,
                 DUPLICATE_EMP_NO -> HttpStatus.CONFLICT;                // 409
            default -> HttpStatus.BAD_REQUEST;                           // 400
        };

        return Mono.just(
            ResponseEntity.status(status)
                .body(ApiResponse.<Void>fail(e.getErrorCode()))
        );
    }

    /**
     * WebExchangeBindException 처리 - @Valid 입력값 검증 실패
     *
     * 요청 DTO의 @NotBlank, @Size 등 검증 어노테이션 실패 시 호출됩니다.
     * 첫 번째 실패 필드와 메시지를 반환합니다.
     */
    @ExceptionHandler(WebExchangeBindException.class)
    public Mono<ResponseEntity<ApiResponse<Void>>> handleValidationException(
            WebExchangeBindException e) {

        // 첫 번째 검증 오류 메시지 추출
        String message = e.getBindingResult()
            .getFieldErrors()
            .stream()
            .findFirst()
            .map(fe -> "[" + fe.getField() + "] " + fe.getDefaultMessage())
            .orElse("입력값이 올바르지 않습니다.");

        log.warn("[입력값 검증 실패] {}", message);

        return Mono.just(
            ResponseEntity.badRequest()
                .body(ApiResponse.<Void>fail(ErrorCode.INVALID_INPUT.getCode(), message))
        );
    }

    /**
     * ServerWebInputException 처리 - 요청 형식 오류
     *
     * JSON 파싱 실패, 타입 불일치 등 요청 자체가 잘못된 경우 처리합니다.
     */
    @ExceptionHandler(ServerWebInputException.class)
    public Mono<ResponseEntity<ApiResponse<Void>>> handleServerWebInputException(
            ServerWebInputException e) {

        log.warn("[요청 형식 오류] {}", e.getMessage());

        return Mono.just(
            ResponseEntity.badRequest()
                .body(ApiResponse.<Void>fail(ErrorCode.INVALID_INPUT.getCode(), "요청 형식이 올바르지 않습니다."))
        );
    }

    /**
     * Exception 처리 - 예상치 못한 서버 오류
     *
     * 위의 핸들러에서 처리되지 않은 모든 예외를 여기서 처리합니다.
     * ERROR 레벨로 스택트레이스와 함께 로깅합니다.
     */
    @ExceptionHandler(Exception.class)
    public Mono<ResponseEntity<ApiResponse<Void>>> handleException(Exception e) {
        // 예상치 못한 오류는 ERROR 레벨 + 스택트레이스 출력
        log.error("[서버 오류] {}", e.getMessage(), e);

        return Mono.just(
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ApiResponse.<Void>fail(ErrorCode.INTERNAL_ERROR))
        );
    }
}
