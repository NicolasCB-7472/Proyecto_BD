#---------Parte 4 - Store Procedure---------# 

#1 Inserta 1 figura en FIGURAS  y en CIRCULO/TRIANGULO o CUADRADO
DELIMITER //
CREATE PROCEDURE crear_cuadrado(IN lado FLOAT)
	BEGIN
		DECLARE id_fig INTEGER;
        INSERT INTO CUADRADO(LADO) VALUES(lado);
        #Suponiendo que siempre se inserta al final y no hay eliminaciones
        SELECT LAST(ID_CUADRADO) INTO id_fig FROM CUADRADO;
        
        # Se inserta con el mismo nombre y figura id, 
        # tipos de figura indica en este caso 1 cuadrado
        INSERT INTO FIGURAS(FIGURA_ID, FIGURA_NAME, FIGURA_TIPO) VALUES(
			CONCAT('C', CAST(id_fig as CHAR(5))),
            CONCAT('C', CAST(id_fig as CHAR(5))),
            1
        );
    END
//
DELIMITER ;

#2 Inserta todas las figuras de FIGURAS en Indice
#3 Agrega 3 figuras (IDs) a figura coleccion
CREATE TABLE FIGURAS (
	ID INTEGER NOT NULL AUTO_INCREMENT,
	FIGURA_ID VARCHAR(6) NOT NULL,
    #(1) pertenece a coleccion (0) no pertenece a coleccion
	FIGURA_COLECCION TINYINT DEFAULT 0,
	FIGURA_NAME VARCHAR(10),
	FIGURA_TIPO TINYINT, 
	CONSTRAINT FIGURAS_PK PRIMARY KEY (ID) 
 ); 

DELIMITER //
CREATE PROCEDURE crear_coleccion(IN id_cuad VARCHAR(6), IN id_tri VARCHAR(6), IN id_cir VARCHAR(6))
	BEGIN
		#Se toma la figura y actualiza coleccion
        #Se agrega efectivamente a la coleccion
        #Se actualiza figuras indice con la coleccion
    END
//

 