package dao;

import model.Application;
import model.ApplicationItem;
import model.RecruiterApplicantItem;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * ApplicationDAO - Data Access Object for job application operations.
 * 
 * Manages queries and insertions on the 'applications' table:
 *   - hasApplied(jobId, jobseekerId): Checks whether a job seeker has already applied for a specific job.
 *   - createApplication(application): Creates a new application record (default status 'APPLIED').
 *   - getApplication(jobId, jobseekerId): Retrieves specific application record if it exists.
 *   - getApplicationsByJobseekerId(jobseekerId): Retrieves all applications submitted by a job seeker,
 *     joined with job details in a single query ordered by applied_at DESC.
 * 
 * Uses PreparedStatement, try-with-resources, and parameterized SQL queries to ensure thread-safety
 * and prevent SQL injection.
 */
public class ApplicationDAO {

    /**
     * Checks if a job seeker has already submitted an application for the specified job.
     * 
     * @param jobId ID of the job
     * @param jobseekerId User ID of the job seeker
     * @return true if an application record exists, false otherwise
     */
    public boolean hasApplied(int jobId, int jobseekerId) {
        if (jobId <= 0 || jobseekerId <= 0) {
            return false;
        }

        String sql = "SELECT COUNT(*) FROM applications WHERE job_id = ? AND jobseeker_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, jobId);
            ps.setInt(2, jobseekerId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("[ApplicationDAO] Error checking application existence: " + e.getMessage());
        }

        return false;
    }

