package controller;

import dao.ProfileDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.JobSeekerProfile;
import model.RecruiterProfile;
import model.User;
import util.DBConnection;
import util.PasswordUtil;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.regex.Pattern;

/**
 * RegisterServlet - Handles user registration with server-side validation,
 * PBKDF2 password hashing, and atomic transaction coordination across
 * the 'users' and role-specific profile tables.
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

    private UserDAO userDAO;
    private ProfileDAO profileDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.userDAO = new UserDAO();
        this.profileDAO = new ProfileDAO();
    }

    // Constructor for dependency injection / testing
    public RegisterServlet(UserDAO userDAO, ProfileDAO profileDAO) {
        this.userDAO = userDAO;
        this.profileDAO = profileDAO;
    }

    public RegisterServlet() {
        // Default constructor for servlet container
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to the registration page
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Retrieve common parameters
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Role-specific parameters
        String phone = request.getParameter("phone");
        String location = request.getParameter("location");
        String skills = request.getParameter("skills");
        String education = request.getParameter("education");
        String experience = request.getParameter("experience");
        String companyName = request.getParameter("companyName");
        String description = request.getParameter("description");

        // 2. Server-side Validation
        String validationError = validateInput(name, email, password, role, companyName);
        if (validationError != null) {
            handleError(request, response, validationError);
            return;
        }

        // Normalize email
        String normalizedEmail = email.trim().toLowerCase();

        // 3. Duplicate Email Check
        if (userDAO.emailExists(normalizedEmail)) {
            handleError(request, response, "An account with this email already exists.");
            return;
        }

        // 4. Hash Password using PBKDF2
        String hashedPassword = PasswordUtil.hashPassword(password);
        if (hashedPassword == null) {
            handleError(request, response, "Registration failed due to a security error. Please try again.");
            return;
        }

        // 5. Execute Transactional Registration
        User user = new User(name.trim(), normalizedEmail, hashedPassword, role.trim());
        boolean registrationSuccess = executeTransactionalRegistration(user, role.trim(), phone, skills,
                education, experience, location, companyName, description);

        if (registrationSuccess) {
            request.setAttribute("successMessage", "Registration successful. Please log in.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            handleError(request, response, "Registration failed due to a database error. Please try again.");
        }
    }

    /**
     * Executes user and profile creation inside a single JDBC transaction.
     */
    public boolean executeTransactionalRegistration(User user, String role, String phone, String skills,
                                                    String education, String experience, String location,
                                                    String companyName, String description) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Step 1: Insert user
            int userId = userDAO.createUser(conn, user);
            if (userId <= 0) {
                conn.rollback();
                return false;
            }

            // Step 2: Insert role-specific profile
            boolean profileCreated = false;
            if ("JOB_SEEKER".equalsIgnoreCase(role)) {
                JobSeekerProfile jsProfile = new JobSeekerProfile(
                        userId,
                        phone != null ? phone.trim() : "",
                        skills != null ? skills.trim() : "",
                        education != null ? education.trim() : "",
                        experience != null ? experience.trim() : "",
                        location != null ? location.trim() : ""
                );
                profileCreated = profileDAO.createJobSeekerProfile(conn, jsProfile);
            } else if ("RECRUITER".equalsIgnoreCase(role)) {
                RecruiterProfile recProfile = new RecruiterProfile(
                        userId,
                        companyName != null ? companyName.trim() : "",
                        phone != null ? phone.trim() : "",
                        location != null ? location.trim() : "",
                        description != null ? description.trim() : ""
                );
                profileCreated = profileDAO.createRecruiterProfile(conn, recProfile);
            }

            // Step 3: Commit or Rollback
            if (profileCreated) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }

        } catch (SQLException e) {
            System.err.println("Registration transaction failed: " + e.getMessage());
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Error rolling back transaction: " + ex.getMessage());
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    }

    /**
     * Validates incoming registration fields.
     *
     * @return error message if invalid, null if valid
     */
    private String validateInput(String name, String email, String password, String role, String companyName) {
        if (name == null || name.trim().isEmpty()) {
            return "Name is required.";
        }
        if (name.trim().length() > 100) {
            return "Name must not exceed 100 characters.";
        }

        if (email == null || email.trim().isEmpty()) {
            return "Email is required.";
        }
        if (email.trim().length() > 150) {
            return "Email must not exceed 150 characters.";
        }
        if (!EMAIL_PATTERN.matcher(email.trim()).matches()) {
            return "Please enter a valid email address.";
        }

        if (password == null || password.trim().isEmpty()) {
            return "Password is required.";
        }
        if (password.length() < 6) {
            return "Password must be at least 6 characters long.";
        }

        if (role == null || role.trim().isEmpty()) {
            return "Role is required.";
        }
        String normalizedRole = role.trim().toUpperCase();
        if (!"JOB_SEEKER".equals(normalizedRole) && !"RECRUITER".equals(normalizedRole)) {
            return "Invalid role. Only Job Seeker or Recruiter accounts are allowed.";
        }

        if ("RECRUITER".equals(normalizedRole)) {
            if (companyName == null || companyName.trim().isEmpty()) {
                return "Company name is required for recruiter accounts.";
            }
            if (companyName.trim().length() > 150) {
                return "Company name must not exceed 150 characters.";
            }
        }

        return null;
    }

    /**
     * Handles registration errors by setting the error attribute and forwarding.
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}
