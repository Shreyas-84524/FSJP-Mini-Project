package dao;

import model.JobSeekerProfile;
import model.RecruiterProfile;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * ProfileDAO - Data Access Object for handling profile operations
 * on 'jobseeker_profile' and 'recruiter_profile' tables.
 */
public class ProfileDAO {

    // ==========================================
    // Job Seeker Profile Operations
    // ==========================================

    /**
     * Inserts a new job seeker profile using a standalone connection.
     *
     * @param profile the JobSeekerProfile object to insert
     * @return true if insertion was successful, false otherwise
     */
    public boolean createJobSeekerProfile(JobSeekerProfile profile) {
        try (Connection conn = DBConnection.getConnection()) {
            return createJobSeekerProfile(conn, profile);
        } catch (SQLException e) {
            System.err.println("Error creating job seeker profile: " + e.getMessage());
            return false;
        }
    }

    /**
     * Inserts a new job seeker profile using an existing transaction-aware Connection.
     *
     * @param conn the active java.sql.Connection (participating in a transaction)
     * @param profile the JobSeekerProfile object to insert
     * @return true if insertion was successful, false otherwise
     * @throws SQLException if a database error occurs during execution
     */
    public boolean createJobSeekerProfile(Connection conn, JobSeekerProfile profile) throws SQLException {
        String sql = "INSERT INTO jobseeker_profile (user_id, phone, skills, education, experience, location) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, profile.getUserId());
            ps.setString(2, profile.getPhone());
            ps.setString(3, profile.getSkills());
            ps.setString(4, profile.getEducation());
            ps.setString(5, profile.getExperience());
            ps.setString(6, profile.getLocation());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Retrieves a job seeker profile by user ID.
     *
     * @param userId the user ID associated with the profile
     * @return populated JobSeekerProfile object or null if not found
     */
    public JobSeekerProfile getJobSeekerProfileByUserId(int userId) {
        String sql = "SELECT id, user_id, phone, skills, education, experience, location " +
                     "FROM jobseeker_profile WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    int uId = rs.getInt("user_id");
                    String phone = rs.getString("phone");
                    String skills = rs.getString("skills");
                    String education = rs.getString("education");
                    String experience = rs.getString("experience");
                    String location = rs.getString("location");

                    return new JobSeekerProfile(id, uId, phone, skills, education, experience, location);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching job seeker profile by user ID: " + e.getMessage());
        }
        return null;
    }

    /**
     * Updates an existing job seeker profile in the database.
     * If the profile does not exist yet, creates a new profile record.
     *
     * @param profile the JobSeekerProfile object containing updated fields
     * @return true if update (or fallback insert) succeeded, false otherwise
     */
    public boolean updateJobSeekerProfile(JobSeekerProfile profile) {
        if (profile == null) {
            return false;
        }

        String updateSql = "UPDATE jobseeker_profile SET phone = ?, skills = ?, education = ?, " +
                           "experience = ?, location = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(updateSql)) {

            ps.setString(1, profile.getPhone());
            ps.setString(2, profile.getSkills());
            ps.setString(3, profile.getEducation());
            ps.setString(4, profile.getExperience());
            ps.setString(5, profile.getLocation());
            ps.setInt(6, profile.getUserId());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                return true;
            }

            // Fallback: If no row was updated because profile was not created previously
            return createJobSeekerProfile(profile);

        } catch (SQLException e) {
            System.err.println("Error updating job seeker profile: " + e.getMessage());
            return false;
        }
    }

    // ==========================================
    // Recruiter Profile Operations
    // ==========================================

    /**
     * Inserts a new recruiter profile using a standalone connection.
     *
     * @param profile the RecruiterProfile object to insert
     * @return true if insertion was successful, false otherwise
     */
    public boolean createRecruiterProfile(RecruiterProfile profile) {
        try (Connection conn = DBConnection.getConnection()) {
            return createRecruiterProfile(conn, profile);
        } catch (SQLException e) {
            System.err.println("Error creating recruiter profile: " + e.getMessage());
            return false;
        }
    }

    /**
     * Inserts a new recruiter profile using an existing transaction-aware Connection.
     *
     * @param conn the active java.sql.Connection (participating in a transaction)
     * @param profile the RecruiterProfile object to insert
     * @return true if insertion was successful, false otherwise
     * @throws SQLException if a database error occurs during execution
     */
    public boolean createRecruiterProfile(Connection conn, RecruiterProfile profile) throws SQLException {
        String sql = "INSERT INTO recruiter_profile (user_id, company_name, phone, location, description) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, profile.getUserId());
            ps.setString(2, profile.getCompanyName());
            ps.setString(3, profile.getPhone());
            ps.setString(4, profile.getLocation());
            ps.setString(5, profile.getDescription());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Retrieves a recruiter profile by user ID.
     *
     * @param userId the user ID associated with the profile
     * @return populated RecruiterProfile object or null if not found
     */
    public RecruiterProfile getRecruiterProfileByUserId(int userId) {
        String sql = "SELECT id, user_id, company_name, phone, location, description " +
                     "FROM recruiter_profile WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    int uId = rs.getInt("user_id");
                    String companyName = rs.getString("company_name");
                    String phone = rs.getString("phone");
                    String location = rs.getString("location");
                    String description = rs.getString("description");

                    return new RecruiterProfile(id, uId, companyName, phone, location, description);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching recruiter profile by user ID: " + e.getMessage());
        }
        return null;
    }

    /**
     * Updates an existing recruiter profile in the database.
     * If the profile does not exist yet, creates a new profile record.
     *
     * @param profile the RecruiterProfile object containing updated fields
     * @return true if update (or fallback insert) succeeded, false otherwise
     */
    public boolean updateRecruiterProfile(RecruiterProfile profile) {
        if (profile == null) {
            return false;
        }

        String updateSql = "UPDATE recruiter_profile SET company_name = ?, phone = ?, " +
                           "location = ?, description = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(updateSql)) {

            ps.setString(1, profile.getCompanyName());
            ps.setString(2, profile.getPhone());
            ps.setString(3, profile.getLocation());
            ps.setString(4, profile.getDescription());
            ps.setInt(5, profile.getUserId());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                return true;
            }

            // Fallback: If no row was updated because profile was not created previously
            return createRecruiterProfile(profile);

        } catch (SQLException e) {
            System.err.println("Error updating recruiter profile: " + e.getMessage());
            return false;
        }
    }
}
