package model;

import java.sql.Timestamp;

/**
 * Job - Model class representing the 'jobs' table.
 */
public class Job {

    private int id;
    private int recruiterId;
    private String title;
    private String description;
    private String skills;
    private String location;
    private Timestamp createdAt;

    // Default No-Argument Constructor
    public Job() {
    }

    // Parameterized Constructor (without id and createdAt, useful for job creation)
    public Job(int recruiterId, String title, String description, String skills, String location) {
        this.recruiterId = recruiterId;
        this.title = title;
        this.description = description;
        this.skills = skills;
        this.location = location;
    }

    // Full Parameterized Constructor
    public Job(int id, int recruiterId, String title, String description, String skills, String location, Timestamp createdAt) {
        this.id = id;
        this.recruiterId = recruiterId;
        this.title = title;
        this.description = description;
        this.skills = skills;
        this.location = location;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getRecruiterId() {
        return recruiterId;
    }

    public void setRecruiterId(int recruiterId) {
        this.recruiterId = recruiterId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSkills() {
        return skills;
    }

    public void setSkills(String skills) {
        this.skills = skills;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Job{" +
                "id=" + id +
                ", recruiterId=" + recruiterId +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", skills='" + skills + '\'' +
                ", location='" + location + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
