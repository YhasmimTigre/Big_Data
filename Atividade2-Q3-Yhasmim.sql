-- Atividade 2 - Questão 3 - Subconsultas

-- a) Recupere nome (pnome e unome) de cada um dos empregados que tenham um dependente cujo primeiro nome e sexo sejam o mesmo do empregado em questão.

select 
    e.pnome, e.unome
from 
    empregado e
where 
    exists (
        select 
            1
        from 
            dependente d
        where 
            d.essn = e.ssn
            and d.nomedep = e.pnome
            and d.sexodep = e.sexo
    );


-- b) Recupere os nomes dos empregados (pnome e unome) cujos salários são maiores que a média dos salários dos empregados do departamento 5.

select 
    e.pnome, e.unome
from 
    empregado e
where 
    e.salario > (
        select 
            avg(e2.salario)
        from 
            empregado e2
        where 
            e2.dno = '5'
    );
   
   
-- c) Retorne o número do seguro social (SSN) de todos os empregados que trabalham com a mesma combinação (projeto, horas) em algum dos projetos em que o empregado ‘Fabio Will’ (SSN= 333445555) trabalhe.
   
select 
    t2.essn
from 
    trabalha t2
where 
    exists (
        select 
            1
        from 
            trabalha t1
        where 
            t1.essn = '333445555'
            and t1.pno = t2.pno
            and t1.horas = t2.horas
            and t2.essn <> '333445555'
    );
   

-- d) Recupere os nomes de todos os empregados que não trabalham em nenhum projeto.
   
select 
    e.pnome, e.unome
from 
    empregado e
where 
    not exists (
        select 
            1
        from 
            trabalha t
        where 
            t.essn = e.ssn
    );
   
-- e) Recupere o nome de empregados que não tenham dependentes.
   
select 
    e.pnome, e.unome
from 
    empregado e
where 
    not exists (
        select 
            1
        from 
            dependente d
        where 
            d.essn = e.ssn
    );
   
-- f) Liste o último nome de todos os gerentes de departamento que não tenham dependentes.
   
select 
    e.unome
from 
    empregado e
where 
    exists (
        select 
            1
        from 
            departamento d
        where 
            d.gerssn = e.ssn
    )
    and not exists (
        select 
            1
        from 
            dependente dep
        where 
            dep.essn = e.ssn
    );
   
-- g) Liste os nomes dos gerentes que tenham, pelo menos, um dependente.
   
select 
    e.pnome, e.unome
from 
    empregado e
where 
    exists (
        select 
            1
        from 
            departamento d
        where 
            d.gerssn = e.ssn
    )
    and exists (
        select 
            1
        from 
            dependente dep
        where 
            dep.essn = e.ssn
    );