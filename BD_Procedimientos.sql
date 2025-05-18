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
        
        # No se agrega a FIGURAS_INDICE (el ejercicio no lo aborda)
    END
//
DELIMITER ;

#2 Inserta todas las figuras de FIGURAS en Indice con uso de cursor.

#Se crea un cursor con la info de figuras
	# -> Se inserta FIGURAX_ID, ID, y TIPO
	# -> Se busca en FIGURAS_COLECCION correspondientemente con la figura si pertenece alguna coleccion


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
			col_name,
            idcua,
            idtri,
            idcir
        );
        
        #Se actualiza figuras indice con la coleccion
        #Suponiendo que siempre se inserta al final y no hay eliminaciones
        SELECT LAST(ID_COLECCION) INTO idcol FROM FIGURAS_COLECCION;
        
        UPDATE FIGURAS_INDICE AS FI
        SET COLX_ID=idcol
        WHERE (FI.ID=idcua AND FI.FIGURAX_ID=id_cuad) OR
        (FI.ID=idtri AND FI.FIGURAX_ID=id_tri) OR
        (FI.ID=idcir AND FI.FIGURAX_ID=id_cir);
    END
//

 