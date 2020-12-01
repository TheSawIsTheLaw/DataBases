import java.sql.*
import java.util.*
import kotlin.reflect.KFunction0

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
    println("\n 12. Exit")
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

fun scalarQuery()
{
    Class.forName("oracle.jdbc.driver.OracleDriver")
    val connection =
        DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "ninanina1")
    val sql = "select AVG(DEBT) from LOANSUBJECTS"
    println("Query: $sql");

    val statement = connection.prepareStatement(sql)
    val result = statement.executeQuery();

    result.next()
    println("Result: ${result.getInt(1)}")
}

fun main()
{
    val functions = arrayOf(::scalarQuery, ::printMenu)
    printMenu()
    while (getAnswerAndInvoke(functions))
        printMenu()
}