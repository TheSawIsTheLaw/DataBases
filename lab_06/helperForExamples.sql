create table BankEmployees
(
    BankEmployeeID integer generated always as identity primary key not null,
    LastName varchar(64),
    Position varchar2(16),
    BankID integer not null,
    foreign key (BankID) references BANKS(BankID)
);
drop table BankEmployees;