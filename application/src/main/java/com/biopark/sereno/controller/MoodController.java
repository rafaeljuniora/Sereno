package com.biopark.sereno.controller;

import com.biopark.sereno.dto.MoodEntryDTO;
import com.biopark.sereno.service.MoodService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Collections;

@RestController
@RequestMapping("/api/v1/moods")
@RequiredArgsConstructor
public class MoodController {
    private final MoodService moodService;

    @PostMapping
    public ResponseEntity<?> createMoodEntry(@Valid @RequestBody MoodEntryDTO dto) {
        try {
            return new ResponseEntity<>(moodService.createMoodEntry(dto), HttpStatus.CREATED);
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
        }
    }

    @GetMapping("/today-status/{userId}")
    public ResponseEntity<?> hasUserSubmittedToday(@PathVariable Long userId) {
        boolean submitted = moodService.hasUserSubmittedToday(userId);
        return ResponseEntity.ok(Collections.singletonMap("submitted", submitted));
    }
}