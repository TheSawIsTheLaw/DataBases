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
        String req = "select " + columnName + " from " + tableName;

        int max = -1;
        try
        {
            Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "ninanina1");
            PreparedStatement statement = connection.prepareStatement(req);

            ResultSet result = statement.executeQuery();

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
            System.err.print(error.getSQLState());
            System.err.print(error.getLocalizedMessage());
            error.printStackTrace();
        }
        return max;
    }
}