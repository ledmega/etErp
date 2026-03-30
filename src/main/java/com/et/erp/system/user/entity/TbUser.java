package com.et.erp.system.user.entity;

import com.et.erp.common.entity.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDateTime;

/**
 * sys_user 테이블 매핑 엔티티
 *
 * R2DBC를 사용하므로 JPA의 @Entity 가 아닌 Spring Data Relational의 @Table 을 사용합니다.
 */
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table("sys_user")
public class TbUser extends BaseEntity {

    @Id
    @Column("user_id")
    private Long userId;

    @Column("login_id")
    private String loginId;

    @Column("password")
    private String password;

    @Column("user_name")
    private String userName;

    @Column("email")
    private String email;

    @Column("phone")
    private String phone;

    @Column("dept_id")
    private Long deptId;

    // 가입 승인 대기 관리를 위한 계정 상태 (PENDING, ACTIVE, INACTIVE)
    @Column("user_status")
    private UserStatus userStatus;

    // 계정 사용 자체(물리적 사용 유무) 여부 'Y'/'N'
    @Column("use_yn")
    private String useYn;

    @Column("pwd_changed_at")
    private LocalDateTime pwdChangedAt;

    @Column("last_login_at")
    private LocalDateTime lastLoginAt;

    /**
     * 회원 가입 시 기본 값 세팅용 메서드
     * - 미승인 상태(PENDING), 미배정 부서(null), 암호화된 패스워드
     */
    public static TbUser createPendingUser(String loginId, String encodedPassword, String userName, String email, String phone) {
        return TbUser.builder()
                .loginId(loginId)
                .password(encodedPassword)
                .userName(userName)
                .email(email)
                .phone(phone)
                .userStatus(UserStatus.PENDING) // 관리자 승인 대기
                .useYn("Y")
                .build();
    }

    /**
     * 관리자 승인 시 (소속 부서 할당 및 권한 매핑 전 상태 ACTIVE 처리)
     */
    public void approve(Long assignedDeptId) {
        this.userStatus = UserStatus.ACTIVE;
        this.deptId = assignedDeptId;
    }
}
