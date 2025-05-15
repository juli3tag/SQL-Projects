-- Gonzalez Julieta 🌷

CREATE DATABASE IF NOT EXISTS Tienda;
USE Tienda;

-- Crear tabla auxiliar temporal para el detalle
CREATE TABLE IF NOT EXISTS DetalleTemp (
	idproducto INT,
    cantidad INT,
    precioUnitario DECIMAL(10,2)
);


DELIMITER $$

CREATE PROCEDURE RegistrarPedidoConDetalle (
	IN p_idcliente INT,
    IN p_idvendedor INT,
    IN p_fecha date
)
BEGIN
	DECLARE v_NumeroPedido INT;
    DECLARE done INT DEFAULT 0;
    
    -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SELECT 'Error al registrar el pedido. Se cancelo la transaccion.' AS mensaje;
	END;
    
	START TRANSACTION;
    
    -- Insertar nuevo producto en tabla Pedidos
		INSERT INTO Pedidos (idcliente, idvendedor, Fecha, Estado)
        VALUES (p_idcliente, p_idvendedor, p_fecha, 'confirmado');
        
        SET v_NumeroPedido = LAST_INSERT_ID();
        
        -- Variables para bucle
        INSERT INTO DetallePedidos (NumeroPedido, Renglon, idproducto, Cantidad, PrecioUnitario)
        SELECT 
			v_NumeroPedido,
            ROW_NUMBER() OVER (),
            idproducto,
            cantidad,
            precioUnitario
            FROM DetalleTemp;
            
		-- Actualizar stock por cada producto
        UPDATE Productos p
        JOIN DetalleTemp dt ON p.idproducto = dt.idproducto
        SET p.Stock = p.Stock - dt.cantidad;
        
        COMMIT;
        SELECT CONCAT('Pedido ', v_NumeroPedido, ' registrado correctamente') AS mensaje;
	END $$

DELIMITER ;

-- Consultas de prueba

-- Insertamos un nuevo pedido para probar su funcionamiento
INSERT INTO DetalleTemp (idproducto, cantidad, precioUnitario)
VALUES (1, 2, 1200.00), (3, 1, 1800.00);

-- Llamamos al procedimiento
CALL RegistrarPedidoConDetalle(1, 2, CURDATE());

-- Consultamos a la tabla Pedidos
SELECT * FROM Pedidos;
        
-- Lista de productos vendidos entre fechas (Descripcion, CantidadTotal)
SELECT pr.Descripcion, SUM(dp.Cantidad) AS CantidadTotal
FROM Productos pr
JOIN DetallePedidos dp ON pr.idproducto = dp.idproducto
JOIN Pedidos p ON dp.NumeroPedido = p.NumeroPedido
WHERE p.Fecha BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY pr.Descripcion;
