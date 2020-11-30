-- Так как у нас лабораторные работы больше на sql, я не буду использовать .ctl и внутренние функции DataGrip
-- для загрузки данных в таблицу.

-- Поэтому мы создадим табличку с полем json и будем методично её перекидывать в копию таблицы LOANSSUBJECTS

-- сохраним битлджуса
SELECT * FROM LOANSUBJECTS;

begin
    DROPTABLEIFEXIST('LOANSJSON');
end;
create table LOANSJSON
(
    JSONString clob check (JSONString is JSON)
);
select * from LOANSJSON;

select JSON_OBJECT('LOANID' is LOANID, 'SUBJECTNAME' is SUBJECTNAME, 'DEBT' is DEBT, 'PURCHASEDATE' is PURCHASEDATE, 'PRICE' is PRICE) from LOANSUBJECTS;

insert into LOANSJSON
select JSON_OBJECT('LOANID' is LOANID, 'SUBJECTNAME' is SUBJECTNAME, 'DEBT' is DEBT, 'PURCHASEDATE' is PURCHASEDATE, 'PRICE' is PRICE) from LOANSUBJECTS;

begin
    DROPTABLEIFEXIST('COPYLOANS');
end;

create table COPYLOANS
(
    LoanID INTEGER PRIMARY KEY NOT NULL,
    SubjectName VARCHAR(256),
    Debt INTEGER NOT NULL,
    PurchaseDate VARCHAR(10) NOT NULL,
    Price INTEGER NOT NULL
);

select * from COPYLOANS;

select JSONString from LOANSJSON;

insert into COPYLOANS
select L.JSONString.LOANID, L.JSONString.SUBJECTNAME, L.JSONString.DEBT, L.JSONString.PURCHASEDATE, L.JSONString.PRICE from LOANSJSON L;
