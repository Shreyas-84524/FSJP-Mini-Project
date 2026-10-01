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

/**
 * RecruiterProfileServlet - Retrieves and displays the authenticated recruiter's profile and account information.
 * 
 * - Mapped to GET /recruiter/profile (protected by AuthenticationFilter for role RECRUITER).
 * - Extracts userId strictly from the authenticated session.
 * - Retrieves User and RecruiterProfile from DAOs.
 * - Transfers flash messages from session to request scope.
 * - Forwards to /recruiter/profile.jsp.
 */
@WebServlet("/recruiter/profile")
public class RecruiterProfileServlet extends HttpServlet {

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
    public RecruiterProfileServlet(UserDAO userDAO, ProfileDAO profileDAO) {
        this.userDAO = userDAO;
        this.profileDAO = profileDAO;
    }

    public RecruiterProfileServlet() {
        // Default constructor for servlet container
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Session & Role Verification
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Object roleObj = session.getAttribute("role");
        Object userIdObj = session.getAttribute("userId");

        if (roleObj == null || !"RECRUITER".equalsIgnoreCase(roleObj.toString()) || userIdObj == null) {
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

        // 2. Transfer flash messages from session to request scope
        String flashSuccess = (String) session.getAttribute("successMessage");
        if (flashSuccess != null) {
            request.setAttribute("successMessage", flashSuccess);
            session.removeAttribute("successMessage");
        }

        String flashError = (String) session.getAttribute("errorMessage");
        if (flashError != null) {
            request.setAttribute("errorMessage", flashError);
            session.removeAttribute("errorMessage");
        }

        // 3. Fetch User and RecruiterProfile data from database
        User user = userDAO.getUserById(userId);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        RecruiterProfile profile = profileDAO.getRecruiterProfileByUserId(userId);

        // 4. Set request attributes and forward to JSP
        request.setAttribute("user", user);
        request.setAttribute("profile", profile);

        request.getRequestDispatcher("/recruiter/profile.jsp").forward(request, response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
