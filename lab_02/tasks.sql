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
         )z
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
from tempTable
