package com.et.erp.common.entity;

import lombok.Getter;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;

import java.time.LocalDateTime;

/**
 * 모든 Entity의 공통 감사(Audit) 컬럼 정의
 *
 * ■ 모든 테이블에 공통으로 들어가는 컬럼을 한 곳에서 관리합니다.
 * ■ @EnableR2dbcAuditing 활성화 시 createdAt, updatedAt 자동으로 채워집니다.
 * ■ createdBy, updatedBy 는 AuditorAware 구현체에서 현재 로그인 사용자를 가져옵니다.
 *
 * 포함 컬럼:
 *   - created_at  : 생성일시 (최초 저장 시 자동 입력)
 *   - created_by  : 생성자 (로그인 사용자 ID)
 *   - updated_at  : 수정일시 (수정 시 자동 갱신)
 *   - updated_by  : 수정자 (로그인 사용자 ID)
 *   - deleted_yn  : 삭제여부 (Y/N) - 물리 삭제 금지, 논리 삭제만 사용
 */
@Getter
public abstract class BaseEntity {

    /**
     * 생성일시
     * - @CreatedDate: 최초 save() 시 현재 시각 자동 입력
     * - R2DBC Auditing이 처리하므로 직접 값을 넣지 않아도 됩니다.
     */
    @CreatedDate
    private LocalDateTime createdAt;

    /**
     * 생성자 (로그인 사용자 ID)
     * - @CreatedBy: 최초 save() 시 ReactiveAuditorAware 에서 사용자 ID를 가져와 자동 입력
     */
    @CreatedBy
    private String createdBy;

    /**
     * 수정일시
     * - @LastModifiedDate: save() 호출 시마다 현재 시각으로 자동 갱신
     */
    @LastModifiedDate
    private LocalDateTime updatedAt;

    /**
     * 수정자 (로그인 사용자 ID)
     * - @LastModifiedBy: save() 호출 시마다 현재 로그인 사용자 ID로 자동 갱신
     */
    @LastModifiedBy
    private String updatedBy;

    /**
     * 삭제여부
     * - 'N': 정상 (기본값)
     * - 'Y': 삭제됨
     *
     * ※ 데이터는 절대 물리적으로 DELETE 하지 않습니다.
     *    deleted_yn = 'Y' 로 논리 삭제 처리합니다.
     */
    private String deletedYn = "N";

    /**
     * 논리 삭제 처리 메서드
     * Entity를 삭제할 때 이 메서드를 호출합니다.
     * DELETE SQL이 아닌 UPDATE SQL로 처리됩니다.
     */
    public void softDelete() {
        this.deletedYn = "Y";
    }

    /**
     * 삭제 여부 확인
     * @return true: 삭제됨, false: 정상
     */
    public boolean isDeleted() {
        return "Y".equals(this.deletedYn);
    }
}
