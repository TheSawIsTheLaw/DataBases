-- Подготовка к РК, чо

DROP TABLE Hangman;
CREATE TABLE Hangman(
    HangmanID INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
    Position VARCHAR(10) NOT NULL,
    FirstName VARCHAR(64),
    LastName VARCHAR(64),
    TelephoneNumber VARCHAR(16) NOT NULL
);

ALTER TABLE Hangman ADD(
    ChiefID INTEGER,
    FOREIGN KEY (ChiefID) REFERENCES Hangman(HangmanID)
);
SELECT * FROM all_constraints
where table_name LIKE '%HANGMAN';

create table empoyees
(
    EmployeeID integer generated always as identity primary key not null,
    DepartmentID integer not null,
    Position varchar2(32),
    FIO varchar2(128),
    Salary integer
);

insert into EMPOYEES (DepartmentID, Position, FIO, Salary)
values (1, 'lox', 'Ivan Ivanov', 399);

-- Инструкция select, использующая предикат сравнения
-- Вывести все задолженности более 500 тысяч рублей.
select distinct SUBJECTNAME, DEBT
from LOANSUBJECTS
where DEBT > 500000;

-- Инструкция select, использующая предикат between
-- Вывести все задолженности, дата приобретения которых между 2000-01-01 и 2010-01-01
select distinct LOANID, PURCHASEDATE
from LOANSUBJECTS
where PURCHASEDATE between '2000-01-01' and '2010-01-01';

-- Иструкция select, использующая предикат LIKE
-- Стало известно об утечке паролей gmail. Надо проверить,
-- какие банки имеют почту gmail, с которой злоумышленники
-- могут отправить информацию о том, что должник якобы
-- закрыл долг
select distinct NAME, MAIL
from BANKS
where MAIL like '%@gmail.com';

-- Инструкция select, использующая предикат IN с вложенным поздапросом
-- Получаем всех палачей, у которых должник задолжал более 500 тыс. руб.
select HANGMANID, FIRSTNAME, LASTNAME
from HANGMAN
where HANGMANID in (
    select HANGMANID
    from DEBTORS join LOANSUBJECTS on DEBTORS.LOANID = LOANSUBJECTS.LOANID
    where DEBT > 500000
    );

-- Инструкция select, использующая предикат exists с вложенным подзапросом
-- Вывести информацию о должниках, у которых не имеется информации о родственниках
select DEBTORID, FIRSTNAME, LASTNAME
from DEBTORS
where NOT EXISTS(
    select RELATIVES.DEBTORID
    from RELATIVES
    where DEBTORS.DEBTORID = RELATIVES.DEBTORID
          );

-- Проверка
select *
from RELATIVES
where DEBTORID = 579;

-- Инструкция select, использующая предикат сравнения с квантором
-- Все объекты долга, которые дешевле всех объектов долга, приобретённых в 2000 году
select SUBJECTNAME, DEBT, PURCHASEDATE
from LOANSUBJECTS
where DEBT < all(
    select DEBT
    from LOANSUBJECTS
    where PURCHASEDATE > '2000-01-01' and PURCHASEDATE < '2000-12-31'
    );

-- Проверка
select *
from LOANSUBJECTS
where PURCHASEDATE > '2000-01-01' and PURCHASEDATE < '2000-12-31';

-- Инструкция SELECT, использующая агрегатные функции в выражениях столбцов
-- Получаем и вычисляем средний размер долга по задолженностям
select AVG(DEBT) as avgFunc, SUM(DEBT) / COUNT(*) as calculatedAvg
from LOANSUBJECTS;

-- Инструкция select, использующая скалярные подзапросы в выражениях столбцов
-- Вывести имена всех палачей, средний долг их "клиентов" и количество их клиентов
select HANGMANID, FIRSTNAME, LASTNAME,
       (
           select AVG(DEBT)
           from DEBTORS join HANGMAN H on DEBTORS.HANGMANID = H.HANGMANID join LOANSUBJECTS L on DEBTORS.LOANID = L.LOANID
           where H.HANGMANID = HANGMAN.HANGMANID
           ) as averageDebtOfDebtors,
       (
           select COUNT(*)
           from DEBTORS
           where DEBTORS.HANGMANID = HANGMAN.HANGMANID
           ) as sumOfDebtors
from HANGMAN;

-- Проверка на то, что у Бритттани Вагнер нет "клиентов"
select *
from DEBTORS
where HANGMANID = 1;

