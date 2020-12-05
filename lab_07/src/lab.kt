import DEBTORS.firstname
import com.google.gson.Gson
import me.liuwj.ktorm.database.Database
import me.liuwj.ktorm.dsl.*
import me.liuwj.ktorm.schema.*
import net.servicestack.func.Func.*

import kotlin.collections.forEach

class LoanSubject(var loanID: Int, var subjectName: String?,
                  var debt: Int, var purchaseDate: String,
                  var price: Int)
{
    override fun toString(): String {
        return "|Loan: id = $loanID | name = $subjectName | " +
                "debt = $debt | purchaseDate = $purchaseDate | " +
                "price = $price|"
    }
}

class Debtor(var debtorID: Int, var firstName: String,
             var lastName: String, var telephoneNum: String?,
             var passportNum: String?, var homeAddress: String?,
             var loanID: Int)
{
    override fun toString(): String {
        return "|debtor: id = $debtorID | fName = $firstName | " +
                "lName = $lastName | telNum = $telephoneNum | " +
                "passNum = $passportNum | homeAddr = $homeAddress | " +
                "loanID = $loanID"
    }
}

object LOANSUBJECTS : Table<Nothing>("LOANSUBJECTS")
{
    var loanid = int("loanid").primaryKey()
    var subjectname = varchar("subjectname")
    var debt = int("debt")
    var purchasedate = varchar("purchasedate")
    var price = int("price")
}

object DEBTORS : Table<Nothing>("DEBTORS")
{
    var debtorid = int("debtorid").primaryKey()
    var firstname = varchar("firstname")
    var lastname = varchar("lastname")
    var telephonenum = varchar("telephonenum")
    var passportnum = varchar("passportNum")
    var homeaddress = varchar("homeaddress")
    var loanid = int("loanid")
    var bankid = int("bankid")
    var hangmanid = int("hangmanid")
}

const val ANSI_RESET = "\u001B[0m"
const val ANSI_GREEN = "\u001B[32m"
const val ANSI_YELLOW = "\u001B[33m"
const val ANSI_BLUE = "\u001B[34m"
const val ANSI_PURPLE = "\u001B[35m"
const val ANSI_CYAN = "\u001B[36m"
const val ANSI_WHITE = "\u001B[37m"

fun LINQToObject(loans: MutableList<LoanSubject>)
{
    println(ANSI_BLUE + "Полный селект!" + ANSI_RESET)
    loans.forEach { println("\u001B[33m[31m$it\u001B[0m") }

    println("\n" + ANSI_YELLOW + "Вот тут пример order by" + ANSI_RESET)
    println((loans.sortedBy{ it.debt }.forEach { println("\u001B[33m[31m$it\u001B[0m") }))

    println("\n" + ANSI_BLUE + "Вот тут пример where < 500000" + ANSI_RESET)
    println((loans.filter { it.debt < 500000 }).forEach{ println("\u001B[33m[31m$it\u001B[0m") })

    println("\n" + ANSI_BLUE + "Вот тут пример groupBy группируем по первым буковкам в именах" + ANSI_RESET)
    loans.groupBy { it.subjectName!![0] }.map { Pair(it.key, it) }.forEach { println(it) }

    println("\n" + ANSI_BLUE + "Вот тут вот пример использования having с приколом в стиле лямбда в лямбда))))))" + ANSI_RESET)
    val getAvgLess500000 : () -> Float = {
        var sum = 0F
        var count= 0F
        (loans.filter { it.debt < 500000 }).forEach { sum += it.debt; count++ }
        sum / count}
    println(ANSI_YELLOW + "${getAvgLess500000()}" + ANSI_RESET)

    val getAvg : () -> Float =
        {
            var sum = 0F
            var count= 0F
            loans.forEach { sum += it.debt; count++ }
            sum / count
        }
    println("\n" + ANSI_BLUE + "Я тут всего понаделал, поэтому дальше будет смесь where, агрегатки и where > этой агрекатки" + ANSI_RESET)
    println((loans.filter { it.debt < getAvg() }).forEach{ println("\u001B[33m[31m$it\u001B[0m") })

    println()
}

fun LINQToJSON(loans: MutableList<LoanSubject>)
{
    println(ANSI_PURPLE + "Вот тут я сейчас превращу рабочую табличку в json строку" + ANSI_RESET)
    val jsonString = Gson().toJson(loans)
    println(ANSI_YELLOW + jsonString + ANSI_RESET)

    println("\n" + ANSI_PURPLE + "Теперь 1) Чтение из JSON документа. Прочитаем " + ANSI_RESET)
    val gotJson = Gson().fromJson(jsonString, Array<LoanSubject>::class.java).toMutableList() // Ha-ha, magic.
    print(ANSI_YELLOW)
    gotJson.forEach { println(it.toString()) }
    print(ANSI_RESET)

    println("\n" + ANSI_PURPLE + "Теперь 2) Обновление JSON документа. Мы прочитали Аррейку. Теперь можем её изменить и создать новый JSON\n Поменяем имя первого долга с amarok на golf " + ANSI_RESET)
    gotJson[0].subjectName = "golf"
    println(ANSI_PURPLE + "И итоговый JSON будет:" + ANSI_RESET)
    println(ANSI_YELLOW + Gson().toJson(gotJson) + ANSI_RESET)

    println("\n" + ANSI_PURPLE + "Теперь 3) Добавление в JSON документ. Добавим новый объект долга!" + ANSI_RESET)
    gotJson.add(LoanSubject(21, "granta", 666666, "2010-01-01", 1000000))
    println("\n" + ANSI_PURPLE + "Вуаля! Ещё и вывести красиво можно" + ANSI_RESET)
    print(ANSI_YELLOW)
    Gson().toJson(gotJson).forEach { if (it == '{' || it == ',') print("$it\n   ") else if (it == '}') print("\n   $it") else print(it)}
    print(ANSI_RESET)
}

