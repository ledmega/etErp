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
     * [회원 가입 메서드 - Reactive 비동기 스트림 파이프라인]
     * 
     * @param request 프론트엔드에서 전달된 가입 정보 DTO
     * @return Mono<Void> : 반환할 데이터는 없지만 비동기 작업의 완료(성공/실패) 신호만 넘김
     */
    public Mono<Void> signup(SignupRequest request) {
        /*
         * 1. DB 비동기 조회 (existsByLoginId) 시작.
         *    결과는 boolean이 아니라 Mono<Boolean>으로 즉시 반환(구독 전까진 실행 안됨).
         */
        return userRepository.existsByLoginId(request.getLoginId())
                /*
                 * 2. flatMap: Mono에서 방출된 데이터(Boolean)를 꺼내서 새로운 Mono(또는 에러)로 변환/전환합니다.
                 *    만약 아이디가 이미 존재(existsId == true)하면 Mono.error()라는 실패 신호를 아래로 보냅니다.
                 */
                .flatMap(existsId -> {
                    if (existsId) {
                        return Mono.error(new RuntimeException("이미 사용중인 아이디입니다."));
                    }
                    /* 아이디가 없으면 다음 체인으로 넘어가기 위해 이메일 중복 체크 Mono 통로를 열어줍니다. */
                    return userRepository.existsByEmail(request.getEmail());
                })
                /*
                 * 3. 위에서 넘어온 통로(이메일 검사 완료)에서 방출된 이벤트(Boolean)를 받아 또 전환합니다.
                 */
                .flatMap(existsEmail -> {
                    if (existsEmail) {
                        return Mono.error(new RuntimeException("이미 가입된 이메일입니다."));
                    }
                    
                    /* 모든 검증을 통과했으므로 (동기 블로킹 없이) 객체를 세팅합니다. */
                    // BCrypt를 사용해 사용자의 순수 비밀번호를 단방향으로 강력하게 암호화 (스프링 시큐리티 권장 사양)
                    String encodedPwd = passwordEncoder.encode(request.getPassword());
                    TbUser newUser = TbUser.createPendingUser(
                            request.getLoginId(),
                            encodedPwd,
                            request.getUserName(),
                            request.getEmail(),
                            request.getPhone()
                    );
                    
                    /*
                     * 4. R2DBC의 save() 메서드 역시 결과를 Mono<TbUser> 타입으로 감싸서 비동기로 반환합니다.
                     *    .then()은 결과 데이터(TbUser)는 버리고 오직 "작업 완료(성공)" 신호 깡통(Mono<Void>)만 다음으로 전달합니다.
                     */
                    return userRepository.save(newUser).then();
                });
    }

    /**
     * [로그인 검증 메서드 - 예외 처리 및 함수형 프로그래밍 적용]
     */
    public Mono<TbUser> login(LoginRequest request) {
        /* 1. 사용자의 Login ID로 DB 인덱스를 논블로킹으로 찔러봅니다. */
        return userRepository.findByLoginId(request.getLoginId())
                /*
                 * 2. switchIfEmpty: WebFlux에서 가장 중요한 메서드 중 하나입니다!
                 *    만약 위 findByLoginId 조회 결과 DB에 해당 아이디가 없어 '빈 깡통'이 내려온다면,
                 *    빈 깡통 대신 지정한 대체자(여기서는 강제 에러 방출)를 파이프라인에 던져줍니다.
                 */
                .switchIfEmpty(Mono.error(new RuntimeException("존재하지 않는 사용자입니다.")))
                /*
                 * 3. 회원이 존재한다면 빈 깡통이 아니므로 위 switchIfEmpty를 무시하고 이 flatMap으로 데이터(TbUser)가 무사히 도착합니다.
                 */
                .flatMap(user -> {
                    // 암호화된 비밀번호와 입력한 평문을 matches 로 대조합니다. (절대 평문끼리 비교하면 안 됩니다!)
                    if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
                        return Mono.error(new RuntimeException("비밀번호가 일치하지 않습니다."));
                    }
                    if ("N".equals(user.getUseYn())) {
                        return Mono.error(new RuntimeException("비활성화된 계정입니다."));
                    }
                    
                    /*
                     * 검증을 모두 통과하면 성공이므로, Mono.just()를 통해 이 유저 데이터를 다시 박스에 예쁘게 포장해서
                     * 컨트롤러(최종 목적지)로 배송 출발시킵니다.
                     */
                    return Mono.just(user);
                });
    }
}
