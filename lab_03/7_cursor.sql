-- Я так и не понял, зачем нам нужны курсоры, если мы в процедурах выполняем действия над таблицами.
-- Удобно, конечно, но толк?..

-- UPD: я тут узнал, что select into, insert, update и delete тоже курсорами являются. Забавно. Теперь я понял.

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