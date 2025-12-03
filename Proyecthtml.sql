-- --------- 1) Crear la base de datos ---------
DROP DATABASE IF EXISTS inventario_db;
CREATE DATABASE IF NOT EXISTS inventario_db
  DEFAULT CHARACTER SET = utf8mb4
  DEFAULT COLLATE = utf8mb4_unicode_ci;

USE inventario_db;

-- --------- 2) Tabla CORE (administrativo) pdt: me quiero morir ---------
CREATE TABLE administrativo (
    id_admin INT AUTO_INCREMENT PRIMARY KEY,
    area_nombre VARCHAR(100) NOT NULL,
    responsable VARCHAR(100),
    ubicacion VARCHAR(150),
    fecha_registro DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT uq_area_nombre UNIQUE (area_nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------- 3) Tabla 1 - Cultura Digital (PC, teclados, ratones) ---------
CREATE TABLE cultura_digital (
    id_cd INT AUTO_INCREMENT PRIMARY KEY,
    id_admin INT NOT NULL,
    tipo_equipo ENUM('PC','Teclado','Raton') NOT NULL,
    marca VARCHAR(100),
    modelo VARCHAR(100),
    serie VARCHAR(100),
    cantidad INT NOT NULL DEFAULT 1,
    estado ENUM('Nuevo','Usado','Dañado') DEFAULT 'Nuevo',
    fecha_ingreso DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (id_admin) REFERENCES administrativo(id_admin)
      ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------- 4) Tabla 2 - Mecatrónica ---------
CREATE TABLE mecatronica (
    id_meca INT AUTO_INCREMENT PRIMARY KEY,
    id_admin INT NOT NULL,
    componente VARCHAR(150) NOT NULL,
    referencia VARCHAR(100),
    descripcion TEXT,
    cantidad INT NOT NULL DEFAULT 1,
    estado ENUM('Nuevo','Usado','Dañado') DEFAULT 'Nuevo',
    fecha_ingreso DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (id_admin) REFERENCES administrativo(id_admin)
      ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------- 5) Tabla 3 - Mantenimiento ---------
CREATE TABLE mantenimiento (
    id_mant INT AUTO_INCREMENT PRIMARY KEY,
    id_admin INT NOT NULL,
    herramienta VARCHAR(150) NOT NULL,
    descripcion TEXT,
    cantidad INT NOT NULL DEFAULT 1,
    ubicacion_almacen VARCHAR(150),
    estado ENUM('Nuevo','Usado','Dañado') DEFAULT 'Nuevo',
    fecha_ingreso DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (id_admin) REFERENCES administrativo(id_admin)
      ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------- 6)  Tabla 5 - Fuentes Alternas ---------
CREATE TABLE fuentes_alternas (
    id_fa INT AUTO_INCREMENT PRIMARY KEY,
    id_admin INT NOT NULL,
    tipo_fuente ENUM('Solar','Eolica','Hidraulica','Biomasa','Geotermica','Otro') NOT NULL,
    modelo VARCHAR(150),
    descripcion TEXT,
    capacidad_kw DECIMAL(10,2),
    estado ENUM('Operativa','Mantenimiento','Fuera de servicio') DEFAULT 'Operativa',
    fecha_instalacion DATE,
    FOREIGN KEY (id_admin) REFERENCES administrativo(id_admin)
      ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------- 7) Datos de ejemplo ---------
INSERT INTO administrativo (area_nombre, responsable, ubicacion)
VALUES ('Sala Administrativa 1', 'Juan Pérez', 'Edificio A - 1er piso'),
       ('Laboratorio Mecatronica', 'María López', 'Edificio B - 2do piso'),
       ('Taller Mantenimiento', 'Carlos Ruiz', 'Planta - Nivel 0');

INSERT INTO cultura_digital (id_admin, tipo_equipo, marca, modelo, cantidad, serie)
VALUES (1, 'PC', 'Dell', 'Optiplex 3050', 10, 'SN-D3050-001'),
       (1, 'Teclado', 'Logitech', 'K120', 15, 'SN-K120-091'),
       (1, 'Raton', 'Microsoft', 'Basic', 20, 'SN-MB-117');

INSERT INTO mecatronica (id_admin, componente, referencia, descripcion, cantidad)
VALUES (2, 'Sensor Ultrasónico', 'HC-SR04', 'Sensor distancia 2cm-400cm', 25),
       (2, 'Motor paso a paso', 'NEMA17', 'Motor para prototipos', 8);

INSERT INTO mantenimiento (id_admin, herramienta, descripcion, cantidad, ubicacion_almacen)
VALUES (3, 'Destornillador Phillips', 'Phillips mediano 4mm', 40, 'Estanteria A1'),
       (3, 'Multímetro', 'Multímetro digital', 5, 'Armario B2');

INSERT INTO fuentes_alternas (id_admin, tipo_fuente, modelo, descripcion, capacidad_kw, fecha_instalacion)
VALUES (1, 'Solar', 'Panel-350W', 'Panel policristalino 350W', 0.35, '2024-06-15'),
       (2, 'Eolica', 'MiniTurbina-2kW', 'Turbina experimental 2kW', 2.00, '2023-11-01');

-- --------- 8) Vista agregada para ver todo el inventario en una sola consulta ---------
CREATE OR REPLACE VIEW inventario_general AS
SELECT
  a.id_admin,
  a.area_nombre AS area,
  a.responsable,
  'Cultura Digital' AS categoria,
  cd.tipo_equipo AS item,
  cd.marca,
  cd.modelo,
  cd.cantidad,
  cd.estado,
  cd.fecha_ingreso
FROM administrativo a
JOIN cultura_digital cd ON a.id_admin = cd.id_admin

UNION ALL

SELECT
  a.id_admin,
  a.area_nombre AS area,
  a.responsable,
  'Mecatronica' AS categoria,
  m.componente AS item,
  m.referencia AS marca,
  NULL AS modelo,
  m.cantidad,
  m.estado,
  m.fecha_ingreso
FROM administrativo a
JOIN mecatronica m ON a.id_admin = m.id_admin

UNION ALL

SELECT
  a.id_admin,
  a.area_nombre AS area,
  a.responsable,
  'Mantenimiento' AS categoria,
  mt.herramienta AS item,
  NULL AS marca,
  NULL AS modelo,
  mt.cantidad,
  mt.estado,
  mt.fecha_ingreso
FROM administrativo a
JOIN mantenimiento mt ON a.id_admin = mt.id_admin

UNION ALL

SELECT
  a.id_admin,
  a.area_nombre AS area,
  a.responsable,
  'Fuentes Alternas' AS categoria,
  fa.tipo_fuente AS item,
  fa.modelo AS marca,
  CAST(fa.capacidad_kw AS CHAR) AS modelo,
  IFNULL(fa.capacidad_kw,0) AS cantidad,
  fa.estado,
  fa.fecha_instalacion AS fecha_ingreso
FROM administrativo a
JOIN fuentes_alternas fa ON a.id_admin = fa.id_admin;

-- --------- 9) Consultas útiles ---------
-- Ver todo el inventario consolidado
SELECT * FROM inventario_general ORDER BY area, categoria;

-- Conteo total por área y categoría
SELECT area, categoria, SUM(cantidad) AS total_unidades
FROM inventario_general
GROUP BY area, categoria
ORDER BY area, categoria;
