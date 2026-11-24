--
-- Autor: David Ruiz
-- Fecha: Noviembre de 2026
-- Descripción: Inserción de un usuario con una afición, sin y con transacción
--

USE hobbies_nm_db;

-- Insertar un usuario nuevo con una afición (en las tres tablas)
DELIMITER //
CREATE OR REPLACE PROCEDURE p_insert_user_with_hobby(
    IN p_full_name VARCHAR(64),
    IN p_gender ENUM('MASCULINO','FEMENINO','OTRO'),
    IN p_age INT,
    IN p_email VARCHAR(255),
    IN p_hobby_name VARCHAR(128)
)
BEGIN
    DECLARE v_user_id INT;
    DECLARE v_hobby_id INT;

    CALL p_insert_user(p_full_name, p_gender, p_age, p_email);
    SET v_user_id = LAST_INSERT_ID();

    INSERT INTO hobbies (hobby_name) VALUES (p_hobby_name);
    SET v_hobby_id = LAST_INSERT_ID();

    INSERT INTO users_hobbies (user_id, hobby_id) VALUES (v_user_id, v_hobby_id);
END //
DELIMITER ;

-- Versión transaccional
DELIMITER //
CREATE OR REPLACE PROCEDURE p_insert_user_with_hobby_tx(
    IN p_full_name VARCHAR(64),
    IN p_gender ENUM('MASCULINO','FEMENINO','OTRO'),
    IN p_age INT,
    IN p_email VARCHAR(255),
    IN p_hobby_name VARCHAR(128)
)
BEGIN
    -- Ante cualquier error se deshace la transacción y se relanza el error
    -- (RESIGNAL), con su motivo, para que lo reciba quien llamó al procedimiento
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        CALL p_insert_user_with_hobby(p_full_name, p_gender, p_age, p_email, p_hobby_name);
    COMMIT;
END //
DELIMITER ;
