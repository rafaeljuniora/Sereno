package com.biopark.sereno.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class AvatarUpdateDTO {
    @NotBlank(message = "O ID do avatar não pode ser vazio.")
    private String avatarId;
}