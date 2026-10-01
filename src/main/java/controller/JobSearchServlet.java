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
 * JobSearchServlet - Handles job search and filtering for authenticated Job Seekers.
 * 
 * - Mapped to /jobseeker/search-jobs (protected by AuthenticationFilter for role JOB_SEEKER).
 * - Reads query parameters: keyword, skills, location.
 * - Invokes JobDAO.searchJobs() to perform SQL/JDBC filtering.
 * - Preserves search criteria in request attributes for form re-population.
 * - Forwards to /jobseeker/search-jobs.jsp.
 */
@WebServlet("/jobseeker/search-jobs")
public class JobSearchServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private JobDAO jobDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.jobDAO = new JobDAO();
    }

    // Constructor for testing / dependency injection
    public JobSearchServlet(JobDAO jobDAO) {
        this.jobDAO = jobDAO;
    }

    public JobSearchServlet() {
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
        if (roleObj == null || !"JOB_SEEKER".equalsIgnoreCase(roleObj.toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Job Seeker area only.");
            return;
        }

        // 2. Read and sanitize search parameters
        String keyword = request.getParameter("keyword");
        String skills = request.getParameter("skills");
        String location = request.getParameter("location");

        String cleanKeyword = (keyword != null) ? keyword.trim() : "";
        String cleanSkills = (skills != null) ? skills.trim() : "";
        String cleanLocation = (location != null) ? location.trim() : "";

        // 3. Execute search via JobDAO
        List<Job> jobResults = jobDAO.searchJobs(cleanKeyword, cleanSkills, cleanLocation);

        boolean hasFilters = !cleanKeyword.isEmpty() || !cleanSkills.isEmpty() || !cleanLocation.isEmpty();

        // 4. Attach request attributes
        request.setAttribute("jobs", jobResults);
        request.setAttribute("keyword", cleanKeyword);
        request.setAttribute("skills", cleanSkills);
        request.setAttribute("location", cleanLocation);
        request.setAttribute("hasFilters", hasFilters);
        request.setAttribute("resultCount", (jobResults != null) ? jobResults.size() : 0);

        // 5. Forward to search-jobs.jsp view
        request.getRequestDispatcher("/jobseeker/search-jobs.jsp").forward(request, response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
