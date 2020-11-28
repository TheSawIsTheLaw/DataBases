create or replace function customMax(tableName in varchar2, columnName in varchar2)
return number
as
    language java name 'Facade.customMax(java.lang.String, java.lang.String) return int';

call DBMS_JAVA.set_output(2000);

-- select customMax('LOANSUBJECTS', 'DEBT') from LOANSUBJECTS;
call DBMS_OUTPUT.PUT_LINE(customMax('LOANSUBJECTS', 'DEBT'));