INSERT INTO CATEGORIA(
	CODIGO_CATEGORIA, DESCRICAO, CODIGO_CAT_PAI)
	VALUES (1, 'ALIMENTOS', NULL);
	
INSERT INTO CATEGORIA(
	CODIGO_CATEGORIA, DESCRICAO, CODIGO_CAT_PAI)
	VALUES (2, 'LIMPEZA', NULL);
	
INSERT INTO CATEGORIA(
	CODIGO_CATEGORIA, DESCRICAO, CODIGO_CAT_PAI)
	VALUES (3, 'HIGIENE', NULL);

INSERT INTO CATEGORIA(
	CODIGO_CATEGORIA, DESCRICAO, CODIGO_CAT_PAI)
	VALUES (4, 'AVEIAS', 1);
	
INSERT INTO CATEGORIA(
	CODIGO_CATEGORIA, DESCRICAO, CODIGO_CAT_PAI)
	VALUES (5, 'CREME DENTAL', 3);
	
INSERT INTO CATEGORIA(
	CODIGO_CATEGORIA, DESCRICAO, CODIGO_CAT_PAI)
	VALUES (6, 'BEBIDAS', NULL);
	
INSERT INTO CATEGORIA(
	CODIGO_CATEGORIA, DESCRICAO, CODIGO_CAT_PAI)
	VALUES (7, 'ENERGETICOS', 6);

INSERT INTO CATEGORIA(
	CODIGO_CATEGORIA, DESCRICAO, CODIGO_CAT_PAI)
	VALUES (8, 'LATICÍNIOS', 1);
	
INSERT INTO CATEGORIA(
	CODIGO_CATEGORIA, DESCRICAO, CODIGO_CAT_PAI)
	VALUES (9, 'FRIOS', 1);
	
INSERT INTO CATEGORIA(
	CODIGO_CATEGORIA, DESCRICAO, CODIGO_CAT_PAI)
	VALUES (10, 'CEREAIS', 1);

SELECT * FROM CATEGORIA;