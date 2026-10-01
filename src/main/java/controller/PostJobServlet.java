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
 * PostJobServlet - Handles creating and publishing new job vacancies by authenticated recruiters.
 * 
 * - Mapped to /recruiter/post-job (GET & POST).
 * - Protected by AuthenticationFilter for role RECRUITER.
 * - Extracts recruiterId strictly from authenticated HttpSession.
 * - Enforces server-side validation against schema limits.
 * - Follows Post/Redirect/Get (PRG) pattern to prevent duplicate submissions on page refresh.
 */
@WebServlet("/recruiter/post-job")
public class PostJobServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private JobDAO jobDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.jobDAO = new JobDAO();
    }

    // Constructor for testing / dependency injection
    public PostJobServlet(JobDAO jobDAO) {
        this.jobDAO = jobDAO;
    }

    public PostJobServlet() {
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

        // 3. Forward to post-job JSP
        request.getRequestDispatcher("/recruiter/post-job.jsp").forward(request, response);
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

        // 2. Read parameters
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String skills = request.getParameter("skills");
        String location = request.getParameter("location");

        // 3. Server-side validation
        String validationError = validateJobInputs(title, description, skills, location);
        if (validationError != null) {
            // Preserve user-submitted values on error
            Job submittedJob = new Job(
                    recruiterId,
                    (title != null) ? title.trim() : "",
                    (description != null) ? description.trim() : "",
                    (skills != null) ? skills.trim() : "",
                    (location != null) ? location.trim() : ""
            );

            request.setAttribute("job", submittedJob);
            request.setAttribute("errorMessage", validationError);
            request.getRequestDispatcher("/recruiter/post-job.jsp").forward(request, response);
            return;
        }

        // 4. Sanitize and prepare model
        String cleanTitle = title.trim();
        String cleanDescription = description.trim();
        String cleanSkills = skills.trim();
        String cleanLocation = location.trim();

        Job newJob = new Job(recruiterId, cleanTitle, cleanDescription, cleanSkills, cleanLocation);

        // 5. Insert into database via DAO
        int generatedId = jobDAO.createJob(newJob);

        if (generatedId > 0) {
            // PRG Pattern: Set flash success message and redirect to GET endpoint
            session.setAttribute("successMessage", "Job posted successfully.");
            response.sendRedirect(request.getContextPath() + "/recruiter/post-job");
        } else {
            // Database insertion failure
            request.setAttribute("job", newJob);
            request.setAttribute("errorMessage", "Failed to post job due to a database error. Please try again.");
            request.getRequestDispatcher("/recruiter/post-job.jsp").forward(request, response);
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
