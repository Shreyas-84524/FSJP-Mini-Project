package controller;

import dao.ApplicationDAO;
import dao.JobDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Job;

import java.io.IOException;

/**
 * JobDetailsServlet - Handles retrieving and displaying detailed information for a single job,
 * including application status for the logged-in job seeker.
 * 
 * - Mapped to /jobseeker/job-details (protected by AuthenticationFilter for role JOB_SEEKER).
 * - Validates the 'id' parameter as a positive integer.
 * - Retrieves the Job entity from JobDAO.
 * - Checks whether the authenticated user has already applied for this job via ApplicationDAO.
 * - Transfers flash messages (successMessage, errorMessage) from session to request.
 * - Gracefully handles missing, malformed, or non-existent job IDs.
 * - Forwards to /jobseeker/job-details.jsp.
 */
@WebServlet("/jobseeker/job-details")
public class JobDetailsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private JobDAO jobDAO;
    private ApplicationDAO applicationDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.jobDAO = new JobDAO();
        this.applicationDAO = new ApplicationDAO();
    }

    // Constructor for testing / dependency injection
    public JobDetailsServlet(JobDAO jobDAO, ApplicationDAO applicationDAO) {
        this.jobDAO = jobDAO;
        this.applicationDAO = applicationDAO;
    }

    public JobDetailsServlet() {
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

        // 3. Validate and parse the 'id' parameter
        String idParam = request.getParameter("id");
        int jobId = -1;

        if (idParam == null || idParam.trim().isEmpty()) {
            request.setAttribute("jobNotFound", true);
            if (request.getAttribute("errorMessage") == null) {
                request.setAttribute("errorMessage", "Job ID is required.");
            }
            request.getRequestDispatcher("/jobseeker/job-details.jsp").forward(request, response);
            return;
        }

        try {
            jobId = Integer.parseInt(idParam.trim());
            if (jobId <= 0) {
                request.setAttribute("jobNotFound", true);
                if (request.getAttribute("errorMessage") == null) {
                    request.setAttribute("errorMessage", "Invalid job ID.");
                }
                request.getRequestDispatcher("/jobseeker/job-details.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("jobNotFound", true);
            if (request.getAttribute("errorMessage") == null) {
                request.setAttribute("errorMessage", "Invalid job ID format.");
            }
            request.getRequestDispatcher("/jobseeker/job-details.jsp").forward(request, response);
            return;
        }

        // 4. Fetch Job from database
        Job job = jobDAO.getJobById(jobId);

        if (job == null) {
            request.setAttribute("jobNotFound", true);
            if (request.getAttribute("errorMessage") == null) {
                request.setAttribute("errorMessage", "Job not found or no longer available.");
            }
        } else {
            request.setAttribute("job", job);
            request.setAttribute("jobNotFound", false);

            // 5. Determine whether current Job Seeker has already applied
            boolean hasApplied = applicationDAO.hasApplied(job.getId(), userId);
            request.setAttribute("hasApplied", hasApplied);
        }

        // 6. Forward to job-details.jsp view
        request.getRequestDispatcher("/jobseeker/job-details.jsp").forward(request, response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
