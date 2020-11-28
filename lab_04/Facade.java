import java.sql.*;
import java.util.*;
import oracle.sql.*;
import java.io.*;

public class Facade
{
    public static String debtorStatus(int debt) throws SQLException
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
}