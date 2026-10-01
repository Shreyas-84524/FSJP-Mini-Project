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
import model.RecruiterApplicantItem;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * RecruiterApplicantsServlet - Controller handling the Recruiter Applicant Dashboard.
 * 
 * URL Patterns:
 *   - GET /recruiter/applicants : Displays applicants across all jobs posted by the authenticated recruiter.
 *   - GET /recruiter/applicants?jobId=<id> : Displays applicants specifically for the chosen job vacancy,
 *     strictly enforcing that the requested job belongs to the authenticated recruiter.
 * 
 * Security & Ownership:
 *   - Recruiter identity is strictly obtained from session.getAttribute("userId").
 *   - Ownership of requested jobId is validated via JobDAO.getJobByIdAndRecruiterId(jobId, recruiterId).
 *   - Prevents unauthorized applicant disclosure across recruiters.
 *   - Read-only: status modification is not permitted in this prompt (reserved for Phase 7 Prompt 002).
 */
@WebServlet("/recruiter/applicants")
public class RecruiterApplicantsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ApplicationDAO applicationDAO;
    private JobDAO jobDAO;

    @Override
    public void init() throws ServletException {
        this.applicationDAO = new ApplicationDAO();
        this.jobDAO = new JobDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Validate session and role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"RECRUITER".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int recruiterId = (Integer) session.getAttribute("userId");

        // 2. Transfer session flash messages to request scope
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage");
        }

        String sessionErrorMessage = (String) session.getAttribute("errorMessage");
        if (sessionErrorMessage != null) {
            request.setAttribute("errorMessage", sessionErrorMessage);
            session.removeAttribute("errorMessage");
        }

        // 3. Retrieve all jobs posted by this recruiter (for selector/filter)
        List<Job> jobs = jobDAO.getJobsByRecruiterId(recruiterId);
        request.setAttribute("jobs", jobs);

        // 4. Handle optional jobId filter
        String jobIdParam = request.getParameter("jobId");
        Job selectedJob = null;
        Integer selectedJobId = null;
        List<RecruiterApplicantItem> applicants;

        if (jobIdParam != null && !jobIdParam.trim().isEmpty()) {
            try {
                int jobId = Integer.parseInt(jobIdParam.trim());
                // Verify ownership at DAO level
                selectedJob = jobDAO.getJobByIdAndRecruiterId(jobId, recruiterId);

                if (selectedJob != null) {
                    selectedJobId = selectedJob.getId();
                    applicants = applicationDAO.getApplicantsForJob(selectedJobId, recruiterId);
                } else {
                    // Job does not exist or belongs to another recruiter
                    request.setAttribute("errorMessage", "Job not found or you are not authorized to view its applicants.");
                    applicants = new ArrayList<>();
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid job specification.");
                applicants = new ArrayList<>();
            }
        } else {
            // No specific job filter: retrieve all applicants across all recruiter's jobs
            applicants = applicationDAO.getApplicantsByRecruiterId(recruiterId);
        }

        request.setAttribute("selectedJob", selectedJob);
        request.setAttribute("selectedJobId", selectedJobId);
        request.setAttribute("applicants", applicants);

        // 5. Forward to JSP view
        request.getRequestDispatcher("/recruiter/applicants.jsp").forward(request, response);
    }
}
