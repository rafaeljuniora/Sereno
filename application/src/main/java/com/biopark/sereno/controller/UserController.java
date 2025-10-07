package com.biopark.sereno.controller;

import com.biopark.sereno.dto.AvatarUpdateDTO;
import com.biopark.sereno.dto.UserRegistrationDTO;
import com.biopark.sereno.domain.User;
import com.biopark.sereno.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@Valid @RequestBody UserRegistrationDTO registrationDto) {
        try {
            User createdUser = userService.registerUser(registrationDto);
            return new ResponseEntity<>(createdUser, HttpStatus.CREATED);
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Ocorreu um erro ao processar a solicitação.");
        }
    }

    @PatchMapping("/{userId}/avatar")
    public ResponseEntity<?> updateUserAvatar(
            @PathVariable Long userId,
            @Valid @RequestBody AvatarUpdateDTO dto) {
        try {
            User updatedUser = userService.updateUserAvatar(userId, dto.getAvatarId());
            return ResponseEntity.ok(updatedUser);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }
}
