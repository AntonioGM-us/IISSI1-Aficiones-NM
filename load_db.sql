--
-- Autor: David Ruiz
-- Fecha: Octubre de 2026
-- Descripción: Carga la BD de Aficiones dinámicas
--

-- BD de Aficiones Dinámicas
SELECT '>>> Creando BD hobbies_nm_db';
SOURCE create_db.sql;
SOURCE populate_db.sql;
SOURCE procedures.sql;
SOURCE transactions.sql;
