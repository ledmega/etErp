package com.et.erp.auth.controller;

import com.et.erp.auth.dto.LoginRequest;
import com.et.erp.auth.dto.SignupRequest;
import com.et.erp.auth.service.AuthService;
import com.et.erp.common.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthApiController {

    private final AuthService authService;

    @PostMapping("/signup")
    public Mono<ApiResponse<Void>> signup(@RequestBody SignupRequest request) {
        return authService.signup(request)
                .then(Mono.just(ApiResponse.<Void>success()))
                .onErrorResume(e -> Mono.just(ApiResponse.<Void>fail("E400", e.getMessage())));
    }

    @PostMapping("/login")
    public Mono<ApiResponse<Map<String, String>>> login(@RequestBody LoginRequest request) {
        return authService.login(request)
                .map(user -> ApiResponse.success(Map.of(
                        "userName", user.getUserName(),
                        "status", user.getUserStatus().name()
                )))
                .onErrorResume(e -> Mono.just(ApiResponse.<Map<String, String>>fail("E401", e.getMessage())));
    }
}
