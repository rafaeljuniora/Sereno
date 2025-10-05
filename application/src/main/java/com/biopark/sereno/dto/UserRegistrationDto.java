package com.biopark.sereno.dto;

import com.biopark.sereno.model.PersonalityType;
import jakarta.validation.constraints.*;
import lombok.Data;
import java.time.LocalDate;

@Data
public class UserRegistrationDto {

    @NotBlank(message = "O email é obrigatório.")
    @Email(message = "O email deve ser válido.")
    private String email;

    @NotBlank(message = "A senha é obrigatória.")
    @Size(min = 8, message = "A senha deve ter no mínimo 8 caracteres.")
    private String password;

    @NotNull(message = "A data de nascimento é obrigatória.")
    @Past(message = "A data de nascimento deve ser no passado.")
    private LocalDate birthDate;

    @NotNull(message = "O campo 'aluno Donaduzzi' é obrigatório.")
    private Boolean isDonaduzziStudent;

    @NotNull(message = "O campo 'colaborador Biopark' é obrigatório.")
    private Boolean isBioparkCollaborator;

    private String hobbies;
    private String job;
    private String course;
    private String leisureTime;

    @NotNull(message = "O tipo de personalidade é obrigatório.")
    private PersonalityType personalityType;

    @NotNull(message = "O campo 'mora sozinho' é obrigatório.")
    private Boolean livesAlone;
}