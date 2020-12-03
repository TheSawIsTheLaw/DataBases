create or replace type averResRow is object(
    SUBJECTNAME varchar2(256),
    DEBT varchar2(18)
                                                 );
drop type averResRow;

create or replace type averResTable is table of averResRow;
drop type averResTable;

call DBMS_JAVA.set_output(5000);

create or replace function biggerThenAveragePlus(plusing in number)
return averResTable
as
    language java name 'Facade.biggerThenAveragePlus(int) return oracle.sql.ARRAY.ARRAY';

select * from TABLE(biggerThenAveragePlus(0));

select * from LOANSUBJECTS where DEBT > all( select avg(debt) from LOANSUBJECTS);