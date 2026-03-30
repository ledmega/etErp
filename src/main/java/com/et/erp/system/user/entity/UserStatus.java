package com.et.erp.system.user.entity;

/**
 * 사용자 계정 상태 관리 Enum
 *
 * PENDING: 최초 가입 시 상태 (관리자 승인 대기, 로그인 불가)
 * ACTIVE: 정상 상태 (로그인 및 시스템 사용 가능)
 * INACTIVE: 비활성화/퇴사 (로그인 1차 차단)
 */
public enum UserStatus {
    PENDING,
    ACTIVE,
    INACTIVE
}
