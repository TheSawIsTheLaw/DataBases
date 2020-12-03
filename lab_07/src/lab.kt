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

const val ANSI_RESET = "\u001B[0m"
const val ANSI_GREEN = "\u001B[32m"
const val ANSI_YELLOW = "\u001B[33m"
const val ANSI_BLUE = "\u001B[34m"
const val ANSI_PURPLE = "\u001B[35m"
const val ANSI_CYAN = "\u001B[36m"
const val ANSI_WHITE = "\u001B[37m"

fun LINQToObject(loans: List<LoanSubject>)
{
    println(ANSI_BLUE + "Полный селект!" + ANSI_RESET)
    loans.forEach { println("\u001B[33m[31m$it\u001B[0m") }

    println("\n" + ANSI_YELLOW + "Вот тут пример order by" + ANSI_RESET)
    println((loans.sortedBy{ it.debt }.forEach { println("\u001B[33m[31m$it\u001B[0m") }))

    println("\n" + ANSI_BLUE + "Вот тут пример where < 500000" + ANSI_RESET)
    println((loans.filter { it.debt < 500000 }).forEach{ println("\u001B[33m[31m$it\u001B[0m") })

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

fun main()
{
    val loans: List<LoanSubject> by lazy {
        listOf(
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

}
