-- Ну конечно же у нас и триггеры особенные. Он, простите за выражение, в*срет ошибку о том, что
-- триггер может не заметить изменений. Мутации у него, видите ли.

-- Таким образом, чтобы реализовать чекер обновления потребуется пользоваться составным триггером.
-- Это не то, что от меня требуется, поэтому идём по пути наименьшего сопротивления.

create or replace trigger checkLoanUpd
after update
on LOANSUBJECTS
for each row
begin
    if :new.price < 0 then
        update LOANSUBJECTS
            set PRICE = :old.price
        where LOANID = :old.loanid;
    end if;

    if :new.debt < 0 then
        update LOANSUBJECTS
            set debt = :old.price
        where LOANID = :old.loanid;
    end if;
end;

select *
from LOANSUBJECTS
where LOANID = 10;

update LOANSUBJECTS
set PRICE = -20
where LOANID = 10;

-- Представим, что у нас есть табличка для insert-ов, которую читает начальник.
-- Мы не хотим, чтобы начальник видел, насколько плохо всё у людей с деньгами.
-- Пускай он не будет видеть всякие большие циферки в своей табличке... Спать спокойнее будет.

create table FOROURCHIEF(
    LoanID INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
    SubjectName VARCHAR(256),
    Debt INTEGER NOT NULL,
    PurchaseDate VARCHAR(10) NOT NULL,
    Price INTEGER NOT NULL
);

create or replace trigger checkLoanIns
after insert
on LOANSUBJECTS
for each row
begin
    if :new.price < 1000000 then
        insert into FOROURCHIEF (subjectname, debt, purchasedate, price)
        values (:new.SUBJECTNAME, :new.DEBT, :new.PURCHASEDATE, :new.PRICE);
end if;
end;

select * from FOROURCHIEF;

insert into LOANSUBJECTS (SUBJECTNAME, DEBT, PURCHASEDATE, PRICE)
values ('VW Golf R 7', 3000, '2020-01-01', 1300000);

insert into LOANSUBJECTS (SUBJECTNAME, DEBT, PURCHASEDATE, PRICE)
values ('VW Touareg 1', 150000, '2020-01-01', 300000);
