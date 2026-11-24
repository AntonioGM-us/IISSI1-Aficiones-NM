--
-- Autor: David Ruiz
-- Fecha: Octubre de 2026
-- Descripción: Procedimiento para insertar usuarios en Aficiones dinámicas
--

USE hobbies_nm_db;

-- Insertar usuario
DELIMITER //
CREATE OR REPLACE PROCEDURE p_insert_user(
    IN p_full_name VARCHAR(64),
    IN p_gender ENUM('MASCULINO','FEMENINO','OTRO'),
    IN p_age INT,
    IN p_email VARCHAR(255)
)
BEGIN
    INSERT INTO users (full_name, gender, age, email)
    VALUES (p_full_name, p_gender, p_age, p_email);
END //
DELIMITER ;
