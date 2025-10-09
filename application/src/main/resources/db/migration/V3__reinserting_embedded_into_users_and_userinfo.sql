-- ========================================
-- Migration para embutir user_info em users
-- ========================================

-- 1. Adicionar as colunas da user_info à tabela users
ALTER TABLE users
ADD COLUMN birth_date DATE,
ADD COLUMN is_donaduzzi_student BOOLEAN,
ADD COLUMN is_biopark_collaborator BOOLEAN,
ADD COLUMN hobbies VARCHAR(255),
ADD COLUMN job VARCHAR(255),
ADD COLUMN course VARCHAR(255),
ADD COLUMN leisure_time VARCHAR(255),
ADD COLUMN personality_type VARCHAR(50),
ADD COLUMN lives_alone BOOLEAN;

-- 2. Migrar os dados existentes da user_info para a tabela users
-- NOTA: O UPDATE com JOIN é a maneira mais limpa de fazer isso no PostgreSQL.
UPDATE users AS u
SET
    birth_date = ui.birth_date,
    is_donaduzzi_student = ui.is_donaduzzi_student,
    is_biopark_collaborator = ui.is_biopark_collaborator,
    hobbies = ui.hobbies,
    job = ui.job,
    course = ui.course,
    leisure_time = ui.leisure_time,
    personality_type = ui.personality_type,
    lives_alone = ui.lives_alone
FROM user_info AS ui
WHERE u.user_info_id = ui.id;

-- 3. Definir as restrições NOT NULL nas novas colunas
-- Isso garante que novos registros cumpram as regras originais.
-- (Assumindo que todos os dados foram migrados com sucesso)
ALTER TABLE users
ALTER COLUMN birth_date SET NOT NULL,
ALTER COLUMN is_donaduzzi_student SET NOT NULL,
ALTER COLUMN is_biopark_collaborator SET NOT NULL,
ALTER COLUMN personality_type SET NOT NULL,
ALTER COLUMN lives_alone SET NOT NULL;


-- 4. Remover a chave estrangeira e a coluna user_info_id da tabela users
-- É necessário remover a restrição UNIQUE/FOREIGN KEY antes da coluna.
ALTER TABLE users
DROP CONSTRAINT fk_user_info;

ALTER TABLE users
DROP COLUMN user_info_id;


-- 5. Excluir a tabela user_info, pois ela não é mais necessária
DROP TABLE user_info;