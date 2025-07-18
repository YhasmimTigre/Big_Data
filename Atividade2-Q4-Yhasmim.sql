-- Atividade 2 - Questão 4 - Visões

-- a) Crie a visão chamada TRABALHA_EM que deverá conter os campos pnome e unome da tabela empregado, o campo pjnome da tabela projeto e o campo horas da tabela trabalha.

create view trabalha_em as
select 
    e.pnome, e.unome, p.pjnome, t.horas
from 
    empregado e
join 
    trabalha t on e.ssn = t.essn
join 
    projeto p on t.pno = p.pnumero;


-- b) Crie uma consulta SQL na visão implementada no item a que retorne o último e o primeiro nome de todos os empregados que trabalham no ‘ProdutoX’.

select 
    unome, pnome
from 
    trabalha_em
where 
    pjnome = 'ProdutoX';


-- c) Exclua a visão criada no item a.

drop view if exists trabalha_em;


-- d) Crie uma visão chamada DEPTO_INFO que deverá conter os campos dnome da tabela departamento, e o total de empregados e somatório dos salários dos empregados da tabela empregado por departamento.

create view depto_info as
select 
    d.dnome,
    count(e.ssn) as total_empregados,
    sum(e.salario) as soma_salarios
from 
    departamento d
join 
    empregado e on d.dnumero = e.dno
group by 
    d.dnome;


-- e) Crie uma consulta SQL na visão implementada no item d que retorne a lista de informações por departamentos ordenados pelo somatório dos salários.

select 
    dnome, total_empregados, soma_salarios
from 
    depto_info
order by 
    soma_salarios desc;


-- f) Exclua as visões criadas nos itens a.

drop view if exists depto_info;