-- Инструкция select, использующая простое выражение case
-- Выводим информацию по тому, как давно задолжали люди. Или не совсем люди, там.
select DEBTORID, FIRSTNAME, LASTNAME,
        case extract(year from to_date(PURCHASEDATE, 'YYYY-MM-DD'))
        when extract(year from CURRENT_DATE) then 'Wow. Fresh!'
        when extract(year from CURRENT_DATE) - 1 then 'Wow, last year!'
        else cast((extract(year from CURRENT_DATE) - extract(year from to_date(PURCHASEDATE, 'YYYY-MM-DD'))) as varchar(10)) || ' years! Pathetic...'
        end as yearSpecification
from DEBTORS join LOANSUBJECTS L on DEBTORS.LOANID = L.LOANID;

select EXTRACT(YEAR FROM '2020-13-12') from LOANSUBJECTS;

-- Инструкция select, использующая поисковое выражение case
-- Вывести имена людей и их спецификацию по их задолженности
select DEBTORID, FIRSTNAME, LASTNAME,
       case
               when price < 100000 then 'Ok, not so expensive'
               when price < 500000 then 'Hmm, it is expensive'
               when price < 3000000 then 'It is so big...'
               else 'Target to kill'
        end as specification
from DEBTORS join LOANSUBJECTS L on DEBTORS.LOANID = L.LOANID;

-- Создание новой временной локальной таблицы из результирующего набора данных инструкций select
-- Создание новой таблицы, в которой указывается какой палач за какую сумму отвечает
create global temporary table tempTable (
    HANGMAN int,
    MONEY int
) ON COMMIT DELETE rows;

drop table tempTable;

insert into tempTable (
    select HANGMANID, SUM(DEBT)
    from (select HANGMAN.HANGMANID, DEBT
    from HANGMAN join DEBTORS D on HANGMAN.HANGMANID = D.HANGMANID join LOANSUBJECTS L on D.LOANID = L.LOANID)
    group by HANGMANID
    );

select *
from tempTable;

-- Инструкция select, использующая вложенные коррелированные подзапросы в качестве производных таблиц в предложении from
-- Требуется обзвонить всех палачей и сообщить им, какая сумма на них висит. Поэтому посчитаем, сколько на них висит и
-- выведем их айди, имя, фамилию, номер и сумму, чтобы обзванивать было легче
select HANGMAN.HANGMANID, FIRSTNAME, LASTNAME, TELEPHONENUMBER, summary
from HANGMAN join (
        select HANGMANID, SUM(DEBT) as summary
        from (
            select HANGMAN.HANGMANID, DEBT
            from HANGMAN join DEBTORS D on HANGMAN.HANGMANID = D.HANGMANID join LOANSUBJECTS L on D.LOANID = L.LOANID
        )
        group by HANGMANID
    ) S on HANGMAN.HANGMANID = S.HANGMANID;

-- Иструкция select, использующая вложенные подзапросы с уровнем вложенности 3.
-- Выводим таблицу, в которой есть информация о палаче и клиенте, который задолжал больше 1/10000 суммарного общего долга...

select BANKS.BANKID, HANGMANID, DEBTORID, TELEPHONENUM, DEBT
from BANKS join (
    select HANGMANID, DEBTORID, TELEPHONENUM, DEBT, BANKID
    from DEBTORS join (
        select LOANID, DEBT
        from LOANSUBJECTS
        where DEBT > (
            select SUM(PRICE) / 10000 as partOfSum
            from LOANSUBJECTS
          )
        ) T on DEBTORS.LOANID = T.LOANID
    ) T on BANKS.BANKID = T.BANKID;

-- Инструкция select, консолидирующая данные с помощью предожения group by, но без предложения having
-- Выводим суммарную и среднюю задолженности для каждого банка
select BANKS.BANKID, SUM(DEBT) as summaryDebt, AVG(DEBT) as averageDebt, COUNT(DEBT) as qttyDebt
from BANKS join DEBTORS D on BANKS.BANKID = D.BANKID join LOANSUBJECTS L on D.LOANID = L.LOANID
group by BANKS.BANKID;

-- Инструкция SELECT, консолидирующая данные с помощью предложения group by и предложения having
-- Выводим всё то же, что и выше, только для тех банков, у которых каунтер больше 3
select BANKS.BANKID, SUM(DEBT) as summaryDebt, AVG(DEBT) as averageDebt, COUNT(DEBT) as qttyDebt
from BANKS join DEBTORS D on BANKS.BANKID = D.BANKID join LOANSUBJECTS L on D.LOANID = L.LOANID
group by BANKS.BANKID
having COUNT(DEBT) > 3;

