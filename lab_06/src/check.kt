import java.sql.*
import java.util.*
import kotlin.reflect.KFunction0

fun printLogo()
{
    print(
                "@@@@@@@@@@@@@@@@@@@@@@&(./@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@@@@&(./@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@@@@&(./@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@@@@&(./@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@&#/**,*#&@@@@&(./@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@%*,*(%@&/,,(@@@&(./@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@&#*.(&@@@@@@#/,*%@&(./@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@&(,.*&@@@@@@@@@@&/ /#(./@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@/,(&@@@@@@@@@@@@@@(,*,./@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@/,#@@@@@@@@@@@@@@@@(,  (@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@%*,/%@@@@@@@@@@@@@@(,  (@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@%(*.,/#%@@@@@@&( .**./@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@%/,./%#(*... ,../@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@&%%%%&@@/      ,#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@@(.   .,/%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@@@&*./@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@@@%*,/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@(..  .#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@%/.(%*. .(&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@%/.,%@&*,/#,,/#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@%,*(@@@&*,/@@@(,.(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@(.,#@@@@&*./@@@@&/.#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@%.,%@@@@@&(. (@@@@&/ /%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@&#&@@@@@@@&#.*@@@@@&, /&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@@@@@&/,&@@@@@&*,/&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@@@@@&(,&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@@@@@&/,&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@@@@(, ,&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@@@%*  ,&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@@/./#/,&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@&* (&&/.&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@&/.#@@&/,&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@#,*@@@&/,&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@(, #@@@&(.(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@#,,(@@@@@&,/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@%,,(@@@@@@&,/&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@(.,#@@@@@@&* #&@@@@@@@@@@@@@@@@@&%(((*,.......,/#%&&&@@@@@@@@@\n" +
                "@@@@@@@@@@@@@@##&@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%*,.  %@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%* ..,,,,,,,,,,,,,,,    ,&@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&(,  ,&@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&,   ,&@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*    ,&@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%(**/////%&&&&&&&&&&#.    ,&@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&%%%%%(///////*///*   *(%@@@@@@@@\n" +
                "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#((((((((((((((((/*. *#&@@@@@@@@@@\n\n"
    )
}

fun printMenu()
{
    println("\n\nWelcome to the Ko-ko-kotlin hell circus!")
    println("What do you want from us?")
    println("1. Scalar query")
    println("2. Some joins query")
    println("3. OTB + Window functions query")
    println("4. Meta query")
    println("5. Call scalar func from 3d lab")
    println("6. Call table func from 3d lab")
    println("7. Call stored procedure from 3d lab")
    println("8. Call system func or procedure")
    println("9. Create table in DB")
    println("10. Insert in table")
    println("11. Анекдот от господина Тассова")
    println("\n     0. Exit")
}

fun getAnswerAndInvoke(funcs: Array<KFunction0<Unit>>) : Boolean
{
    val input = Scanner(System.`in`)
    val gotCall = input.nextInt()
    if (gotCall == 0)
        return false
    else if (gotCall < 0 || gotCall > 11)
    {
        println("No menu num like this :(")
        return true
    }

    funcs[gotCall - 1].call()

    input.nextLine()
    input.nextLine()

    return true
}

fun TassovsAnek()
{
    println("В картине Малевича 'Чёрный супрематический квадрат' британскими учёными было обнаружено три Украинских флага!")
}

// #1 Скалярный запрос
fun scalarQuery() {
    try {
        val connection =
            DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "ninanina1")
        val sql = "select AVG(DEBT) from LOANSUBJECTS"
        println("Query: $sql");

        val statement = connection.prepareStatement(sql)
        val result = statement.executeQuery();

        result.next()
        println("Result: ${result.getFloat(1)}")
    } catch (err: SQLException)
    {
        println("YA UPAL :(")
        println(err.message)
    }
}

