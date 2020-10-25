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
where DEBTORID = 579

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