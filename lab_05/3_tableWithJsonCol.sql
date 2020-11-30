-- Окей, создадим новую таблицу со всеми дебторами, где будет добавлен json_object с замечательными данными
-- по задолженности этого человека

begin
    DROPTABLEIFEXIST('DebtorsWithLoans');
end;

create table DebtorsWithLoans
(
    DebtorID INTEGER PRIMARY KEY NOT NULL,
    FirstName VARCHAR(64) NOT NULL,
    LastName VARCHAR(64) NOT NULL,
    TelephoneNum VARCHAR(16),
    PassportNum VARCHAR(10),
    HomeAddress VARCHAR(256),
    BankID INTEGER NOT NULL,
    FOREIGN KEY (BankID) REFERENCES BANKS(BankID),
    HangmanID INTEGER NOT NULL,
    FOREIGN KEY (HangmanID) REFERENCES Hangman(HangmanID),

    JSONLoan clob check (JSONLoan is JSON)
);

insert into DebtorsWithLoans
select DEBTORID, FIRSTNAME, LASTNAME, TELEPHONENUM, PASSPORTNUM, HOMEADDRESS, BANKID, HANGMANID,
       JSON_OBJECT('LOANID' is L.LOANID, 'SUBJECTNAME' is SUBJECTNAME, 'DEBT' is DEBT, 'PURCHASEDATE' is PURCHASEDATE, 'PRICE' is PRICE)
from DEBTORS D join LOANSUBJECTS L on D.LOANID = L.LOANID;

select * from DebtorsWithLoans;