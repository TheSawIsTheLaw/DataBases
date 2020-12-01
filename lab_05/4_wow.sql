-- 1) Извлекаем фрагмент из JSON
-- Старая песня. Хотим видеть имена, фамилии, а также битлджус с ID < 100
-- Предистория
select DEBTORID, FIRSTNAME, LASTNAME, DL.JSONLOAN
from DEBTORSWITHLOANS DL
where DEBTORID < 100;

-- Тут я покажу, что умею обращаться со CLOB, в дальнейшем уже пойдёт просто работа с табличным JSON
declare
    fragment clob;
begin
    select DL.JSONLOAN
    into fragment
    from DEBTORSWITHLOANS DL
    where DEBTORID = 555;
    DBMS_OUTPUT.PUT_LINE(fragment);
end;

-- 2) Извлекаем значения конкретных узлов или атрибутов.
-- Вынимаем их битлджуса нужные значения
-- Предистория
select DEBTORID, FIRSTNAME, LASTNAME, DL.JSONLOAN.SUBJECTNAME, DL.JSONLOAN.DEBT
from DEBTORSWITHLOANS DL
where DEBTORID < 100;

declare
    attributeSubjName clob;
    attributeDebt clob;
begin
    select DL.JSONLOAN.SUBJECTNAME, DL.JSONLOAN.DEBT
    into attributeSubjName, attributeDebt
    from DEBTORSWITHLOANS DL
    where DEBTORID = 555;
    DBMS_OUTPUT.PUT_LINE(attributeSubjName);
    DBMS_OUTPUT.PUT_LINE(attributeDebt);
end;

-- 3) Выполнить проверку существования узла или атрибута
-- Сначала я написал вот это чудо
select case
        when exists (select DL.JSONLOAN.TYPE from DEBTORSWITHLOANS DL where DL.JSONLOAN.OLOLO is not null)
        then 'Yes'
        else 'No'
       end as DOES_THIS_ATTRIBUTE_EXISTS
from dual;

-- А потом Остапа понесло
create or replace function doesThisAttributeExists(tableName in varchar2, columnName in varchar2, attributeName in varchar2)
return varchar2
as
-- Почему я это убрал? Как я понимаю, в битлджусах всё-таки важен регистр полей. Или аттрибутов. Короче важно это, решил не трогать...
--     upperTableName varchar2 := upper(columnName);
--     upperColumnName varchar2 := upper(columnName);
--     upperAttributeName varchar2 := upper(attributeName);
    ret number;
begin
    execute immediate
        'select case
                    when exists(select dummyName.' || columnName ||'.' || attributeName || '
                                        from ' || tableName || ' dummyName
                                        where dummyName.'|| columnName ||'.' || attributeName || ' is not null)
                        then 1
                    else 0
                    end as amIDummyKing
                    from dual'
        into ret;
    if (ret = 1) then return 'Yes';
    else return 'No';
    end if;
end;

-- Он ещё так прикольно исключениями кидается, если таблицы не существует. Решил это не исправлять, чтобы неповадно было что попало передавать.
-- А так, можно было бы через метаданные проверять, конечно. Нас же уже научили ;)
begin
    DBMS_OUTPUT.PUT_LINE(doesThisAttributeExists('DEBTORSWITHLOANS', 'JSONLOAN', 'DEBT'));
end;

-- 4) Изменить JSON документ
-- Ну, изменим что-нибудь в нашей небезызвестной табличке...

-- Вот есть способ. Но это как-то не по-нашему... Так что пропускаем.
-- Ну, то есть пропускаем из-за того, что я убил эту запись, проводя тесты. Так что теперь записи 666 не существует...
update DEBTORSWITHLOANS DL
set DL.JSONLOAN = JSON_OBJECT('LOANID' is 666,
                       'SUBJECTNAME' is 'center',
                       'DEBT' is 666666,
                       'PURCHASEDATE' is '1979-11-18',
                       'PRICE' is 9419173)
where DL.JSONLOAN.LOANID = 666;

-- А эту вещь я назвал Сатанайзер2000
-- СНАЧАЛА СЕЛЕКТ, ПОТОМ АПДЕЙТ, ПОТОМ СЕЛЕКТ!!!!!!!!!!!!!!!!!!!!!!
select DL.JSONLOAN from DEBTORSWITHLOANS DL where DL.JSONLOAN.LOANID = 555;

update DEBTORSWITHLOANS DL
set DL.JSONLOAN = (
select JSON_OBJECT('LOANID' is dl.JSONLOAN.LOANID,
                   'SUBJECTNAME' is dl.JSONLOAN.SUBJECTNAME,
                   'DEBT' is 666666,
                   'PURCHASEDATE' is dl.JSONLOAN.PURCHASEDATE,
                   'PRICE' is dl.JSONLOAN.PRICE)
    from DEBTORSWITHLOANS dl
    where dl.JSONLOAN.LOANID = 555
)
where DL.JSONLOAN.LOANID = 555;

select DL.JSONLOAN from DEBTORSWITHLOANS DL where DL.JSONLOAN.LOANID = 555;

-- 5) Разделить JSON на несколько строк по узлам
-- Я в недоумении. Ничего не могу поделать.

-- Я хотел бы вывести в два столбца. Но оракл не хочет видеть битлджуса в том, что сам он как бы не объявлял.
-- Всё больше и больше мне это напоминает броски бумеранга с ловлей его лицом.

create global temporary table IHATEORACLE
(
    fCol clob check (fCol is JSON),
    sCol clob check (sCol is JSON)
       ) on commit delete rows;
drop table IHATEORACLE;

-- Когда это заработало я чуть не сломал себе левую ногу. Потрясающе.
select * from IHATEORACLE;
select I.fcol.DEBT from IHATEORACLE I;

insert into IHATEORACLE
    (fCol, sCol)
    select JSON_OBJECT('LOANID' is DL.JSONLOAN.LOANID, 'DEBT' is DL.JSONLOAN.DEBT, 'PURCHASEDATE' is DL.JSONLOAN.PURCHASEDATE),
    JSON_OBJECT('SUBJECTNAME' is DL.JSONLOAN.SUBJECTNAME, 'PRICE' is DL.JSONLOAN.PRICE)
from DEBTORSWITHLOANS DL;

-- Ну не хочет он работать так, как я бы хотел. Видимо, многого хочу и многого не понимаю :)
select fCol.LOANID from
(
select to_clob(JSON_OBJECT('LOANID' is DL.JSONLOAN.LOANID, 'DEBT' is DL.JSONLOAN.DEBT, 'PURCHASEDATE' is DL.JSONLOAN.PURCHASEDATE)) fCol,
    to_clob(JSON_OBJECT('SUBJECTNAME' is DL.JSONLOAN.SUBJECTNAME, 'PRICE' is DL.JSONLOAN.PRICE)) sCol FROM DEBTORSWITHLOANS dl
    );