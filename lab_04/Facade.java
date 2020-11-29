import java.sql.*;
import java.util.*;
import oracle.sql.*;
import java.io.*;
import java.math.BigDecimal;

public class Facade
{
    // Скалярная функция
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

    // Никому не нужное оно
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

    final static BigDecimal SUCCESS = new BigDecimal(0);
    final static BigDecimal ERROR = new BigDecimal(1);

    static public BigDecimal ODCIInitialize(BigDecimal[] sctx) {

        return SUCCESS;
    }

    static public BigDecimal ODCIIterate(BigDecimal ctx, String str) {

        return SUCCESS;
    }

    static public BigDecimal ODCITerminate(BigDecimal ctx, String[] str) {

        str[0] = "Hello World";
        return SUCCESS;
    }

    // Табличная функция
    // Выводим все предметы задолженности с долгом в среднее + некоторое переданное значение
    static public ARRAY biggerThenAveragePlus(int plusing) throws SQLException
    {
        String req = "select avg(debt) from LOANSUBJECTS";

        try
        {
            Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "ninanina1");
            PreparedStatement statement = connection.prepareStatement(req);

            // Получаем среднее
            ResultSet result = statement.executeQuery();

            result.next();
            float aver = result.getInt(1);
            result.close();
            statement.close();

            // Получаем количество итоговых записей
            req = "select count(*) from LOANSUBJECTS where DEBT > " + Float.toString(aver + plusing);
            statement = connection.prepareStatement(req);
            result = statement.executeQuery();
            result.next();
            int counter = result.getInt(1);
            result.close();
            statement.close();

            // ¯\_(ツ)_/¯
            req = "select SUBJECTNAME, DEBT from LOANSUBJECTS where DEBT > " + Float.toString(aver + plusing);
            statement = connection.prepareStatement(req);
            result = statement.executeQuery();

            String ret[][] = new String[counter][2];
            int i = 0;
            while (result.next())
            {
//                System.out.println(result.getString(1));
                ret[i][0] = result.getString(1);
                ret[i][1] = result.getString(2);
                i++;
            }

            ArrayDescriptor descriptor = ArrayDescriptor.createDescriptor("AVERRESTABLE", connection);

            System.out.print(ret);
            result.close();
            statement.close();
            ARRAY retArr = new ARRAY(descriptor, connection, ret);
            connection.close();
            return retArr;
        }
        catch (SQLException error)
        {
            System.err.print(error.getMessage());
            System.err.print(error.getSQLState());
            System.err.print(error.getLocalizedMessage());
            error.printStackTrace();

            return null;
        }
    }

    // Нам принесли деняк. Мы довольные. Мы уменьшать долг.
    static public void reduceDebtWithJava(int debtorID, int reduceValue) throws SQLException
    {
        String req = "update LOANSUBJECTS set DEBT = DEBT - " + reduceValue + " where LOANID = (select LOANID from DEBTORS D where D.DEBTORID = " + debtorID + " )";
        try
        {
            Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "ninanina1");
            PreparedStatement statement = connection.prepareStatement(req);

            statement.executeUpdate();
            statement.close();
        }
        catch (SQLException error)
        {
            System.err.print(error.getMessage());
            System.err.print(error.getSQLState());
            System.err.print(error.getLocalizedMessage());
            error.printStackTrace();
        }
    }

    static public void insertChiefJava(int newLoanID, String newSubjectName, int newDebt, String newPurchaseDate, int newPrice) throws SQLException
    {
        if (newDebt <= 1000000)
            return;

        String req = "insert into FOROURCHIEF (loanid, subjectname, debt, purchasedate, price) values (" + newLoanID +", '" + newSubjectName +
                "', " + newDebt + ", '" + newPurchaseDate + "', " + newPrice + ")";
        try
        {
            Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "ninanina1");
            PreparedStatement statement = connection.prepareStatement(req);

            statement.executeUpdate();
            statement.close();
        }
        catch (SQLException error)
        {
            System.err.print(error.getMessage());
            System.err.print(error.getSQLState());
            System.err.print(error.getLocalizedMessage());
            error.printStackTrace();
        }
    }
}