package controller;

import dao.ApplicationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ApplicationItem;

import java.io.IOException;
import java.util.List;

/**
 * MyApplicationsServlet - Displays all job applications submitted by the logged-in Job Seeker.
 * 
 * - Mapped to GET /jobseeker/applications (protected by AuthenticationFilter for role JOB_SEEKER).
 * - Extracts job seeker ID strictly from the authenticated session.
 * - Retrieves applications with joined job details via ApplicationDAO in a single query.
 * - Transfers flash messages (successMessage, errorMessage) from session to request.
 * - Forwards to /jobseeker/applications.jsp.
 */
@WebServlet("/jobseeker/applications")
public class MyApplicationsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ApplicationDAO applicationDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.applicationDAO = new ApplicationDAO();
    }

    // Constructor for testing / dependency injection
    public MyApplicationsServlet(ApplicationDAO applicationDAO) {
        this.applicationDAO = applicationDAO;
    }

    public MyApplicationsServlet() {
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

        if (roleObj == null || !"JOB_SEEKER".equalsIgnoreCase(roleObj.toString()) || userIdObj == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Job Seeker area only.");
            return;
        }

        int jobseekerId;
        try {
            jobseekerId = Integer.parseInt(userIdObj.toString());
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

        // 3. Fetch applications for the authenticated job seeker
        List<ApplicationItem> applications = applicationDAO.getApplicationsByJobseekerId(jobseekerId);

        request.setAttribute("applications", applications);
        request.setAttribute("applicationCount", applications != null ? applications.size() : 0);

        // 4. Forward to applications.jsp
        request.getRequestDispatcher("/jobseeker/applications.jsp").forward(request, response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
