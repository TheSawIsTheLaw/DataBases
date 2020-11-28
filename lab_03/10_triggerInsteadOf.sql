create view infoAboutLoans as
select D.LOANID, D.DEBTORID, SUBJECTNAME ,DEBT, PRICE
from LOANSUBJECTS L join DEBTORS D on L.LOANID = D.LOANID;

drop view infoAboutLoans;

select *
from infoAboutLoans;

-- Я хотел бы вообще исключать записи, если у нас обновляется значение отрицательным долгом.
-- Но это нарушение целостности.
create or replace trigger deleteDebtorIfDebtEnds
instead of update
on infoAboutLoans
for each row
begin
    if :new.DEBT > 0 then
        update LOANSUBJECTS
        set
            SUBJECTNAME = :new.SUBJECTNAME,
            DEBT = :new.DEBT,
            PRICE = :new.PRICE
        where :new.LOANID = LOANID;
    end if;
end;

select * from LOANSUBJECTS
    where LOANID = 1;

select * from infoAboutLoans
    where LOANID = 1;

update infoAboutLoans
set SUBJECTNAME = 'ololo'
where LOANID = 1;

select *
from DEBTORS
where LOANID = 1;

update infoAboutLoans
set DEBT = -1
where LOANID = 1;