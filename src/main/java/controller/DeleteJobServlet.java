package controller;

import dao.JobDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * DeleteJobServlet - Handles deletion of job postings by authenticated recruiters.
 * 
 * - Mapped to /recruiter/delete-job (POST only).
 * - GET requests are rejected with 405 Method Not Allowed to prevent accidental or CSRF link deletions.
 * - Protected by AuthenticationFilter for role RECRUITER.
 * - Extracts recruiterId strictly from authenticated HttpSession to prevent IDOR attacks.
 * - Enforces cross-recruiter ownership checks at the DAO level.
 * - Utilizes MySQL ON DELETE CASCADE to automatically remove associated application rows.
 * - Uses Post/Redirect/Get (PRG) pattern on deletion.
 */
@WebServlet("/recruiter/delete-job")
public class DeleteJobServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private JobDAO jobDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.jobDAO = new JobDAO();
    }

    // Constructor for testing / dependency injection
    public DeleteJobServlet(JobDAO jobDAO) {
        this.jobDAO = jobDAO;
    }

    public DeleteJobServlet() {
        // Default constructor for servlet container
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Reject destructive deletion over GET
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, 
                "GET method is not supported for job deletion. Deletion must be performed via POST.");
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

        // 2. Parse job ID parameter
        String idParam = request.getParameter("id");
        int jobId;
        try {
            jobId = Integer.parseInt(idParam);
            if (jobId <= 0) {
                throw new NumberFormatException("Negative or zero ID");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Invalid job ID specified for deletion.");
            response.sendRedirect(request.getContextPath() + "/recruiter/manage-jobs");
            return;
        }

        // 3. Execute deletion with strict recruiter ownership enforcement
        boolean deleted = jobDAO.deleteJob(jobId, recruiterId);

        if (deleted) {
            session.setAttribute("successMessage", "Job deleted successfully.");
        } else {
            session.setAttribute("errorMessage", "Failed to delete job. The job was not found or belongs to another recruiter.");
        }

        // 4. Redirect to manage-jobs (PRG pattern)
        response.sendRedirect(request.getContextPath() + "/recruiter/manage-jobs");
    }
}