// #2 Запрос с несколькими соединениями JOIN
fun totalJoinQuery()
{
    try {
        val connection =
            DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "ninanina1")
        val sql = "select * from DEBTORS D join LOANSUBJECTS L on D.LOANID = L.LOANID join HANGMAN H on D.HANGMANID = H.HANGMANID"
        println("Query: $sql");

        val statement = connection.prepareStatement(sql)
        val result = statement.executeQuery()
        // ХАХАХАХАХАХХАХА, ДА Я ВСЁ ЭТО ДЕЛАЛ ВРУЧНУЮ
        // Адреса не вывожу, потому что много занимает...
        val resMeta = result.metaData
        println("|%10s|%16s|%16s|%16s|%16s|%10s|%10s|%10s|%10s|%16s|%10s|%16s|%10s|%10s|%16s|%16s|%16s|%16s|%10s|".format(
            resMeta.getColumnName(1), resMeta.getColumnName(2), resMeta.getColumnName(3),
            resMeta.getColumnName(4), resMeta.getColumnName(5), resMeta.getColumnName(7),
            resMeta.getColumnName(8), resMeta.getColumnName(9), resMeta.getColumnName(10),
            resMeta.getColumnName(11), resMeta.getColumnName(12), resMeta.getColumnName(13),
            resMeta.getColumnName(14), resMeta.getColumnName(15), resMeta.getColumnName(16),
            resMeta.getColumnName(17), resMeta.getColumnName(18), resMeta.getColumnName(19),
            resMeta.getColumnName(20)
        ))
        println("|-------------------------------------------------------------------------------------------------------" +
                "--------------------------------------------------------------------------------------------------------" +
                "------------------------------------------------------------|")
        while (result.next())
            println("|%10d|%16s|%16s|%16s|%16s|%10d|%10d|%10d|%10d|%16s|%10d|%16s|%10d|%10d|%16s|%16s|%16s|%16s|%10d|".format(
                result.getInt(1), result.getString(2), result.getString(3),
                result.getString(4), result.getString(5),
                result.getInt(7), result.getInt(8), result.getInt(9), result.getInt(10),
                result.getString(11), result.getInt(12), result.getString(13), result.getInt(14),
                result.getInt(15), result.getString(16), result.getString(17), result.getString(18),
                result.getString(19), result.getInt(20)))
    } catch (err: SQLException)
    {
        println("YA UPAL :(")
        println(err.message)
    }
}

fun OTBQuery()
{
    try {
        val connection =
            DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "ninanina1")
        val sql = "with debtOfDebtors(DEBTORID, FIRSTNAME, LASTNAME, NAME, DEBT, debtorTableNum)\n" +
                "                as (\n" +
                "                    select\n" +
                "                        DEBTORID,\n" +
                "                        FIRSTNAME,\n" +
                "                        LASTNAME,\n" +
                "                        NAME,\n" +
                "                        DEBT,\n" +
                "                        ROW_NUMBER() over (order by DEBTORID) as debtorTableNum\n" +
                "                    from DEBTORS D join LOANSUBJECTS L on D.LOANID = L.LOANID join BANKS B on D.BANKID = B.BANKID\n" +
                "                         )\n" +
                "                select debtorTableNum, DEBTORID, DEBT from debtOfDebtors where debtorTableNum between 1 and 10"
        println("Query: $sql");

        val statement = connection.prepareStatement(sql)
        val result = statement.executeQuery();

        while(result.next())
            println("ResultString: ROWNUM:${result.getInt(1)} ID:${result.getInt(2)} DEBT:${result.getInt(3)}")
    } catch (err: SQLException)
    {
        println("YA UPAL :(")
        println(err.message)
    }
}

fun metaQuery()
{
    try {
        val connection =
            DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "ninanina1")
        val sql = "select OWNER, TABLE_NAME from ALL_TABLES where OWNER = 'SYSTEM'"
        println("Query: $sql");

        val statement = connection.prepareStatement(sql)
        val result = statement.executeQuery();

        while(result.next())
            println("ResultString: Owner:${result.getString(1)} Table name:${result.getString(2)}")
    } catch (err: SQLException)
    {
        println("YA UPAL :(")
        println(err.message)
    }
}

fun scalarFromThirdLab()
{
    try {
        val connection =
            DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "ninanina1")
        val sql = "select getDebtStatus(DEBT), count(getDebtStatus(DEBT)) as DEBTSTATUS\n" +
                "from DEBTORS  D join LOANSUBJECTS L on D.LOANID = L.LOANID\n" +
                "group by getDebtStatus(DEBT)"
        println("Query: $sql");

        val statement = connection.prepareStatement(sql)
        val result = statement.executeQuery();

        while(result.next())
            println("Status:${result.getString(1)} | Status qtty:${result.getInt(2)}")
    } catch (err: SQLException)
    {
        println("YA UPAL :(")
        println(err.message)
    }
}

