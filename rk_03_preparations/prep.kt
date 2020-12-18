import me.liuwj.ktorm.database.Database
import me.liuwj.ktorm.dsl.*
import me.liuwj.ktorm.schema.ColumnDeclaring
import me.liuwj.ktorm.schema.Table
import me.liuwj.ktorm.schema.int
import me.liuwj.ktorm.schema.varchar
import java.sql.ResultSet

object LOANSUBJECTS : Table<Nothing>("LOANSUBJECTS")
{
    var loanid = int("loanid").primaryKey()
    var subjectname = varchar("subjectname")
    var debt = int("debt")
    var purchasedate = varchar("purchasedate")
    var price = int("price")
}

fun main()
{
    val database = Database.connect("jdbc:oracle:thin:@localhost:1521:XE", "oracle.jdbc.driver.OracleDriver", "system", "ninanina1")

    var resultSet : ResultSet
    database.useConnection {
        resultSet = it.prepareStatement("select * from debtors").executeQuery()
        for (i in 0..2)
        {
            resultSet.next()
            println(resultSet.getInt(1))
        }
    }

    database
        .from(LOANSUBJECTS)
        .select(LOANSUBJECTS.loanid)
        .where { LOANSUBJECTS.loanid less 3 } // and, or, eq, like, greater, less
        .forEach { println(it.getInt(1)) }
}