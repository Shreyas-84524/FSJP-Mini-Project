package model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * RecruiterApplicantItem - View-Model / Data Transfer Object (DTO) combining an application record
 * with applicant user details, jobseeker profile information, and applied job metadata.
 * 
 * Used by the Recruiter Applicant Dashboard (/recruiter/applicants) to render candidate profiles
 * and application statuses efficiently in a single query without N+1 overhead.
 * 
 * Omits all sensitive authentication secrets (passwords, hashes, session tokens).
 */
public class RecruiterApplicantItem implements Serializable {

    private static final long serialVersionUID = 1L;

    // Application metadata
    private int applicationId;
    private int jobId;
    private int jobseekerId;
    private String status;
    private Timestamp appliedAt;

    // Applicant user information (from 'users' table)
    private String applicantName;
    private String applicantEmail;

    // Applicant profile information (from 'jobseeker_profile' table)
    private String phone;
    private String skills;
    private String education;
    private String experience;
    private String location;

    // Applied job information (from 'jobs' table)
    private String jobTitle;
    private String jobLocation;

    // Default constructor
    public RecruiterApplicantItem() {
        this.status = "APPLIED";
    }

    // Full constructor
    public RecruiterApplicantItem(int applicationId, int jobId, int jobseekerId, String status,
                                  Timestamp appliedAt, String applicantName, String applicantEmail,
                                  String phone, String skills, String education, String experience,
                                  String location, String jobTitle, String jobLocation) {
        this.applicationId = applicationId;
        this.jobId = jobId;
        this.jobseekerId = jobseekerId;
        this.status = (status != null && !status.trim().isEmpty()) ? status : "APPLIED";
        this.appliedAt = appliedAt;
        this.applicantName = applicantName;
        this.applicantEmail = applicantEmail;
        this.phone = phone;
        this.skills = skills;
        this.education = education;
        this.experience = experience;
        this.location = location;
        this.jobTitle = jobTitle;
        this.jobLocation = jobLocation;
    }

    // Getters and Setters
    public int getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
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

    public String getApplicantName() {
        return applicantName;
    }

    public void setApplicantName(String applicantName) {
        this.applicantName = applicantName;
    }

    public String getApplicantEmail() {
        return applicantEmail;
    }

    public void setApplicantEmail(String applicantEmail) {
        this.applicantEmail = applicantEmail;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getSkills() {
        return skills;
    }

    public void setSkills(String skills) {
        this.skills = skills;
    }

    public String getEducation() {
        return education;
    }

    public void setEducation(String education) {
        this.education = education;
    }

    public String getExperience() {
        return experience;
    }

    public void setExperience(String experience) {
        this.experience = experience;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getJobLocation() {
        return jobLocation;
    }

    public void setJobLocation(String jobLocation) {
        this.jobLocation = jobLocation;
    }

    @Override
    public String toString() {
        return "RecruiterApplicantItem{" +
                "applicationId=" + applicationId +
                ", jobId=" + jobId +
                ", jobseekerId=" + jobseekerId +
                ", applicantName='" + applicantName + '\'' +
                ", applicantEmail='" + applicantEmail + '\'' +
                ", status='" + status + '\'' +
                ", appliedAt=" + appliedAt +
                ", jobTitle='" + jobTitle + '\'' +
                ", jobLocation='" + jobLocation + '\'' +
                '}';
    }
}
