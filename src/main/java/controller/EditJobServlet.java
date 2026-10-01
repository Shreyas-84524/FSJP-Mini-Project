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

/**
 * EditJobServlet - Handles loading the edit form and updating job postings by authenticated recruiters.
 * 
 * - Mapped to /recruiter/edit-job (GET & POST).
 * - Protected by AuthenticationFilter for role RECRUITER.
 * - Enforces cross-recruiter ownership checks at the DAO level using authenticated session recruiterId.
 * - Preserves submitted values and displays validation errors without leaking sensitive stack traces.
 * - Uses Post/Redirect/Get (PRG) pattern on successful update.
 */
@WebServlet("/recruiter/edit-job")
public class EditJobServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private JobDAO jobDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.jobDAO = new JobDAO();
    }

    // Constructor for testing / dependency injection
    public EditJobServlet(JobDAO jobDAO) {
        this.jobDAO = jobDAO;
    }

    public EditJobServlet() {
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

        // 2. Parse and validate job ID
        String idParam = request.getParameter("id");
        int jobId;
        try {
            jobId = Integer.parseInt(idParam);
            if (jobId <= 0) {
                throw new NumberFormatException("Negative or zero ID");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Invalid job ID specified.");
            response.sendRedirect(request.getContextPath() + "/recruiter/manage-jobs");
            return;
        }

        // 3. Retrieve job strictly ensuring ownership by authenticated recruiter
        Job job = jobDAO.getJobByIdAndRecruiterId(jobId, recruiterId);
        if (job == null) {
            session.setAttribute("errorMessage", "Job not found or access denied.");
            response.sendRedirect(request.getContextPath() + "/recruiter/manage-jobs");
            return;
        }

        // 4. Transfer flash messages
        String flashError = (String) session.getAttribute("errorMessage");
        if (flashError != null) {
            request.setAttribute("errorMessage", flashError);
            session.removeAttribute("errorMessage");
        }

        // 5. Forward to edit JSP
        request.setAttribute("job", job);
        request.getRequestDispatcher("/recruiter/edit-job.jsp").forward(request, response);
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

        // 2. Parse job ID
        String idParam = request.getParameter("id");
        int jobId;
        try {
            jobId = Integer.parseInt(idParam);
            if (jobId <= 0) {
                throw new NumberFormatException("Negative or zero ID");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Invalid job ID.");
            response.sendRedirect(request.getContextPath() + "/recruiter/manage-jobs");
            return;
        }

        // 3. Read form parameters
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String skills = request.getParameter("skills");
        String location = request.getParameter("location");

        // 4. Server-side validation
        String validationError = validateJobInputs(title, description, skills, location);
        if (validationError != null) {
            // Preserve user-submitted values on error
            Job submittedJob = new Job(
                    jobId,
                    recruiterId,
                    (title != null) ? title.trim() : "",
                    (description != null) ? description.trim() : "",
                    (skills != null) ? skills.trim() : "",
                    (location != null) ? location.trim() : "",
                    null
            );

            request.setAttribute("job", submittedJob);
            request.setAttribute("errorMessage", validationError);
            request.getRequestDispatcher("/recruiter/edit-job.jsp").forward(request, response);
            return;
        }

        // 5. Sanitize and prepare model
        String cleanTitle = title.trim();
        String cleanDescription = description.trim();
        String cleanSkills = skills.trim();
        String cleanLocation = location.trim();

        Job updatedJob = new Job(jobId, recruiterId, cleanTitle, cleanDescription, cleanSkills, cleanLocation, null);

        // 6. Execute update with strict ownership enforcement
        boolean success = jobDAO.updateJob(updatedJob, recruiterId);

        if (success) {
            // PRG Pattern: Set flash success message and redirect to manage jobs
            session.setAttribute("successMessage", "Job updated successfully.");
            response.sendRedirect(request.getContextPath() + "/recruiter/manage-jobs");
        } else {
            // Update failed (either not found, not owned, or DB error)
            session.setAttribute("errorMessage", "Failed to update job. It may have been deleted or access was denied.");
            response.sendRedirect(request.getContextPath() + "/recruiter/manage-jobs");
        }
    }

    /**
     * Validates job input fields against database constraints.
     *
     * @return error message if invalid, null if valid
     */
    public String validateJobInputs(String title, String description, String skills, String location) {
        if (title == null || title.trim().isEmpty()) {
            return "Job title is required.";
        }
        if (title.trim().length() > 150) {
            return "Job title must not exceed 150 characters.";
        }

        if (description == null || description.trim().isEmpty()) {
            return "Job description is required.";
        }
        if (description.trim().length() > 4000) {
            return "Job description must not exceed 4000 characters.";
        }

        if (skills == null || skills.trim().isEmpty()) {
            return "Required skills are required.";
        }
        if (skills.trim().length() > 500) {
            return "Skills must not exceed 500 characters.";
        }

        if (location == null || location.trim().isEmpty()) {
            return "Job location is required.";
        }
        if (location.trim().length() > 100) {
            return "Location must not exceed 100 characters.";
        }

        return null;
    }
}
