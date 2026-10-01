package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.PasswordUtil;

import java.io.IOException;
import java.util.regex.Pattern;

/**
 * LoginServlet - Handles user authentication, input validation,
 * PBKDF2 password verification, session fixation protection,
 * and authenticated session initialization.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.userDAO = new UserDAO();
    }

    // Constructor for testing / dependency injection
    public LoginServlet(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    public LoginServlet() {
        // Default constructor for servlet container
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to login page
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Retrieve login parameters
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 2. Validate Email
        if (email == null || email.trim().isEmpty()) {
            handleError(request, response, "Email is required.", null);
            return;
        }

        String normalizedEmail = email.trim().toLowerCase();
        if (!EMAIL_PATTERN.matcher(normalizedEmail).matches()) {
            handleError(request, response, "Please enter a valid email address.", normalizedEmail);
            return;
        }

        // 3. Validate Password (Do not trim password)
        if (password == null || password.isEmpty()) {
            handleError(request, response, "Password is required.", normalizedEmail);
            return;
        }

        // 4. Retrieve user by email from database
        User user = userDAO.getUserByEmail(normalizedEmail);
        if (user == null) {
            // Generic error message - do not reveal if email exists
            handleError(request, response, "Invalid email or password.", normalizedEmail);
            return;
        }

        // 5. Verify password against PBKDF2 stored hash
        boolean passwordValid = PasswordUtil.verifyPassword(password, user.getPassword());
        if (!passwordValid) {
            handleError(request, response, "Invalid email or password.", normalizedEmail);
            return;
        }

        // 6. Session Fixation Protection: Invalidate old session if present
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }

        // 7. Create fresh authenticated session and store user credentials (excluding passwords)
        HttpSession session = request.getSession(true);
        session.setAttribute("userId", user.getId());
        session.setAttribute("name", user.getName());
        session.setAttribute("role", user.getRole());

        // 8. Redirect to placeholder destination (index.jsp)
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    /**
     * Handles authentication errors by setting the error message attribute and forwarding to login.jsp.
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage, String email)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        if (email != null) {
            request.setAttribute("email", email);
        }
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}
