-- Atividade 3 - Index

CREATE TABLE aluno (
    matricula SERIAL PRIMARY KEY,
    curso VARCHAR(100) NOT NULL,
    idade INT NOT NULL,
    cre NUMERIC(4,2),
    disciplinas JSONB,
    data_ingresso TIMESTAMP NOT NULL DEFAULT now(),
    localizacao GEOMETRY(Point, 4326)
);


-- a) SELECT * FROM aluno WHERE cre = 5.0
CREATE INDEX idx_aluno_cre ON aluno (cre);
-- Índice do tipo B-Tree (busca por igualdade)

--b) SELECT * FROM aluno WHERE idade < 70
CREATE INDEX idx_aluno_idade ON aluno (idade);
-- Índice do tipo B-Tree (busca com operador <)

-- c) SELECT * FROM aluno WHERE idade > 27 AND cre < 3.0
CREATE INDEX idx_aluno_idade_cre ON aluno (idade, cre); 
-- Índice composto B-Tree (combinação de filtros, usando idade primeiro por conta do operador >)

--d) SELECT AVG(idade) FROM aluno
CREATE INDEX idx_aluno_idade_avg ON aluno (idade);
-- Índice do tipo B-Tree 

--e) SELECT idade, count(*) FROM aluno WHERE curso = "Computação" GROUP BY idade
CREATE INDEX idx_aluno_curso ON aluno (curso);
-- Índice do tipo B-Tree em curso

--f) SELECT * FROM aluno WHERE disciplinas @> '[{"nome": "Cálculo I"}]'
CREATE INDEX idx_aluno_disciplinas ON aluno USING GIN (disciplinas);
-- Índice do tipo Gin no campo JSONB (para busca de conteúdo parcial no documento JSON)

--g) SELECT * FROM aluno WHERE data_ingresso BETWEEN '2024-01-01' AND '2024-12-31'
CREATE INDEX idx_aluno_data_ingresso ON aluno (data_ingresso);
-- Índice do tipo B-Tree em data_ingresso (para comparações com BETWEEN)

--h) SELECT * FROM aluno WHERE ST_DWithin(localizacao, ST_MakePoint(-34.88, -7.12)::GEOMETRY, 1000)
CREATE INDEX idx_aluno_localizacao ON aluno USING GIST (localizacao);
-- Índice do tipo GIST no campo GEOMETRY (que exige GIST para operações de vizinhança eficientes)
