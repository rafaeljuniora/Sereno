package com.biopark.sereno.service;

import com.biopark.sereno.domain.MoodEntry;
import com.biopark.sereno.domain.User;
import com.biopark.sereno.dto.MoodEntryDTO;
import com.biopark.sereno.repository.MoodEntryRepository;
import com.biopark.sereno.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.time.LocalDate;

@Service
@RequiredArgsConstructor
public class MoodService {
    private final MoodEntryRepository moodEntryRepository;
    private final UserRepository userRepository;

    public MoodEntry createMoodEntry(MoodEntryDTO dto) {
        User user = userRepository.findById(dto.getUserId())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado."));

        if (moodEntryRepository.existsByUserAndEntryDate(user, LocalDate.now())) {
            throw new IllegalStateException("Humor já registrado para hoje.");
        }

        MoodEntry newEntry = new MoodEntry();
        newEntry.setUser(user);
        newEntry.setMoodType(dto.getMoodType());
        newEntry.setEntryDate(LocalDate.now());

        return moodEntryRepository.save(newEntry);
    }

    public boolean hasUserSubmittedToday(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado."));
        return moodEntryRepository.existsByUserAndEntryDate(user, LocalDate.now());
    }
}