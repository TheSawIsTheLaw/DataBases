create or replace function getDebtorsWithPurchaseDateAfter(afterDate in date)
return TABLETYPE as tableType;
    begin
         select rowDebtorsPurchaseDateAfter(FIRSTNAME, LASTNAME, TO_DATE(PURCHASEDATE, 'YYYY-MM-DD'))
         bulk collect into retTable
         from SYSTEM.DEBTORS D join SYSTEM.LOANSUBJECTS L on L.LOANID = D.LOANID
         where TO_DATE(L.PURCHASEDATE, 'YYYY-MM-DD') > afterDate;
         return retTable;
    end;