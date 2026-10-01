package controller;

import dao.ProfileDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.JobSeekerProfile;
import model.User;

import java.io.IOException;
import java.util.regex.Pattern;

/**
 * UpdateJobSeekerProfileServlet - Handles viewing and updating the Job Seeker's profile.
 * 
 * - Mapped to /jobseeker/profile/edit (GET) and /jobseeker/profile/update (POST).
 * - Protected by AuthenticationFilter for role JOB_SEEKER.
 * - Extracts userId strictly from authenticated HttpSession.
 * - Validates input field lengths and phone formatting against database limits.
 * - Updates only the authenticated user's jobseeker_profile record in MySQL.
 */
@WebServlet(urlPatterns = {"/jobseeker/profile/update", "/jobseeker/profile/edit"})
public class UpdateJobSeekerProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9+()\\s-]{0,20}$");

    private UserDAO userDAO;
    private ProfileDAO profileDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.userDAO = new UserDAO();
        this.profileDAO = new ProfileDAO();
    }

    // Constructor for testing / dependency injection
    public UpdateJobSeekerProfileServlet(UserDAO userDAO, ProfileDAO profileDAO) {
        this.userDAO = userDAO;
        this.profileDAO = profileDAO;
    }

    public UpdateJobSeekerProfileServlet() {
        // Default constructor for servlet container
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Verify authenticated session
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Object userIdObj = session.getAttribute("userId");
        Object roleObj = session.getAttribute("role");

        if (userIdObj == null || roleObj == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (!"JOB_SEEKER".equalsIgnoreCase(roleObj.toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Job Seeker area only.");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(userIdObj.toString());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 2. Fetch existing user and profile from database
        User rawUser = userDAO.getUserById(userId);
        JobSeekerProfile profile = profileDAO.getJobSeekerProfileByUserId(userId);

        if (rawUser == null) {
            response.sendRedirect(request.getContextPath() + "/jobseeker/profile");
            return;
        }

        User viewSafeUser = new User(
                rawUser.getId(),
                rawUser.getName(),
                rawUser.getEmail(),
                null,
                rawUser.getRole(),
                rawUser.getCreatedAt()
        );

        request.setAttribute("user", viewSafeUser);
        request.setAttribute("profile", profile);

        // 3. Forward to edit form
        request.getRequestDispatcher("/jobseeker/edit-profile.jsp").forward(request, response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Verify authenticated session
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Object userIdObj = session.getAttribute("userId");
        Object roleObj = session.getAttribute("role");

        if (userIdObj == null || roleObj == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (!"JOB_SEEKER".equalsIgnoreCase(roleObj.toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Job Seeker area only.");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(userIdObj.toString());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 2. Read parameters
        String phone = request.getParameter("phone");
        String location = request.getParameter("location");
        String skills = request.getParameter("skills");
        String education = request.getParameter("education");
        String experience = request.getParameter("experience");

        // 3. Server-side validation
        String validationError = validateProfileInputs(phone, location, skills, education, experience);
        if (validationError != null) {
            User rawUser = userDAO.getUserById(userId);
            User viewSafeUser = (rawUser != null) ? new User(
                    rawUser.getId(), rawUser.getName(), rawUser.getEmail(), null, rawUser.getRole(), rawUser.getCreatedAt()
            ) : null;

            // Preserve user-submitted values on error
            JobSeekerProfile submittedProfile = new JobSeekerProfile(
                    userId, phone, skills, education, experience, location
            );

            request.setAttribute("user", viewSafeUser);
            request.setAttribute("profile", submittedProfile);
            request.setAttribute("errorMessage", validationError);
            request.getRequestDispatcher("/jobseeker/edit-profile.jsp").forward(request, response);
            return;
        }

        // 4. Sanitize and prepare model
        String cleanPhone = (phone != null) ? phone.trim() : "";
        String cleanLocation = (location != null) ? location.trim() : "";
        String cleanSkills = (skills != null) ? skills.trim() : "";
        String cleanEducation = (education != null) ? education.trim() : "";
        String cleanExperience = (experience != null) ? experience.trim() : "";

        JobSeekerProfile updatedProfile = new JobSeekerProfile(
                userId, cleanPhone, cleanSkills, cleanEducation, cleanExperience, cleanLocation
        );

        // 5. Update database
        boolean success = profileDAO.updateJobSeekerProfile(updatedProfile);

        if (success) {
            session.setAttribute("successMessage", "Profile updated successfully.");
            response.sendRedirect(request.getContextPath() + "/jobseeker/profile");
        } else {
            User rawUser = userDAO.getUserById(userId);
            User viewSafeUser = (rawUser != null) ? new User(
                    rawUser.getId(), rawUser.getName(), rawUser.getEmail(), null, rawUser.getRole(), rawUser.getCreatedAt()
            ) : null;

            request.setAttribute("user", viewSafeUser);
            request.setAttribute("profile", updatedProfile);
            request.setAttribute("errorMessage", "Failed to update profile due to a database error. Please try again.");
            request.getRequestDispatcher("/jobseeker/edit-profile.jsp").forward(request, response);
        }
    }

    /**
     * Validates editable job seeker profile fields against schema constraints.
     *
     * @return error message if invalid, null if valid
     */
    public String validateProfileInputs(String phone, String location, String skills, String education, String experience) {
        if (phone != null && !phone.trim().isEmpty()) {
            if (phone.trim().length() > 20) {
                return "Phone number must not exceed 20 characters.";
            }
            if (!PHONE_PATTERN.matcher(phone.trim()).matches()) {
                return "Please enter a valid phone number (digits, spaces, hyphens, and + allowed).";
            }
        }

        if (location != null && location.trim().length() > 100) {
            return "Location must not exceed 100 characters.";
        }

        if (skills != null && skills.trim().length() > 500) {
            return "Skills must not exceed 500 characters.";
        }

        if (education != null && education.trim().length() > 255) {
            return "Education must not exceed 255 characters.";
        }

        if (experience != null && experience.trim().length() > 255) {
            return "Experience must not exceed 255 characters.";
        }

        return null;
    }
}
