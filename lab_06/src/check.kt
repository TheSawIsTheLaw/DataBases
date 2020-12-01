import java.sql.*
import java.util.*
import java.sql.SQLException


fun main() {
    Class.forName("oracle.jdbc.driver.OracleDriver")
    val connection =
        DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "ninanina1")
    val sql = "select * from LOANSUBJECTS"
    val statement = connection.prepareStatement(sql)
    val result = statement.executeQuery();

    while (result.next())
        println(result.getInt(1))
}