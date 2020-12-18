import me.liuwj.ktorm.database.Database

fun main()
{
    val database = Database.connect("jdbc:oracle:thin:@localhost:1521:XE", "oracle.jdbc.driver.OracleDriver", "system", "ninanina1")
}