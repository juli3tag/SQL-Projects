-- Gonzalez Julieta 🌷

CREATE DATABASE IF NOT EXISTS Tienda;
USE Tienda;

DELIMITER $$

CREATE PROCEDURE AnularPedido (
    IN p_numeroPedido INT
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_idproducto INT;
    DECLARE v_cantidad INT;

    -- Cursor y manejador de fin de datos
    DECLARE cur CURSOR FOR
        SELECT idproducto, cantidad
        FROM DetallePedidos
        WHERE NumeroPedido = p_numeroPedido;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Manejador de error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    -- Verificar si el pedido existe
    IF NOT EXISTS (
        SELECT 1 FROM Pedidos WHERE NumeroPedido = p_numeroPedido
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El pedido no existe.';
    END IF;

    -- Verificar si ya está anulado
    IF EXISTS (
        SELECT 1 FROM Pedidos WHERE NumeroPedido = p_numeroPedido AND Estado = 'anulado'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El pedido ya fue anulado.';
    END IF;

    START TRANSACTION;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_idproducto, v_cantidad;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Devolver la cantidad al stock
        UPDATE Productos
        SET Stock = Stock + v_cantidad
        WHERE idproducto = v_idproducto;
    END LOOP;

    CLOSE cur;

    -- Cambiar el estado del pedido a "anulado"
    UPDATE Pedidos
    SET Estado = 'anulado'
    WHERE NumeroPedido = p_numeroPedido;

    COMMIT;
END$$

DELIMITER ;

-- Consultas de prueba

-- Consultamos a la tabla Pedidos
SELECT * FROM Pedidos;
SELECT * FROM Productos;

CALL AnularPedido(4); 

-- Consultamos a la tabla Pedidos
SELECT * FROM Pedidos;
SELECT * FROM Productos;