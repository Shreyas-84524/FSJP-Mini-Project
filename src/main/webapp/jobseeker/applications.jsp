<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ApplicationItem" %>
<%@ page import="util.HtmlUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Obtain session state
    HttpSession currentSession = request.getSession(false);
    String sessionName = (currentSession != null && currentSession.getAttribute("name") != null) 
            ? (String) currentSession.getAttribute("name") : "Job Seeker";

    @SuppressWarnings("unchecked")
    List<ApplicationItem> applications = (List<ApplicationItem>) request.getAttribute("applications");
    Integer applicationCount = (Integer) request.getAttribute("applicationCount");
    int count = (applicationCount != null) ? applicationCount : (applications != null ? applications.size() : 0);

    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMMM yyyy, hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications — Syntra Job Portal</title>
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
            <li><a href="${pageContext.request.contextPath}/jobseeker/search-jobs">Search Jobs</a></li>
            <li><a href="${pageContext.request.contextPath}/jobseeker/applications" class="active">My Applications</a></li>
            <li>
                <form action="${pageContext.request.contextPath}/logout" method="POST" style="display: inline;">
                    <button type="submit" class="btn btn-outline btn-sm">Logout</button>
                </form>
            </li>
        </ul>
    </header>

    <!-- Main Container -->
    <main class="container">

        <!-- Top Navigation / Breadcrumbs -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 0.85rem;">
            <div>
                <a href="${pageContext.request.contextPath}/jobseeker/dashboard.jsp" class="btn btn-outline btn-sm">
                    &larr; Back to Dashboard
                </a>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/jobseeker/search-jobs" class="btn btn-primary btn-sm">
                    🔍 Search More Jobs
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

        <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
            <div class="alert alert-error">
                <span class="alert-icon">⚠️</span>
                <div>
                    <strong>Notice:</strong> <%= HtmlUtil.escape(errorMessage) %>
                </div>
            </div>
        <% } %>

        <!-- Hero Header -->
        <section class="jobseeker-hero">
            <div class="hero-content">
                <h1>My Job Applications</h1>
                <p>Track the real-time review and shortlisting status of your submitted job applications.</p>
            </div>
        </section>

        <!-- Application Results Count & Header Bar -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 0.75rem;">
            <div style="font-size: 1.15rem; font-weight: 700; color: var(--white-pure);">
                Submitted Applications 
                <span class="badge" style="background: rgba(0, 92, 255, 0.14); color: var(--blue-soft); border: 1px solid rgba(0, 119, 255, 0.35); margin-left: 0.5rem; font-size: 0.85rem;">
                    <%= count %> Total
                </span>
            </div>
        </div>

        <!-- Application List / Empty State -->
        <% if (applications == null || applications.isEmpty()) { %>
            <!-- Empty State -->
            <div class="empty-state">
                <div class="empty-state-icon">📭</div>
                <h3>You haven't applied to any jobs yet.</h3>
                <p>Explore active career openings matching your skillset and submit your application with one click.</p>
                <div style="margin-top: 1.5rem;">
                    <a href="${pageContext.request.contextPath}/jobseeker/search-jobs" class="btn btn-primary">
                        🔍 Browse Available Jobs
                    </a>
                </div>
            </div>
        <% } else { %>
            <!-- Applications List -->
            <div class="job-list">
                <% for (ApplicationItem item : applications) { 
                    String rawStatus = item.getStatus();
                    String displayStatus;
                    String statusClass;

                    if ("APPLIED".equalsIgnoreCase(rawStatus)) {
                        displayStatus = "Applied";
                        statusClass = "status-applied";
                    } else if ("UNDER_REVIEW".equalsIgnoreCase(rawStatus)) {
                        displayStatus = "Under Review";
                        statusClass = "status-under-review";
                    } else if ("SHORTLISTED".equalsIgnoreCase(rawStatus)) {
                        displayStatus = "Shortlisted";
                        statusClass = "status-shortlisted";
                    } else if ("REJECTED".equalsIgnoreCase(rawStatus)) {
                        displayStatus = "Rejected";
                        statusClass = "status-rejected";
                    } else {
                        displayStatus = "Status unavailable";
                        statusClass = "status-unknown";
                    }
                %>
                    <article class="job-item-card">
                        
                        <!-- Top Header: Title, Location, and Status Badge -->
                        <div class="job-item-header">
                            <div>
                                <h2 class="job-item-title">
                                    <a href="${pageContext.request.contextPath}/jobseeker/job-details?id=<%= item.getJobId() %>">
                                        <%= HtmlUtil.escape(item.getJobTitle()) %>
                                    </a>
                                </h2>
                                <div class="job-meta-row" style="margin-top: 0.4rem;">
                                    <span class="job-meta-item">
                                        📍 <strong><%= HtmlUtil.escape(item.getJobLocation()) %></strong>
                                    </span>
                                    <span>•</span>
                                    <span class="job-meta-item">
                                        📅 Applied on <%= (item.getAppliedAt() != null) ? dateFormat.format(item.getAppliedAt()) : "Recently" %>
                                    </span>
                                    <span>•</span>
                                    <span class="job-meta-item" style="color: var(--gray-500);">
                                        Job ID #<%= item.getJobId() %>
                                    </span>
                                </div>
                            </div>
                            
                            <!-- Application Status Badge -->
                            <div style="text-align: right;">
                                <span class="badge badge-status <%= statusClass %>">
                                    <%= displayStatus %>
                                </span>
                            </div>
                        </div>

                        <!-- Required Skills Chips -->
                        <div class="skills-container" style="margin-top: 0.5rem;">
                            <% 
                                String skillsStr = item.getJobSkills();
                                if (skillsStr != null && !skillsStr.trim().isEmpty()) {
                                    String[] skillsArr = skillsStr.split(",");
                                    for (String s : skillsArr) {
                                        String trimmed = s.trim();
                                        if (!trimmed.isEmpty()) {
                            %>
                                <span class="badge-tag">
                                    ⚡ <%= HtmlUtil.escape(trimmed) %>
                                </span>
                            <% 
                                        }
                                    }
                                } 
                            %>
                        </div>

                        <!-- Short Description Preview -->
                        <div style="margin-top: 0.5rem; color: var(--gray-300); font-size: 0.95rem; line-height: 1.6;">
                            <% 
                                String desc = item.getJobDescription();
                                if (desc != null) {
                                    if (desc.length() > 200) {
                                        desc = desc.substring(0, 197) + "...";
                                    }
                                } else {
                                    desc = "No description provided.";
                                }
                            %>
                            <%= HtmlUtil.escape(desc) %>
                        </div>

                        <!-- Card Footer Action -->
                        <div class="job-item-footer" style="margin-top: 0.75rem;">
                            <div style="font-size: 0.85rem; color: var(--gray-500);">
                                Application Reference: <strong>#<%= item.getId() %></strong>
                            </div>
                            <div>
                                <a href="${pageContext.request.contextPath}/jobseeker/job-details?id=<%= item.getJobId() %>" class="btn btn-outline btn-sm">
                                    📄 View Job Details &rarr;
                                </a>
                            </div>
                        </div>

                    </article>
                <% } %>
            </div>
        <% } %>

    </main>

    <!-- Footer -->
    <footer class="footer">
        <p>&copy; 2026 Syntra Job Portal System — Second Year FSJP Mini Project</p>
    </footer>

</body>
</html>
