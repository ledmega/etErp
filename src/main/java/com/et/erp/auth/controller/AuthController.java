package com.et.erp.auth.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import reactor.core.publisher.Mono;

@Controller
public class AuthController {

    @GetMapping("/login")
    public Mono<String> loginPage() {
        return Mono.just("auth/login");
    }

    @GetMapping("/signup")
    public Mono<String> signupPage() {
        return Mono.just("auth/signup");
    }
}
