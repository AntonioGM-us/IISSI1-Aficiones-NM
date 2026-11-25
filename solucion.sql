USE hobbies_nm_db;

/*Funcion f_get_hobby_id*/
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

/*Procedimiento p_add_hobby_to_user*/
DELIMITER //
CREATE OR REPLACE PROCEDURE p_add_hobby_to_user(
	IN p_user_id INT,
	IN p_hobby_name VARCHAR(128)
)
BEGIN
	DECLARE v_hobby_id INT;
	
	SET v_hobby_id = f_get_hobby_id(p_hobby_name);
	
	IF EXISTS (
		SELECT *
		FROM users_hobbies uh
		WHERE uh.user_hobby_id = p_user_id
		AND uh.user_hobby_id = v_hobby_id	 
	) THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'RN03: El usuario ya tiene esa aficion';
	END IF;
	IF v_hobby_id IS NULL THEN
		INSERT INTO hobbies (hobby_name) VALUES (p_hobby_name);
		
		SET v_hobby_id = LAST_INSERT_ID();
	END IF;
		
	INSERT INTO users_hobbies (user_id, hobby_id) VALUES (p_user_id, v_hobby_id);
END //

DELIMITER ;	

SELECT uh.user_id, h.hobby_name
FROM users_hobbies uh
JOIN hobbies h ON h.hobby_id=uh.hobby_id
WHERE uh.user_id=1;

CALL p_add_hobby_to_user(1, 'Cine');

SELECT uh.user_id, h.hobby_name
FROM users_hobbies uh
JOIN hobbies h ON h.hobby_id=uh.hobby_id
WHERE uh.user_id=1;
SELECT COUNT(*) AS hobbies_in_catalog
FROM hobbies;
		
/*Procedimiento transaccional del anterior (envoltorio)*/
DELIMITER //
CREATE OR REPLACE PROCEDURE p_add_hobby_to_user_ts(
	IN p_user_id INT,
	IN p_hobby_name VARCHAR(128)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		RESIGNAL;
	END;
	START TRANSACTION;
		CALL p_add_hobby_to_user(p_user_id, p_hobby_name);
	COMMIT;
END //
DELIMITER ;

SELECT 
FROM users_hobbies uh
JOIN hobbies h ON h.hobby_id=uh.hobby_id
WHERE uh.user_id = 3;