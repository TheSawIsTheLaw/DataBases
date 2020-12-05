-- Загрузка битлджус файла в таблицу

-- Почему так? А потому что shared диски оракл видеть не хочет :)
create or replace directory jsonLocation as 'C:\Program Files\Oracle';

grant read on directory jsonLocation to sys;

create global temporary table newLoans
(
    LoanID INTEGER PRIMARY KEY NOT NULL,
    SubjectName VARCHAR(256),
    Debt INTEGER NOT NULL,
    PurchaseDate VARCHAR(10) NOT NULL,
    Price INTEGER NOT NULL
) on commit delete rows;

select * from newLoans;

declare
    currentFile UTL_FILE.file_type;
    gotString varchar2 (6666);
    resultString varchar2 (6666);
    currentJson JSON_OBJECT_T;

    -- Ну вот потому что не нравится ему в плскл доставать что-то из битлджуса
    curLoanID number;
    curSubjName varchar2(256);
    curDebt number;
    curPurchase varchar2(10);
    curPrice number;
begin
    currentJson := NEW JSON_OBJECT_T();
    currentFile := utl_file.fopen('JSONLOCATION', 'loans.json', 'r');
    loop
        begin
            utl_file.get_line(currentFile, gotString);
             if (gotString like '%"%') or (gotString like '%{%') then
                    resultString := resultString || gotString;
                elsif gotString like '%}%' then
                    resultString := resultString || '}';
                    currentJson := JSON_OBJECT_T.parse(resultString);
                    DBMS_OUTPUT.PUT_LINE(currentJson.stringify);
                    curLoanID := currentJson.get_number('LOANID');
                    curSubjName := currentJson.get_string('SUBJECTNAME');
                    curDebt := currentJson.get_number('DEBT');
                    curPurchase := currentJson.get_string('PURCHASEDATE');
                    curPrice := currentJson.get_number('PRICE');

                    insert into newLoans (LOANID, SUBJECTNAME, DEBT, PURCHASEDATE, PRICE)
                    values (curLoanID, curSubjName, curDebt, curPurchase, curPrice);
                    resultString := '';
                end if;
            exception when No_data_found then exit;
        end;
    end loop;
    utl_file.FCLOSE(currentFile);
end;

select * from newLoans;
