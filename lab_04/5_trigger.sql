create table FOROURCHIEF(
    LoanID INTEGER PRIMARY KEY NOT NULL,
    SubjectName VARCHAR(256),
    Debt INTEGER NOT NULL,
    PurchaseDate VARCHAR(10) NOT NULL,
    Price INTEGER NOT NULL
);

call DBMS_JAVA.set_output(5000);

create or replace package triggerPack as
    procedure javaTrigger(newLoanID in number, newSubjectName in varchar2, newDebt in number, newPurchaseDate in varchar2, newPrice in number);
        end;

drop package triggerPack;
drop package body triggerPack;

create or replace package body triggerPack as
    procedure javaTrigger(newLoanID in number, newSubjectName in varchar2, newDebt in number, newPurchaseDate in varchar2, newPrice in number)
    AS LANGUAGE JAVA
    NAME 'Facade.insertChiefJava(int, java.lang.String, int, java.lang.String, int)';
end;

-- Теперь мы хотим, чтобы шефу приходили только очень большие долги. Крутяк.......
create or replace trigger insChiefJava
after insert
on LOANSUBJECTS
for each row
    begin
        triggerPack.javaTrigger(:new.LOANID, :new.SUBJECTNAME, :new.DEBT, :new.PURCHASEDATE, :new.PRICE);
    end;

-- Удаления созданного безобразия...
delete from LOANSUBJECTS where SUBJECTNAME = 'wow' or SUBJECTNAME = 'notwow';
delete from FOROURCHIEF where SUBJECTNAME = 'notwow';

-- Селекты на просмотр этого безобразия
select * from LOANSUBJECTS where SUBJECTNAME = 'wow' or SUBJECTNAME = 'notwow';
select * from FOROURCHIEF;

-- Инсёрты на проверку
insert into LOANSUBJECTS (SUBJECTNAME, DEBT, PURCHASEDATE, PRICE)
values ('wow', 1, '2000-11-11', 666);
insert into LOANSUBJECTS (SUBJECTNAME, DEBT, PURCHASEDATE, PRICE)
values ('notwow', 2000000, '2000-10-10', 3000000);