fun LINQToSQL(loans: MutableList<LoanSubject>, debtors: MutableList<Debtor>)
{
    // А потом оказалось, что я делал не то :)
//    println("\n\n" + ANSI_CYAN + "1) Селектим всех должников с номерами телефона, включающих в себя 85, а потом выводим всех их отсортированными по имени" + ANSI_RESET)
//    val joinable = debtors.filter { it.telephoneNum!!.contains("85") }.sortedBy { it.firstName }
//    print(ANSI_YELLOW)
//    joinable.forEach { println(it.toString()) }
//    print(ANSI_RESET)
//
//    println("\n" + ANSI_CYAN + "2) Джойн :) Заджойним то чудо, которое получили в предыдущем " +
//            "запросе к таблице loans и выведем их айдишники, имена и задолженности. В " +
//            "отсортированном виде, офкорс\n Полученный join:" + ANSI_RESET)
//    print(ANSI_YELLOW)
//    val joinResult = join(loans, joinable) { l, j -> l.loanID == j.loanID}
//            .sortedBy { it.B.firstName }
//            .map { listOf(it.B.debtorID, it.A.loanID, it.B.firstName, it.B.lastName, it.A.debt) }
//    joinResult.forEach { println(it.toString()) }
//    print(ANSI_RESET)
//
//    println("\n" + ANSI_CYAN + "Также мне хотелось бы показать, как тут работают агрегатные функции. Выведем сумму по задолженностям людей, выведенных выше")
//    val sum = join(loans, joinable) { l, j -> l.loanID == j.loanID }.sumBy { it.A.debt }
//    println(ANSI_YELLOW + sum + ANSI_RESET)
//
//    println("\n" + ANSI_CYAN + "И средний долг всех людей с именами, начинающимися на L")
//    val joinDL = join(loans, debtors) { l, d -> l.loanID == d.loanID }
//            .filter { it.B.firstName[0] == 'L' }
//    // Ваще невероятная магия и костыли
//    val avg = joinDL.map { it.A.debt }.average()
//    println("Таблица, по которой это считалось и значение, собственно: $ANSI_RESET")
//    print(ANSI_YELLOW)
//    joinDL.forEach { println(it) }
//    println("AVG: $avg$ANSI_RESET")
    val database = Database.connect("jdbc:oracle:thin:@localhost:1521:XE", "oracle.jdbc.driver.OracleDriver", "system", "ninanina1")

    println("\n\n" + ANSI_CYAN + "1) Выведем все те долги, задолженности по которым будут меньше" +
            "средней задолженности по ВСЕЙ таблице" + ANSI_RESET)
    var debtAvg : Int = 0
    database
            .from(LOANSUBJECTS)
            .select(avg(LOANSUBJECTS.debt))
            .forEach { debtAvg = it.getInt(1) }
    print(ANSI_YELLOW)
    database
            .from(LOANSUBJECTS)
            .select(LOANSUBJECTS.loanid, LOANSUBJECTS.subjectname, LOANSUBJECTS.debt)
            .where {
                val conditions = ArrayList<ColumnDeclaring<Boolean>>()
                conditions += LOANSUBJECTS.debt less debtAvg

                conditions.reduce { a, b -> a and b }
            }
            .forEach { println("loanID: ${it.getInt(1)} name: ${it.getString(2)} debt: ${it.getInt(3)} avgDebt: $debtAvg") }
    print(ANSI_RESET)

    println("\n\n" + ANSI_CYAN + "2) Селектим всех должников с номерами телефона, включающих в себя 85, смотрим, у кого долг выше некоторой цифры, " +
            "а потом выводим всех их отсортированными по имени" + ANSI_RESET)
    // Выводим информацию о всех тех, чей номер телефона начинается с 85 и долг выше некоторого значения
    print(ANSI_YELLOW)
    database
            .from(LOANSUBJECTS)
            .innerJoin(DEBTORS, on = LOANSUBJECTS.loanid eq DEBTORS.loanid)
            .select(DEBTORS.firstname, DEBTORS.lastname, LOANSUBJECTS.debt, DEBTORS.telephonenum)
            .where {
                val conditions = ArrayList<ColumnDeclaring<Boolean>>()

                conditions += DEBTORS.telephonenum like "85%"
                conditions += LOANSUBJECTS.debt greater 800000

                conditions.reduce { a, b -> a and b }
            }
            .orderBy(DEBTORS.firstname.asc())
            .forEach { println("fName: ${it.getString(1)} sName: ${it.getString(2)} debt: ${it.getInt(3)} telNum: ${it.getString(4)}")}
    print(ANSI_RESET)
}


