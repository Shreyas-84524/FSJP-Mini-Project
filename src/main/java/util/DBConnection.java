package util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * DBConnection - Utility class for managing JDBC database connections.
 * Loads database configuration from db.properties in the classpath.
 */
public class DBConnection {

    private static final String CONFIG_FILE = "db.properties";
    private static String url;
    private static String user;
    private static String password;
    private static String driver;
    private static boolean initialized = false;

    static {
        loadConfiguration();
    }

    /**
     * Loads the database configuration from db.properties.
     */
    private static synchronized void loadConfiguration() {
        if (initialized) {
            return;
        }

        Properties props = new Properties();
        try (InputStream in = DBConnection.class.getClassLoader().getResourceAsStream(CONFIG_FILE)) {
            if (in == null) {
                System.err.println("Database configuration file '" + CONFIG_FILE + "' not found in classpath.");
                return;
            }
            props.load(in);

            url = props.getProperty("db.url");
            user = props.getProperty("db.user");
            password = props.getProperty("db.password");
            driver = props.getProperty("db.driver");

            // Allow environment variable or system property overrides
            String sysUrl = System.getProperty("db.url", System.getenv("DB_URL"));
            if (sysUrl != null && !sysUrl.trim().isEmpty()) {
                url = sysUrl.trim();
            }

            String sysUser = System.getProperty("db.user", System.getenv("DB_USER"));
            if (sysUser != null && !sysUser.trim().isEmpty()) {
                user = sysUser.trim();
            }

            String sysPass = System.getProperty("db.password", System.getenv("DB_PASSWORD"));
            if (sysPass != null) {
                password = sysPass;
            } else if ("YOUR_LOCAL_MYSQL_PASSWORD".equals(password)) {
                password = "";
            }

            if (driver != null && !driver.trim().isEmpty()) {
                Class.forName(driver.trim());
            }

            initialized = true;
        } catch (IOException e) {
            System.err.println("Error reading database configuration: " + e.getMessage());
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found: " + e.getMessage());
        }
    }

    private static ConnectionSupplier testConnectionSupplier = null;

    @FunctionalInterface
    public interface ConnectionSupplier {
        Connection getConnection() throws SQLException;
    }

    public static void setTestConnectionSupplier(ConnectionSupplier supplier) {
        testConnectionSupplier = supplier;
    }

    /**
     * Obtains a new JDBC Connection to the MySQL database.
     *
     * @return active java.sql.Connection
     * @throws SQLException if a database access error occurs or configuration is invalid
     */
    public static Connection getConnection() throws SQLException {
        if (testConnectionSupplier != null) {
            return testConnectionSupplier.getConnection();
        }
        if (!initialized) {
            loadConfiguration();
            if (!initialized) {
                throw new SQLException("Database connection failed: configuration could not be loaded.");
            }
        }
        return DriverManager.getConnection(url, user, password);
    }

    /**
     * Closes an open database connection safely.
     *
     * @param conn the Connection to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing database connection: " + e.getMessage());
            }
        }
    }
}
