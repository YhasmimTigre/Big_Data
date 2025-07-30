-- Atividade 5 - NonSQL

------------- Arrays ---------------
ALTER TABLE EMPREGADO
ADD certificados text[];

INSERT INTO EMPREGADO (
  ssn, pnome, inicialm, unome, sexo, endereco, datanasc, superssn, dno, salario, certificados
)
VALUES (
  '123456789', 'Bill', NULL, 'Smith', 'M', '123 Rua Exemplo', '1985-02-15', NULL, '1', 6000.00,
  ARRAY['CCNA', 'ACSP', 'CISSP']
);

SELECT * FROM EMPREGADO;

SELECT pnome
FROM EMPREGADO
WHERE certificados @> ARRAY['ACSP'];