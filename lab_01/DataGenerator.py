from faker import *
from random import randint

ZZZAP = 1000

def generateDebtor():
    faker = Faker()
    f = open('debtors.csv', 'w')
    for i in range(ZZZAP):
        DeptorID = i
        BankID = randint(0, ZZZAP)
        HangmanID = randint(0, ZZZAP)
        FirstName = faker.first_name()
        SecondName = faker.last_name()
        PassportNum = randint(1000000000, 9999999999)
        TelephoneNum = randint(80000000000, 89999999999)
        HomeAddress = faker.address()
        line = "{};{};{};{};{};{};{};{} {}\n".format(DeptorID, BankID, HangmanID, FirstName, SecondName, PassportNum, str(TelephoneNum), HomeAddress.split('\n')[0], HomeAddress.split('\n')[1])
        f.write(line)
    f.close()

if __name__ == "__main__":
    generateDebtor()