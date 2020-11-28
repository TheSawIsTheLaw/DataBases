create or replace function debtorStatus(debt in number)
return varchar2
as
    language java name 'Facade.debtorStatus(int) return java.lang.String';

select FIRSTNAME, LASTNAME, DEBT, debtorStatus(DEBT)
from DEBTORS D join LOANSUBJECTS L on D.LOANID = L.LOANID;

