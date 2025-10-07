package com.biopark.sereno.domain;

import com.biopark.sereno.model.PersonalityType;
import jakarta.persistence.*; // Importações atualizadas
import lombok.Data;
import java.time.LocalDate;

@Data
@Entity
@Table(name = "user_info")
public class UserInfo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

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