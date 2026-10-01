package controller;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * AuthenticationFilter - Enforces role-based authorization and session verification
 * for protected application endpoints (/jobseeker/* and /recruiter/*).
 * 
 * - Checks whether a valid authenticated session exists (with non-null userId and role).
 * - Redirects unauthenticated requests to the login page using a dynamic context path.
 * - Enforces role-specific access boundaries:
 *     - /jobseeker/* requires role "JOB_SEEKER"
 *     - /recruiter/* requires role "RECRUITER"
 * - Returns 403 Forbidden if a logged-in user attempts to access the other role's area.
 * - Leaves public endpoints and static resources accessible.
 */
@WebFilter(urlPatterns = {"/jobseeker/*", "/recruiter/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // 1. Obtain existing session without creating a new one
        HttpSession session = httpRequest.getSession(false);

        // 2. Validate authenticated session state
        boolean isAuthenticated = false;
        String userRole = null;

        if (session != null) {
            Object userIdObj = session.getAttribute("userId");
            Object roleObj = session.getAttribute("role");

            if (userIdObj != null && roleObj != null) {
                isAuthenticated = true;
                userRole = roleObj.toString();
            }
        }

        // 3. Handle unauthenticated access to protected resources
        if (!isAuthenticated) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
            return;
        }

        // 4. Role-Based Access Control (RBAC)
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String relativePath = requestURI.substring(contextPath.length());

        if (relativePath.startsWith("/jobseeker/") || relativePath.equals("/jobseeker")) {
            if (!"JOB_SEEKER".equalsIgnoreCase(userRole)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, 
                        "Access Denied: You do not have permission to access Job Seeker resources.");
                return;
            }
        } else if (relativePath.startsWith("/recruiter/") || relativePath.equals("/recruiter")) {
            if (!"RECRUITER".equalsIgnoreCase(userRole)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, 
                        "Access Denied: You do not have permission to access Recruiter resources.");
                return;
            }
        }

        // 5. Authorized request — proceed along filter chain
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