fun main()
{
    val loans: MutableList<LoanSubject> by lazy {
        mutableListOf(
            LoanSubject(1,"amarok",484176,"2004-11-18", 5365240),
            LoanSubject(2,"collection",783176,"2002-01-28",788508),
            LoanSubject(3,"paper",816895,"2014-10-01",9681245),
            LoanSubject(4,"both",423489,"1994-11-05",3746184),
            LoanSubject(5,"no",669287,"1988-02-23",325975),
            LoanSubject(6,"down",687603,"1971-02-13",3875574),
            LoanSubject(7,"size",951472,"1989-10-16",1988175),
            LoanSubject(8,"these",547705,"1986-04-11",4576332),
            LoanSubject(9,"time",356937,"2018-10-21",1865175),
            LoanSubject(10,"almost",756512,"2006-12-15",855354),
            LoanSubject(11,"far",64784,"2008-04-05",6441101),
            LoanSubject(12,"democratic",180836,"2019-02-01",8566102),
            LoanSubject(13,"between",892415,"2008-05-25",2564569),
            LoanSubject(14,"professor",209603,"1980-04-04",4913012),
            LoanSubject(15,"way",456094,"1983-08-15",8166220),
            LoanSubject(16,"fly",527364,"1972-08-05",4964363),
            LoanSubject(17,"low",920635,"2010-10-13",9076803),
            LoanSubject(18,"current",574240,"1976-01-05",9908757),
            LoanSubject(19,"feeling",497809,"2000-09-14",2578574),
            LoanSubject(20,"lawyer",217020,"1972-04-04",3096641))
    }

    LINQToObject(loans)
    LINQToJSON(loans)

    val debtors: MutableList<Debtor> by lazy {
        mutableListOf(
                Debtor(85,"Richard","Cross",  "86680980492","4299013226","66821 George Bypass West Rebecca, ID 71770",1),
                Debtor(86,"Karen","Moyer",    "85510782232","1294105691","85211 Ramos Green Wallsberg, NH 03070",2),
                Debtor(87,"Ryan","Johnson",   "81720444351","5131840919","0142 Joshua Haven Suite 163 West Brianmouth, IA 59119",3),
                Debtor(88,"Anthony","Oneal",  "84588565378","1390790809","Unit 0854 Box 7284 DPO AE 35360",4),
                Debtor(89,"Brittany","Green", "82029475269","8514585441","8912 Graham Radial Suite 884 West Peter, NV 37469",5),
                Debtor(90,"Patrick","Jones",  "82781507224","3204727089","55727 Little Walk Suite 683 South Ericburgh, FL 10056",6),
                Debtor(91,"Danny","Evans",    "86485781327","9098584261","76657 Megan Roads Apt. 403 Colonfurt, AR 42357",7),
                Debtor(92,"Hector","Jones",   "83319242634","6680754331","452 Sanchez Station Suite 155 New Rebeccabury, IL 69254",8),
                Debtor(93,"Lauren","Simpson", "86696521238","9885482839","5829 Matthew Center Suite 580 Paulstad, KY 48026",9),
                Debtor(94,"Michael","Johnson","85665349603","7870618004","8356 Jerry Village Apt. 861 Dixonberg, VT 20899",10),
                Debtor(95,"Susan","Ray",      "85557414181","7522614227","USS Morales FPO AP 24225",11),
                Debtor(96,"Julie","Gilbert",  "88913132053","3268201231","66439 Nelson Crest North Loganberg, MN 91387",12),
                Debtor(97,"Ronald","Simon",   "80721076205","4433171666","13304 Jose Locks Apt. 366 Harperstad, MD 33442",13),
                Debtor(98,"Cindy","Guerrero", "87391598093","9763215441","PSC 1374, Box 9802 APO AE 27792",14),
                Debtor(99,"Melissa","Salazar","86152827556","2634234545","11789 Sandra Circle Lake Michelleview, NC 96601",15),
                Debtor(100,"Earl","Mcmillan", "87680109045","1116950443","93603 Eric Port Suite 052 Ashleyshire, LA 74932",16),
                Debtor(101,"Lisa","Aguilar",  "86028027897","5529715326","87372 Myers Avenue East Matthewville, ND 18865",17),
                Debtor(102,"Kathy","Atkinson","88761896358","1284216076","84498 Schwartz Loaf Suite 067 South Katherineshire, MT 87099",18),
                Debtor(103,"Patricia","Park", "88610111172","4575140273","66203 Palmer Port Suite 225 North Bryanmouth, KY 52046",19),
                Debtor(104,"Linda","Hughes",  "88691428150","4785587154","3699 Cross Forges Port Markberg, NY 05630",20))
    }

    LINQToSQL(loans, debtors)

}
