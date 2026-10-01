package model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Application - JavaBean entity representing an application record in the 'applications' table.
 * 
 * Schema:
 *   - id: INT AUTO_INCREMENT PRIMARY KEY
 *   - job_id: INT NOT NULL (FK -> jobs.id)
 *   - jobseeker_id: INT NOT NULL (FK -> users.id)
 *   - status: VARCHAR(30) NOT NULL DEFAULT 'APPLIED'
 *   - applied_at: TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 *   - UNIQUE(job_id, jobseeker_id)
 */
public class Application implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private int jobId;
    private int jobseekerId;
    private String status;
    private Timestamp appliedAt;

    // Default constructor
    public Application() {
        this.status = "APPLIED";
    }

    // Constructor for creating new application before insertion
    public Application(int jobId, int jobseekerId) {
        this.jobId = jobId;
        this.jobseekerId = jobseekerId;
        this.status = "APPLIED";
    }

    // Constructor with status
    public Application(int jobId, int jobseekerId, String status) {
        this.jobId = jobId;
        this.jobseekerId = jobseekerId;
        this.status = (status != null && !status.trim().isEmpty()) ? status : "APPLIED";
    }

    // Full constructor for database retrieval
    public Application(int id, int jobId, int jobseekerId, String status, Timestamp appliedAt) {
        this.id = id;
        this.jobId = jobId;
        this.jobseekerId = jobseekerId;
        this.status = status;
        this.appliedAt = appliedAt;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getJobId() {
        return jobId;
    }

    public void setJobId(int jobId) {
        this.jobId = jobId;
    }

    public int getJobseekerId() {
        return jobseekerId;
    }

    public void setJobseekerId(int jobseekerId) {
        this.jobseekerId = jobseekerId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getAppliedAt() {
        return appliedAt;
    }

    public void setAppliedAt(Timestamp appliedAt) {
        this.appliedAt = appliedAt;
    }

    @Override
    public String toString() {
        return "Application{" +
                "id=" + id +
                ", jobId=" + jobId +
                ", jobseekerId=" + jobseekerId +
                ", status='" + status + '\'' +
                ", appliedAt=" + appliedAt +
                '}';
    }
}
