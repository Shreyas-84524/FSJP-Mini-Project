package model;

/**
 * RecruiterProfile - Model class representing the 'recruiter_profile' table.
 */
public class RecruiterProfile {

    private int id;
    private int userId;
    private String companyName;
    private String phone;
    private String location;
    private String description;

    // Default No-Argument Constructor
    public RecruiterProfile() {
    }

    // Parameterized Constructor (without id)
    public RecruiterProfile(int userId, String companyName, String phone, String location, String description) {
        this.userId = userId;
        this.companyName = companyName;
        this.phone = phone;
        this.location = location;
        this.description = description;
    }

    // Full Parameterized Constructor
    public RecruiterProfile(int id, int userId, String companyName, String phone, String location, String description) {
        this.id = id;
        this.userId = userId;
        this.companyName = companyName;
        this.phone = phone;
        this.location = location;
        this.description = description;
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

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "RecruiterProfile{" +
                "id=" + id +
                ", userId=" + userId +
                ", companyName='" + companyName + '\'' +
                ", phone='" + phone + '\'' +
                ", location='" + location + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}
