-- ============================================================
-- LA CASA DE MANDI — Seed (datos de prueba)
-- Ejecutar DESPUÉS de schema.sql
-- ============================================================

USE la_casa_de_mandi;

-- ============================================================
-- 1. SEED — Categorías
-- ============================================================

INSERT INTO Categoria (nombre) VALUES
  ('Dulces'),
  ('Postres');

-- ============================================================
-- 2. SEED — Catálogo: DULCES (id_categoria = 1)
-- (No se siembra cuenta de Administrador: se crea por fuera del seed,
--  directamente en la tabla Administrador cuando se monte el ambiente real)
-- ============================================================

INSERT INTO Producto (id_categoria, nombre, descripcion, disponible) VALUES
  (1, 'Delicia Tres Leches Frutal', 'Bizcocho tres leches decorado con fresas frescas y melocotón, suave y húmedo.', TRUE),
  (1, 'Cheesecake Tropical de Maracuyá', 'Cheesecake cremoso con cobertura de maracuyá natural y sabor tropical.', TRUE),
  (1, 'Fresas & Crema', 'Pastel relleno de fresas frescas y crema suave, ideal para celebraciones.', TRUE),
  (1, 'Chocoflan de Fresas', 'Combinación de flan y pastel de chocolate decorado con fresas frescas.', TRUE),
  (1, 'Melocotón & Crema', 'Pastel relleno de melocotón y crema, con textura ligera y sabor delicado.', TRUE),
  (1, 'Cheesecake Frutos del Bosque', 'Cheesecake cremoso cubierto con una selección de frutos rojos.', TRUE),
  (1, 'Dulce Tentación de Leche', 'Pastel relleno de crema de dulce de leche, con sabor intenso y suave.', TRUE);

-- Variantes de tamaño para cada dulce (precios tomados del catálogo real)

-- Delicia Tres Leches Frutal (id_producto = 1)
INSERT INTO Producto_Variante (id_producto, tamano, precio_base, disponible) VALUES
  (1, '6"', 35.00, TRUE),
  (1, '8"', 45.00, TRUE),
  (1, '10"', 55.00, TRUE);

-- Cheesecake Tropical de Maracuyá (id_producto = 2)
INSERT INTO Producto_Variante (id_producto, tamano, precio_base, disponible) VALUES
  (2, '6"', 18.00, TRUE),
  (2, '8"', 25.00, TRUE),
  (2, '10"', 35.00, TRUE);

-- Fresas & Crema (id_producto = 3)
INSERT INTO Producto_Variante (id_producto, tamano, precio_base, disponible) VALUES
  (3, '6"', 15.00, TRUE),
  (3, '8"', 25.00, TRUE),
  (3, '10"', 40.00, TRUE);

-- Chocoflan de Fresas (id_producto = 4)
INSERT INTO Producto_Variante (id_producto, tamano, precio_base, disponible) VALUES
  (4, '6"', 15.00, TRUE),
  (4, '8"', 28.00, TRUE),
  (4, '10"', 40.00, TRUE);

-- Melocotón & Crema (id_producto = 5)
INSERT INTO Producto_Variante (id_producto, tamano, precio_base, disponible) VALUES
  (5, '6"', 15.00, TRUE),
  (5, '8"', 25.00, TRUE),
  (5, '10"', 40.00, TRUE);

-- Cheesecake Frutos del Bosque (id_producto = 6)
INSERT INTO Producto_Variante (id_producto, tamano, precio_base, disponible) VALUES
  (6, '6"', 18.00, TRUE),
  (6, '8"', 25.00, TRUE),
  (6, '10"', 35.00, TRUE);

-- Dulce Tentación de Leche (id_producto = 7)
INSERT INTO Producto_Variante (id_producto, tamano, precio_base, disponible) VALUES
  (7, '6"', 25.00, TRUE),
  (7, '8"', 35.00, TRUE),
  (7, '10"', 45.00, TRUE);

-- ============================================================
-- 3. SEED — Catálogo: POSTRES / Rebanadas Triangulares (id_categoria = 2)
-- Cada postre tiene una sola variante ("Porción individual"), sin selector de tamaño
-- ============================================================

INSERT INTO Producto (id_categoria, nombre, descripcion, disponible) VALUES
  (2, 'Cheesecake Tropical de Maracuyá (porción)', 'Porción individual de cheesecake con cobertura de maracuyá.', TRUE),
  (2, 'Cheesecake Caramelo de Maracuyá', 'Porción individual de cheesecake con salsa de maracuyá y caramelo.', TRUE),
  (2, 'Cheesecake Frutos del Bosque (porción)', 'Porción individual de cheesecake cubierto con frutos rojos.', TRUE);

-- Variantes (única por producto, representa la porción individual)
-- Cheesecake Tropical de Maracuyá porción (id_producto = 8)
INSERT INTO Producto_Variante (id_producto, tamano, precio_base, disponible) VALUES
  (8, 'Porción individual', 3.00, TRUE);

