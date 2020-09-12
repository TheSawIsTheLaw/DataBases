from faker import *
from random import randint

ZZZAP = 1000

def generateDebtor():
    faker = Faker()
    f.write("LoanID;BankID;HangmanID;FirstName;SecondName;PassportNum;TelephoneNum;HomeAddress\n")
    f = open('debtors.csv', 'w')
    for i in range(ZZZAP):
        LoanID = i
        BankID = randint(0, ZZZAP)
        HangmanID = randint(0, ZZZAP)
        FirstName = faker.first_name()
        FirstName = faker.first_name()
        SecondName = faker.last_name()
        PassportNum = randint(1000000000, 9999999999)
        TelephoneNum = randint(80000000000, 89999999999)
        HomeAddress = faker.address()
        line = "{};{};{};{};{};{};{};{} {}\n".format(LoanID, BankID, HangmanID, FirstName, SecondName, PassportNum, str(TelephoneNum), HomeAddress.split('\n')[0], HomeAddress.split('\n')[1])
        f.write(line)
    f.close()

def generateHangman():
    faker = Faker()
    f = open('hangmans.csv', 'w')
    for i in range(ZZZAP):
        HangmanID = i
        Chief = i - i % 4 if i % 4 != 0 else -1
        Position = "Chief" if i % 4 == 0 else "Executor"
        FirstName = faker.first_name()
        LastName = faker.last_name()
        TelephoneNum = randint(80000000000, 89999999999)
        line = "{};{};{};{};{}\n".format(Chief, Position, FirstName, LastName, TelephoneNum)
        f.write(line)
    f.close()

def generateLoanSubject():
    faker = Faker()
    f = open("loansubjects.csv", 'w')
    for i in range(ZZZAP):
        SubjectName = faker.word()
        Debt = randint(500, 1000000)
        PurchaseDate = faker.date()
        Price = randint(5000, 9999999)
        line = "{};{};{};{}\n".format(SubjectName, Debt, PurchaseDate, Price)
        f.write(line)
    f.close()

def generateRelatives():
    faker = Faker()
    f = open("relatives.csv", 'w')
    for i in range(ZZZAP * 2):
        DeptorID = randint(0, ZZZAP)
        FirstName = faker.first_name()
        LastName = faker.last_name()
        TelephoneNum = randint(80000000000, 89999999999)
        HomeAddress = faker.address()
        line = "{};{};{};{};{} {}\n".format(DeptorID, FirstName, LastName, TelephoneNum,
                                             HomeAddress.split('\n')[0], HomeAddress.split('\n')[1])
        f.write(line)
    f.close()

def generateBanks():
    faker = Faker()
    f = open("banks.csv", 'w')
    for i in range(ZZZAP):
        Name = faker.word()
        Mail = faker.email()
        TelephoneNum = randint(80000000000, 89999999999)
        LegalAddress = faker.address()
        line = "{};{};{};{} {}\n".format(Name, Mail, TelephoneNum,
                                      LegalAddress.split('\n')[0], LegalAddress.split('\n')[1])
        f.write(line)
    f.close()

if __name__ == "__main__":
    generateBanks()
    generateRelatives()
    generateLoanSubject()
    generateHangman()
    generateDebtor()