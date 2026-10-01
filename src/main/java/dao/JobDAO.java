package dao;

import model.Job;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * JobDAO - Data Access Object for handling database operations on the 'jobs' table.
 */
public class JobDAO {

    /**
     * Retrieves all available jobs ordered by creation date descending.
     *
     * @return List of Job objects
     */
    public List<Job> getAllJobs() {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT id, recruiter_id, title, description, skills, location, created_at " +
                     "FROM jobs ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                jobs.add(mapResultSetToJob(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all jobs: " + e.getMessage());
        }
        return jobs;
    }

    /**
     * Searches jobs by keyword, required skills, and location filters using SQL/JDBC.
     * Combines filter categories with logical AND.
     *
     * @param keyword  optional keyword searching across title, description, and skills
     * @param skills   optional comma-separated skills searching in skills column
     * @param location optional location filter searching in location column
     * @return List of matching Job objects
     */
    public List<Job> searchJobs(String keyword, String skills, String location) {
        String cleanKeyword = normalizeInput(keyword, 150);
        String cleanSkills = normalizeInput(skills, 500);
        String cleanLocation = normalizeInput(location, 100);

        // If no filter criteria supplied, return all available jobs
        if (cleanKeyword == null && cleanSkills == null && cleanLocation == null) {
            return getAllJobs();
        }

        StringBuilder sql = new StringBuilder(
                "SELECT id, recruiter_id, title, description, skills, location, created_at FROM jobs WHERE "
        );
        List<String> conditions = new ArrayList<>();
        List<String> params = new ArrayList<>();

        // 1. Keyword search (matches title OR description OR skills)
        if (cleanKeyword != null) {
            conditions.add("(title LIKE ? OR description LIKE ? OR skills LIKE ?)");
            String keywordPattern = "%" + cleanKeyword + "%";
            params.add(keywordPattern);
            params.add(keywordPattern);
            params.add(keywordPattern);
        }

        // 2. Skill-based search (supports comma-separated skills: skill1 OR skill2)
        if (cleanSkills != null) {
            String[] skillTokens = cleanSkills.split(",");
            List<String> validTokens = new ArrayList<>();
            for (String token : skillTokens) {
                String trimmed = token.trim();
                if (!trimmed.isEmpty()) {
                    validTokens.add(trimmed);
                }
            }

            if (!validTokens.isEmpty()) {
                StringBuilder skillClause = new StringBuilder("(");
                for (int i = 0; i < validTokens.size(); i++) {
                    if (i > 0) {
                        skillClause.append(" OR ");
                    }
                    skillClause.append("skills LIKE ?");
                    params.add("%" + validTokens.get(i) + "%");
                }
                skillClause.append(")");
                conditions.add(skillClause.toString());
            }
        }

        // 3. Location filtering
        if (cleanLocation != null) {
            conditions.add("location LIKE ?");
            params.add("%" + cleanLocation + "%");
        }

        // If after tokenization all conditions are empty, return all jobs
        if (conditions.isEmpty()) {
            return getAllJobs();
        }

        sql.append(String.join(" AND ", conditions));
        sql.append(" ORDER BY created_at DESC");

        List<Job> jobs = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setString(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    jobs.add(mapResultSetToJob(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error searching jobs: " + e.getMessage());
        }

        return jobs;
    }

    /**
     * Retrieves a single job by its primary key ID.
     *
     * @param id the unique job ID
     * @return Job object if found, null otherwise
     */
    public Job getJobById(int id) {
        String sql = "SELECT id, recruiter_id, title, description, skills, location, created_at " +
                     "FROM jobs WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToJob(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching job by id: " + e.getMessage());
        }
        return null;
    }

    /**
     * Inserts a new job record using a standalone connection.
     *
     * @param job Job object containing recruiterId, title, description, skills, location
     * @return generated job ID if successful, -1 otherwise
     */
    public int createJob(Job job) {
        try (Connection conn = DBConnection.getConnection()) {
            return createJob(conn, job);
        } catch (SQLException e) {
            System.err.println("Error creating job: " + e.getMessage());
            return -1;
        }
    }

    /**
     * Inserts a new job record using an existing connection and returns the generated job ID.
     *
     * @param conn active java.sql.Connection
     * @param job  Job object
     * @return generated job ID if successful, -1 otherwise
     * @throws SQLException if a database error occurs
     */
    public int createJob(Connection conn, Job job) throws SQLException {
        String sql = "INSERT INTO jobs (recruiter_id, title, description, skills, location) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, job.getRecruiterId());
            ps.setString(2, job.getTitle());
            ps.setString(3, job.getDescription());
            ps.setString(4, job.getSkills());
            ps.setString(5, job.getLocation());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
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
     * Retrieves all jobs posted by a specific recruiter, ordered by creation date descending.
     *
     * @param recruiterId the user ID of the recruiter
     * @return List of Job objects belonging to the recruiter
     */
    public List<Job> getJobsByRecruiterId(int recruiterId) {
        List<Job> jobs = new ArrayList<>();
        if (recruiterId <= 0) {
            return jobs;
        }

        String sql = "SELECT id, recruiter_id, title, description, skills, location, created_at " +
                     "FROM jobs WHERE recruiter_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, recruiterId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    jobs.add(mapResultSetToJob(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching jobs for recruiter " + recruiterId + ": " + e.getMessage());
        }
        return jobs;
    }

    /**
     * Retrieves a single job by its ID and verifies it belongs to the specified recruiter.
     *
     * @param jobId       the unique job ID
     * @param recruiterId the user ID of the recruiter
     * @return Job object if found and owned by the recruiter, null otherwise
     */
    public Job getJobByIdAndRecruiterId(int jobId, int recruiterId) {
        if (jobId <= 0 || recruiterId <= 0) {
            return null;
        }

        String sql = "SELECT id, recruiter_id, title, description, skills, location, created_at " +
                     "FROM jobs WHERE id = ? AND recruiter_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, jobId);
            ps.setInt(2, recruiterId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToJob(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching job " + jobId + " for recruiter " + recruiterId + ": " + e.getMessage());
        }
        return null;
    }

    /**
     * Updates an existing job record, strictly verifying that it belongs to the authenticated recruiter.
     *
     * @param job         Job object containing updated title, description, skills, location, and id
     * @param recruiterId the authenticated recruiter's user ID
     * @return true if the job was successfully updated, false otherwise
     */
    public boolean updateJob(Job job, int recruiterId) {
        if (job == null || job.getId() <= 0 || recruiterId <= 0) {
            return false;
        }

        String sql = "UPDATE jobs SET title = ?, description = ?, skills = ?, location = ? " +
                     "WHERE id = ? AND recruiter_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, job.getTitle());
            ps.setString(2, job.getDescription());
            ps.setString(3, job.getSkills());
            ps.setString(4, job.getLocation());
            ps.setInt(5, job.getId());
            ps.setInt(6, recruiterId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating job " + job.getId() + " for recruiter " + recruiterId + ": " + e.getMessage());
            return false;
        }
    }

    /**
     * Deletes a job by its ID, strictly verifying that it belongs to the authenticated recruiter.
     * Deleting a job will automatically cascade and delete associated application records.
     *
     * @param jobId       the job ID to delete
     * @param recruiterId the authenticated recruiter's user ID
     * @return true if deletion succeeded, false otherwise
     */
    public boolean deleteJob(int jobId, int recruiterId) {
        if (jobId <= 0 || recruiterId <= 0) {
            return false;
        }

        String sql = "DELETE FROM jobs WHERE id = ? AND recruiter_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, jobId);
            ps.setInt(2, recruiterId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting job " + jobId + " for recruiter " + recruiterId + ": " + e.getMessage());
            return false;
        }
    }

    /**
     * Deletes a job by its ID (unconstrained).
     *
     * @param id the job ID to delete
     * @return true if deletion succeeded, false otherwise
     */
    public boolean deleteJob(int id) {
        String sql = "DELETE FROM jobs WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting job: " + e.getMessage());
            return false;
        }
    }

    /**
     * Helper method to map a ResultSet row to a Job object.
     *
     * @param rs ResultSet positioned at a valid row
     * @return populated Job object
     * @throws SQLException if column reading fails
     */
    private Job mapResultSetToJob(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        int recruiterId = rs.getInt("recruiter_id");
        String title = rs.getString("title");
        String description = rs.getString("description");
        String skills = rs.getString("skills");
        String location = rs.getString("location");
        Timestamp createdAt = rs.getTimestamp("created_at");

        return new Job(id, recruiterId, title, description, skills, location, createdAt);
    }

    /**
     * Trims and bounds input strings, returning null if empty.
     */
    private String normalizeInput(String input, int maxLength) {
        if (input == null) {
            return null;
        }
        String trimmed = input.trim();
        if (trimmed.isEmpty()) {
            return null;
        }
        if (trimmed.length() > maxLength) {
            return trimmed.substring(0, maxLength);
        }
        return trimmed;
    }
}
