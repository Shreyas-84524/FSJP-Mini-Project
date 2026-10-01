package controller;

import dao.ApplicationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Application;

import java.io.IOException;

/**
 * UpdateApplicationStatusServlet - Controller for recruiter application status transitions.
 * 
 * URL Mapping:
 *   - POST /recruiter/update-application-status
 * 
 * Allowed Status Transitions (Enforced Server-Side):
 *   - APPLIED -> UNDER_REVIEW
 *   - UNDER_REVIEW -> SHORTLISTED
 *   - UNDER_REVIEW -> REJECTED
 * 
 * All other transitions are strictly rejected.
 * 
 * Security & Ownership:
 *   - Recruiter identity is strictly derived from session.getAttribute("userId").
 *   - Verified at the database layer that the application belongs to a job posted by the authenticated recruiter.
 *   - Mutation is POST-only; GET returns 405 Method Not Allowed.
 *   - Post/Redirect/Get (PRG) pattern with session flash messaging.
 */
@WebServlet("/recruiter/update-application-status")
public class UpdateApplicationStatusServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ApplicationDAO applicationDAO;

    @Override
    public void init() throws ServletException {
        this.applicationDAO = new ApplicationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Disallow status modification through GET requests
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED,
                "GET method is not supported for application status updates. Please submit a POST request.");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Validate session and role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"RECRUITER".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int recruiterId = (Integer) session.getAttribute("userId");

        // 2. Read parameters
        String applicationIdStr = request.getParameter("applicationId");
        String newStatus = request.getParameter("status");
        String jobIdStr = request.getParameter("jobId");

        // Build redirect target URL (preserving job filter context if provided)
        StringBuilder redirectUrl = new StringBuilder(request.getContextPath()).append("/recruiter/applicants");
        if (jobIdStr != null && !jobIdStr.trim().isEmpty()) {
            try {
                int jId = Integer.parseInt(jobIdStr.trim());
                if (jId > 0) {
                    redirectUrl.append("?jobId=").append(jId);
                }
            } catch (NumberFormatException ignored) {
                // Ignore invalid jobId query filter
            }
        }

        // 3. Validate application ID format
        int applicationId;
        if (applicationIdStr == null || applicationIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Invalid application identifier.");
            response.sendRedirect(redirectUrl.toString());
            return;
        }

        try {
            applicationId = Integer.parseInt(applicationIdStr.trim());
            if (applicationId <= 0) {
                session.setAttribute("errorMessage", "Invalid application identifier.");
                response.sendRedirect(redirectUrl.toString());
                return;
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid application identifier.");
            response.sendRedirect(redirectUrl.toString());
            return;
        }

        // 4. Validate status parameter format
        if (newStatus == null || newStatus.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Status specification is required.");
            response.sendRedirect(redirectUrl.toString());
            return;
        }

        String targetStatus = newStatus.trim().toUpperCase();
        if (!"APPLIED".equals(targetStatus) && !"UNDER_REVIEW".equals(targetStatus) 
                && !"SHORTLISTED".equals(targetStatus) && !"REJECTED".equals(targetStatus)) {
            session.setAttribute("errorMessage", "Invalid status value specified.");
            response.sendRedirect(redirectUrl.toString());
            return;
        }

        // 5. Verify ownership and retrieve current status
        Application app = applicationDAO.getApplicationForRecruiter(applicationId, recruiterId);
        if (app == null) {
            session.setAttribute("errorMessage", "Application not found or you are not authorized to update it.");
            response.sendRedirect(redirectUrl.toString());
            return;
        }

        String currentStatus = (app.getStatus() != null) ? app.getStatus().trim().toUpperCase() : "APPLIED";

        // 6. Handle same-status no-op
        if (currentStatus.equals(targetStatus)) {
            session.setAttribute("successMessage", "Application is already in '" + formatStatusLabel(currentStatus) + "' status.");
            response.sendRedirect(redirectUrl.toString());
            return;
        }

        // 7. Enforce server-side allowed status transitions:
        //    APPLIED -> UNDER_REVIEW
        //    UNDER_REVIEW -> SHORTLISTED
        //    UNDER_REVIEW -> REJECTED
        boolean isAllowedTransition = false;
        if ("APPLIED".equals(currentStatus) && "UNDER_REVIEW".equals(targetStatus)) {
            isAllowedTransition = true;
        } else if ("UNDER_REVIEW".equals(currentStatus) && ("SHORTLISTED".equals(targetStatus) || "REJECTED".equals(targetStatus))) {
            isAllowedTransition = true;
        }

        if (!isAllowedTransition) {
            session.setAttribute("errorMessage", "Invalid status transition from '" + formatStatusLabel(currentStatus) 
                    + "' to '" + formatStatusLabel(targetStatus) + "'.");
            response.sendRedirect(redirectUrl.toString());
            return;
        }

        // 8. Execute status update in database
        boolean updated = applicationDAO.updateApplicationStatus(applicationId, recruiterId, targetStatus);
        if (updated) {
            session.setAttribute("successMessage", "Application status updated successfully to '" + formatStatusLabel(targetStatus) + "'.");
        } else {
            session.setAttribute("errorMessage", "The application status could not be updated.");
        }

        // 9. Post/Redirect/Get redirect
        response.sendRedirect(redirectUrl.toString());
    }

    private String formatStatusLabel(String status) {
        if ("APPLIED".equalsIgnoreCase(status)) {
            return "Applied";
        } else if ("UNDER_REVIEW".equalsIgnoreCase(status)) {
            return "Under Review";
        } else if ("SHORTLISTED".equalsIgnoreCase(status)) {
            return "Shortlisted";
        } else if ("REJECTED".equalsIgnoreCase(status)) {
            return "Rejected";
        }
        return status;
    }
}
