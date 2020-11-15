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
create or replace function getDebtorsWithLoanPriceInRange(startPrice in number, endPrice in number, numberOfRecords in number)
return LoansLowerTableType as retTable LoansLowerTableType;
            ind number := 0;
    begin
        DBMS_OUTPUT.ENABLE(20000000);
        while (ind < numberOfRecords)
        loop
            select rowLoansPriceLower(LASTNAME, D.LOANID, SUBJECTNAME, PRICE)
            bulk collect into retTable
            from DEBTORS D join LOANSUBJECTS L on L.LOANID = D.LOANID
            where L.PRICE > startPrice and L.PRICE < endPrice and D.DEBTORID = ind;
            ind := ind + 1;
            end loop;
        return retTable;
    end;

select *
from getDebtorsWithLoanPriceInRange(0, 10000000000, 1001);

select *
from DEBTORS
where DEBTORID = 1000;