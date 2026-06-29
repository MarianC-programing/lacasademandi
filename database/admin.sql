-- ============================================================
-- LA CASA DE MANDI — Cuenta de Administrador
-- Ejecutar UNA SOLA VEZ después de schema.sql y seed.sql
-- NO es necesario rehacer la base de datos completa
-- ============================================================

USE la_casa_de_mandi;

INSERT INTO Administrador (nombre, correo, password) VALUES (
    'Mandi',
    'mandi.admin@gmail.com',
    '$2a$10$6QaiAtB7ihuZgG.bRLPQQe/Tr2MDRe1ZD0MLztBVZq6rRCyqDsxnW'
);

-- Hash generado con jBCrypt (Java) para password 'MandiWorld'

-- Verificar inserción:
-- SELECT id_admin, nombre, correo FROM Administrador;
