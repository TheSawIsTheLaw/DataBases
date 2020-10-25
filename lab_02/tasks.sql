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
where HANGMANID = 1