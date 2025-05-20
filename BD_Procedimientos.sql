#---------Parte 3 - Store Procedure---------# 

#1 Inserta 1 figura en FIGURAS  y en CIRCULO/TRIANGULO o CUADRADO
DELIMITER //
CREATE PROCEDURE crear_cuadrado(IN lado FLOAT)
	BEGIN
		DECLARE id_fig INTEGER;
        INSERT INTO CUADRADO(LADO) VALUES(lado);
        #Suponiendo que siempre se inserta al final y no hay eliminaciones
        SELECT LAST_INSERT_ID(ID_CUADRADO) INTO id_fig FROM CUADRADO;
        
        # Se inserta con el mismo nombre y figura id, 
        # tipos de figura indica en este caso 1 cuadrado
        INSERT INTO FIGURAS(FIGURA_ID, FIGURA_NAME, FIGURA_TIPO) VALUES(
			CONCAT('C', CAST(id_fig as CHAR(5))),
            CONCAT('C', CAST(id_fig as CHAR(5))),
            1
        );
        
        # No se agrega a FIGURAS_INDICE (el ejercicio no lo aborda)
    END
//
DELIMITER ;

#2 Inserta todas las figuras de FIGURAS en Indice con uso de cursor.
CREATE TABLE FIGURAS (
	ID INTEGER NOT NULL AUTO_INCREMENT,
	FIGURA_ID VARCHAR(6) NOT NULL,
    #(1) pertenece a coleccion (0) no pertenece a coleccion
	FIGURA_COLECCION TINYINT DEFAULT 0,
	FIGURA_NAME VARCHAR(10),
	FIGURA_TIPO TINYINT, 
	CONSTRAINT FIGURAS_PK PRIMARY KEY (ID) 
 ); 
 
 CREATE TABLE FIGURAS_INDICE ( 
	IDX INTEGER NOT NULL AUTO_INCREMENT,
	ID INTEGER NOT NULL, #Idem CUADRADO, CIRCULO, TRIANGULO ID 
	FIGURAX_ID VARCHAR(6) NOT NULL, #Idem FIGURA_ID 
	TIPO TINYINT DEFAULT 0, #Idem FIGURA_TIP 
	COLX_ID INTEGER DEFAULT 0, #Idem ID_COL 
	CONSTRAINT F_INDICE_PK PRIMARY KEY (FIGURAX_ID) 
 ); 

 CREATE TABLE FIGURAS_COLECCION ( 
	ID_COLECCION INTEGER NOT NULL AUTO_INCREMENT, 
    FIGURAC_ID varchar(6),
	ID_CUADRADO INTEGER, 
    ID_TRIANGULO INTEGER, 
	ID_CIRCULO INTEGER, 
    CONSTRAINT COLECCION_PK PRIMARY KEY (ID_COLECCION) 
 ); 

DELIMITER //
CREATE PROCEDURE insercion_fi()
	BEGIN
		#Se crea un cursor con la info de figuras
        DECLARE fig_id VARCHAR(6);
        DECLARE fig_col TINYINT; #BOOLEAN PROPERTY
        DECLARE fig_tip TINYINT;
        DECLARE id_col INTEGER DEFAULT 0;
        DECLARE finDatos INTEGER DEFAULT 0;
        
        DECLARE cur_figuras CURSOR FOR
        SELECT FIGURA_ID, FIGURA_COLECCION, FIGURA_TIPO FROM FIGURAS;
		
        DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET finDatos=1;
        OPEN cur_figuras;
        FETCH cur_figuras INTO fig_id, fig_col, fig_tip;
        
        # -> Se inserta FIGURAX_ID, ID, y TIPO
        # -> Se busca en FIGURAS_COLECCION correspondientemente con la figura si pertenece alguna coleccion
        WHILE finDatos <> 1 DO
			IF fig_tip = 0 THEN
				INSERT INTO FIGURAS_INDICE(FIGURAX_ID, ID,TIPO, COLX_ID) VALUES(
					fig_id,
                    SUBSTRING(fig_id, 2,6),
                    fig_tip,
                    0
                );
			ELSE
				#Can be optimized to search only for the specific type of figure
				SELECT FC.ID_COLECCION into id_col
				FROM FIGURAS_COLECCION AS FC
				WHERE FC.ID_CUADRADO=SUBSTRING(fig_id, 2,6) 
                OR FC.ID_TRIANGULO=SUBSTRING(fig_id, 2,6) 
                OR FC.ID_CIRCULO=SUBSTRING(fig_id, 2,6);
				
				INSERT INTO FIGURAS_INDICE(FIGURAX_ID, ID,TIPO, COLX_ID) VALUES(
					fig_id,
                    SUBSTRING(fig_id, 2,6),
                    fig_tip,
                    id_col
                );              
            END IF;
			FETCH cur_figuras INTO fig_id, fig_col, fig_tip; 
        END WHILE;
        CLOSE cur_figuras;
	END
//
DELIMITER ;




#3 Agrega 3 figuras (IDs) a figura coleccion

DELIMITER //
CREATE PROCEDURE crear_coleccion(IN id_cuad VARCHAR(6), IN id_tri VARCHAR(6), IN id_cir VARCHAR(6), IN col_name VARCHAR(6))
	BEGIN
		#Se toma la figura y actualiza coleccion
        DECLARE idcua INTEGER;
        DECLARE idtri INTEGER;
        DECLARE idcir INTEGER;
        DECLARE idcol INTEGER;
        
        #Suponiendo que estan ya en las tablas
        UPDATE FIGURAS AS F 
        SET F.FIGURA_COLECCION=1 
        WHERE F.FIGURA_ID=id_cuad OR F.FIGURA_ID=id_tri OR F.FIGURA_ID=id_cir; 
        
        SELECT SUBSTRING(id_cuad, 2, 6) INTO idcua;
        SELECT SUBSTRING(id_tri, 2, 6) INTO idtri;
        SELECT SUBSTRING(id_cir, 2, 6) INTO idcir;
        
        #Se agrega efectivamente a la coleccion
        INSERT INTO FIGURAS_COLECCION(FIGURAC_ID, ID_CUADRADO, ID_TRIANGULO, ID_CIRCULO) VALUES(
			(col_name),
            (idcua),
            (idtri),
            (idcir);
 
        
        #Se actualiza figuras indice con la coleccion
        #Suponiendo que siempre se inserta al final y no hay eliminaciones
        SELECT LAST_INSERT_ID(ID_COLECCION) INTO idcol FROM FIGURAS_COLECCION;
        
        UPDATE FIGURAS_INDICE AS FI
        SET COLX_ID=idcol
        WHERE (FI.ID=idcua AND FI.FIGURAX_ID=id_cuad) OR
        (FI.ID=idtri AND FI.FIGURAX_ID=id_tri) OR
        (FI.ID=idcir AND FI.FIGURAX_ID=id_cir);
    END
//

 