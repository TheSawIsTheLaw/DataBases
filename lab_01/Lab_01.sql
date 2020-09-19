DROP TABLE Bank;
CREATE TABLE Bank(
    BankID INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
    Name VARCHAR(64) NOT NULL,
    Mail VARCHAR(64),
    Telephone VARCHAR(16),
    LegalAddress VARCHAR(256) NOT NULL
);

DROP TABLE LoanSubject;
CREATE TABLE LoanSubject(
    LoanID INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
    SubjectName VARCHAR(256),
    Debt INTEGER NOT NULL,
    PurchaseDate VARCHAR(10) NOT NULL,
    Price INTEGER NOT NULL
);

DROP TABLE Hangman;
CREATE TABLE Hangman(
    HangmanID INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
    Position VARCHAR(10) NOT NULL,
    FirstName VARCHAR(64),
    LastName VARCHAR(64),
    TelephoneNumber VARCHAR(16) NOT NULL
);

ALTER TABLE Hangman ADD(
    ChiefID INTEGER,
    FOREIGN KEY (ChiefID) REFERENCES Hangman(HangmanID)
);
SELECT * FROM all_constraints
where table_name LIKE '%HANGMAN';
-- ДОБАВИТЬ ADD НА CHIEF

DROP TABLE Debtor;
CREATE TABLE Debtor(
    DebtorID INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
    FirstName VARCHAR(64) NOT NULL,
    LastName VARCHAR(64) NOT NULL,
    TelephoneNum VARCHAR(16),
    PassportNum VARCHAR(10),
    HomeAddress VARCHAR(256),
    LoanID INTEGER NOT NULL,
    FOREIGN KEY (LoanID) REFERENCES LoanSubject(LoanID),
    BankID INTEGER NOT NULL,
    FOREIGN KEY (BankID) REFERENCES Bank(BankID),
    HangmanID INTEGER NOT NULL,
    FOREIGN KEY (HangmanID) REFERENCES Hangman(HangmanID)
);

DROP TABLE Relative;
CREATE TABLE Relative(
    RelativeID INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
    FirstName VARCHAR(64),
    LastName VARCHAR(64),
    TelephoneNum VARCHAR(64) NOT NULL,
    HomeAddress VARCHAR(256) NOT NULL,
    DebtorID INTEGER NOT NULL,
    FOREIGN KEY (DebtorID) REFERENCES Debtor(DebtorID)
);