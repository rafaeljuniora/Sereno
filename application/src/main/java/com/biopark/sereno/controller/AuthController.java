package com.biopark.sereno.controller;

import com.biopark.sereno.domain.User;
import com.biopark.sereno.dto.LoginRequestDTO;
import com.biopark.sereno.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {
    private final UserService userService;

    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@Valid @RequestBody LoginRequestDTO loginDto) {
        try {
            User user = userService.findByEmail(loginDto.getEmail());

            if (!userService.checkPassword(loginDto.getPassword(), user.getPassword())) {
                return ResponseEntity.status(401).body("Credenciais inválidas.");
            }

            Map<String, Object> response = new HashMap<>();
            response.put("userId", user.getId());
            response.put("email", user.getEmail());
            response.put("message", "Login realizado com sucesso");

            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(401).body("Credenciais inválidas.");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Erro interno do servidor.");
        }
    }
}