<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if user is already authenticated
    HttpSession currentSession = request.getSession(false);
    boolean isAuthenticated = (currentSession != null 
            && currentSession.getAttribute("userId") != null 
            && currentSession.getAttribute("role") != null);

    String userName = isAuthenticated ? (String) currentSession.getAttribute("name") : null;
    String userRole = isAuthenticated ? (String) currentSession.getAttribute("role") : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — Syntra Job Portal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">
</head>
<body>

    <!-- Header / Navbar -->
    <header class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="nav-brand">
            <span>💼</span> Syntra Job Portal
        </a>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
            <% if (!isAuthenticated) { %>
                <li><a href="${pageContext.request.contextPath}/register.jsp">Register</a></li>
            <% } else { %>
                <li class="nav-user">
                    <span><%= "JOB_SEEKER".equalsIgnoreCase(userRole) ? "👤" : "🏢" %> <%= userName %></span>
                    <span class="badge <%= "JOB_SEEKER".equalsIgnoreCase(userRole) ? "badge-jobseeker" : "badge-recruiter" %>">
                        <%= "JOB_SEEKER".equalsIgnoreCase(userRole) ? "Job Seeker" : "Recruiter" %>
                    </span>
                </li>
                <li>
                    <form action="${pageContext.request.contextPath}/logout" method="POST" style="display: inline;">
                        <button type="submit" class="btn btn-outline btn-sm">Logout</button>
                    </form>
                </li>
            <% } %>
        </ul>
    </header>

    <!-- Main Content -->
    <main class="main-wrapper">
        <div class="register-card" style="max-width: 480px;">

            <% if (isAuthenticated) { %>
                <!-- Already Logged In State View -->
                <div class="card-header">
                    <h1>Active Session Found</h1>
                    <p>You currently have an authenticated session.</p>
                </div>

                <div class="alert alert-success">
                    <span class="alert-icon">ℹ️</span>
                    <div>
                        Signed in as <strong><%= userName %></strong> (<%= "JOB_SEEKER".equalsIgnoreCase(userRole) ? "Job Seeker" : "Recruiter" %>).
                    </div>
                </div>

                <div style="margin: 1.75rem 0; display: flex; flex-direction: column; gap: 0.95rem;">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary" style="font-size: 1.02rem;">
                        Return to Home / Dashboard
                    </a>
                    <form action="${pageContext.request.contextPath}/logout" method="POST">
                        <button type="submit" class="btn btn-secondary" style="width: 100%;">
                            Sign Out (Switch Account)
                        </button>
                    </form>
                </div>

            <% } else { %>
                <!-- Standard Login Form View -->
                <div class="card-header">
                    <h1>Account Login</h1>
                    <p>Sign in to access your portal workspace.</p>
                </div>

                <!-- Server-Side Error Alert Banner -->
                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-error">
                        <span class="alert-icon">⚠️</span>
                        <span><%= request.getAttribute("errorMessage") %></span>
                    </div>
                <% } %>

                <!-- Server-Side Success Alert Banner -->
                <% if (request.getAttribute("successMessage") != null) { %>
                    <div class="alert alert-success">
                        <span class="alert-icon">✅</span>
                        <span><%= request.getAttribute("successMessage") %></span>
                    </div>
                <% } %>

                <!-- Login Form -->
                <form action="${pageContext.request.contextPath}/login" method="POST" novalidate>
                    <div class="form-group">
                        <label class="form-label" for="email">Email Address <span class="required">*</span></label>
                        <input type="email" id="email" name="email" class="form-control" 
                               value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : (request.getParameter("email") != null ? request.getParameter("email") : "") %>"
                               placeholder="e.g. john@example.com" maxlength="150" required autofocus>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="password">Password <span class="required">*</span></label>
                        <input type="password" id="password" name="password" class="form-control" 
                               placeholder="Enter your password" required>
                    </div>

                    <div class="form-group" style="margin-top: 1.75rem;">
                        <button type="submit" class="btn btn-primary" style="width: 100%;">Sign In</button>
                    </div>
                </form>

                <div class="card-footer" style="margin-top: 1.75rem;">
                    Don't have an account? <a href="${pageContext.request.contextPath}/register.jsp">Register here</a>
                    <div style="margin-top: 0.85rem;">
                        <a href="${pageContext.request.contextPath}/index.jsp" style="color: var(--gray-500); font-size: 0.88rem;">← Back to Home</a>
                    </div>
                </div>

            <% } %>

        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <p>&copy; 2026 Syntra Job Portal System — Second Year FSJP Mini Project</p>
    </footer>

</body>
</html>
