-- Ну да, описать тип возвращаемой таблицы внутри функции тоже нельзя.
-- Поэтому мы будем делать предыдущий запрос, но в ином ключе. Класс.

create or replace type debtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin is object(
    DEBTORLASTNAME varchar2(64),
    LOANID number,
    SUBJECTNAME varchar2(256),
    DEBT number
);
drop type debtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin;

create or replace type tableOfDebtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin is table of debtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin;
drop type debtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin;


-- Функция, возвращающая фамилии всех должников, цена преобретённых
-- предметов у которых ниже заданной.
create or replace function showTableOfDebtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin
return tableOfDebtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin as retTable tableOfDebtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin;
            averDebt number := 0;
            halfOfMaxDebt number := 0;
            minDebt number := 0;
    begin
        select avg(DEBT)
        into averDebt
        from system.LOANSUBJECTS;

        select max(DEBT) / 2
        into halfOfMaxDebt
        from system.LOANSUBJECTS;

        select min(DEBT)
        into minDebt
        from system.LOANSUBJECTS;

        select debtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin(LASTNAME, L.LOANID, SUBJECTNAME, DEBT)
        bulk collect into retTable
        from DEBTORS D join LOANSUBJECTS L on D.LOANID = L.LOANID
        where DEBT > averDebt and DEBT < halfOfMaxDebt + minDebt;

        return retTable;
    end;

select *
from showTableOfDebtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin();