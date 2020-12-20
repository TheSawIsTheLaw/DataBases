import me.liuwj.ktorm.database.Database
import me.liuwj.ktorm.dsl.*
import me.liuwj.ktorm.schema.*
import java.sql.ResultSet
import kotlin.math.floor
import kotlin.random.Random

// Вариант 2

object EMPLOYEES : Table<Nothing>("EMPLOYEES")
{
    var employeeid = int("employeeid").primaryKey()
    var FIO = varchar("fio")
    var birthday = datetime("birthday")
    var department = varchar("department")
}

object ARRLEA : Table<Nothing>("ARRLEA")
{
    var employeeid = int("employeeid")
    var dayCome = varchar("daycome")
    var weekday = varchar("weekday")
    var timeCome = varchar("timecome")
    var inout = int("inout")
}

fun main()
{
//    print(Random.nextInt(1, 5)) Сгенерили вариант 2
    val database = Database.connect("jdbc:oracle:thin:@localhost:1521:XE", "oracle.jdbc.driver.OracleDriver", "system", "ninanina1")
    database
//        .from(EMPLOYEES)
//        .select(EMPLOYEES.employeeid, EMPLOYEES.birthday )
//        .forEach { println("${it.getInt(1)} ${it.getString(2)}") }
//
//    database
//        .from(ARRLEA)
//        .select(ARRLEA.employeeid, ARRLEA.weekday)
//        .forEach { println("${it.getInt(1)} ${it.getString(2)}") } -- проверка
    // задание 2
    // номер 1
    database.useConnection {
        val result = it.prepareStatement("select department from employees\n" +
                "where department not in(\n" +
                "    select department from employees\n" +
                "    where floor(months_between(current_date, birthday) / 12) > 25\n" +
                "    )").executeQuery()
        while (result.next())
            println(result.getString(1))
    }

    val help : ResultSet
    database.useConnection {
        help = it.prepareStatement( "    select department from employees\n" +
                "    where floor(months_between(current_date, birthday) / 12) > 25\n" +
                "    )").executeQuery()
    }

    val query = database
        .from(EMPLOYEES)
        .select(EMPLOYEES.department)
        .where { EMPLOYEES.department notInList(help) }

    // номер 2
    database.useConnection {
        val result = it.prepareStatement("select *\n" +
                "            from employees join arrLea aL on employees.employeeID = aL.employeeID\n" +
                "    where extract(year from TO_DATE(dayCome, 'dd-mm-yyyy')) = extract(year from current_date) and extract(day from TO_DATE(dayCome, 'dd-mm-yyyy')) = extract(day from current_date)\n" +
                "    and extract(year from TO_DATE(dayCome, 'hh24-mi-ss')) in (\n" +
                "            select min(timeCome)\n" +
                "                    from arrLea\n" +
                "                    where extract(year from TO_DATE(dayCome, 'dd-mm-yyyy')) = extract(year from current_date) and extract(day from TO_DATE(dayCome, 'dd-mm-yyyy')) = extract(day from current_date)\n" +
                "            )").executeQuery()
        while (result.next())
            println(result.getString(1))
    }

    // номер 3
    database.useConnection {
        val result = it.prepareStatement("select count(EMPLOYEEID)\n" +
                "from EMPLOYEES\n" +
                "where employeeID in (\n" +
                "    select employeeID from arrLea where to_date(timeCome, 'hh24:mi:ss') > to_date('09:00:00', 'hh24:mi:ss') and inOut = 1)").executeQuery()
        while (result.next())
            println(result.getString(1))
    }
}
// Почему так плохо...