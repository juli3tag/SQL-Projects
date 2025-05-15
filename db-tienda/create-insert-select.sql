-- Gonzalez Julieta 🌷

-- Seccion 1 - Creacion de tablas de la base de datos
CREATE DATABASE IF NOT EXISTS Tienda;
USE Tienda;

-- Tabla Clientes
CREATE TABLE Clientes (
    idcliente INT PRIMARY KEY AUTO_INCREMENT,
    Apellido VARCHAR(50) NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Direccion VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE
);

-- Tabla Proveedores
CREATE TABLE Proveedores (
    idproveedor INT PRIMARY KEY AUTO_INCREMENT,
    NombreProveedor VARCHAR(100) NOT NULL,
    Direccion VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE
);

-- Tabla Vendedor
CREATE TABLE Vendedor (
    idvendedor INT PRIMARY KEY AUTO_INCREMENT,
    Apellido VARCHAR(50) NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Comision DECIMAL(5,2) NOT NULL
    -- Puedes controlar Comision >= 0 mediante una lógica en la app
);

-- Tabla Productos
CREATE TABLE Productos (
    idproducto INT PRIMARY KEY AUTO_INCREMENT,
    Descripcion VARCHAR(100) NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL,
    StockMax INT NOT NULL,
    StockMin INT NOT NULL,
    idproveedor INT NOT NULL,
    Origen ENUM('nacional', 'importado') NOT NULL,
    FOREIGN KEY (idproveedor) REFERENCES Proveedores(idproveedor)
    -- Reglas de Stock entre Min y Max deben manejarse en la app
);

-- Tabla Pedidos
CREATE TABLE Pedidos (
    NumeroPedido INT PRIMARY KEY AUTO_INCREMENT,
    idcliente INT NOT NULL,
    idvendedor INT NOT NULL,
    Fecha DATE NOT NULL,
    Estado ENUM('pendiente', 'confirmado', 'anulado') DEFAULT 'pendiente',
    FOREIGN KEY (idcliente) REFERENCES Clientes(idcliente),
    FOREIGN KEY (idvendedor) REFERENCES Vendedor(idvendedor)
);

-- Tabla DetallePedidos
CREATE TABLE DetallePedidos (
    NumeroPedido INT,
    Renglon INT,
    idproducto INT,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (NumeroPedido, Renglon),
    FOREIGN KEY (NumeroPedido) REFERENCES Pedidos(NumeroPedido),
    FOREIGN KEY (idproducto) REFERENCES Productos(idproducto)
    -- Total calculado manualmente si se requiere
);

-- Tabla LogAnulaciones
CREATE TABLE LogAnulaciones (
    idlog INT PRIMARY KEY AUTO_INCREMENT,
    NumeroPedido INT NOT NULL,
    Fecha_Anulacion DATE NOT NULL,
    FOREIGN KEY (NumeroPedido) REFERENCES Pedidos(NumeroPedido)
);


--  Seccion 2 - Insercion de datos

-- Clientes
INSERT INTO Clientes (Apellido, Nombre, Direccion, Email) VALUES
('Perez', 'Juan', 'Calle Falsa 123', 'juan.perez@mail.com'),
('Gomez', 'Ana', 'Av. Siempreviva 742', 'ana.gomez@mail.com'),
('Lopez', 'Maria', 'Mitre 456', 'maria.lopez@mail.com'),
('Fernandez', 'Carlos', 'Sarmiento 321', 'carlos.fernandez@mail.com'),
('Rodriguez', 'Lucia', 'Belgrano 789', 'lucia.rodriguez@mail.com'),
('Potter', 'Harry', 'Privet Drive 4', 'harrypotter@mail.com');

-- Proveedores
INSERT INTO Proveedores (NombreProveedor, Direccion, Email) VALUES
('Distribuidora Andina', 'Av. Argentina 123', 'contacto@andina.com'),
('Frutas del Sur', 'Ruta 22 KM 5', 'ventas@frutasdelsur.com'),
('Importadora GlobalFood', 'Calle Comercio 567', 'info@globalfood.com');

