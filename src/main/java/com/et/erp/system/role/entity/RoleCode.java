package com.et.erp.system.role.entity;

/**
 * 역할 코드 Enum
 *
 * 권한 기반 접근 제어에 사용되는 기본 ROLE 명칭입니다.
 */
public enum RoleCode {
    ROLE_ADMIN,        // 최고 관리자 (admin) - 모든 접근 허용
    ROLE_MANAGER,      // 시스템 관리자/인사 (관리자)
    ROLE_TEAM_LEADER,  // 팀장
    ROLE_TEAM_MEMBER,  // 팀원
    ROLE_FREELANCER    // 프리랜서
}
