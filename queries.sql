--
-- Autor: David Ruiz
-- Fecha: Octubre de 2026
-- Descripción: Consultas SQL correspondientes al álgebra relacional de Aficiones-NM
--

USE hobbies_nm_db;

-- RF10: Usuarios con sus aficiones
CREATE OR REPLACE VIEW v_users_hobbies AS
SELECT u.user_id, u.full_name, u.age, u.gender, u.email,
       uh.user_hobby_id, h.hobby_id, h.hobby_name
FROM users u
JOIN users_hobbies uh ON uh.user_id = u.user_id
JOIN hobbies h ON h.hobby_id = uh.hobby_id;

SELECT v.user_id, v.full_name, v.age, v.gender, v.hobby_name
FROM v_users_hobbies v;

-- RF11: Usuarios a los que les gusta el cine
SELECT v.user_id, v.full_name
FROM v_users_hobbies v
WHERE v.hobby_name = 'Cine';

-- RF12: Usuarios sin aficiones
-- Opción 1: EXCEPT (calca la diferencia del AR)
SELECT u.full_name
FROM users u
JOIN (
	SELECT u.user_id
	FROM users u
	EXCEPT
	SELECT uh.user_id
	FROM users_hobbies uh
) s ON s.user_id = u.user_id;
-- Opción 2: NOT EXISTS
SELECT u.full_name
FROM users u
WHERE NOT EXISTS (
	SELECT *
	FROM users_hobbies uh
	WHERE uh.user_id = u.user_id
);

-- RF13: Número de aficiones por usuario
CREATE OR REPLACE VIEW v_hobbies_per_user AS
SELECT uh.user_id, COUNT(*) AS total
FROM users_hobbies uh
GROUP BY uh.user_id;

SELECT n.user_id, n.total
FROM v_hobbies_per_user n;

-- RF14: Máximo número de aficiones por usuario
CREATE OR REPLACE VIEW v_max_hobbies AS
SELECT MAX(n.total) AS max
FROM v_hobbies_per_user n;

SELECT m.max
FROM v_max_hobbies m;

-- RF15: Usuarios con el máximo número de aficiones
SELECT u.user_id, u.full_name
FROM users u
JOIN v_hobbies_per_user n ON n.user_id = u.user_id
WHERE n.total = (SELECT m.max FROM v_max_hobbies m);

-- RF16: Usuarios con todas las aficiones
-- División: no hay ninguna afición del catálogo que el usuario no tenga
SELECT u.full_name, u.user_id
FROM users u
WHERE NOT EXISTS (
    SELECT *
    FROM hobbies h
    WHERE NOT EXISTS (
        SELECT *
        FROM users_hobbies uh
        WHERE uh.user_id = u.user_id
          AND uh.hobby_id = h.hobby_id
    )
);