-- Vendedores
INSERT INTO Vendedor (Apellido, Nombre, Email, Comision) VALUES
('Sanchez', 'Luis', 'luis.sanchez@empresa.com', 5.0),
('Moreno', 'Elena', 'elena.moreno@empresa.com', 7.5),
('Diaz', 'Roberto', 'roberto.diaz@empresa.com', 6.0);

-- Productos
INSERT INTO Productos (Descripcion, PrecioUnitario, Stock, StockMax, StockMin, idproveedor, Origen) VALUES
('Arroz Integral 1kg', 250.00, 50, 100, 20, 1, 'nacional'),
('Aceite de Oliva 500ml', 800.00, 30, 60, 10, 3, 'importado'),
('Yerba Mate 1kg', 600.00, 80, 100, 30, 1, 'nacional'),
('Cafe en grano 500g', 1200.00, 20, 50, 5, 3, 'importado'),
('Lentejas 500g', 350.00, 60, 80, 20, 1, 'nacional'),
('Manzanas Rojas 1kg', 400.00, 70, 100, 30, 2, 'nacional'),
('Bananas 1kg', 300.00, 90, 120, 40, 2, 'nacional'),
('Chocolate Amargo 100g', 500.00, 40, 70, 15, 3, 'importado'),
('Queso Rallado 200g', 450.00, 35, 60, 20, 1, 'nacional'),
('Mermelada de Frutilla 454g', 550.00, 45, 70, 25, 2, 'nacional');

-- Pedidos + Detalles

-- Pedido 1
INSERT INTO Pedidos (idcliente, idvendedor, Fecha, Estado) VALUES (1, 1, '2024-04-01', 'confirmado');
INSERT INTO DetallePedidos VALUES
(1, 1, 1, 2, 250.00),
(1, 2, 5, 1, 350.00);

-- Pedido 2
INSERT INTO Pedidos (idcliente, idvendedor, Fecha, Estado) VALUES (2, 2, '2024-04-03', 'confirmado');
INSERT INTO DetallePedidos VALUES
(2, 1, 3, 3, 600.00);

-- Pedido 3
INSERT INTO Pedidos (idcliente, idvendedor, Fecha, Estado) VALUES (3, 3, '2024-04-05', 'confirmado');
INSERT INTO DetallePedidos VALUES
(3, 1, 4, 1, 1200.00),
(3, 2, 8, 2, 500.00);

-- Pedido 4
INSERT INTO Pedidos (idcliente, idvendedor, Fecha, Estado) VALUES (4, 1, '2024-04-06', 'confirmado');
INSERT INTO DetallePedidos VALUES
(4, 1, 6, 3, 400.00);

-- Pedido 5
INSERT INTO Pedidos (idcliente, idvendedor, Fecha, Estado) VALUES (5, 2, '2024-04-06', 'confirmado');
INSERT INTO DetallePedidos VALUES
(5, 1, 7, 4, 300.00);

-- Pedido 6
INSERT INTO Pedidos (idcliente, idvendedor, Fecha, Estado) VALUES (1, 3, '2024-04-07', 'confirmado');
INSERT INTO DetallePedidos VALUES
(6, 1, 2, 1, 800.00),
(6, 2, 9, 2, 450.00);

-- Pedido 7
INSERT INTO Pedidos (idcliente, idvendedor, Fecha, Estado) VALUES (2, 1, '2024-04-08', 'confirmado');
INSERT INTO DetallePedidos VALUES
(7, 1, 10, 2, 550.00);

-- Pedido 8
INSERT INTO Pedidos (idcliente, idvendedor, Fecha, Estado) VALUES (3, 2, '2024-04-08', 'confirmado');
INSERT INTO DetallePedidos VALUES
(8, 1, 5, 2, 350.00),
(8, 2, 6, 1, 400.00);

