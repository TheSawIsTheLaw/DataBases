-- У должника может быть больше одного предмета задолженности
-- Так что надо подправить

create or replace procedure reduceDebt(debtor number, reduceValue number) as
begin
    update LOANSUBJECTS set DEBT = DEBT - reduceValue
    where LOANID = (select LOANID
                    from DEBTORS D
                    where D.DEBTORID = debtor);
end;

select DEBTORID, DEBT
from DEBTORS D join LOANSUBJECTS L on D.LOANID = L.LOANID
where D.DEBTORID = 85;

begin
reduceDebt(85, 100);
end;