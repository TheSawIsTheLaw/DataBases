-- Ну да, описать тип возвращаемой таблицы внутри функции тоже нельзя.
-- Поэтому мы будем делать предыдущий запрос, но в ином ключе. Класс.

create or replace type rowLoansPriceLower is object(
    DEBTORLASTNAME varchar2(64),
    LOANID number,
    SUBJECTNAME varchar2(256),
    PRICE number
);
drop type rowLoansPriceLower;

create or replace type LoansLowerTableType is table of rowLoansPriceLower;
drop type LoansLowerTableType;


-- Функция, возвращающая фамилии всех должников, цена преобретённых
-- предметов у которых ниже заданной.
create or replace function getDebtorsWithLoanPriceInRange(startPrice in number, endPrice in number)
return LoansLowerTableType as retTable LoansLowerTableType;
    begin
        select rowLoansPriceLower(D.LASTNAME, L.LOANID, L.SUBJECTNAME, L.PRICE)
        bulk collect into retTable
        from DEBTORS D join LOANSUBJECTS L on D.LOANID = L.LOANID
        where PRICE < endPrice and PRICE > startPrice;
        return retTable;
    end;

select *
from getDebtorsWithLoanPriceInRange(60000, 100000);