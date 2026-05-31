package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/lms?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    private static final String USER = "root";

    private static final String PASSWORD = "";

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Database Connected Successfully");
            return connection;
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("MySQL JDBC Driver Not Found", e);
        } catch (SQLException e) {
            throw new IllegalStateException("Database connection failed", e);
        }
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException ignored) {
                // ignore close failures
            }
        }
    }

    public static void main(String[] args) {
        Connection connection = getConnection();
        closeConnection(connection);
    }
}