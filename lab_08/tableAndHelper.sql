begin
    DROPTABLEIFEXIST('pays');
end;

create table pays (
    payID integer generated always as identity primary key,
    DebtorID integer not null,
    foreign key (DebtorID) references DEBTORS(DEBTORID),
    value integer,
    dateOfPayment date not null
);
