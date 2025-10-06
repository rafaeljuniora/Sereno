package com.biopark.sereno.repository;

import com.biopark.sereno.domain.MoodEntry;
import com.biopark.sereno.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;

@Repository
public interface MoodEntryRepository extends JpaRepository<MoodEntry, Long> {
    boolean existsByUserAndEntryDate(User user, LocalDate entryDate);
}