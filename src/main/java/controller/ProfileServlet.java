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

/**
 * ProfileServlet - Handles retrieving and displaying the authenticated Job Seeker's profile.
 * 
 * - Mapped to /jobseeker/profile (protected by AuthenticationFilter for role JOB_SEEKER).
 * - Obtains the authenticated userId strictly from the active HttpSession.
 * - Queries UserDAO for account details and ProfileDAO for professional/personal profile data.
 * - Never trusts browser-supplied URL query parameters (?userId=) for user identity.
 * - Forwards to /jobseeker/profile.jsp for rendering.
 */
@WebServlet("/jobseeker/profile")
public class ProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;
    private ProfileDAO profileDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.userDAO = new UserDAO();
        this.profileDAO = new ProfileDAO();
    }

    // Constructor for testing / dependency injection
    public ProfileServlet(UserDAO userDAO, ProfileDAO profileDAO) {
        this.userDAO = userDAO;
        this.profileDAO = profileDAO;
    }

    public ProfileServlet() {
        // Default constructor for servlet container
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Obtain active session
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

        String role = roleObj.toString();
        if (!"JOB_SEEKER".equalsIgnoreCase(role)) {
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

        // 2. Fetch Account and Profile details using authenticated session userId
        User rawUser = userDAO.getUserById(userId);
        JobSeekerProfile profile = profileDAO.getJobSeekerProfileByUserId(userId);

        if (rawUser == null) {
            request.setAttribute("profileUnavailable", true);
            request.setAttribute("errorMessage", "Profile information is currently unavailable.");
            request.getRequestDispatcher("/jobseeker/profile.jsp").forward(request, response);
            return;
        }

        // 3. Create view-safe User instance (omitting password hash)
        User viewSafeUser = new User(
                rawUser.getId(),
                rawUser.getName(),
                rawUser.getEmail(),
                null, // Exclude password hash from view layer
                rawUser.getRole(),
                rawUser.getCreatedAt()
        );

        request.setAttribute("user", viewSafeUser);
        request.setAttribute("profile", profile);

        if (profile == null) {
            request.setAttribute("profileUnavailable", true);
        }

        // Transfer flash successMessage from session to request if present
        Object flashSuccess = session.getAttribute("successMessage");
        if (flashSuccess != null) {
            request.setAttribute("successMessage", flashSuccess.toString());
            session.removeAttribute("successMessage");
        }

        // 4. Forward to profile.jsp view
        request.getRequestDispatcher("/jobseeker/profile.jsp").forward(request, response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