-- Однострочная иснтрукция insert, выполняющая вставку в таблицу одной строки значений
-- Добавим новый банк
insert into BANKS (NAME, MAIL, TELEPHONE, LEGALADDRESS)
values ('Smert', 'Smert@mail.org', '+96666666666', 'Ulitsa Pupkina, dom 4, Moscow, Serbia');

-- Проверка
select *
from BANKS where NAME = 'Smert';

-- Многострочная инструкция insert, выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса
-- У нас новый палач! Ему нужно выбрать шефа, у которого меньше 4 подчинённых
insert into HANGMAN (POSITION, FIRSTNAME, LASTNAME, TELEPHONENUMBER, CHIEFID)
select 'Executor', 'Алексей', 'Романов', '+79991112233', CHIEFID
from (
        select *
        from (
            select CHIEFID, COUNT(CHIEFID) as counter
            from HANGMAN
            group by CHIEFID)
        where counter < 4
         )
where ROWNUM=1;

-- Проверка
select *
from HANGMAN
where FIRSTNAME = 'Алексей';

-- Простая инструкция update
-- Алексей решил поменять себе фамилию. Поможем ему в этом!
update HANGMAN
set LASTNAME = 'Евдокимов'
where HANGMANID = 1001;

-- Проверка
select *
from HANGMAN
where FIRSTNAME = 'Алексей';

-- Инструкция update со скалярным подзапросом в предложении set
-- АЛЯРМА!!! СМЫСЛА В ЭТОМ ЗАПРОСЕ НЕ БОЛЬШЕ, ЧЕМ В МОЁМ СУЩЕСТВОВАНИИ!!!
-- А поменяем-ка мы для последнего элемента задолженности стоимость на среднюю стоимость по таблице)))))))
update LOANSUBJECTS
set PRICE = (
    select AVG(PRICE)
    from LOANSUBJECTS
    )
where LOANID = 1000;

select *
from LOANSUBJECTS
where LOANID = 1000;

-- Простая инструкция delete
-- Удалим то непотребство, которое мы добавили в insert-запросе
delete HANGMAN
where HANGMANID = 1001;

-- Инстукция delete  вложенным коррелированным подзапросов в предложении where
-- Удалим банки, у которых нет "клиентов" для нашего обслуживания
delete BANKS
where BANKID not in (
        select distinct BANKID
        from DEBTORS
    );

-- Проверка. Запускается до исполнения и после.
select count(BANKID)
from BANKS;

-- Инструкция select, использующая просто обобщённое табличное выражение
-- Получаем среднюю задолженность банкам
with banksAndMoney(BANKNAME, DEBTORSDEBTS)
as (
    select BANKS.NAME, SUM(DEBT)
    from BANKS join DEBTORS D on BANKS.BANKID = D.BANKID join LOANSUBJECTS L on D.LOANID = L.LOANID
    group by BANKS.NAME
    )
select AVG(DEBTORSDEBTS)
from banksAndMoney;

-- Инструкция select, спользующая рекурсивное обобщённое табличное выражение
-- Будем выводить иерархию зависимости исполнителей от шефов
with recurs(CHIEFID, POSITION, HANGMANID, LVL)
as (
    select CHIEFID, POSITION, HANGMANID, 0 as LVL
    from HANGMAN
    where CHIEFID is null
    union all
    select fTable.CHIEFID, fTable.POSITION, fTable.HANGMANID, sTable.LVL + 1
    from HANGMAN fTable join recurs sTable on fTable.CHIEFID = sTable.HANGMANID
    )
select *
from recurs
where LVL = 0;

-- Оконные функции. Использование конструкций MIN/MAX/AVG OVER()
-- Выведем должников с минимальным и максимальным значением долга по банку. Ну ещё и среднее в придачу
select
    DEBTORID,
    FIRSTNAME,
    LASTNAME,
    NAME,
    DEBT,
    MAX(DEBT) OVER (PARTITION BY NAME) as MAXDEBT,
    AVG(DEBT) OVER (PARTITION BY NAME) as AVERDEBT,
    MIN(DEBT) OVER (PARTITION BY NAME) as MINDEBT
from DEBTORS D join LOANSUBJECTS L on D.LOANID = L.LOANID JOIN BANKS B on D.BANKID = B.BANKID;

