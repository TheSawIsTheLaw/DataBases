create or replace function getDebtStatus
    (Debt in number)
    return varchar2
is
    status varchar2(14);
begin
    if Debt < 50000
        then
            status := 'Not so scary';
    elsif Debt < 100000
        then
            status := 'Normal';
    elsif Debt < 500000
        then
            status := 'Need attention';
    elsif Debt > 500000
    then
        status := 'Target to kill';
    end if;

    return status;
end;

-- Получаем всех примерных господ со статусом "Не так страшно". Хотя какой тут
-- "не так страшно", если люди попали к нам...
select FIRSTNAME, LASTNAME, DEBT, getDebtStatus(DEBT) as DEBTSTATUS
from DEBTORS D join LOANSUBJECTS L on D.LOANID = L.LOANID
where getDebtStatus(DEBT) = 'Not so scary';

-- Получаем количество каждого из статусов
select getDebtStatus(DEBT), count(getDebtStatus(DEBT)) as DEBTSTATUS
from DEBTORS  D join LOANSUBJECTS L on D.LOANID = L.LOANID
group by getDebtStatus(DEBT);
