package com.biopark.sereno.service;

import com.biopark.sereno.domain.UserInfo;
import com.biopark.sereno.dto.LoginRequestDTO;
import com.biopark.sereno.dto.UserRegistrationDTO;
import com.biopark.sereno.domain.User;
import com.biopark.sereno.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public User registerUser(UserRegistrationDTO dto) {
        if (userRepository.findByEmail(dto.getEmail()).isPresent()) {
            throw new IllegalStateException("O email informado já está cadastrado.");
        }

        UserInfo info = new UserInfo();
        info.setBirthDate(dto.getBirthDate());
        info.setDonaduzziStudent(dto.getIsDonaduzziStudent());
        info.setBioparkCollaborator(dto.getIsBioparkCollaborator());
        info.setHobbies(dto.getHobbies());
        info.setJob(dto.getJob());
        info.setCourse(dto.getCourse());
        info.setLeisureTime(dto.getLeisureTime());
        info.setPersonalityType(dto.getPersonalityType());
        info.setLivesAlone(dto.getLivesAlone());

        User newUser = new User();
        newUser.setEmail(dto.getEmail());
        newUser.setPassword(passwordEncoder.encode(dto.getPassword()));

        newUser.setUserInfo(info);

        return userRepository.save(newUser);
    }

    public User login(LoginRequestDTO dto) {
        User user = userRepository.findByEmail(dto.getEmail()).orElseThrow(() -> new RuntimeException("Credenciais inválidas."));

        if (!passwordEncoder.matches(dto.getPassword(), user.getPassword())) {
            throw new RuntimeException("Credenciais inválidas.");
        }

        return user;
    }
}