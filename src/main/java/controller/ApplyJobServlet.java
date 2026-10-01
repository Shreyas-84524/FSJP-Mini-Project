package controller;

import dao.ApplicationDAO;
import dao.JobDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Application;
import model.Job;

import java.io.IOException;

/**
 * ApplyJobServlet - Handles job application submission for authenticated Job Seekers.
 * 
 * - Mapped to POST /jobseeker/apply (protected by AuthenticationFilter for role JOB_SEEKER).
 * - Enforces session identity: jobseekerId is derived strictly from the authenticated session.
 * - Validates job ID and checks for job existence in JobDAO.
 * - Performs two-tier duplicate prevention:
 *     1. Application-level check: applicationDAO.hasApplied(jobId, userId)
 *     2. Database-level UNIQUE(job_id, jobseeker_id) constraint handling.
 * - Sets flash session messages (successMessage or errorMessage) and redirects back using Post-Redirect-Get.
 * - Application submission is strictly POST-only.
 */
@WebServlet("/jobseeker/apply")
public class ApplyJobServlet extends HttpServlet {

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
    public ApplyJobServlet(JobDAO jobDAO, ApplicationDAO applicationDAO) {
        this.jobDAO = jobDAO;
        this.applicationDAO = applicationDAO;
    }

    public ApplyJobServlet() {
        // Default constructor for servlet container
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
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

        // 2. Validate and parse the 'jobId' parameter
        String jobIdParam = request.getParameter("jobId");
        int jobId;

        if (jobIdParam == null || jobIdParam.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Job ID is required.");
            response.sendRedirect(request.getContextPath() + "/jobseeker/search-jobs");
            return;
        }

        try {
            jobId = Integer.parseInt(jobIdParam.trim());
            if (jobId <= 0) {
                session.setAttribute("errorMessage", "Invalid job ID.");
                response.sendRedirect(request.getContextPath() + "/jobseeker/search-jobs");
                return;
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid job ID format.");
            response.sendRedirect(request.getContextPath() + "/jobseeker/search-jobs");
            return;
        }

        // 3. Verify Job Existence
        Job job = jobDAO.getJobById(jobId);
        if (job == null) {
            session.setAttribute("errorMessage", "Job not found.");
            response.sendRedirect(request.getContextPath() + "/jobseeker/search-jobs");
            return;
        }

        // 4. Duplicate Check (Application Level)
        if (applicationDAO.hasApplied(jobId, jobseekerId)) {
            session.setAttribute("errorMessage", "You have already applied for this job.");
            response.sendRedirect(request.getContextPath() + "/jobseeker/job-details?id=" + jobId);
            return;
        }

        // 5. Create Application
        Application application = new Application(jobId, jobseekerId, "APPLIED");
        boolean created = applicationDAO.createApplication(application);

        if (created) {
            session.setAttribute("successMessage", "Application submitted successfully.");
        } else {
            // Check if failure was due to duplicate key race condition
            if (applicationDAO.hasApplied(jobId, jobseekerId)) {
                session.setAttribute("errorMessage", "You have already applied for this job.");
            } else {
                session.setAttribute("errorMessage", "Unable to submit application right now. Please try again.");
            }
        }

        // 6. Post-Redirect-Get back to Job Details view
        response.sendRedirect(request.getContextPath() + "/jobseeker/job-details?id=" + jobId);
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Application submission is strictly POST-only. Redirect GET requests to search.
        response.sendRedirect(request.getContextPath() + "/jobseeker/search-jobs");
    }
}