-- Пример, отрабатывающий задание:
select DEBTORID, FIRSTNAME, LASTNAME, NAME, DEBT, MAXDEBT, AVERDEBT, MINDEBT
from (
    select
        DEBTORID,
        FIRSTNAME,
        LASTNAME,
        NAME,
        DEBT,
        MAX(DEBT) over (partition by NAME) as MAXDEBT,
        AVG(DEBT) over (partition by NAME) as AVERDEBT,
        MIN(DEBT) over (partition by NAME) as MINDEBT
    from DEBTORS D join LOANSUBJECTS L on D.LOANID = L.LOANID join BANKS B on D.BANKID = B.BANKID
         )
where DEBT = MAXDEBT or DEBT = MINDEBT;

-- Оконные функции для устранения дублей
select *
from (
    select dF.FIRSTNAME as dFName, dF.TELEPHONENUM as dFTelephone, dS.FIRSTNAME as dSName, dS.TELEPHONENUM as dSTelephone, row_number() over (partition by dF.TELEPHONENUM order by dF.TELEPHONENUM) as cnt
    from DEBTORS dF join DEBTORS dS on dF.FIRSTNAME = dS.FIRSTNAME join DEBTORS dT on dT.FIRSTNAME = dS.FIRSTNAME
         )
where dFName = 'Amy' and cnt = 1;

-- Исправление (?)
create global temporary table tempTable (
    DFNAME varchar(64),
    DFTELEPHONE varchar(16) not null,
    DSNAME varchar(64),
    DSTELEPHONE varchar(16) not null,
    CNT int
) ON COMMIT DELETE rows;

drop table tempTable;

insert into tempTable (
    select dF.FIRSTNAME as dFName, dF.TELEPHONENUM as dFTelephone, dS.FIRSTNAME as dSName, dS.TELEPHONENUM as dSTelephone, row_number() over (partition by dF.TELEPHONENUM order by dF.TELEPHONENUM) as cnt
    from DEBTORS dF join DEBTORS dS on dF.FIRSTNAME = dS.FIRSTNAME join DEBTORS dT on dT.FIRSTNAME = dS.FIRSTNAME
    );

delete from tempTable
where cnt <> 1;

select *
from tempTable;

-- Скалярная функция
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

-- Подставляемая табличная функция
create or replace type rowDebtorsPurchaseDateAfter is object(
    DEBTORFIRSTNAME varchar2(64),
    DEBTORLASTNAME varchar2(64),
    DETBORPURCHASEDATE date
                                                 );
drop type rowDebtorsPurchaseDateAfter;

create or replace type tableType is table of rowDebtorsPurchaseDateAfter;
drop type tableType;

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

-- Многооператорная табличная функция
create or replace type debtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin is object(
    DEBTORLASTNAME varchar2(64),
    LOANID number,
    SUBJECTNAME varchar2(256),
    DEBT number
);
drop type debtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin;

create or replace type tableOfDebtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin is table of debtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin;
drop type debtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin;

create or replace function showTableOfDebtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin
return tableOfDebtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin as retTable tableOfDebtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin;
            averDebt number := 0;
            halfOfMaxDebt number := 0;
            minDebt number := 0;
    begin
        select avg(DEBT), max(DEBT) / 2, min(DEBT)
        into averDebt, halfOfMaxDebt, minDebt
        from system.LOANSUBJECTS;

        select debtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin(LASTNAME, L.LOANID, SUBJECTNAME, DEBT)
        bulk collect into retTable
        from DEBTORS D join LOANSUBJECTS L on D.LOANID = L.LOANID
        where DEBT > averDebt and DEBT < halfOfMaxDebt + minDebt;

        return retTable;
    end;

select *
from showTableOfDebtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin();

-- рекурсивная функция
create or replace type hangmansOnLevel is object(
    CHIEFID number,
    POSITIONINHIERARCHY varchar2(10),
    HANGMANID number,
    LVL number
                                                );

create or replace type tableOfHangmansOnLevel is table of hangmansOnLevel;
drop type tableOfHangmansOnLevel;

