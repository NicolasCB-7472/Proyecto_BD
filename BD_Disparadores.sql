#---------Parte 3 - Triggers ---------# 
#1 Se insertan datos no validos en figuras
DELIMITER //
CREATE TRIGGER BI_ValidFiguras BEFORE INSERT ON FIGURAS
FOR EACH ROW
BEGIN
	-- ID is a code 6 char code (FXXXXX) and FIGURA_TIPO is capped to 10 figures
	IF (NEW.ID NOT REGEXP '^F[0-9]{5}$' OR NEW.FIGURA_TIPO > 10) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La insercion en figuras no es valida';
    END IF;
END;
//
DELIMITER ;

#2 Se pasa del limite de figuras
DELIMITER //
CREATE TRIGGER BI_LimiteFiguras BEFORE INSERT ON FIGURAS
FOR EACH ROW
BEGIN
	DECLARE total_Figuras INT;
    SELECT COUNT(*) INTO total_Figuras FROM FIGURAS;
	
	#100 is a magic value, could be a global constant, predifined number, or derivated one, etc
	IF (total_Figuras > 100 )THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El limite de figuras se ha alcanzado';
    END IF;
END;
//
DELIMITER ;

#3 Se auditan los cambios sobre los datos de Circulo
CREATE TABLE AUDIT_CIRCULO(
	ID INTEGER NOT NULL AUTO_INCREMENT,
    TEXTO VARCHAR(150),
    CONSTRAINT AUDIT_PK PRIMARY KEY (ID)
);
-- Se crea un trigger para evitar la eliminacion de tablas, modificacion de estas, etc
-- Se puede revocar los permisos necesarios de las tablas y hacerla read-only
DELIMITER //
CREATE TRIGGER BD_AUDIT_CIR BEFORE DELETE ON AUDIT_CIRCULO
FOR EACH ROW
BEGIN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No se pueden eliminar los datos de esta tabla';
END;
//
DELIMITER ;

-- Se crea el trigger en si
DELIMITER //
CREATE TRIGGER AI_AUDIT_CIR AFTER INSERT ON CIRCULO
FOR EACH ROW
BEGIN
	INSERT INTO AUDIT_CIRCULO(TEXTO) VALUES(
		CONCAT(
			'Figura: ',
			CAST(NEW.ID_CIRCULO as CHAR(10)),
			'Radio: ',
			CAST(NEW.RADIUS as CHAR(10)),
			'Fecha: ',
			CAST(CURRENT_TIMESTAMP as CHAR(20))
			-- Se podria agregar el usuario tambien
		)
    );
END;
//
DELIMITER ;
