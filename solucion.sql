USE hobbies_nm_db;
-- Implementa una función f_get_hobby_id que devuelva el id de una afición a partir de su nombre
DELIMITER //
CREATE OR REPLACE FUNCTION f_get_hobby_id(
    p_nombreA VARCHAR(128)
) RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_id_result INT;
    SELECT MIN(h.hobby_id) INTO v_id_result FROM hobbies h WHERE h.hobby_name=p_nombreA;
    RETURN v_id_result;
END //
DELIMITER ;

SELECT f_get_hobby_id("Cine") AS cine, f_get_hobby_id("Ajedrez") as Ajedrez;