fun manyOperatorsFromThird()
{
    try {
        val connection =
            DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "ninanina1")
        val sql = "select * from showTableOfDebtorsWithDebtsMoreThanAverLessThanHalfOfMaxPlusMin()"
        println("Query: $sql");

        val statement = connection.prepareStatement(sql)
        val result = statement.executeQuery();

        while(result.next())
            println("LastName: ${result.getString(1)} | LoanID: ${result.getInt(2)} | " +
                    "SubjectName: ${result.getString(3)} | Debt: ${result.getInt(4)}")
    } catch (err: SQLException)
    {
        println("YA UPAL :(")
        println(err.message)
    }
}

fun storedProcedureFromThird()
{
    try {
        val connection =
            DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "ninanina1")
        val sql = "select DEBTORID, DEBT\n" +
                "from DEBTORS D join LOANSUBJECTS L on D.LOANID = L.LOANID\n" +
                "where D.DEBTORID = 85"

        val statement = connection.prepareStatement(sql)
        var result = statement.executeQuery();

        println("BEFORE:")
        result.next()
        println("DebtorID: ${result.getInt(1)} | Debt: ${result.getInt(2)}")

        val callSQL = "{call reduceDebt(85, 100)}"
        val callSt = connection.prepareCall(callSQL)
        callSt.executeUpdate()

        result = statement.executeQuery();
        println("AFTER:")
        result.next()
        println("DebtorID: ${result.getInt(1)} | Debt: ${result.getInt(2)}")
    } catch (err: SQLException)
    {
        println("YA UPAL :(")
        println(err.message)
    }
}

fun systemProcQuery()
{
    try {
        val connection =
            DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "ninanina1")

        val callSQL = "{? = call Floor(5.5463)}"
        val callSt = connection.prepareCall(callSQL)
        callSt.registerOutParameter(1, Types.VARCHAR)
        callSt.executeUpdate()
        val got = callSt.getInt(1)
        println("Floor for 5.5463 is $got")
    } catch (err: SQLException)
    {
        println("YA UPAL :(")
        println(err.message)
    }
}

// Создаём табличку с работниками банка
fun createTable()
{
    try {
        val connection =
            DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "ninanina1")
        val sql = "create table BankEmployees\n" +
                "(\n" +
                "    BankEmployeeID integer generated always as identity primary key not null,\n" +
                "    LastName varchar(64),\n" +
                "    Position varchar2(16),\n" +
                "    BankID integer not null,\n" +
                "    foreign key (BankID) references BANKS(BankID)\n" +
                ")"

        val statement = connection.createStatement()
        statement.execute(sql)

        println("SUCCESSFULLY CREATED")

    } catch (err: SQLException)
    {
        println("YA UPAL :(")
        println(err.message)
    }
}

fun fullTable()
{
    try {
        val connection =
            DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "ninanina1")
        var sql = "insert into BankEmployees (LastName, Position, BankID) values ('Perestoronin', 'Director', 4)"

        val statement = connection.prepareStatement(sql)
        statement.executeUpdate()

        println("SUCCESSFULLY ADDED")

        println("Now table is:")
        sql = "select * from BankEmployees"
        val newStatement = connection.prepareStatement(sql)
        val result = newStatement.executeQuery()
        while (result.next())
            println("EmployeeID: ${result.getInt(1)} | LastName: ${result.getString(2)} | Position: ${result.getString(3)} | " +
                    "BankID: ${result.getInt(4)}")


    } catch (err: SQLException)
    {
        println("YA UPAL :(")
        println(err.message)
    }
}

fun main()
{
    val functions = arrayOf(::scalarQuery, ::totalJoinQuery, ::OTBQuery, ::metaQuery, ::scalarFromThirdLab,
                            ::manyOperatorsFromThird, ::storedProcedureFromThird, ::systemProcQuery,
                            ::createTable, ::fullTable, ::TassovsAnek)
    printMenu()
    while (getAnswerAndInvoke(functions))
        printMenu()

    printLogo()

    println("It's my logo :cool:")
    println("Good bye!")

}