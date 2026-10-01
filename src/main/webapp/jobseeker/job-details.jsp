<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Job" %>
<%@ page import="util.HtmlUtil" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Obtain session state
    HttpSession currentSession = request.getSession(false);
    String sessionName = (currentSession != null && currentSession.getAttribute("name") != null) 
            ? (String) currentSession.getAttribute("name") : "Job Seeker";

    Job job = (Job) request.getAttribute("job");
    Boolean jobNotFound = (Boolean) request.getAttribute("jobNotFound");
    Boolean hasApplied = (Boolean) request.getAttribute("hasApplied");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");

    boolean isMissing = (jobNotFound != null && jobNotFound) || (job == null);
    boolean isApplied = (hasApplied != null && hasApplied);
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMMM yyyy, hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= (!isMissing && job != null) ? HtmlUtil.escape(job.getTitle()) + " — Syntra Job Portal" : "Job Details — Syntra Job Portal" %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/jobseeker.css">
</head>
<body>

    <!-- Header / Navbar -->
    <header class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="nav-brand">
            <span>💼</span> Syntra Job Portal
        </a>

        <ul class="nav-links">
            <li class="nav-user">
                <span>👤 <%= HtmlUtil.escape(sessionName) %></span>
                <span class="badge badge-jobseeker">Job Seeker</span>
            </li>
            <li><a href="${pageContext.request.contextPath}/jobseeker/dashboard.jsp">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/jobseeker/profile">Profile</a></li>
            <li><a href="${pageContext.request.contextPath}/jobseeker/search-jobs" class="active">Search Jobs</a></li>
            <li><a href="${pageContext.request.contextPath}/jobseeker/applications">My Applications</a></li>
            <li>
                <form action="${pageContext.request.contextPath}/logout" method="POST" style="display: inline;">
                    <button type="submit" class="btn btn-outline btn-sm">Logout</button>
                </form>
            </li>
        </ul>
    </header>

    <!-- Main Container -->
    <main class="container" style="max-width: 950px;">

        <!-- Navigation / Breadcrumbs -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 0.85rem;">
            <div style="display: flex; gap: 0.85rem;">
                <a href="${pageContext.request.contextPath}/jobseeker/search-jobs" class="btn btn-outline btn-sm">
                    &larr; Back to Search Results
                </a>
                <a href="${pageContext.request.contextPath}/jobseeker/dashboard.jsp" class="btn btn-secondary btn-sm">
                    Dashboard
                </a>
            </div>
        </div>

        <!-- Flash Message Alerts -->
        <% if (successMessage != null && !successMessage.trim().isEmpty()) { %>
            <div class="alert alert-success">
                <span class="alert-icon">✅</span>
                <div>
                    <strong>Success:</strong> <%= HtmlUtil.escape(successMessage) %>
                </div>
            </div>
        <% } %>

        <% if (errorMessage != null && !errorMessage.trim().isEmpty() && !isMissing) { %>
            <div class="alert alert-error">
                <span class="alert-icon">⚠️</span>
                <div>
                    <strong>Notice:</strong> <%= HtmlUtil.escape(errorMessage) %>
                </div>
            </div>
        <% } %>

        <% if (isMissing) { %>
            <!-- Job Not Found Alert -->
            <div class="alert alert-warning" style="margin-bottom: 2rem;">
                <span class="alert-icon">⚠️</span>
                <div>
                    <strong>Notice:</strong> <%= (errorMessage != null) ? HtmlUtil.escape(errorMessage) : "The requested job could not be found or is no longer available." %>
                </div>
            </div>

            <div class="empty-state">
                <div class="empty-state-icon">📋</div>
                <h3>Job Not Available</h3>
                <p>The job you are trying to view does not exist or may have been removed.</p>
                <a href="${pageContext.request.contextPath}/jobseeker/search-jobs" class="btn btn-primary">
                    🔍 Browse Available Jobs
                </a>
            </div>
        <% } else { %>
            <!-- Job Detail Card -->
            <article class="job-detail-card">
                
                <!-- Hero Header -->
                <div class="job-detail-hero">
                    <div style="margin-bottom: 0.75rem; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 0.75rem;">
                        <div style="display: flex; align-items: center; gap: 0.65rem;">
                            <span class="badge badge-jobseeker">Active Vacancy</span>
                            <span class="badge" style="background: rgba(255, 255, 255, 0.05); color: var(--gray-300); border: 1px solid rgba(255, 255, 255, 0.10);">
                                Job ID #<%= job.getId() %>
                            </span>
                        </div>
                        <% if (isApplied) { %>
                            <span class="badge status-shortlisted" style="font-size: 0.85rem; padding: 0.35rem 0.95rem;">
                                ✓ APPLICATION SUBMITTED
                            </span>
                        <% } %>
                    </div>

                    <h1><%= HtmlUtil.escape(job.getTitle()) %></h1>

                    <div class="job-meta-row" style="margin-top: 0.85rem; font-size: 0.96rem;">
                        <span class="job-meta-item">
                            📍 <strong><%= HtmlUtil.escape(job.getLocation()) %></strong>
                        </span>
                        <span>•</span>
                        <span class="job-meta-item">
                            📅 Posted on <%= (job.getCreatedAt() != null) ? dateFormat.format(job.getCreatedAt()) : "Recently" %>
                        </span>
                    </div>
                </div>

                <!-- Job Detail Body -->
                <div class="job-detail-body">

                    <!-- Required Skills Section -->
                    <div class="info-group">
                        <div class="info-group-title">
                            <span>⚡</span> Required Technical Skills
                        </div>
                        <div class="skills-container" style="margin-top: 0.65rem;">
                            <% 
                                String skillsStr = job.getSkills();
                                if (skillsStr != null && !skillsStr.trim().isEmpty()) {
                                    String[] skillsArr = skillsStr.split(",");
                                    for (String s : skillsArr) {
                                        String trimmedSkill = s.trim();
                                        if (!trimmedSkill.isEmpty()) {
                            %>
                                <span class="badge-tag" style="font-size: 0.92rem; padding: 0.45rem 0.95rem;">
                                    ⚡ <%= HtmlUtil.escape(trimmedSkill) %>
                                </span>
                            <% 
                                        }
                                    }
                                } else { 
                            %>
                                <span style="color: var(--gray-500); font-style: italic;">No specific skills required.</span>
                            <% } %>
                        </div>
                    </div>

                    <!-- Job Description Section -->
                    <div class="info-group">
                        <div class="info-group-title">
                            <span>📄</span> Job Description & Responsibilities
                        </div>
                        <div class="job-description-content" style="margin-top: 0.85rem;">
                            <%= HtmlUtil.escape(job.getDescription()) %>
                        </div>
                    </div>

                    <!-- Application Action Area -->
                    <div style="margin-top: 1.5rem; padding: 1.75rem 2rem; border-radius: var(--radius-lg); background: rgba(0, 16, 48, 0.55); border: 1px solid rgba(0, 119, 255, 0.28); box-shadow: 0 0 35px rgba(0, 92, 255, 0.12);">
                        <% if (isApplied) { %>
                            <!-- Already Applied State -->
                            <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 1.25rem;">
                                <div style="display: flex; align-items: center; gap: 1.25rem;">
                                    <div style="width: 52px; height: 52px; border-radius: 50%; background: rgba(54, 211, 153, 0.15); border: 1px solid rgba(54, 211, 153, 0.35); color: var(--color-success); display: flex; align-items: center; justify-content: center; font-size: 1.6rem;">
                                        ✓
                                    </div>
                                    <div>
                                        <div style="font-weight: 700; color: var(--color-success); font-size: 1.15rem;">
                                            Application Successfully Submitted
                                        </div>
                                        <div style="color: var(--gray-300); font-size: 0.95rem; margin-top: 0.2rem;">
                                            You have applied for this position. Track review updates in <a href="${pageContext.request.contextPath}/jobseeker/applications" style="color: var(--blue-soft); text-decoration: underline;">My Applications</a>.
                                        </div>
                                    </div>
                                </div>
                                <button type="button" class="btn btn-secondary" disabled style="opacity: 0.75; cursor: not-allowed;">
                                    ✓ Already Applied
                                </button>
                            </div>
                        <% } else { %>
                            <!-- Not Applied State: Apply Form -->
                            <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 1.5rem;">
                                <div>
                                    <div style="font-weight: 700; color: var(--white-pure); font-size: 1.2rem; letter-spacing: -0.01em; margin-bottom: 0.35rem;">
                                        Ready to Apply?
                                    </div>
                                    <div style="color: var(--gray-300); font-size: 0.96rem;">
                                        Submit your application instantly using your current Job Seeker profile credentials.
                                    </div>
                                </div>
                                <form action="${pageContext.request.contextPath}/jobseeker/apply" method="POST" style="margin: 0;">
                                    <input type="hidden" name="jobId" value="<%= job.getId() %>">
                                    <button type="submit" class="btn btn-primary" style="padding: 0.85rem 2.25rem; font-size: 1.05rem;">
                                        <span>🚀</span> Apply for Job
                                    </button>
                                </form>
                            </div>
                        <% } %>
                    </div>

                    <!-- Bottom Navigation Links -->
                    <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid rgba(255, 255, 255, 0.08); padding-top: 1.75rem; margin-top: 1.5rem; flex-wrap: wrap; gap: 1rem;">
                        <a href="${pageContext.request.contextPath}/jobseeker/search-jobs" class="btn btn-secondary">
                            &larr; Back to Search
                        </a>
                        <a href="${pageContext.request.contextPath}/jobseeker/dashboard.jsp" class="btn btn-outline">
                            Return to Dashboard
                        </a>
                    </div>

                </div>

            </article>
        <% } %>

    </main>

    <!-- Footer -->
    <footer class="footer">
        <p>&copy; 2026 Syntra Job Portal System — Second Year FSJP Mini Project</p>
    </footer>

</body>
</html>
