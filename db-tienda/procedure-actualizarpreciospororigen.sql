-- Gonzalez Julieta 🌷

CREATE DATABASE IF NOT EXISTS Tienda;
USE Tienda;

DELIMITER //

CREATE PROCEDURE ActualizarPreciosPorOrigen(
    IN p_origen VARCHAR(20),
    IN p_porcentaje DECIMAL(5,2)
)
BEGIN
    -- Actualiza los precios de los productos del origen especificado
    UPDATE Productos
    SET PrecioUnitario = PrecioUnitario * (1 + p_porcentaje / 100)
    WHERE Origen = p_origen;
    
    -- Mensaje de confirmación
    SELECT CONCAT('Precios actualizados para productos de origen ', p_origen, ' en un ', p_porcentaje, '%');
END;
//

DELIMITER ;

-- Consultas de prueba

-- Deshabilitar temporalmente el modo seguro de actualización
SET SQL_SAFE_UPDATES = 0;


-- Tabla productos antes de llamar al procedimiento
SELECT * FROM Productos WHERE Origen = 'nacional';
SELECT * FROM Productos WHERE Origen = 'importado';

-- Llamada al procedimiento para aumentar el precio de los productos de origen nacional en un 10%:
CALL ActualizarPreciosPorOrigen('nacional', 10);

-- Llamada al procedimiento para disminuir el precio de los productos de origen importado en un 5%:
CALL ActualizarPreciosPorOrigen('importado', -5);

-- Verificamos los resultados con una consulta sobre la tabla Productos:
SELECT * FROM Productos WHERE Origen = 'nacional';
SELECT * FROM Productos WHERE Origen = 'importado';

