-- Я наконец-то добрался до этого.
-- Так как у нас, у джабистов-кококотлинистов, не принято добавлять функционал IF EXISTS
-- сами вот всё ручками делаем.

-- Процедура удаляет таблицу, если та присутствует в системе. Красота!
-- UPD: мой pull-request в репозиторий оракла отменили. Сказали, что не готовы к таким
-- высоким технологиям. Придётся идти работать в Сбер©.

create or replace procedure dropTableIfExist(tableName in varchar2)
is
    doesExists number;
begin
    select count(*)
    into doesExists
    from USER_TABLES
    where TABLE_NAME = tableName;

    if doesExists > 0 then
        execute immediate 'DROP TABLE ' || tableName;
    end if;
end;

begin
    dropTableIfExist('TEMPTABLE');
end;

create table temptable(
    smth number
);

select *
from TEMPTABLE;