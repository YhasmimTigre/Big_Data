-- Atividade 2 - Questão 2 - Funções agregadas e nativas

-- a) Recupere a média salarial de todos os empregados do sexo feminino.

select avg(e.salario)
from empregado as e 
where e.sexo = 'F';

-- b) Mostre o número de empregados por supervisor

select e.superssn, count(e.ssn)
from empregado as e 
group by e.superssn
having e.superssn notnull;

-- c) Mostre o maior número de horas envolvido em projetos

select max(t.horas)
from trabalha as t;

-- d) Para cada projeto, liste o nome do projeto e o total de horas por semana (de todos os empregados) gastas no projeto.

select 
    p.pjnome,
    sum(t.horas) as Total_Horas
from 
    projeto p
join 
    trabalha t on p.pnumero = t.pno
group by 
    p.pjnome;

-- e) Para cada departamento, recupere o nome do departamento e a média salarial de todos os empregados que trabalham nesse departamento.
   
select 
    d.dnome as nome_departamento,
    avg(e.salario) as media_salarial
from 
    departamento d
join 
    empregado e on d.dnumero = e.dno
group by 
    d.dnome;

-- f) Liste os nomes de todos os empregados com dois ou mais dependentes
  
select 
    e.pnome as primeiro_nome,
    e.unome as ultimo_nome
from 
    empregado e
join 
    dependente d on e.ssn = d.essn
group by 
    e.pnome, e.unome
having 
    count(d.nomedep) >= 2;

-- g) Nome do departamento com o menor número de projetos associados
   
select 
    d.dnome as nome_departamento
from 
    departamento d
join 
    projeto p on d.dnumero = p.dnum
group by 
    d.dnome
order by 
    count(p.pnumero) asc
limit 1;

-- h) Consulta que retorne do 10º ao 22º caractere do endereço do empregado

select 
    substring(endereco from 10 for 13) as endereco_parcial
from 
    empregado;
   
-- i) Consulta que retorne apenas o mês de nascimento de cada funcionário
   
select 
    extract(month from datanasc) as mes_nascimento
from 
    empregado;

-- j) Idade do empregado quando o dependente de parentesco filho ou filha nasceu

 select 
    e.pnome as primeiro_nome,
    e.unome as ultimo_nome,
    extract(year from (d.datanascdep - e.datanasc)) as idade_quando_filho_nasceu
from 
    empregado e
join 
    dependente d on e.ssn = d.essn
where 
    d.parentesco in ('FILHO', 'FILHA');

-- k) Consulta que conte o número de dependentes por ano de nascimento

select 
    extract(year from datanascdep) as ano_nascimento,
    count(*) as numero_dependentes
from 
    dependente
group by 
    extract(year from datanascdep)
order by 
    ano_nascimento;

-- l) Nome de supervisores que tenham 2 ou mais supervisionados	

select 
    e.pnome as primeiro_nome,
    e.unome as ultimo_nome
from 
    empregado e
join 
    empregado sup on e.ssn = sup.superssn
group by 
    e.pnome, e.unome
having 
    count(sup.ssn) >= 2;

-- m) Escreva uma consulta que mostre o valor mensal a ser pago por projeto (considere que a coluna ‘salário’ de empregado é mensal).

select 
    p.pjnome as nome_projeto,
    sum(e.salario * t.horas / 160) as valor_mensal_pago
from 
    projeto p
join 
    trabalha t on p.pnumero = t.pno
join 
    empregado e on t.essn = e.ssn
group by 
    p.pjnome;