create or replace function getAllHangmansOnLevel(level number)
return tableOfHangmansOnLevel is retTable tableOfHangmansOnLevel;
begin
    with recurs(CHIEFID, POSITION, HANGMANID, LVL)
    as (
        select CHIEFID, POSITION, HANGMANID, 0 as LVL
        from HANGMAN
        where CHIEFID is null
        union all
        select fTable.CHIEFID, fTable.POSITION, fTable.HANGMANID, sTable.LVL + 1
        from HANGMAN fTable join recurs sTable on fTable.CHIEFID = sTable.HANGMANID
    )
    select hangmansOnLevel(recurs.CHIEFID, recurs.POSITION, recurs.HANGMANID, recurs.LVL)
    bulk collect into retTable
    from recurs
    where recurs.LVL = level;

    return retTable;
end;

select *
from getAllHangmansOnLevel(0);


-- Хранимая процедура
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

-- Рекурсивная хранимая процедура
-- Рекурсивная процедура
create or replace type newChiefsRow is object(
   COUNTER number,
   HANGID number
                                            );
create or replace type newChiefsTable is table of newChiefsRow;

create or replace procedure addTraineeToFreeHangman(TFirstName varchar2, TLastName varchar2, telephone varchar2, curChiefId number)
is
    counter number;
    type arr is varray(100) of number;
    newChiefsArr arr := arr();
begin
    select count(*)
    into counter
    from HANGMAN where CHIEFID = curChiefId;
    if counter = 0 then
        begin
            insert into HANGMAN (POSITION, FIRSTNAME, LASTNAME, TELEPHONENUMBER, CHIEFID)
            values ('trainee', TFirstName, TLastName, telephone, curChiefId);
        end;
    else
        begin
            for i in 1..counter
                loop
                newChiefsArr.extend();
                end loop;
            -- С надеждой на светлое будущее и на то, что никто ничего в этот момент в таблице не поменяет :)
            for i in 1..counter
                loop
                select HANGMANID
                into newChiefsArr(i)
                from (
                    select rownum as rn, HANGMANID
                    from(
                        select count(*), HANGMANID
                        from HANGMAN where chiefID = curChiefId
                        group by HANGMANID

                    )
                    )
                where rn = i;
                end loop;
            for chiefNum in 1..counter
                loop
                addTraineeToFreeHangman(TFirstName, TLastName, telephone, newChiefsArr(chiefNum));
                end loop;
        end;
    end if;
end;

begin
    addTraineeToFreeHangman('Pavel', 'Pepperoni', '86666666666', 5);
end;


-- Курсор
create or replace procedure showAllExecutorsNames
is
    curName varchar2(64);
begin
    declare
        cursor hangmanCursor is
            select *
            from HANGMAN;

    begin
        for curHangman in hangmanCursor
        loop
            curName := curHangman.LASTNAME;
            DBMS_OUTPUT.PUT_LINE(curName);
        end loop;
    end;
end;

create or replace procedure showAllExecutorsNamesSVersion
is
    curName varchar2(64);
    cursor hangmanCursor is select * from HANGMAN;
begin
    for curHangman in hangmanCursor
    loop
        curName := curHangman.LASTNAME;
        DBMS_OUTPUT.PUT_LINE(curName);
    end loop;
end;

-- ВАЖНО! ПЕРЕД ИСПОЛЬЗОВАНИЕМ ВКЛЮЧИТЬ ВЫВОД ДБМС ДЕБАГА
begin
    showAllExecutorsNames();
end;

begin
    showAllExecutorsNamesSVersion();
end;


-- Процедура с мета
-- мета-данные
create or replace procedure dropTableIfExist(tableName in varchar2)
is
    doesExists number;
begin
    select count(*)
    into doesExists
    from USER_TABLES
    where TABLE_NAME = upper(tableName);

    if doesExists > 0 then
        execute immediate 'DROP TABLE ' || tableName;
    end if;
end;

begin
    dropTableIfExist('temptable');
end;

select * from GLOBAL_NAME;

select * from all_views where OWNER = 'SYSTEM';

select * from ALL_INDEXES;

select * from global_name;

create table temptable(
    smth number
);


-- Триггер after
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


-- Триггер Instead of
-- insteadof
create view infoAboutLoans as
select D.LOANID, D.DEBTORID, SUBJECTNAME ,DEBT, PRICE
from LOANSUBJECTS L join DEBTORS D on L.LOANID = D.LOANID;

drop view infoAboutLoans;

create or replace trigger deleteDebtorIfDebtEnds
instead of update
on infoAboutLoans
for each row
begin
    if :new.DEBT > 0 then
        update LOANSUBJECTS
        set
            SUBJECTNAME = :new.SUBJECTNAME,
            DEBT = :new.DEBT,
            PRICE = :new.PRICE
        where :new.LOANID = LOANID;
    end if;
end;