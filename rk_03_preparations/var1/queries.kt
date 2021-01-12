import me.liuwj.ktorm.database.Database
import me.liuwj.ktorm.dsl.*
import me.liuwj.ktorm.schema.*
import java.sql.Date
import java.sql.ResultSet
import java.time.LocalDateTime
import java.time.ZoneId
import kotlin.math.floor
import kotlin.random.Random

// Вариант 1

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
    val database = Database.connect("jdbc:oracle:thin:@localhost:1521:XE", "oracle.jdbc.driver.OracleDriver", "system", "ninanina1")

//     задание 2
//     номер 1
    database.useConnection {
        val result = it.prepareStatement("select department from employees\n" +
                "having count(employeeID) > 10\n" +
                "group by department").executeQuery()
        while (result.next())
            println(result.getString(1))
    }


    database
        .from(EMPLOYEES)
        .select(EMPLOYEES.department)
        .having { count(EMPLOYEES.employeeid) greater 10 }
        .groupBy(EMPLOYEES.department)
        .forEach { println(it.getString(1)) }

//     номер 2
    database.useConnection {
        val result = it.prepareStatement("select distinct employeeID\n" +
                "from arrLea\n" +
                "where employeeID not in (\n" +
                "    select employeeID from arrLea\n" +
                "    where inOut = 2 and timeCome < TO_DATE('12:00', 'hh:mi')\n" +
                "    )").executeQuery()
        while (result.next())
            println(result.getInt(1))
    }

//    var help : Collection<Int> = mutableListOf()
//    database.useConnection {
//        val res = it.prepareStatement( "select employeeID from arrLea\n" +
//                "where inOut = 2 and timeCome < TO_DATE('12:00', 'hh:mi')").executeQuery()
//        while (res.next())
//            help += res.getInt(1)
//    }
    var help : Collection<Int> = mutableListOf()
    database
        .from(ARRLEA)
        .select(ARRLEA.employeeid)
        .where { (ARRLEA.inout eq 2) and (ARRLEA.timeCome less LocalDateTime.parse("2020-12-01T12:00:00.000")) }
        .forEach { help += it.getInt(1) }

    database
        .from(ARRLEA)
        .selectDistinct(ARRLEA.employeeid)
        .where { ARRLEA.employeeid notInList help }
        .forEach { println(it.getInt(1)) }

//     номер 3
    database.useConnection {
        val result = it.prepareStatement("select distinct department\n" +
                "from (\n" +
                "     select department, aL.employeeID, min(timeCome) come\n" +
                "    from employees join arrLea aL on employees.employeeID = aL.employeeID\n" +
                "    where dayCome = TO_DATE('14-12-2018')\n" +
                "    and inOut = 1\n" +
                "    group by aL.employeeID, department\n" +
                "         )\n" +
                "where come > TO_DATE('09:00', 'hh24:mi')").executeQuery()
        while (result.next())
            println(result.getString(1))
    }

    val sub = database
        .from(EMPLOYEES)
        .innerJoin(ARRLEA, on = EMPLOYEES.employeeid eq ARRLEA.employeeid)
        .select(EMPLOYEES.department, ARRLEA.employeeid, min(ARRLEA.timeCome))
        .where { (ARRLEA.dayCome eq LocalDateTime.parse("2018-12-14T00:00:00.000")) and (ARRLEA.inout eq 1) }
        .groupBy(ARRLEA.employeeid, EMPLOYEES.department)

}