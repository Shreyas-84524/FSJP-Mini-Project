package dao;

import model.User;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

/**
 * UserDAO - Data Access Object for handling database operations on the 'users' table.
 */
public class UserDAO {

    /**
     * Inserts a new user using a standalone connection.
     *
     * @param user the User object containing name, email, password, and role
     * @return true if insertion was successful, false otherwise
     */
    public boolean createUser(User user) {
        try (Connection conn = DBConnection.getConnection()) {
            return createUser(conn, user) > 0;
        } catch (SQLException e) {
            System.err.println("Error creating user: " + e.getMessage());
            return false;
        }
    }

    /**
     * Inserts a new user using an existing transaction-aware Connection and returns the generated user ID.
     *
     * @param conn the active java.sql.Connection (participating in a transaction)
     * @param user the User object containing name, email, password, and role
     * @return generated user ID (primary key) if successful, -1 otherwise
     * @throws SQLException if a database error occurs during execution
     */
    public int createUser(Connection conn, User user) throws SQLException {
        String sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
            return -1;
        }
    }

    /**
     * Retrieves a user by their email address.
     *
     * @param email the email to search for
     * @return User object if found, null otherwise
     */
    public User getUserByEmail(String email) {
        String sql = "SELECT id, name, email, password, role, created_at FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching user by email: " + e.getMessage());
        }
        return null;
    }

    /**
     * Retrieves a user by their unique user ID.
     *
     * @param id the primary key of the user
     * @return User object if found, null otherwise
     */
    public User getUserById(int id) {
        String sql = "SELECT id, name, email, password, role, created_at FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching user by id: " + e.getMessage());
        }
        return null;
    }

    /**
     * Checks if a user with the specified email already exists.
     *
     * @param email the email to check
     * @return true if the email exists, false otherwise
     */
    public boolean emailExists(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("Error checking email existence: " + e.getMessage());
            return false;
        }
    }

    /**
     * Helper method to map a ResultSet row to a User object.
     *
     * @param rs the ResultSet positioned at a valid row
     * @return populated User object
     * @throws SQLException if a column reading error occurs
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        String name = rs.getString("name");
        String email = rs.getString("email");
        String password = rs.getString("password");
        String role = rs.getString("role");
        Timestamp createdAt = rs.getTimestamp("created_at");

        return new User(id, name, email, password, role, createdAt);
    }
}
