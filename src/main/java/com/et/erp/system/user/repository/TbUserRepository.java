package com.et.erp.system.user.repository;

import com.et.erp.system.user.entity.TbUser;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Mono;

/**
 * TbUser Entity 접근을 위한 R2DBC 리포지토리
 * 
 * Spring Data R2DBC는 ReactiveCrudRepository 를 상속받아 사용합니다.
 */
public interface TbUserRepository extends ReactiveCrudRepository<TbUser, Long> {
    
    /**
     * 로그인 ID로 사용자를 단건 조회합니다.
     * 
     * @param loginId 시스템 내부 로그인 아이디
     * @return 일치하는 사용자(Mono)
     */
    Mono<TbUser> findByLoginId(String loginId);

    /**
     * 접속 이메일 중복 가입 여부를 확인합니다.
     * 
     * @param email 가입 이메일
     * @return 해당 이메일이 이미 존재하는지 여부(Mono)
     */
    Mono<Boolean> existsByEmail(String email);

    /**
     * 로그인 ID 중복 여부를 확인합니다.
     * 
     * @param loginId 로그인 아이디
     * @return 해당 아이디가 이미 존재하는지 여부(Mono)
     */
    Mono<Boolean> existsByLoginId(String loginId);
}