    /**
     * Creates a new job application record in the 'applications' table.
     * 
     * @param application Application object containing jobId, jobseekerId, and optional status
     * @return true if inserted successfully, false if duplicate or error occurs
     */
    public boolean createApplication(Application application) {
        if (application == null || application.getJobId() <= 0 || application.getJobseekerId() <= 0) {
            return false;
        }

        String sql = "INSERT INTO applications (job_id, jobseeker_id, status) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, application.getJobId());
            ps.setInt(2, application.getJobseekerId());
            
            String status = application.getStatus();
            if (status == null || status.trim().isEmpty()) {
                status = "APPLIED";
            }
            ps.setString(3, status);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLIntegrityConstraintViolationException e) {
            // Catches unique constraint uk_job_jobseeker (job_id, jobseeker_id) or FK violation
            System.err.println("[ApplicationDAO] Duplicate application or constraint violation: " + e.getMessage());
            return false;
        } catch (SQLException e) {
            // Also check vendor-specific MySQL duplicate key code (1062)
            if (e.getErrorCode() == 1062) {
                System.err.println("[ApplicationDAO] MySQL duplicate key error 1062: " + e.getMessage());
                return false;
            }
            System.err.println("[ApplicationDAO] Error inserting application: " + e.getMessage());
            return false;
        }
    }

    /**
     * Retrieves an application by job ID and job seeker user ID.
     * 
     * @param jobId ID of the job
     * @param jobseekerId User ID of the job seeker
     * @return Application object if found, null otherwise
     */
    public Application getApplication(int jobId, int jobseekerId) {
        if (jobId <= 0 || jobseekerId <= 0) {
            return null;
        }

        String sql = "SELECT id, job_id, jobseeker_id, status, applied_at FROM applications WHERE job_id = ? AND jobseeker_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, jobId);
            ps.setInt(2, jobseekerId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    int jId = rs.getInt("job_id");
                    int jsId = rs.getInt("jobseeker_id");
                    String status = rs.getString("status");
                    Timestamp appliedAt = rs.getTimestamp("applied_at");

                    return new Application(id, jId, jsId, status, appliedAt);
                }
            }
        } catch (SQLException e) {
            System.err.println("[ApplicationDAO] Error retrieving application: " + e.getMessage());
        }

        return null;
    }

    /**
     * Retrieves all applications submitted by a specific job seeker, joined with job details.
     * Avoids N+1 query overhead by joining applications and jobs in a single query.
     * 
     * @param jobseekerId User ID of the job seeker
     * @return List of ApplicationItem objects ordered by applied_at DESC
     */
    public List<ApplicationItem> getApplicationsByJobseekerId(int jobseekerId) {
        List<ApplicationItem> list = new ArrayList<>();
        if (jobseekerId <= 0) {
            return list;
        }

        String sql = "SELECT a.id, a.job_id, a.jobseeker_id, a.status, a.applied_at, "
                   + "j.title, j.description, j.skills, j.location, j.created_at "
                   + "FROM applications a "
                   + "INNER JOIN jobs j ON a.job_id = j.id "
                   + "WHERE a.jobseeker_id = ? "
                   + "ORDER BY a.applied_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, jobseekerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("id");
                    int jobId = rs.getInt("job_id");
                    int jsId = rs.getInt("jobseeker_id");
                    String status = rs.getString("status");
                    Timestamp appliedAt = rs.getTimestamp("applied_at");

                    String jobTitle = rs.getString("title");
                    String jobDescription = rs.getString("description");
                    String jobSkills = rs.getString("skills");
                    String jobLocation = rs.getString("location");
                    Timestamp jobCreatedAt = rs.getTimestamp("created_at");

                    ApplicationItem item = new ApplicationItem(
                            id, jobId, jsId, status, appliedAt,
                            jobTitle, jobDescription, jobSkills, jobLocation, jobCreatedAt
                    );
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("[ApplicationDAO] Error fetching applications for job seeker: " + e.getMessage());
        }

        return list;
    }

    /**
     * Retrieves all applicants across all jobs posted by the specified recruiter.
     * Orders by applied_at DESC.
     * 
     * @param recruiterId User ID of the recruiter
     * @return List of RecruiterApplicantItem objects
     */
    public List<RecruiterApplicantItem> getApplicantsByRecruiterId(int recruiterId) {
        List<RecruiterApplicantItem> list = new ArrayList<>();
        if (recruiterId <= 0) {
            return list;
        }

        String sql = "SELECT a.id AS application_id, a.job_id, a.jobseeker_id, a.status, a.applied_at, "
                   + "u.name AS applicant_name, u.email AS applicant_email, "
                   + "jp.phone, jp.skills, jp.education, jp.experience, jp.location AS applicant_location, "
                   + "j.title AS job_title, j.location AS job_location "
                   + "FROM applications a "
                   + "INNER JOIN jobs j ON a.job_id = j.id "
                   + "INNER JOIN users u ON a.jobseeker_id = u.id "
                   + "LEFT JOIN jobseeker_profile jp ON jp.user_id = u.id "
                   + "WHERE j.recruiter_id = ? "
                   + "ORDER BY a.applied_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, recruiterId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToRecruiterApplicantItem(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("[ApplicationDAO] Error fetching applicants for recruiter: " + e.getMessage());
        }

        return list;
    }

    /**
     * Retrieves applicants for a specific job, strictly verifying that the job belongs to the authenticated recruiter.
     * 
     * @param jobId ID of the job
     * @param recruiterId User ID of the recruiter
     * @return List of RecruiterApplicantItem objects ordered by applied_at DESC
     */
    public List<RecruiterApplicantItem> getApplicantsForJob(int jobId, int recruiterId) {
        List<RecruiterApplicantItem> list = new ArrayList<>();
        if (jobId <= 0 || recruiterId <= 0) {
            return list;
        }

        String sql = "SELECT a.id AS application_id, a.job_id, a.jobseeker_id, a.status, a.applied_at, "
                   + "u.name AS applicant_name, u.email AS applicant_email, "
                   + "jp.phone, jp.skills, jp.education, jp.experience, jp.location AS applicant_location, "
                   + "j.title AS job_title, j.location AS job_location "
                   + "FROM applications a "
                   + "INNER JOIN jobs j ON a.job_id = j.id "
                   + "INNER JOIN users u ON a.jobseeker_id = u.id "
                   + "LEFT JOIN jobseeker_profile jp ON jp.user_id = u.id "
                   + "WHERE j.id = ? AND j.recruiter_id = ? "
                   + "ORDER BY a.applied_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, jobId);
            ps.setInt(2, recruiterId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToRecruiterApplicantItem(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("[ApplicationDAO] Error fetching applicants for job " + jobId + ": " + e.getMessage());
        }

        return list;
    }

    /**
     * Helper method to map a ResultSet row to a RecruiterApplicantItem object.
     * 
     * @param rs ResultSet positioned at a valid row
     * @return populated RecruiterApplicantItem
     * @throws SQLException if a column reading error occurs
     */
    private RecruiterApplicantItem mapResultSetToRecruiterApplicantItem(ResultSet rs) throws SQLException {
        int applicationId = rs.getInt("application_id");
        int jobId = rs.getInt("job_id");
        int jobseekerId = rs.getInt("jobseeker_id");
        String status = rs.getString("status");
        Timestamp appliedAt = rs.getTimestamp("applied_at");

        String applicantName = rs.getString("applicant_name");
        String applicantEmail = rs.getString("applicant_email");

        String phone = rs.getString("phone");
        String skills = rs.getString("skills");
        String education = rs.getString("education");
        String experience = rs.getString("experience");
        String location = rs.getString("applicant_location");

        String jobTitle = rs.getString("job_title");
        String jobLocation = rs.getString("job_location");

        return new RecruiterApplicantItem(
                applicationId, jobId, jobseekerId, status, appliedAt,
                applicantName, applicantEmail, phone, skills, education,
                experience, location, jobTitle, jobLocation
        );
    }

    /**
     * Retrieves an application by ID strictly verifying that it belongs to a job posted by the specified recruiter.
     * 
     * @param applicationId ID of the application
     * @param recruiterId User ID of the recruiter
     * @return Application entity if found and authorized, null otherwise
     */
    public Application getApplicationForRecruiter(int applicationId, int recruiterId) {
        if (applicationId <= 0 || recruiterId <= 0) {
            return null;
        }

        String sql = "SELECT a.id, a.job_id, a.jobseeker_id, a.status, a.applied_at "
                   + "FROM applications a "
                   + "INNER JOIN jobs j ON a.job_id = j.id "
                   + "WHERE a.id = ? AND j.recruiter_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, applicationId);
            ps.setInt(2, recruiterId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    int jobId = rs.getInt("job_id");
                    int jobseekerId = rs.getInt("jobseeker_id");
                    String status = rs.getString("status");
                    Timestamp appliedAt = rs.getTimestamp("applied_at");

                    return new Application(id, jobId, jobseekerId, status, appliedAt);
                }
            }
        } catch (SQLException e) {
            System.err.println("[ApplicationDAO] Error retrieving application for recruiter: " + e.getMessage());
        }

        return null;
    }

    /**
     * Updates an application status strictly verifying that the application belongs to a job posted by the recruiter.
     * 
     * @param applicationId ID of the application to update
     * @param recruiterId User ID of the recruiter
     * @param newStatus new status string (e.g. UNDER_REVIEW, SHORTLISTED, REJECTED)
     * @return true if the application status was successfully updated, false otherwise
     */
    public boolean updateApplicationStatus(int applicationId, int recruiterId, String newStatus) {
        if (applicationId <= 0 || recruiterId <= 0 || newStatus == null || newStatus.trim().isEmpty()) {
            return false;
        }

        String sql = "UPDATE applications a "
                   + "INNER JOIN jobs j ON a.job_id = j.id "
                   + "SET a.status = ? "
                   + "WHERE a.id = ? AND j.recruiter_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus.trim());
            ps.setInt(2, applicationId);
            ps.setInt(3, recruiterId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("[ApplicationDAO] Error updating application status: " + e.getMessage());
            return false;
        }
    }
}
