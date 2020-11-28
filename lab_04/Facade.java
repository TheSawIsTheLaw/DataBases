import java.sql.*;
import java.util.*;
import oracle.sql.*;
import java.io.*;

public class Facade
{
    public static String debtorStatus(int debt)
    {
        String status;
        if (debt < 50000)
            status = "Not so scary";
        else if (debt < 100000)
            status = "Normal";
        else if (debt < 500000)
            status = "Need attention";
        else
            status = "Target to kill";

        return status;
    }

    public static int customMax(String tableName, String columnName) throws SQLException
    {
        String req = "select ? from ?"; // ? - маркер параметра

        System.out.println("Fuck");

        int max = -1;
        try
        {
            Connection connection = DriverManager.getConnection("jdbc:default:connection:");
            PreparedStatement statement = connection.prepareStatement(req);
            statement.setString(1, tableName.toUpperCase());
            statement.setString(2, columnName.toUpperCase());



            ResultSet result = statement.executeQuery();

            max = 1;

            while (result.next())
            {
                if (max < result.getInt(1))
                {
                    max = result.getInt(1);
                }
            }

            result.close();
            statement.close();
            connection.close();

        }
        catch (SQLException error)
        {
            System.err.print(error.getMessage());
        }
        return max;
    }
}