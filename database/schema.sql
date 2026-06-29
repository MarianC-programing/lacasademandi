-- ============================================================
-- LA CASA DE MANDI — Esquema de Base de Datos
-- Proyecto Semestral Programación 2
-- ============================================================

CREATE DATABASE IF NOT EXISTS la_casa_de_mandi
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE la_casa_de_mandi;

-- ============================================================
-- 1. TABLAS BASE (sin dependencias)
-- ============================================================

CREATE TABLE Categoria (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  telefono VARCHAR(20) NOT NULL,
  whatsapp VARCHAR(20) NOT NULL UNIQUE,
  correo VARCHAR(150) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Administrador (
  id_admin INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  correo VARCHAR(150) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL
);

CREATE TABLE Capacidad_Entrega (
  id_capacidad INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATE NOT NULL UNIQUE,
  pedidos_confirmados INT NOT NULL DEFAULT 0,
  limite_diario INT NOT NULL DEFAULT 5
);

-- ============================================================
-- 2. CATÁLOGO (depende de Categoria)
-- ============================================================

CREATE TABLE Producto (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  id_categoria INT NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  descripcion TEXT,
  imagen VARCHAR(255),
  disponible BOOLEAN NOT NULL DEFAULT TRUE,
  FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

CREATE TABLE Producto_Variante (
  id_variante INT AUTO_INCREMENT PRIMARY KEY,
  id_producto INT NOT NULL,
  tamano VARCHAR(50) NOT NULL,
  precio_base DECIMAL(10,2) NOT NULL,
  disponible BOOLEAN NOT NULL DEFAULT TRUE,
  FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

-- ============================================================
-- 3. PEDIDOS (depende de Cliente y de las variantes)
-- ============================================================

CREATE TABLE Pedido (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
  fecha_entrega DATE NOT NULL,
  descripcion_diseno TEXT,
  estado ENUM('Pendiente','Aceptado','Rechazado','En produccion','Listo','Entregado','Cancelado')
    NOT NULL DEFAULT 'Pendiente',
  precio_total DECIMAL(10,2) NOT NULL DEFAULT 0,
  precio_confirmado BOOLEAN NOT NULL DEFAULT FALSE,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Pedido_Variante (
  id_pedido_variante INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_variante INT NOT NULL,
  cantidad INT NOT NULL DEFAULT 1,
  precio_unitario DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
  FOREIGN KEY (id_variante) REFERENCES Producto_Variante(id_variante)
);

-- ============================================================
-- 4. PAGOS (1:1 con Pedido)
-- ============================================================

CREATE TABLE Abono (
  id_abono INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL UNIQUE,
  monto DECIMAL(10,2) NOT NULL,
  porcentaje DECIMAL(5,2) NOT NULL,
  fecha_pago DATE NOT NULL,
  metodo_pago ENUM('Yappy','Efectivo','Transferencia') NOT NULL,
  referencia VARCHAR(100),
  confirmado BOOLEAN NOT NULL DEFAULT FALSE,
  fecha_confirmacion DATE,
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

CREATE TABLE Pago_Final (
  id_pago_final INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL UNIQUE,
  monto DECIMAL(10,2) NOT NULL,
  fecha_pago DATE NOT NULL,
  metodo_pago ENUM('Yappy','Efectivo','Transferencia') NOT NULL,
  referencia VARCHAR(100),
  confirmado BOOLEAN NOT NULL DEFAULT FALSE,
  fecha_confirmacion DATE,
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

-- ============================================================
-- FIN DEL ESQUEMA
-- ============================================================
