package com.biopark.sereno.controller;

import com.biopark.sereno.domain.User;
import com.biopark.sereno.dto.LoginRequestDTO;
import com.biopark.sereno.dto.LoginResponseDTO;
import com.biopark.sereno.service.JwtService;
import com.biopark.sereno.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {
    private final UserService userService;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@Valid @RequestBody LoginRequestDTO loginDto) {
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(loginDto.getEmail(), loginDto.getPassword())
            );

            User user = userService.findByEmail(loginDto.getEmail());
            String jwtToken = jwtService.generateToken(user);

            return ResponseEntity.ok(LoginResponseDTO.builder()
                    .token(jwtToken)
                    .userId(user.getId())
                    .build());
        } catch (Exception e) {
            return ResponseEntity.status(401).body("Credenciais inválidas.");
        }
    }
}