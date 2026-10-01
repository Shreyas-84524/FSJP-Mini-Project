<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Job" %>
<%@ page import="model.RecruiterApplicantItem" %>
<%@ page import="util.HtmlUtil" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%
    // Obtain session state (AuthenticationFilter guarantees role is RECRUITER)
    HttpSession currentSession = request.getSession(false);
    String userName = (currentSession != null && currentSession.getAttribute("name") != null) 
            ? (String) currentSession.getAttribute("name") : "Recruiter";

    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");

    @SuppressWarnings("unchecked")
    List<Job> jobs = (List<Job>) request.getAttribute("jobs");

    @SuppressWarnings("unchecked")
    List<RecruiterApplicantItem> applicants = (List<RecruiterApplicantItem>) request.getAttribute("applicants");

    Job selectedJob = (Job) request.getAttribute("selectedJob");
    Integer selectedJobId = (Integer) request.getAttribute("selectedJobId");

    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy 'at' hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Applicant Dashboard — Syntra Job Portal</title>
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
            <li><a href="${pageContext.request.contextPath}/recruiter/manage-jobs">Manage Jobs</a></li>
            <li><a href="${pageContext.request.contextPath}/recruiter/applicants" class="active">Applicants</a></li>
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

        <!-- Page Header & Action Bar -->
        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem; margin-bottom: 2rem;">
            <div>
                <h1 style="font-size: 1.85rem; font-weight: 700; color: var(--white-pure); letter-spacing: -0.02em;">
                    👥 Applicant Dashboard
                </h1>
                <p style="color: var(--gray-300); font-size: 0.98rem; margin-top: 0.35rem;">
                    Review candidates who have applied for your published career opportunities.
                </p>
            </div>
            <div style="display: flex; gap: 0.85rem; align-items: center; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/recruiter/manage-jobs" class="btn btn-secondary">
                    💼 Manage Jobs
                </a>
                <a href="${pageContext.request.contextPath}/recruiter/post-job" class="btn btn-primary">
                    ➕ Post New Job
                </a>
            </div>
        </div>

        <!-- If Recruiter has NO jobs at all -->
        <% if (jobs == null || jobs.isEmpty()) { %>

            <div class="profile-card" style="text-align: center; padding: 4rem 2rem;">
                <div style="font-size: 3.5rem; margin-bottom: 1.25rem;">📋</div>
                <h3 style="font-size: 1.45rem; font-weight: 700; margin-bottom: 0.5rem; color: var(--white-pure);">
                    You haven't posted any jobs yet
                </h3>
                <p style="color: var(--gray-300); max-width: 480px; margin: 0 auto 1.75rem; font-size: 0.98rem; line-height: 1.6;">
                    Once you publish career openings, candidate applications, matched skills, and profile dossiers will appear here.
                </p>
                <a href="${pageContext.request.contextPath}/recruiter/post-job" class="btn btn-primary">
                    ➕ Post Your First Job
                </a>
            </div>

        <% } else { %>

            <!-- Job Filter Selection Card -->
            <section class="filter-card">
                <form action="${pageContext.request.contextPath}/recruiter/applicants" method="GET" class="filter-form">
                    <label for="jobSelect" style="font-size: 0.92rem; font-weight: 600; color: var(--white); display: flex; align-items: center; gap: 0.4rem;">
                        <span>🔍</span> Filter by Job Vacancy:
                    </label>
                    <select id="jobSelect" name="jobId" class="form-control" style="max-width: 420px;">
                        <option value="" <%= (selectedJobId == null) ? "selected" : "" %>>
                            — All Job Postings (<%= jobs.size() %> total) —
                        </option>
                        <% for (Job j : jobs) { 
                            boolean isSelected = (selectedJobId != null && selectedJobId.intValue() == j.getId());
                        %>
                            <option value="<%= j.getId() %>" <%= isSelected ? "selected" : "" %>>
                                #<%= j.getId() %>: <%= HtmlUtil.escape(j.getTitle()) %> (<%= HtmlUtil.escape(j.getLocation()) %>)
                            </option>
                        <% } %>
                    </select>
                    <button type="submit" class="btn btn-primary btn-sm">
                        Filter Applications
                    </button>
                    <% if (selectedJobId != null) { %>
                        <a href="${pageContext.request.contextPath}/recruiter/applicants" class="btn btn-outline btn-sm">
                            Clear Filter
                        </a>
                    <% } %>
                </form>
            </section>

            <!-- Results Summary Banner -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 0.75rem;">
                <div style="font-size: 1.15rem; font-weight: 700; color: var(--white-pure);">
                    <% if (selectedJob != null) { %>
                        Applications for: <span style="color: var(--blue-soft);"><%= HtmlUtil.escape(selectedJob.getTitle()) %></span> (Job #<%= selectedJob.getId() %>)
                    <% } else { %>
                        All Received Applications
                    <% } %>
                    <span class="badge" style="background: rgba(0, 92, 255, 0.14); color: var(--blue-soft); border: 1px solid rgba(0, 119, 255, 0.35); margin-left: 0.5rem; font-size: 0.85rem;">
                        <%= (applicants != null) ? applicants.size() : 0 %> <%= ((applicants != null && applicants.size() == 1) ? "Candidate" : "Candidates") %>
                    </span>
                </div>
            </div>

            <!-- Applicants List / Empty States -->
            <% if (applicants == null || applicants.isEmpty()) { %>

                <div class="profile-card" style="text-align: center; padding: 3.5rem 2rem;">
                    <div style="font-size: 3.25rem; margin-bottom: 1rem;">📭</div>
                    <h3 style="font-size: 1.35rem; font-weight: 700; margin-bottom: 0.5rem; color: var(--white-pure);">
                        <% if (selectedJob != null) { %>
                            No applications have been received for this job yet.
                        <% } else { %>
                            No applications have been received across your job postings yet.
                        <% } %>
                    </h3>
                    <p style="color: var(--gray-300); max-width: 460px; margin: 0 auto 1.5rem; font-size: 0.98rem; line-height: 1.6;">
                        Candidates searching for matching skills and locations will appear here as soon as they submit an application.
                    </p>
                    <a href="${pageContext.request.contextPath}/recruiter/manage-jobs" class="btn btn-outline btn-sm">
                        View Active Listings
                    </a>
                </div>

            <% } else { %>

                <!-- Candidate Cards -->
                <% for (RecruiterApplicantItem item : applicants) { 
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
                        displayStatus = (rawStatus != null && !rawStatus.trim().isEmpty()) ? rawStatus : "Applied";
                        statusClass = "status-unknown";
                    }

                    String formattedDate = (item.getAppliedAt() != null) 
                            ? dateFormat.format(item.getAppliedAt()) : "Recently";
                %>
                    <article class="applicant-card">

                        <!-- Card Header: Candidate Name, Target Job, and Status Badge -->
                        <div class="applicant-card-header">
                            <div>
                                <h2 class="applicant-name">
                                    👤 <%= HtmlUtil.escape(item.getApplicantName()) %>
                                </h2>
                                <div class="applicant-job-target">
                                    Applied for: <strong><%= HtmlUtil.escape(item.getJobTitle()) %></strong> (📍 <%= HtmlUtil.escape(item.getJobLocation()) %>)
                                </div>
                            </div>
                            <div style="text-align: right;">
                                <span class="badge badge-status <%= statusClass %>">
                                    <%= displayStatus %>
                                </span>
                            </div>
                        </div>

                        <!-- Candidate Profile Details Grid -->
                        <div class="applicant-details-grid">
                            <div class="data-item">
                                <span class="detail-label">Email Address</span>
                                <span class="detail-value">
                                    ✉️ <a href="mailto:<%= HtmlUtil.escape(item.getApplicantEmail()) %>" style="color: var(--blue-soft); text-decoration: underline;">
                                        <%= HtmlUtil.escape(item.getApplicantEmail()) %>
                                    </a>
                                </span>
                            </div>
                            <div class="data-item">
                                <span class="detail-label">Contact Phone</span>
                                <span class="detail-value <%= (item.getPhone() == null || item.getPhone().trim().isEmpty()) ? "empty-text" : "" %>">
                                    📞 <%= (item.getPhone() != null && !item.getPhone().trim().isEmpty()) ? HtmlUtil.escape(item.getPhone()) : "Not provided" %>
                                </span>
                            </div>
                            <div class="data-item">
                                <span class="detail-label">Candidate Location</span>
                                <span class="detail-value <%= (item.getLocation() == null || item.getLocation().trim().isEmpty()) ? "empty-text" : "" %>">
                                    📍 <%= (item.getLocation() != null && !item.getLocation().trim().isEmpty()) ? HtmlUtil.escape(item.getLocation()) : "Not specified" %>
                                </span>
                            </div>
                            <div class="data-item">
                                <span class="detail-label">Education</span>
                                <span class="detail-value <%= (item.getEducation() == null || item.getEducation().trim().isEmpty()) ? "empty-text" : "" %>">
                                    🎓 <%= (item.getEducation() != null && !item.getEducation().trim().isEmpty()) ? HtmlUtil.escape(item.getEducation()) : "Not specified" %>
                                </span>
                            </div>
                            <div class="data-item">
                                <span class="detail-label">Experience</span>
                                <span class="detail-value <%= (item.getExperience() == null || item.getExperience().trim().isEmpty()) ? "empty-text" : "" %>">
                                    💼 <%= (item.getExperience() != null && !item.getExperience().trim().isEmpty()) ? HtmlUtil.escape(item.getExperience()) : "Not specified" %>
                                </span>
                            </div>
                            <div class="data-item">
                                <span class="detail-label">Applied Date</span>
                                <span class="detail-value">
                                    🗓️ <%= formattedDate %>
                                </span>
                            </div>
                        </div>

                        <!-- Candidate Skills Tags -->
                        <div style="margin-top: 1.25rem;">
                            <span class="detail-label" style="display: block; margin-bottom: 0.45rem;">Candidate Key Skills</span>
                            <% if (item.getSkills() != null && !item.getSkills().trim().isEmpty()) { %>
                                <div style="display: flex; flex-wrap: wrap; gap: 0.5rem;">
                                    <% 
                                        String[] skillsArr = item.getSkills().split(",");
                                        for (String s : skillsArr) {
                                            String trimmed = s.trim();
                                            if (!trimmed.isEmpty()) {
                                    %>
                                        <span class="skill-tag">
                                            ⚡ <%= HtmlUtil.escape(trimmed) %>
                                        </span>
                                    <% 
                                            }
                                        } 
                                    %>
                                </div>
                            <% } else { %>
                                <span style="font-size: 0.9rem; color: var(--gray-500); font-style: italic;">No specific skills listed on profile</span>
                            <% } %>
                        </div>

                        <!-- Candidate Status Action Control Bar -->
                        <div class="status-action-bar">
                            <div style="font-size: 0.92rem; font-weight: 600; color: var(--white); display: flex; align-items: center; gap: 0.5rem;">
                                <span>⚙️</span> Update Application Status:
                            </div>

                            <div class="status-action-buttons">
                                <% if ("APPLIED".equalsIgnoreCase(rawStatus)) { %>
                                    <!-- Transition: APPLIED -> UNDER_REVIEW -->
                                    <form action="${pageContext.request.contextPath}/recruiter/update-application-status" method="POST" style="display: inline;">
                                        <input type="hidden" name="applicationId" value="<%= item.getApplicationId() %>">
                                        <% if (selectedJobId != null) { %>
                                            <input type="hidden" name="jobId" value="<%= selectedJobId %>">
                                        <% } %>
                                        <input type="hidden" name="status" value="UNDER_REVIEW">
                                        <button type="submit" class="btn btn-primary btn-sm">
                                            🔍 Move to Under Review
                                        </button>
                                    </form>
                                <% } else if ("UNDER_REVIEW".equalsIgnoreCase(rawStatus)) { %>
                                    <!-- Transition: UNDER_REVIEW -> SHORTLISTED -->
                                    <form action="${pageContext.request.contextPath}/recruiter/update-application-status" method="POST" style="display: inline;">
                                        <input type="hidden" name="applicationId" value="<%= item.getApplicationId() %>">
                                        <% if (selectedJobId != null) { %>
                                            <input type="hidden" name="jobId" value="<%= selectedJobId %>">
                                        <% } %>
                                        <input type="hidden" name="status" value="SHORTLISTED">
                                        <button type="submit" class="btn btn-success btn-sm">
                                            ✅ Shortlist Candidate
                                        </button>
                                    </form>

                                    <!-- Transition: UNDER_REVIEW -> REJECTED -->
                                    <form action="${pageContext.request.contextPath}/recruiter/update-application-status" method="POST" style="display: inline;"
                                          onsubmit="return confirm('Are you sure you want to mark this application as Rejected? This is a terminal status.');">
                                        <input type="hidden" name="applicationId" value="<%= item.getApplicationId() %>">
                                        <% if (selectedJobId != null) { %>
                                            <input type="hidden" name="jobId" value="<%= selectedJobId %>">
                                        <% } %>
                                        <input type="hidden" name="status" value="REJECTED">
                                        <button type="submit" class="btn btn-danger-outline btn-sm">
                                            ❌ Reject Application
                                        </button>
                                    </form>
                                <% } else if ("SHORTLISTED".equalsIgnoreCase(rawStatus)) { %>
                                    <div class="status-terminal-badge" style="color: var(--color-success);">
                                        <span>🌟 Candidate has been <strong>Shortlisted</strong> (Decision finalized)</span>
                                    </div>
                                <% } else if ("REJECTED".equalsIgnoreCase(rawStatus)) { %>
                                    <div class="status-terminal-badge" style="color: var(--color-error);">
                                        <span>🚫 Application has been <strong>Rejected</strong> (Decision finalized)</span>
                                    </div>
                                <% } else { %>
                                    <div class="status-terminal-badge">
                                        <span>No status transitions available</span>
                                    </div>
                                <% } %>
                            </div>
                        </div>

                        <!-- Card Footer: Reference IDs -->
                        <div style="margin-top: 1.25rem; padding-top: 0.85rem; border-top: 1px solid rgba(255, 255, 255, 0.08); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 0.5rem; font-size: 0.82rem; color: var(--gray-500);">
                            <div>
                                Application ID: <strong style="color: var(--gray-300);">#<%= item.getApplicationId() %></strong> &bull; Job Reference: <strong style="color: var(--gray-300);">Job #<%= item.getJobId() %></strong>
                            </div>
                            <div>
                                Candidate User ID: <strong style="color: var(--gray-300);">#<%= item.getJobseekerId() %></strong>
                            </div>
                        </div>

                    </article>
                <% } %>

            <% } %>

        <% } %>

    </main>

    <!-- Footer -->
    <footer class="footer">
        <p>&copy; 2026 Syntra Job Portal System — Second Year FSJP Mini Project</p>
    </footer>

</body>
</html>
