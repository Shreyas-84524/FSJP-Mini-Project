package controller;

import dao.ProfileDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.RecruiterProfile;
import model.User;

import java.io.IOException;
import java.util.regex.Pattern;

/**
 * UpdateRecruiterProfileServlet - Handles viewing and updating the Recruiter's company profile.
 * 
 * - Mapped to /recruiter/profile/edit (GET) and /recruiter/profile/update (POST).
 * - Protected by AuthenticationFilter for role RECRUITER.
 * - Extracts userId strictly from authenticated HttpSession.
 * - Validates input field lengths and phone formatting against database limits.
 * - Updates only the authenticated user's recruiter_profile record in MySQL.
 */
@WebServlet(urlPatterns = {"/recruiter/profile/update", "/recruiter/profile/edit"})
public class UpdateRecruiterProfileServlet extends HttpServlet {

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
    public UpdateRecruiterProfileServlet(UserDAO userDAO, ProfileDAO profileDAO) {
        this.userDAO = userDAO;
        this.profileDAO = profileDAO;
    }

    public UpdateRecruiterProfileServlet() {
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

        if (!"RECRUITER".equalsIgnoreCase(roleObj.toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Recruiter area only.");
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
        RecruiterProfile profile = profileDAO.getRecruiterProfileByUserId(userId);

        if (rawUser == null) {
            response.sendRedirect(request.getContextPath() + "/recruiter/profile");
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
        request.getRequestDispatcher("/recruiter/edit-profile.jsp").forward(request, response);
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

        if (!"RECRUITER".equalsIgnoreCase(roleObj.toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Recruiter area only.");
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
        String companyName = request.getParameter("companyName");
        String phone = request.getParameter("phone");
        String location = request.getParameter("location");
        String description = request.getParameter("description");

        // 3. Server-side validation
        String validationError = validateProfileInputs(companyName, phone, location, description);
        if (validationError != null) {
            User rawUser = userDAO.getUserById(userId);
            User viewSafeUser = (rawUser != null) ? new User(
                    rawUser.getId(), rawUser.getName(), rawUser.getEmail(), null, rawUser.getRole(), rawUser.getCreatedAt()
            ) : null;

            // Preserve user-submitted values on error
            RecruiterProfile submittedProfile = new RecruiterProfile(
                    userId,
                    (companyName != null) ? companyName.trim() : "",
                    (phone != null) ? phone.trim() : "",
                    (location != null) ? location.trim() : "",
                    (description != null) ? description.trim() : ""
            );

            request.setAttribute("user", viewSafeUser);
            request.setAttribute("profile", submittedProfile);
            request.setAttribute("errorMessage", validationError);
            request.getRequestDispatcher("/recruiter/edit-profile.jsp").forward(request, response);
            return;
        }

        // 4. Sanitize and prepare model
        String cleanCompanyName = companyName.trim();
        String cleanPhone = (phone != null) ? phone.trim() : "";
        String cleanLocation = (location != null) ? location.trim() : "";
        String cleanDescription = (description != null) ? description.trim() : "";

        RecruiterProfile updatedProfile = new RecruiterProfile(
                userId, cleanCompanyName, cleanPhone, cleanLocation, cleanDescription
        );

        // 5. Update database
        boolean success = profileDAO.updateRecruiterProfile(updatedProfile);

        if (success) {
            session.setAttribute("successMessage", "Company profile updated successfully.");
            response.sendRedirect(request.getContextPath() + "/recruiter/profile");
        } else {
            User rawUser = userDAO.getUserById(userId);
            User viewSafeUser = (rawUser != null) ? new User(
                    rawUser.getId(), rawUser.getName(), rawUser.getEmail(), null, rawUser.getRole(), rawUser.getCreatedAt()
            ) : null;

            request.setAttribute("user", viewSafeUser);
            request.setAttribute("profile", updatedProfile);
            request.setAttribute("errorMessage", "Failed to update profile due to a database error. Please try again.");
            request.getRequestDispatcher("/recruiter/edit-profile.jsp").forward(request, response);
        }
    }

    /**
     * Validates editable recruiter profile fields against schema constraints.
     *
     * @return error message if invalid, null if valid
     */
    public String validateProfileInputs(String companyName, String phone, String location, String description) {
        if (companyName == null || companyName.trim().isEmpty()) {
            return "Company name is required.";
        }

        if (companyName.trim().length() > 150) {
            return "Company name must not exceed 150 characters.";
        }

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

        if (description != null && description.trim().length() > 2000) {
            return "Description must not exceed 2000 characters.";
        }

        return null;
    }
}
