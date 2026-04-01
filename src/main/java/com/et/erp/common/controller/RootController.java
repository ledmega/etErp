package com.et.erp.common.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;
import java.util.Map;

@RestController
public class RootController {

    @GetMapping("/")
    public Mono<Map<String, String>> welcome() {
        return Mono.just(Map.of(
            "message", "Welcome to etERP API Server!",
            "status", "Running",
            "version", "1.0.0"
        ));
    }
}
