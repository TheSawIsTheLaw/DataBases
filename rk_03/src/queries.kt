import me.liuwj.ktorm.database.Database
import me.liuwj.ktorm.dsl.*
import me.liuwj.ktorm.schema.*
import java.sql.Date
import java.time.ZoneId

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

// Найти самого старшего сотрудника в бухгалтерии
// Получится найти не одного, а всех старших сотрудников. Можно сказать, что план перевыполнен.
    database.useConnection {
        val result = it.prepareStatement("select *\n" +
                "from employees\n" +
                "where birthday = (\n" +
                "        select min(birthday)\n" +
                "        from employees\n" +
                "        where department = 'Бухгалтерия'\n" +
                "    )\n" +
                "and department = 'Бухгалтерия'").executeQuery()

        while (result.next())
            println(result.getInt(1))
    }

    var minBirth : Date? = null

    database
        .from(EMPLOYEES)
        .select(min(EMPLOYEES.birthday))
        .where { EMPLOYEES.department eq "Бухгалтерия" }
        .forEach { minBirth = it.getDate(1) }

    database
        .from(EMPLOYEES)
        .select(EMPLOYEES.employeeid)
        .where { (EMPLOYEES.department eq "Бухгалтерия") and (EMPLOYEES.birthday eq minBirth!!.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime()) }
        .forEach { println(it.getInt(1)) }

// Найти сотрудников, выходивших больше 3-х раз с рабочего места
// Так как не говорится, в какой день или кто и как, просто посчитаем выходы людей...
    database.useConnection {
        val result = it.prepareStatement("select employeeID\n" +
                "from arrLea\n" +
                "where inOut = 2\n" +
                "group by employeeID\n" +
                "having count(employeeID) > 3").executeQuery()
        while (result.next())
            println(result.getInt(1))
    }

    database
        .from(ARRLEA)
        .select(ARRLEA.employeeid)
        .where { ARRLEA.inout eq 2 }
        .groupBy(ARRLEA.employeeid)
        .having { count(ARRLEA.employeeid) greater 3 }

//-- Найти сотрудника, который пришёл сегодня последним
//-- Я бы мог искать приходы по самому первому приходу, как делал это в скалярной функции, но в задании не обозначено,
//-- поэтому сделал в лоб
    database.useConnection {
        val result = it.prepareStatement("with\n" +
                "     todayTable as (\n" +
                "         select *\n" +
                "         from arrLea\n" +
                "         where inOut = 1\n" +
                "           and extract(year from dayCome) = extract(year from current_date)\n" +
                "           and extract(month from dayCome) = extract(month from current_date)\n" +
                "           and extract(day from dayCome) = extract(day from current_date)\n" +
                "     )\n" +
                "select employeeID, timeCome\n" +
                "from todayTable\n" +
                "where timeCome = (select max(timeCome) from todayTable)").executeQuery()
        while (result.next())
            println("${result.getInt(1)} ${result.getDate(2)}")
    }

//    К несчастью, через орм я никак не могу заэкстрактить нормально дату из-за привязок к уникальным в своём роде коллекциям.
//    Пытаться сделать это через Calendar - себе дороже, потому что minBirth.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime())
//    Поэтому прошу прощения. Получу таблицу из with и поработаю над ней, чтобы получить требуемое
    var helpID = mutableListOf<Int>()
    var helpDate = mutableListOf<Date>()

    database
        .useConnection {
            val result = it.prepareStatement("select *\n" +
                    "         from arrLea\n" +
                    "         where inOut = 1\n" +
                    "           and extract(year from dayCome) = extract(year from current_date)\n" +
                    "           and extract(month from dayCome) = extract(month from current_date)\n" +
                    "           and extract(day from dayCome) = extract(day from current_date)").executeQuery()
            while (result.next())
            {
                helpID.add(result.getInt(1))
                helpDate.add(result.getDate(4))
            }
        }

    var max = helpDate.maxByOrNull { it }

    println("ID: ${ helpID[helpDate.indexOf(max)] }")

}