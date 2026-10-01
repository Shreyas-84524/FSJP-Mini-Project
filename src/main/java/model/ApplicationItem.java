package model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * ApplicationItem - View-Model / Data Transfer Object (DTO) combining an application record
 * with its associated job information.
 * 
 * Used primarily by the 'My Applications' page to avoid N+1 queries.
 */
public class ApplicationItem implements Serializable {

    private static final long serialVersionUID = 1L;

    // Application fields
    private int id;
    private int jobId;
    private int jobseekerId;
    private String status;
    private Timestamp appliedAt;

    // Joined Job fields
    private String jobTitle;
    private String jobDescription;
    private String jobSkills;
    private String jobLocation;
    private Timestamp jobCreatedAt;

    // Default constructor
    public ApplicationItem() {
        this.status = "APPLIED";
    }

    // Full constructor
    public ApplicationItem(int id, int jobId, int jobseekerId, String status, Timestamp appliedAt,
                           String jobTitle, String jobDescription, String jobSkills, String jobLocation,
                           Timestamp jobCreatedAt) {
        this.id = id;
        this.jobId = jobId;
        this.jobseekerId = jobseekerId;
        this.status = status;
        this.appliedAt = appliedAt;
        this.jobTitle = jobTitle;
        this.jobDescription = jobDescription;
        this.jobSkills = jobSkills;
        this.jobLocation = jobLocation;
        this.jobCreatedAt = jobCreatedAt;
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

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getJobDescription() {
        return jobDescription;
    }

    public void setJobDescription(String jobDescription) {
        this.jobDescription = jobDescription;
    }

    public String getJobSkills() {
        return jobSkills;
    }

    public void setJobSkills(String jobSkills) {
        this.jobSkills = jobSkills;
    }

    public String getJobLocation() {
        return jobLocation;
    }

    public void setJobLocation(String jobLocation) {
        this.jobLocation = jobLocation;
    }

    public Timestamp getJobCreatedAt() {
        return jobCreatedAt;
    }

    public void setJobCreatedAt(Timestamp jobCreatedAt) {
        this.jobCreatedAt = jobCreatedAt;
    }

    @Override
    public String toString() {
        return "ApplicationItem{" +
                "id=" + id +
                ", jobId=" + jobId +
                ", jobseekerId=" + jobseekerId +
                ", status='" + status + '\'' +
                ", appliedAt=" + appliedAt +
                ", jobTitle='" + jobTitle + '\'' +
                ", jobLocation='" + jobLocation + '\'' +
                '}';
    }
}
