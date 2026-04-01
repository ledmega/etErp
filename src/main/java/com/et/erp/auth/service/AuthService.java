package com.et.erp.auth.service;

import com.et.erp.auth.dto.LoginRequest;
import com.et.erp.auth.dto.SignupRequest;
import com.et.erp.system.user.entity.TbUser;
import com.et.erp.system.user.repository.TbUserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final TbUserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    /**
     * 회원 가입 (승인 대기 상태로 생성)
     */
    public Mono<Void> signup(SignupRequest request) {
        return userRepository.existsByLoginId(request.getLoginId())
                .flatMap(existsId -> {
                    if (existsId) {
                        return Mono.error(new RuntimeException("이미 사용중인 아이디입니다."));
                    }
                    return userRepository.existsByEmail(request.getEmail());
                })
                .flatMap(existsEmail -> {
                    if (existsEmail) {
                        return Mono.error(new RuntimeException("이미 가입된 이메일입니다."));
                    }
                    
                    // 비밀번호 암호화 후 엔티티 생성
                    String encodedPwd = passwordEncoder.encode(request.getPassword());
                    TbUser newUser = TbUser.createPendingUser(
                            request.getLoginId(),
                            encodedPwd,
                            request.getUserName(),
                            request.getEmail(),
                            request.getPhone()
                    );
                    
                    return userRepository.save(newUser).then();
                });
    }

    /**
     * 로그인 검증 (간단 버전)
     */
    public Mono<TbUser> login(LoginRequest request) {
        return userRepository.findByLoginId(request.getLoginId())
                .switchIfEmpty(Mono.error(new RuntimeException("존재하지 않는 사용자입니다.")))
                .flatMap(user -> {
                    if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
                        return Mono.error(new RuntimeException("비밀번호가 일치하지 않습니다."));
                    }
                    if ("N".equals(user.getUseYn())) {
                        return Mono.error(new RuntimeException("비활성화된 계정입니다."));
                    }
                    // 성공 시 토큰 생성 로직은 나중에 추가
                    return Mono.just(user);
                });
    }
}
