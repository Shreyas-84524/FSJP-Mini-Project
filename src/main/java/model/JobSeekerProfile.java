package model;

/**
 * JobSeekerProfile - Model class representing the 'jobseeker_profile' table.
 */
public class JobSeekerProfile {

    private int id;
    private int userId;
    private String phone;
    private String skills;
    private String education;
    private String experience;
    private String location;

    // Default No-Argument Constructor
    public JobSeekerProfile() {
    }

    // Parameterized Constructor (without id)
    public JobSeekerProfile(int userId, String phone, String skills, String education, String experience, String location) {
        this.userId = userId;
        this.phone = phone;
        this.skills = skills;
        this.education = education;
        this.experience = experience;
        this.location = location;
    }

    // Full Parameterized Constructor
    public JobSeekerProfile(int id, int userId, String phone, String skills, String education, String experience, String location) {
        this.id = id;
        this.userId = userId;
        this.phone = phone;
        this.skills = skills;
        this.education = education;
        this.experience = experience;
        this.location = location;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
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

    @Override
    public String toString() {
        return "JobSeekerProfile{" +
                "id=" + id +
                ", userId=" + userId +
                ", phone='" + phone + '\'' +
                ", skills='" + skills + '\'' +
                ", education='" + education + '\'' +
                ", experience='" + experience + '\'' +
                ", location='" + location + '\'' +
                '}';
    }
}
