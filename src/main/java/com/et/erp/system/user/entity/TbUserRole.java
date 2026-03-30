package com.et.erp.system.user.entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table("sys_user_role")
public class TbUserRole {
    
    @Id
    @Column("user_role_id")
    private Long userRoleId;

    @Column("user_id")
    private Long userId;

    @Column("role_id")
    private Long roleId;

    public static TbUserRole create(Long userId, Long roleId) {
        return TbUserRole.builder()
                .userId(userId)
                .roleId(roleId)
                .build();
    }
}