-- Cheesecake Caramelo de Maracuyá (id_producto = 9)
INSERT INTO Producto_Variante (id_producto, tamano, precio_base, disponible) VALUES
  (9, 'Porción individual', 3.00, TRUE);

-- Cheesecake Frutos del Bosque porción (id_producto = 10)
INSERT INTO Producto_Variante (id_producto, tamano, precio_base, disponible) VALUES
  (10, 'Porción individual', 3.00, TRUE);

-- ============================================================
-- 4. SEED — Clientes de prueba
-- Password real para todos: "cliente123"
-- Hashes generados con password_hash('cliente123', PASSWORD_BCRYPT) en PHP — son reales y funcionan
-- ============================================================

INSERT INTO Cliente (nombre, telefono, whatsapp, correo, password) VALUES
  ('Ana Pérez',        '6000-0001', '6000-0001', 'ana.perez@gmail.com',      '$2y$10$trIeLS/0v2wkrxKI7t2ZvuOYC/HH2.s.Osa74zutxsMBLx4qjhYZq'),
  ('Carlos Gómez',     '6000-0002', '6000-0002', 'carlos.gomez@gmail.com',   '$2y$10$c0bfz8mzqfDfJRP9gfuPzenEgk1/EdxI.GNrkwnOFuBjG/FRKTCey'),
  ('María Rodríguez',  '6000-0003', '6000-0003', 'maria.rodriguez@gmail.com','$2y$10$v.IayMeFpQMoNJIO3oizVOYivKBQ7DYe6hPYgZ8ivvjWwCMp.QzXW'),
  ('Luis Fernández',   '6000-0004', '6000-0004', 'luis.fernandez@gmail.com', '$2y$10$PLQiFcJPIwO90shMKATJFONBXPdwXLKVMOFX6LYD9UFq/BkLwgxNy'),
  ('Daniela Castillo', '6000-0005', '6000-0005', 'daniela.castillo@gmail.com','$2y$10$Ib8.OogsZ/pmdKEpAC/5O.OUYDUvJn2SMjhBC5EdanxwgEwQzSvl6');

-- ============================================================
-- 5. SEED — Capacidad de entrega (próximos días con cupos)
-- ============================================================

INSERT INTO Capacidad_Entrega (fecha, pedidos_confirmados, limite_diario) VALUES
  (CURDATE() + INTERVAL 2 DAY, 0, 5),
  (CURDATE() + INTERVAL 3 DAY, 0, 5),
  (CURDATE() + INTERVAL 4 DAY, 0, 5),
  (CURDATE() + INTERVAL 5 DAY, 0, 5),
  (CURDATE() + INTERVAL 6 DAY, 0, 5),
  (CURDATE() + INTERVAL 7 DAY, 0, 5);

-- ============================================================
-- 6. SEED — Pedidos de ejemplo (cubren todos los estados del flujo)
-- ============================================================

-- Pedido 1 — Ana Pérez — Dulce — Pendiente (recién enviado, sin precio fijado)
INSERT INTO Pedido (id_cliente, fecha_entrega, descripcion_diseno, estado, precio_total, precio_confirmado)
VALUES (1, CURDATE() + INTERVAL 5 DAY,
  'Torta de Tres Leches con decoración de flores rosadas, para cumpleaños de 15 años.',
  'Pendiente', 45.00, FALSE);

INSERT INTO Pedido_Variante (id_pedido, id_variante, cantidad, precio_unitario)
VALUES (1, 2, 1, 45.00); -- Tres Leches 8"

-- Pedido 2 — Carlos Gómez — Dulce — Aceptado (precio ya fijado, esperando abono)
INSERT INTO Pedido (id_cliente, fecha_entrega, descripcion_diseno, estado, precio_total, precio_confirmado)
VALUES (2, CURDATE() + INTERVAL 4 DAY,
  'Cheesecake de Maracuyá con topping extra de fruta y nombre escrito en chocolate.',
  'Aceptado', 30.00, TRUE);

INSERT INTO Pedido_Variante (id_pedido, id_variante, cantidad, precio_unitario)
VALUES (2, 5, 1, 30.00); -- Cheesecake Tropical 8" (ajustado de 25 a 30 por el admin)

-- Pedido 3 — María Rodríguez — Dulce — En producción (abono confirmado)
INSERT INTO Pedido (id_cliente, fecha_entrega, descripcion_diseno, estado, precio_total, precio_confirmado)
VALUES (3, CURDATE() + INTERVAL 3 DAY,
  'Fresas & Crema tamaño grande para aniversario, decoración elegante en blanco y dorado.',
  'En produccion', 40.00, TRUE);

INSERT INTO Pedido_Variante (id_pedido, id_variante, cantidad, precio_unitario)
VALUES (3, 9, 1, 40.00); -- Fresas & Crema 10"

