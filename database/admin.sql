-- ============================================================
-- LA CASA DE MANDI — Cuenta de Administrador
-- Ejecutar UNA SOLA VEZ después de schema.sql y seed.sql
-- NO es necesario rehacer la base de datos completa
-- ============================================================

USE la_casa_de_mandi;

INSERT INTO Administrador (nombre, correo, password) VALUES (
    'Mandi',
    'mandi.admin@gmail.com',
    '$2y$10$x1ZpChL9bk/O.8VcQpPMhuNnRw0k.WPn5kCf/29/GA46QWX9ben4q'
);

-- Hash generado con password_hash('MandiWorld', PASSWORD_BCRYPT) — verificado
-- Para validar en Java usar BCrypt.checkpw(passwordIngresada, hashGuardado) con jBCrypt

-- Verificar inserción:
-- SELECT id_admin, nombre, correo FROM Administrador;
