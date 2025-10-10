-- ========================================
-- Migration inicial ajustada
-- ========================================

-- Tabela para armazenar informações detalhadas do usuário
CREATE TABLE IF NOT EXISTS user_info (
    id BIGSERIAL PRIMARY KEY,
    birth_date DATE NOT NULL,
    is_donaduzzi_student BOOLEAN NOT NULL,
    is_biopark_collaborator BOOLEAN NOT NULL,
    hobbies VARCHAR(255),
    job VARCHAR(255),
    course VARCHAR(255),
    leisure_time VARCHAR(255),
    personality_type VARCHAR(50) NOT NULL,
    lives_alone BOOLEAN NOT NULL
);

-- Tabela para armazenar possíveis avatares (opcional)
CREATE TABLE IF NOT EXISTS avatar (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL

);

-- Tabela de usuários
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,

    -- FK opcional para avatar
    avatar_id BIGINT NULL,
    CONSTRAINT fk_avatar
        FOREIGN KEY (avatar_id)
        REFERENCES avatar(id),

    -- FK para UserInfo (Relacionamento One-to-One)
    user_info_id BIGINT NOT NULL UNIQUE,
    CONSTRAINT fk_user_info
        FOREIGN KEY (user_info_id)
        REFERENCES user_info(id)
);

-- Tabela para armazenar tipos de emoção
CREATE TABLE IF NOT EXISTS emotion (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Inserindo emoções padrões
INSERT INTO emotion (name) VALUES
('FELIZ'),
('INDIFERENTE'),
('RAIVA'),
('TRISTEZA'),
('MEDO');

-- Tabela para armazenar os registros diários de emoção
CREATE TABLE IF NOT EXISTS mood_entry (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    mood_type VARCHAR(50) NOT NULL,
    entry_date DATE NOT NULL,

    CONSTRAINT fk_mood_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
);
