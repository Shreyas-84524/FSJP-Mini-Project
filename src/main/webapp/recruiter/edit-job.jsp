<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Job" %>
<%@ page import="util.HtmlUtil" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Obtain session state (AuthenticationFilter guarantees role is RECRUITER)
    HttpSession currentSession = request.getSession(false);
    String userName = (currentSession != null && currentSession.getAttribute("name") != null) 
            ? (String) currentSession.getAttribute("name") : "Recruiter";

    String errorMessage = (String) request.getAttribute("errorMessage");
    Job job = (Job) request.getAttribute("job");

    int jobId = (job != null) ? job.getId() : 0;
    String title = (job != null && job.getTitle() != null) ? job.getTitle() : "";
    String skills = (job != null && job.getSkills() != null) ? job.getSkills() : "";
    String location = (job != null && job.getLocation() != null) ? job.getLocation() : "";
    String description = (job != null && job.getDescription() != null) ? job.getDescription() : "";

    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
    String formattedCreated = (job != null && job.getCreatedAt() != null) 
            ? dateFormat.format(job.getCreatedAt()) : "Recently";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Job Posting #<%= jobId %> — Syntra Job Portal</title>
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
            <li><a href="${pageContext.request.contextPath}/recruiter/post-job">Post Job</a></li>
            <li><a href="${pageContext.request.contextPath}/recruiter/manage-jobs" class="active">Manage Jobs</a></li>
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
        <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
            <div class="alert alert-error">
                <span class="alert-icon">⚠️</span>
                <span><%= HtmlUtil.escape(errorMessage) %></span>
            </div>
        <% } %>

        <!-- Edit Job Card -->
        <div class="profile-card">
            <div class="profile-header">
                <div>
                    <h2><span>✏️</span> Edit Job Vacancy #<%= jobId %></h2>
                    <p style="color: var(--gray-300); font-size: 0.95rem; margin-top: 0.35rem;">
                        Update the role title, skills criteria, location, or detailed job specifications.
                    </p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/recruiter/manage-jobs" class="btn btn-secondary btn-sm">
                        Back to Manage Jobs
                    </a>
                </div>
            </div>

            <!-- Read-Only System Metadata Information -->
            <div class="data-grid" style="background: rgba(0, 0, 16, 0.50); padding: 1.25rem 1.5rem; border-radius: var(--radius-md); border: 1px solid rgba(255, 255, 255, 0.08); margin-bottom: 2rem;">
                <div class="data-item">
                    <span class="data-label">Job Reference ID</span>
                    <span class="data-value">#<%= jobId %></span>
                </div>
                <div class="data-item">
                    <span class="data-label">Original Post Date</span>
                    <span class="data-value"><%= formattedCreated %></span>
                </div>
                <div class="data-item">
                    <span class="data-label">Recruiter Owner</span>
                    <span class="data-value"><%= HtmlUtil.escape(userName) %></span>
                </div>
            </div>

            <!-- Job Edit Form -->
            <form action="${pageContext.request.contextPath}/recruiter/edit-job" method="POST" style="margin-top: 1rem;">

                <!-- Hidden Job ID Field -->
                <input type="hidden" name="id" value="<%= jobId %>">

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
                           placeholder="e.g. Lead Full-Stack Java Engineer">
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
                               placeholder="e.g. Java, JSP, JDBC, MySQL, HTML, CSS">
                        <div class="form-hint">Maximum 500 characters. Used for skill search matching.</div>
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
                               placeholder="e.g. Bengaluru, India or Remote">
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
                              placeholder="Detail the updated role responsibilities, qualifications, and benefits..."><%= HtmlUtil.escape(description) %></textarea>
                    <div class="form-hint">Maximum 4000 characters. Comprehensive description of requirements.</div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary" style="padding: 0.85rem 2rem; font-size: 1rem;">
                        💾 Save Changes
                    </button>
                    <a href="${pageContext.request.contextPath}/recruiter/manage-jobs" class="btn btn-outline">
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
