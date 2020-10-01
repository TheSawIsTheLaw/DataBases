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
          )

-- Проверка
select *
from RELATIVES
where DEBTORID = 579