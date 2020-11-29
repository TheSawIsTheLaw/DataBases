create or replace type phoneBookRecord is object (
    firstName varchar2(64),
    lastName varchar2(64),
    telephoneNumber varchar2(16),
    debt number
);

create or replace function getPhoneBookRecord(debtorID in number)
return phoneBookRecord
is language java name 'Facade.getPhoneBookRecord(int) return oracle.sql.Struct';

begin
    DBMS_OUTPUT.PUT_LINE(getPhoneBookRecord(666).FIRSTNAME);
    DBMS_OUTPUT.PUT_LINE(getPhoneBookRecord(666).LASTNAME);
    DBMS_OUTPUT.PUT_LINE(getPhoneBookRecord(666).TELEPHONENUMBER);
    DBMS_OUTPUT.PUT_LINE(getPhoneBookRecord(666).DEBT);
end;