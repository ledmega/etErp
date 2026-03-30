package com.et.erp.common.response;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;

/**
 * API 공통 응답 포맷
 *
 * 모든 REST API 응답은 이 클래스를 사용합니다.
 * 성공/실패 여부, 응답 코드, 메시지, 데이터를 일관된 형태로 반환합니다.
 *
 * ■ 성공 응답 예시:
 * {
 *   "success": true,
 *   "code": "200",
 *   "message": "성공",
 *   "data": { ... }
 * }
 *
 * ■ 실패 응답 예시:
 * {
 *   "success": false,
 *   "code": "E001",
 *   "message": "직원을 찾을 수 없습니다.",
 *   "data": null
 * }
 *
 * @param <T> 응답 데이터 타입 (성공 시 실제 데이터, 실패 시 null)
 */
@Getter
// null인 필드는 JSON 응답에서 제외 (data가 null이면 "data" 키 자체를 생략)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponse<T> {

    /** 요청 성공 여부 (true: 성공, false: 실패) */
    private final boolean success;

    /** 응답 코드 (성공: "200", 실패: "E001" 등 ErrorCode 참고) */
    private final String code;

    /** 응답 메시지 */
    private final String message;

    /** 응답 데이터 (성공 시 실제 데이터, 실패 시 null) */
    private final T data;

    /**
     * 생성자 (private - 외부에서 직접 생성 금지)
     * 아래 정적 팩토리 메서드를 사용하세요.
     */
    private ApiResponse(boolean success, String code, String message, T data) {
        this.success = success;
        this.code = code;
        this.message = message;
        this.data = data;
    }

    /**
     * 성공 응답 생성 (데이터 있음)
     *
     * 사용 예시:
     * return ApiResponse.success(employeeResponse);
     *
     * @param data 응답 데이터
     * @return ApiResponse (success=true, code="200")
     */
    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(true, "200", "성공", data);
    }

    /**
     * 성공 응답 생성 (데이터 없음 - 삭제, 상태변경 등)
     *
     * 사용 예시:
     * return ApiResponse.success();
     *
     * @return ApiResponse (success=true, code="200", data=null)
     */
    public static <T> ApiResponse<T> success() {
        return new ApiResponse<>(true, "200", "성공", null);
    }

    /**
     * 실패 응답 생성 (ErrorCode 기반)
     *
     * 사용 예시:
     * return ApiResponse.fail(ErrorCode.EMPLOYEE_NOT_FOUND);
     *
     * @param errorCode ErrorCode enum
     * @return ApiResponse (success=false)
     */
    public static <T> ApiResponse<T> fail(ErrorCode errorCode) {
        return new ApiResponse<>(false, errorCode.getCode(), errorCode.getMessage(), null);
    }

    /**
     * 실패 응답 생성 (코드, 메시지 직접 지정)
     *
     * 사용 예시:
     * return ApiResponse.fail("E002", "이름은 필수입니다.");
     *
     * @param code    에러 코드
     * @param message 에러 메시지
     * @return ApiResponse (success=false)
     */
    public static <T> ApiResponse<T> fail(String code, String message) {
        return new ApiResponse<>(false, code, message, null);
    }
}