INSERT INTO Abono (id_pedido, monto, porcentaje, fecha_pago, metodo_pago, referencia, confirmado, fecha_confirmacion)
VALUES (3, 20.00, 50.00, CURDATE() - INTERVAL 1 DAY, 'Yappy', 'YP-882341', TRUE, CURDATE());

-- Pedido 4 — Luis Fernández — Dulce — Listo (en producción terminada, esperando pago final)
INSERT INTO Pedido (id_cliente, fecha_entrega, descripcion_diseno, estado, precio_total, precio_confirmado)
VALUES (4, CURDATE() + INTERVAL 1 DAY,
  'Chocoflan de Fresas mediano, sin decoraciones adicionales.',
  'Listo', 28.00, TRUE);

INSERT INTO Pedido_Variante (id_pedido, id_variante, cantidad, precio_unitario)
VALUES (4, 11, 1, 28.00); -- Chocoflan 8"

INSERT INTO Abono (id_pedido, monto, porcentaje, fecha_pago, metodo_pago, referencia, confirmado, fecha_confirmacion)
VALUES (4, 14.00, 50.00, CURDATE() - INTERVAL 3 DAY, 'Transferencia', 'TR-559012', TRUE, CURDATE() - INTERVAL 2 DAY);

-- Pedido 5 — Daniela Castillo — Postres — Entregado (ciclo completo)
INSERT INTO Pedido (id_cliente, fecha_entrega, descripcion_diseno, estado, precio_total, precio_confirmado)
VALUES (5, CURDATE() - INTERVAL 1 DAY,
  NULL,
  'Entregado', 15.00, TRUE);

INSERT INTO Pedido_Variante (id_pedido, id_variante, cantidad, precio_unitario)
VALUES (5, 18, 5, 3.00); -- 5 porciones de Cheesecake Frutos del Bosque (porción)

INSERT INTO Abono (id_pedido, monto, porcentaje, fecha_pago, metodo_pago, referencia, confirmado, fecha_confirmacion)
VALUES (5, 7.50, 50.00, CURDATE() - INTERVAL 4 DAY, 'Efectivo', NULL, TRUE, CURDATE() - INTERVAL 4 DAY);

INSERT INTO Pago_Final (id_pedido, monto, fecha_pago, metodo_pago, referencia, confirmado, fecha_confirmacion)
VALUES (5, 7.50, CURDATE() - INTERVAL 1 DAY, 'Yappy', 'YP-991123', TRUE, CURDATE() - INTERVAL 1 DAY);

-- Pedido 6 — Ana Pérez — Postres — Pendiente (pedido simple sin diseño)
INSERT INTO Pedido (id_cliente, fecha_entrega, descripcion_diseno, estado, precio_total, precio_confirmado)
VALUES (1, CURDATE() + INTERVAL 2 DAY, NULL, 'Pendiente', 9.00, FALSE);

INSERT INTO Pedido_Variante (id_pedido, id_variante, cantidad, precio_unitario)
VALUES (6, 19, 3, 3.00); -- 3 porciones de Cheesecake Caramelo de Maracuyá

-- Pedido 7 — Carlos Gómez — Dulce — Rechazado (sin capacidad esa fecha)
INSERT INTO Pedido (id_cliente, fecha_entrega, descripcion_diseno, estado, precio_total, precio_confirmado)
VALUES (2, CURDATE() + INTERVAL 6 DAY,
  'Torta de Dulce de Leche grande con decoración de mariposas comestibles.',
  'Rechazado', 45.00, FALSE);

INSERT INTO Pedido_Variante (id_pedido, id_variante, cantidad, precio_unitario)
VALUES (7, 21, 1, 45.00); -- Dulce Tentación de Leche 10"

-- Pedido 8 — María Rodríguez — Dulce — Cancelado (cliente canceló antes de ser aceptado)
INSERT INTO Pedido (id_cliente, fecha_entrega, descripcion_diseno, estado, precio_total, precio_confirmado)
VALUES (3, CURDATE() + INTERVAL 7 DAY,
  'Melocotón & Crema chico para reunión familiar.',
  'Cancelado', 15.00, FALSE);

INSERT INTO Pedido_Variante (id_pedido, id_variante, cantidad, precio_unitario)
VALUES (8, 14, 1, 15.00); -- Melocotón & Crema 6"

-- ============================================================
-- 7. Actualizar contadores de Capacidad_Entrega según los seeds
-- (Solo se cuentan pedidos con estado >= Aceptado, según la regla de negocio)
-- ============================================================

UPDATE Capacidad_Entrega SET pedidos_confirmados = 1 WHERE fecha = CURDATE() + INTERVAL 1 DAY;  -- Pedido 4
UPDATE Capacidad_Entrega SET pedidos_confirmados = 1 WHERE fecha = CURDATE() + INTERVAL 3 DAY;  -- Pedido 3
UPDATE Capacidad_Entrega SET pedidos_confirmados = 1 WHERE fecha = CURDATE() + INTERVAL 4 DAY;  -- Pedido 2

-- ============================================================
-- FIN DEL SEED
-- ============================================================
