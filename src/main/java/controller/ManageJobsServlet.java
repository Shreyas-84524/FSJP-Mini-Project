package controller;

import dao.JobDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Job;

import java.io.IOException;
import java.util.List;

/**
 * ManageJobsServlet - Handles listing all jobs posted by the authenticated recruiter.
 * 
 * - Mapped to /recruiter/manage-jobs (GET).
 * - Protected by AuthenticationFilter for role RECRUITER.
 * - Extracts recruiterId strictly from authenticated HttpSession.
 * - Queries JobDAO.getJobsByRecruiterId(recruiterId) ensuring cross-recruiter isolation.
 * - Passes flash messages and forwards to recruiter/manage-jobs.jsp.
 */
@WebServlet("/recruiter/manage-jobs")
public class ManageJobsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private JobDAO jobDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.jobDAO = new JobDAO();
    }

    // Constructor for testing / dependency injection
    public ManageJobsServlet(JobDAO jobDAO) {
        this.jobDAO = jobDAO;
    }

    public ManageJobsServlet() {
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

        int recruiterId;
        try {
            recruiterId = Integer.parseInt(userIdObj.toString());
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

        // 3. Fetch jobs posted by this authenticated recruiter
        List<Job> jobs = jobDAO.getJobsByRecruiterId(recruiterId);
        request.setAttribute("jobs", jobs);

        // 4. Forward to manage-jobs JSP
        request.getRequestDispatcher("/recruiter/manage-jobs.jsp").forward(request, response);
    }
}
