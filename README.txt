Este es un proyecto personal para exponer mis conocimientos de base de datos y SQL,
desde insercion, creacion de tablas, a consultas y trabajo con tablas, 
hasta procedimientos y disparadores. Se trabaja con el manejador de MySQL

Es algo rustico y algunas cosas estan basadas y/o inspiradas en otro
proyecto relacionados a C++. Este proyecto de base de datos cuenta con 
varias partes y modulos.

ProyectoDatos -> Trabaja con la insercion de datos, no de forma extensa, algo precariamente
ProyectoFiguras -> Trabaja con la creacion de tablas y algunas posible consultas
Procedimientos -> Trabaja con Store Procedure (SP)
Disparadores -> Trabaja con Triggers

*Informacion tecnica*
[Procedimientos]:
crear_cuadrado(IN lado FLOAT)
insercion_fi()
crear_coleccion(IN id_cuad VARCHAR(6), IN id_tri VARCHAR(6), IN id_cir VARCHAR(6), IN col_name VARCHAR(6))

[Triggers]:
BI_ValidFiguras
BI_LimiteFiguras
BD_AUDIT_CIR
AI_AUDIT_CIR

[Tablas sin foreings keys]:
AUDIT_CIRCULO
FIGURAS
FIGURAS_INDICE
FIGURAS_COLECCION
CUADRADO
CIRCULO
TRIANGULO

[Consultas]: En el mismo modulo de ProyectoFiguras