-- Pedido 9
INSERT INTO Pedidos (idcliente, idvendedor, Fecha, Estado) VALUES (1, 1, '2024-04-10', 'pendiente');
INSERT INTO DetallePedidos VALUES
(9, 1, 3, 1, 600.00);

-- Pedido 10 (anulado)
INSERT INTO Pedidos (idcliente, idvendedor, Fecha, Estado) VALUES (2, 3, '2024-04-11', 'anulado');
INSERT INTO DetallePedidos VALUES
(10, 1, 1, 1, 250.00);

-- Registro en LogAnulaciones
INSERT INTO LogAnulaciones (NumeroPedido, Fecha_Anulacion) VALUES
(10, '2024-04-12');


-- Consultas SQL solicitadas

-- Detalle de clientes que realizaron pedidos entre fechas (apellido, nombres, DNI, correo electr�nico)
SELECT c.Apellido, c.Nombre, c.Direccion, c.Email
FROM Clientes c
JOIN Pedidos p ON c.idcliente = p.idcliente
WHERE p.Fecha BETWEEN '2024-01-01' AND '2024-12-31';

-- Detalle de vendedores con la cantidad de pedidos realizados (apellido, nombres, DNI, correo electronico, CantidadPedidos)
SELECT v.Apellido, v.Nombre, v.Email, COUNT(p.NumeroPedido) AS CantidadPedidos
FROM Vendedor v
LEFT JOIN Pedidos p ON v.idvendedor = p.idvendedor
GROUP BY v.Apellido, v.Nombre, v.Email;

-- Detalle de pedidos con un total mayor a un determinado valor umbral (NumeroPedido, fecha, TotalPedido)
SELECT p.NumeroPedido, p.Fecha, SUM(dp.Cantidad * dp.PrecioUnitario) AS TotalPedido
FROM Pedidos p
JOIN DetallePedidos dp ON p.NumeroPedido = dp.NumeroPedido
GROUP BY p.NumeroPedido, p.Fecha
HAVING SUM(dp.Cantidad * dp.PrecioUnitario) > 1000.00;  

-- Lista de productos vendidos entre fechas (Descripcion, CantidadTotal)
SELECT pr.Descripcion, SUM(dp.Cantidad) AS CantidadTotal
FROM Productos pr
JOIN DetallePedidos dp ON pr.idproducto = dp.idproducto
JOIN Pedidos p ON dp.NumeroPedido = p.NumeroPedido
WHERE p.Fecha BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY pr.Descripcion;

-- Cual es el proveedor que realizo mas productos vendidos?
SELECT pr.idproveedor, pv.NombreProveedor, SUM(dp.Cantidad) AS CantidadVendida
FROM DetallePedidos dp
JOIN Productos pr ON dp.idproducto = pr.idproducto
JOIN Proveedores pv ON pr.idproveedor = pv.idproveedor
GROUP BY pr.idproveedor, pv.NombreProveedor
ORDER BY CantidadVendida DESC
LIMIT 1;

-- Detalle de clientes registrados que nunca realizaron un pedido (apellido, nombres, e-mail)
SELECT c.Apellido, c.Nombre, c.Email
FROM Clientes c
LEFT JOIN Pedidos p ON c.idcliente = p.idcliente
WHERE p.NumeroPedido IS NULL;

-- Detalle de clientes que realizaron menos de dos pedidos (apellido, nombres, e-mail)
SELECT c.Apellido, c.Nombre, c.Email
FROM Clientes c
JOIN Pedidos p ON c.idcliente = p.idcliente
GROUP BY c.Apellido, c.Nombre, c.Email
HAVING COUNT(p.NumeroPedido) < 2;

-- Cantidad total vendida por origen de producto
SELECT pr.Origen, SUM(dp.Cantidad) AS CantidadTotalVendida
FROM DetallePedidos dp
JOIN Productos pr ON dp.idproducto = pr.idproducto
GROUP BY pr.Origen;

