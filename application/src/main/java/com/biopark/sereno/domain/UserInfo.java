package com.biopark.sereno.domain;

import com.biopark.sereno.model.PersonalityType;
import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import lombok.Data;
import java.time.LocalDate;

@Data
@Embeddable
public class UserInfo {

    @Column(nullable = false)
    private LocalDate birthDate;

    @Column(nullable = false)
    private boolean isDonaduzziStudent;

    @Column(nullable = false)
    private boolean isBioparkCollaborator;

    private String hobbies;

    private String job;

    private String course;

    private String leisureTime;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PersonalityType personalityType;

    @Column(nullable = false)
    private boolean livesAlone;
}