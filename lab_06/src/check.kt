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
    println("Welcome to the Ko-ko-kotlin hell circus!")
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

    funcs[gotCall - 1].call()

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
        println("Result: ${result.getInt(1)}")
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
    val sql = "with debtOfDebtors(DEBTORID, FIRSTNAME, LASTNAME, NAME, DEBT, debtorTableNum)\n" +
            "as (\n" +
            "    select\n" +
            "        DEBTORID,\n" +
            "        FIRSTNAME,\n" +
            "        LASTNAME,\n" +
            "        NAME,\n" +
            "        DEBT,\n" +
            "        ROW_NUMBER() over (order by DEBTORID) as debtorTableNum\n" +
            "    from DEBTORS D join LOANSUBJECTS L on D.LOANID = L.LOANID join BANKS B on D.BANKID = B.BANKID\n" +
            "         )\n" +
            "select debtorTableNum, DEBTORID, DEBT from debtOfDebtors where debtorTableNum between 1 and 10;\n"
}

fun main()
{
    val functions = arrayOf(::scalarQuery, ::totalJoinQuery)
    printMenu()
    while (getAnswerAndInvoke(functions))
        printMenu()

    printLogo()

    println("It's my logo :cool:")
    println("Good bye!")

}