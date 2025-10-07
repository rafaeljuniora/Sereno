package com.biopark.sereno.domain;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "avatar")
public class Avatar {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
}

