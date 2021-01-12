import me.liuwj.ktorm.database.Database
import me.liuwj.ktorm.dsl.*
import me.liuwj.ktorm.schema.*
import java.sql.Date
import java.sql.ResultSet
import java.time.LocalDateTime
import java.time.ZoneId
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
    var dayCome = datetime("daycome")
    var weekday = varchar("weekday")
    var timeCome = datetime("timecome")
    var inout = int("inout")
}

fun main()
{
//    print(Random.nextInt(1, 5)) Сгенерили вариант 2
    val database = Database.connect("jdbc:oracle:thin:@localhost:1521:XE", "oracle.jdbc.driver.OracleDriver", "system", "ninanina1")

//     задание 2
//     номер 1
    database.useConnection {
        val result = it.prepareStatement("select department\n" +
                "from employees\n" +
                "where department not in (\n" +
                "    select department\n" +
                "    from employees\n" +
                "    where floor(months_between(current_date, birthday) / 12) < 25\n" +
                "    )").executeQuery()
        while (result.next())
            println(result.getString(1))
    }


    var help : Collection<String> = mutableListOf()
    database.useConnection {
        val res = it.prepareStatement( "    select department\n" +
                "    from employees\n" +
                "    where floor(months_between(current_date, birthday) / 12) < 25").executeQuery()
        while (res.next())
            help += res.getString(1)
    }

    database
        .from(EMPLOYEES)
        .select(EMPLOYEES.department)
        .where { EMPLOYEES.department notInList help }
        .forEach { println("${it.getString(1)}") }

//
//     номер 2
    database.useConnection {
        val result = it.prepareStatement("select employeeID\n" +
                "from arrLea\n" +
                "where timeCome in (\n" +
                "    select min(timeCome)\n" +
                "    from arrLea\n" +
                "    where extract(year from dayCome) = extract(year from current_date) " +
                "    and extract(month from dayCome) = extract(month from current_date) " +
                "    and extract(day from dayCome) = extract(day from current_date)\n" +
                "    )").executeQuery()
        result.next()
        while (result.next())
            println(result.getInt(1))
    }

    var newHelp : Collection<LocalDateTime> = mutableListOf()
    database.useConnection {
        val result = it.prepareStatement("select min(timeCome)\n" +
                "    from arrLea\n" +
                "    where extract(year from dayCome) = extract(year from current_date) " +
                "    and extract(month from dayCome) = extract(month from current_date)" +
                "    and extract(day from dayCome) = extract(day from current_date)").executeQuery()
        while (result.next())
            if (result.getDate(1) != null)
                newHelp += result.getDate(1).toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime()
    }

    database
        .from(ARRLEA)
        .selectDistinct(ARRLEA.employeeid)
        .where { ARRLEA.timeCome inList newHelp }
//        .forEach { println(it.getDate(1)) }
//
//     номер 3
    database.useConnection {
        val result = it.prepareStatement("select employeeID\n" +
                "from (\n" +
                "    select employeeID, min(timeCome) mTime\n" +
                "    from arrLea\n" +
                "    where inOut = 1\n" +
                "    group by employeeID, dayCome\n" +
                "    )\n" +
                "where mTime > TO_DATE('09:00', 'hh:mi')\n" +
                "group by employeeID\n" +
                "having count(employeeID) > 5").executeQuery()
        while (result.next())
            println(result.getString(1))
    }

}