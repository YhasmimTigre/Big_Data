-- Atividade 2 - Questão 1 - Aplicando Joins

CREATE TABLE TABELA_A (
    CODIGO INT PRIMARY KEY,
    NOME VARCHAR(50)
);

CREATE TABLE TABELA_B (
    ID INT PRIMARY KEY,
    CODIGO INT,
    VALOR DECIMAL(10,3)
);

INSERT INTO TABELA_A (CODIGO, NOME) VALUES
(1, 'UM'),
(2, 'DOIS'),
(3, 'TRES'),
(4, 'QUATRO'),
(5, 'CINCO');

INSERT INTO TABELA_B (ID, CODIGO, VALOR) VALUES
(1, 1, 1.000),
(2, 1, 2.000),
(3, 1, 5.000),
(4, 2, 4.000),
(5, 2, 9.000),
(6, 3, 7.000),
(7, 5, 4.000),
(8, 8, 7.000);

-- Inner Join
SELECT A.CODIGO, A.NOME, B.ID, B.VALOR
FROM TABELA_A A
INNER JOIN TABELA_B B ON A.CODIGO = B.CODIGO;
-- Código 4 não possui registros na tabela b, por isso não aparece
-- O registro com código 8 (da tabela b) não aparece pois não existe na tabela a
-- 7 registros apenas com correspondência nas duas tabelas

-- Left Outer Join
SELECT A.CODIGO, A.NOME, B.ID, B.VALOR
FROM TABELA_A A
LEFT OUTER JOIN TABELA_B B ON A.CODIGO = B.CODIGO;
-- Por não ter registros na tabela b, código 4 aparece com valores NULL
-- O registro com código 8 (da tabela b) não aparece pois não existe na tabela a
-- 8 registros para todos da tabela a e correspondências

-- Right Outer Join
SELECT A.CODIGO, A.NOME, B.ID, B.VALOR
FROM TABELA_A A
RIGHT OUTER JOIN TABELA_B B ON A.CODIGO = B.CODIGO;
-- Código 4 não aparece pos não existe join com a tabela b
-- O registro com código 8 (da tabela b) tem valores NULL para tabela a
-- 8 registros para todos da tabela b e correspondências

-- Full outer Join
SELECT A.CODIGO, A.NOME, B.ID, B.VALOR
FROM TABELA_A A
FULL OUTER JOIN TABELA_B B ON A.CODIGO = B.CODIGO;
-- Os registros de ambas tabelas estão presentes
--código 8 (da tabela b) tem valores NULL na tabela a
-- O código 4 tem valores NULL na tabela b
-- 9 registros para todos de ambas tabelas
