#---------Parte 3 - Triggers ---------# 
#1 Se insertan datos no validos en figuras
#2 Se pasa del limite de figuras
DELIMITER //
CREATE TRIGGER BI_LimiteFiguras BEFORE INSERT ON FIGURAS
FOR EACH ROW
BEGIN
	#100 is a magic value, could be a global constant, predifined number, or derivated one, etc
	IF ((SELECT COUNT(F.ID) FROM FIGURAS AS F) > 100 )THEN
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
DELIMITER //
CREATE TRIGGER BD_AUDIT_CIR BEFORE DELETE ON AUDIT_CIRCULO
FOR EACH ROW
BEGIN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No se pueden eliminar los datos de esta tabla';
END;
//
DELIMITER ;

CREATE TABLE CIRCULO ( 
	ID_CIRCULO INTEGER NOT NULL, 
    RADIUS FLOAT, 
    CONSTRAINT CIRCULO_PK PRIMARY KEY (ID_CIRCULO) 
); 

-- Se crea el trigger en si
DELIMITER //
CREATE TRIGGER AI_AUDIT_CIR AFTER INSERT ON CIRCULO
FOR EACH ROW
BEGIN
	INSERT INTO AUDIT_CIRCULO(TEXTO) VALUES(
		'Figura: ',
        CAST(OLD.ID as CHAR(10)),
        'Viejo Radio: ',
        CAST(OLD.ID as CHAR(10)),
        'Nuevo Radio: ',
        CAST(NEW.ID as CHAR(10)),
        'Fecha: ',
        CAST(TIMESTAMP as CHAR(20))
        -- Se podria agregar el usuario tambien
    );
END;
//
DELIMITER ;
