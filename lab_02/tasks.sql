-- Инструкция select, использующая предикат сравнения
-- Вывести все задолженности более 500 тысяч рублей.
select distinct SUBJECTNAME, DEBT
from LOANSUBJECT
where DEBT > 500000;

-- Инструкция select, использующая предикат between
-- Вывести все задолженности, дата приобретения которых между 2000-01-01 и 2010-01-01
select distinct LOANID, PURCHASEDATE
from LOANSUBJECT
where PURCHASEDATE between '2000-01-01' and '2010-01-01'