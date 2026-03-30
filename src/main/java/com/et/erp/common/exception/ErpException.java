package com.et.erp.common.exception;

import com.et.erp.common.response.ErrorCode;
import lombok.Getter;

/**
 * etERP 비즈니스 예외 클래스
 *
 * 비즈니스 로직에서 오류가 발생할 때 사용합니다.
 * GlobalExceptionHandler에서 일괄 처리됩니다.
 *
 * ■ 사용 방법:
 *
 * // ErrorCode Enum 사용 (권장)
 * throw new ErpException(ErrorCode.EMPLOYEE_NOT_FOUND);
 *
 * // 메시지 포함
 * throw new ErpException(ErrorCode.NOT_FOUND, "사번 " + empNo + " 직원이 없습니다.");
 *
 * ■ Reactive에서 사용:
 *
 * Mono.error(new ErpException(ErrorCode.EMPLOYEE_NOT_FOUND))
 * .switchIfEmpty(Mono.error(new ErpException(ErrorCode.EMPLOYEE_NOT_FOUND)))
 */
@Getter
public class ErpException extends RuntimeException {

    /**
     * 에러 코드 (ErrorCode Enum)
     * HTTP 상태코드와 응답 메시지 결정에 사용됩니다.
     */
    private final ErrorCode errorCode;

    /**
     * 기본 생성자 - ErrorCode의 메시지를 그대로 사용
     *
     * @param errorCode 발생한 에러 코드
     */
    public ErpException(ErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
    }

    /**
     * 메시지 지정 생성자 - ErrorCode의 메시지 대신 직접 지정한 메시지 사용
     * 더 구체적인 에러 메시지가 필요할 때 사용합니다.
     *
     * @param errorCode 발생한 에러 코드
     * @param message   상세 에러 메시지
     */
    public ErpException(ErrorCode errorCode, String message) {
        super(message);
        this.errorCode = errorCode;
    }

    /**
     * 원인 예외 포함 생성자
     *
     * @param errorCode 발생한 에러 코드
     * @param cause     원인 예외
     */
    public ErpException(ErrorCode errorCode, Throwable cause) {
        super(errorCode.getMessage(), cause);
        this.errorCode = errorCode;
    }
}
