CREATE OR REPLACE package pkg as
    procedure REDUCEDEBTWITHJAVA(debtorID in number, reduceValue in number);
        end;

drop package pkg;
drop package body pkg;

create or replace package body pkg as
    procedure REDUCEDEBTWITHJAVA(debtorID in number, reduceValue in number)
    AS LANGUAGE JAVA
    NAME 'Facade.reduceDebtWithJava(int, int)';
end;

-- А ВОТ ТАК ОНО НЕ РАБОТАЕТ, ПОЧЕМУ, ПОЧЕМУ, ПОЧЕМУ?????? Я НЕ ЗНАЮ, ХАХАХАХАХХАХАХАХАХАХАХХАХАХАХАХАХАХАХХАХАХАХАХАХАХ
-- create or replace procedure reduce(debtorID in number, reduceValue in number)
-- as language JAVA name 'Facade.reduceDebtWithJava(int, int)';

call DBMS_JAVA.set_output(5000);
select DEBTORID, DEBT from DEBTORS D join LOANSUBJECTS L on D.LOANID = L.LOANID where DEBTORID = 666;

call pkg.REDUCEDEBTWITHJAVA(666, 5);

select * from DEBTORS D join LOANSUBJECTS L on D.LOANID = L.LOANID where DEBTORID = 666;
