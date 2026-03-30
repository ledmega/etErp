package com.et.erp.system.role.entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table("sys_role")
public class TbRole {
    
    @Id
    @Column("role_id")
    private Long roleId;

    @Column("role_code")
    private RoleCode roleCode;   // Enum을 직접 매핑 (R2DBC에서 Enum 처리 로직이 필요할 수도 있음, 일단 Enum 타입으로 설정)

    @Column("role_name")
    private String roleName;

    @Column("description")
    private String description;

    @Column("created_at")
    private LocalDateTime createdAt;
    
    @Column("created_by")
    private String createdBy;

    // TODO: 그외 Auditing 컬럼
}
