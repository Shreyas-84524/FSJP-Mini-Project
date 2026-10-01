<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Job" %>
<%@ page import="util.HtmlUtil" %>
<%
    // Obtain session state (AuthenticationFilter guarantees role is RECRUITER)
    HttpSession currentSession = request.getSession(false);
    String userName = (currentSession != null && currentSession.getAttribute("name") != null) 
            ? (String) currentSession.getAttribute("name") : "Recruiter";

    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");

    Job submittedJob = (Job) request.getAttribute("job");
    String title = (submittedJob != null && submittedJob.getTitle() != null) ? submittedJob.getTitle() : "";
    String skills = (submittedJob != null && submittedJob.getSkills() != null) ? submittedJob.getSkills() : "";
    String location = (submittedJob != null && submittedJob.getLocation() != null) ? submittedJob.getLocation() : "";
    String description = (submittedJob != null && submittedJob.getDescription() != null) ? submittedJob.getDescription() : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post a Job Opening — Syntra Job Portal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recruiter.css">
</head>
<body>

    <!-- Header / Navbar -->
    <header class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="nav-brand">
            <span>💼</span> Syntra Job Portal
        </a>

        <ul class="nav-links">
            <li class="nav-user">
                <span>🏢 <%= HtmlUtil.escape(userName) %></span>
                <span class="badge badge-recruiter">Recruiter</span>
            </li>
            <li><a href="${pageContext.request.contextPath}/recruiter/dashboard.jsp">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/recruiter/profile">Profile</a></li>
            <li><a href="${pageContext.request.contextPath}/recruiter/post-job" class="active">Post Job</a></li>
            <li><a href="${pageContext.request.contextPath}/recruiter/manage-jobs">Manage Jobs</a></li>
            <li><a href="${pageContext.request.contextPath}/recruiter/applicants">Applicants</a></li>
            <li>
                <form action="${pageContext.request.contextPath}/logout" method="POST" style="display: inline;">
                    <button type="submit" class="btn btn-outline btn-sm">Logout</button>
                </form>
            </li>
        </ul>
    </header>

    <!-- Main Content Container -->
    <main class="dashboard-container">

        <!-- Flash Messages -->
        <% if (successMessage != null && !successMessage.trim().isEmpty()) { %>
            <div class="alert alert-success">
                <span class="alert-icon">✅</span>
                <span><%= HtmlUtil.escape(successMessage) %></span>
            </div>
        <% } %>

        <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
            <div class="alert alert-error">
                <span class="alert-icon">⚠️</span>
                <span><%= HtmlUtil.escape(errorMessage) %></span>
            </div>
        <% } %>

        <!-- Post Job Card -->
        <div class="profile-card">
            <div class="profile-header">
                <div>
                    <h2><span>➕</span> Post a New Job Vacancy</h2>
                    <p style="color: var(--gray-300); font-size: 0.95rem; margin-top: 0.35rem;">
                        Publish a new career opportunity visible to qualified job seekers across the portal.
                    </p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/recruiter/dashboard.jsp" class="btn btn-secondary btn-sm">
                        Back to Dashboard
                    </a>
                </div>
            </div>

            <!-- Job Details Form -->
            <form action="${pageContext.request.contextPath}/recruiter/post-job" method="POST" style="margin-top: 1.5rem;">

                <!-- Job Title -->
                <div class="form-group">
                    <label for="title" class="form-label">
                        Job Title <span class="required">*</span>
                    </label>
                    <input type="text" 
                           id="title" 
                           name="title" 
                           class="form-control" 
                           maxlength="150" 
                           required 
                           value="<%= HtmlUtil.escape(title) %>" 
                           placeholder="e.g. Senior Java Full-Stack Developer, Cloud Architect">
                    <div class="form-hint">Maximum 150 characters. Required.</div>
                </div>

                <!-- Skills & Location Grid -->
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1.25rem; margin-bottom: 1.25rem;">
                    <!-- Required Skills -->
                    <div class="form-group" style="margin-bottom: 0;">
                        <label for="skills" class="form-label">
                            Required Skills (Comma-Separated) <span class="required">*</span>
                        </label>
                        <input type="text" 
                               id="skills" 
                               name="skills" 
                               class="form-control" 
                               maxlength="500" 
                               required 
                               value="<%= HtmlUtil.escape(skills) %>" 
                               placeholder="e.g. Java, Spring Boot, MySQL, REST APIs, Docker">
                        <div class="form-hint">Maximum 500 characters. Used for automated skill matching.</div>
                    </div>

                    <!-- Job Location -->
                    <div class="form-group" style="margin-bottom: 0;">
                        <label for="location" class="form-label">
                            Job Location <span class="required">*</span>
                        </label>
                        <input type="text" 
                               id="location" 
                               name="location" 
                               class="form-control" 
                               maxlength="100" 
                               required 
                               value="<%= HtmlUtil.escape(location) %>" 
                               placeholder="e.g. San Francisco, CA or Remote">
                        <div class="form-hint">Maximum 100 characters. City, State or Remote.</div>
                    </div>
                </div>

                <!-- Job Description -->
                <div class="form-group">
                    <label for="description" class="form-label">
                        Job Description & Requirements <span class="required">*</span>
                    </label>
                    <textarea id="description" 
                              name="description" 
                              class="form-control" 
                              rows="8" 
                              maxlength="4000" 
                              required 
                              placeholder="Detail the role responsibilities, tech stack, team expectations, experience level, and key qualifications..."><%= HtmlUtil.escape(description) %></textarea>
                    <div class="form-hint">Maximum 4000 characters. Comprehensive description of requirements and duties.</div>
                </div>

                <!-- Form Action Buttons -->
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary" style="padding: 0.85rem 2rem; font-size: 1rem;">
                        ➕ Publish Job Posting
                    </button>
                    <a href="${pageContext.request.contextPath}/recruiter/dashboard.jsp" class="btn btn-outline">
                        Cancel & Return
                    </a>
                </div>

            </form>

        </div>

    </main>

    <!-- Footer -->
    <footer class="footer">
        <p>&copy; 2026 Syntra Job Portal System — Second Year FSJP Mini Project</p>
    </footer>

</body>
</html>
