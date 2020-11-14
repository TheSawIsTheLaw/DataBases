-- Короче у нас тут халявы нет))) Придётся описать свой тип возвращаемой
-- записи и тип таблицы, которую мы возвращаем.

-- Зачем я на это подписался?

create or replace type rowDebtorsPurchaseDateAfter is object(
    DEBTORFIRSTNAME varchar2(64),
    DEBTORLASTNAME varchar2(64),
    DETBORPURCHASEDATE date
                                                 );
drop type rowDebtorsPurchaseDateAfter;

create or replace type tableType is table of rowDebtorsPurchaseDateAfter;
drop type tableType;

-- НЕТ, НУ ПРАВИЛЬНО, А ДАВАЙТЕ, РАЗ МЫ ТУТ ВСЕ ДЖАВИСТЫ,
-- СОБИРАТЬ ЗАПИСИ (ОЙ, ИЗВИНИТЕ, ОБЪЕКТИКИ) ЧЕРЕЗ КОНСТРУКТОР
-- ДААААААА, ООП, ЗАДЕЙСТВОВАННОЕ В ОБРАЗЕ SQL
-- А ПОТОМ КОЛЛЕКТИТЬ ЭТО ВСЁ В СОЗДАННЫЙ ТИП ТАБЛИЦЫ, ДААААААА

-- Содомия.
create or replace function getDebtorsWithPurchaseDateAfter(afterDate in date)
return tableType as retTable tableType;
    begin
         select rowDebtorsPurchaseDateAfter(FIRSTNAME, LASTNAME, TO_DATE(PURCHASEDATE, 'YYYY-MM-DD'))
         bulk collect into retTable
         from SYSTEM.DEBTORS D join SYSTEM.LOANSUBJECTS L on L.LOANID = D.LOANID
         where TO_DATE(L.PURCHASEDATE, 'YYYY-MM-DD') > afterDate;
         return retTable;
    end;

select *
from getDebtorsWithPurchaseDateAfter(TO_DATE('2019-01-01', 'YYYY-MM-DD'));

