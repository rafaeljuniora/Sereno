package com.biopark.sereno.dto;

import com.biopark.sereno.model.MoodType;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class MoodEntryDTO {
    @NotNull
    private Long userId;
    @NotNull
    private MoodType moodType;
}