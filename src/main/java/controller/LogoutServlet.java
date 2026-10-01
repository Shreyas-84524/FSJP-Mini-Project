package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * LogoutServlet - Handles user session termination and invalidation.
 * 
 * - Invalidates existing active HttpSession on POST /logout.
 * - Redirects the user to the login page.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests on /logout to login page or process logout safely
        doPost(request, response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Obtain the current session if one exists
        HttpSession session = request.getSession(false);

        // 2. Invalidate server-side session
        if (session != null) {
            session.invalidate();
        }

        // 3. Redirect to login page using dynamic context path
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
