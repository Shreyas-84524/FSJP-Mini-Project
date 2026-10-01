<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Job" %>
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

    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Job Postings — Syntra Job Portal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recruiter.css">
    <style>
        .page-header-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
            margin-bottom: 2rem;
        }
        .job-card {
            background: rgba(0, 16, 48, 0.42);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: var(--radius-lg);
            padding: 2rem;
            box-shadow: var(--shadow-sm);
            margin-bottom: 1.75rem;
            transition: var(--transition-standard);
        }
        .job-card:hover {
            border-color: rgba(0, 119, 255, 0.35);
            box-shadow: 0 0 35px rgba(0, 92, 255, 0.12);
            transform: translateY(-2px);
        }
        .job-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 1rem;
            padding-bottom: 1.25rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            margin-bottom: 1.25rem;
        }
        .job-title-group h2 {
            font-size: 1.35rem;
            font-weight: 700;
            color: var(--white-pure);
            margin-bottom: 0.35rem;
            letter-spacing: -0.01em;
        }
        .job-meta-row {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 1.25rem;
            font-size: 0.9rem;
            color: var(--gray-300);
        }
        .job-meta-item {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }
        .skills-container {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin: 1.15rem 0;
        }
        .job-desc-snippet {
            font-size: 0.96rem;
            color: var(--gray-300);
            line-height: 1.6;
            margin-bottom: 1.35rem;
            white-space: pre-wrap;
            word-break: break-word;
        }
        .job-card-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 1.15rem;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
            flex-wrap: wrap;
            gap: 1rem;
        }
        .empty-state-box {
            text-align: center;
            padding: 4rem 2rem;
            background: rgba(0, 16, 48, 0.30);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px dashed rgba(255, 255, 255, 0.12);
            border-radius: var(--radius-xl);
            margin: 2rem 0;
        }
        .empty-state-icon {
            font-size: 3.25rem;
            margin-bottom: 1rem;
            display: block;
        }
        .empty-state-box h3 {
            font-size: 1.45rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: var(--white-pure);
        }
        .empty-state-box p {
            color: var(--gray-300);
            max-width: 480px;
            margin: 0 auto 1.75rem;
            font-size: 0.98rem;
            line-height: 1.6;
        }
    </style>
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
        <div class="page-header-actions">
            <div>
                <h1 style="font-size: 1.85rem; font-weight: 700; color: var(--white-pure); letter-spacing: -0.02em;">
                    💼 Manage Job Postings
                </h1>
                <p style="color: var(--gray-300); font-size: 0.98rem; margin-top: 0.35rem;">
                    Review, update, and manage the career vacancies you have published.
                </p>
            </div>
            <div style="display: flex; gap: 0.85rem; align-items: center;">
                <a href="${pageContext.request.contextPath}/recruiter/post-job" class="btn btn-primary">
                    ➕ Post New Job
                </a>
                <a href="${pageContext.request.contextPath}/recruiter/dashboard.jsp" class="btn btn-secondary">
                    Dashboard
                </a>
            </div>
        </div>

        <!-- Job Listings or Empty State -->
        <% if (jobs == null || jobs.isEmpty()) { %>

            <!-- Empty State -->
            <div class="empty-state-box">
                <span class="empty-state-icon">📋</span>
                <h3>You haven't posted any jobs yet</h3>
                <p>
                    Publish your first job vacancy to start attracting qualified candidates across the portal.
                </p>
                <a href="${pageContext.request.contextPath}/recruiter/post-job" class="btn btn-primary">
                    ➕ Post Your First Job
                </a>
            </div>

        <% } else { %>

            <div style="margin-bottom: 1.5rem; color: var(--gray-300); font-size: 0.92rem; font-weight: 600;">
                Showing <%= jobs.size() %> active job <%= (jobs.size() == 1) ? "posting" : "postings" %>
            </div>

            <!-- Job Cards -->
            <% for (Job job : jobs) { 
                String formattedDate = (job.getCreatedAt() != null) 
                        ? dateFormat.format(job.getCreatedAt()) : "Recently";
            %>
                <article class="job-card">
                    <!-- Card Header -->
                    <div class="job-card-header">
                        <div class="job-title-group">
                            <h2><%= HtmlUtil.escape(job.getTitle()) %></h2>
                            <div class="job-meta-row">
                                <span class="job-meta-item">
                                    📍 <strong><%= HtmlUtil.escape(job.getLocation()) %></strong>
                                </span>
                                <span class="job-meta-item">
                                    🗓️ Posted <%= formattedDate %>
                                </span>
                                <span class="job-meta-item" style="color: var(--gray-500);">
                                    🆔 Job #<%= job.getId() %>
                                </span>
                            </div>
                        </div>
                        <div>
                            <span class="badge badge-recruiter" style="font-size: 0.75rem;">Active Vacancy</span>
                        </div>
                    </div>

                    <!-- Skills Tags -->
                    <% if (job.getSkills() != null && !job.getSkills().trim().isEmpty()) { %>
                        <div class="skills-container">
                            <% 
                                String[] skillArray = job.getSkills().split(",");
                                for (String s : skillArray) {
                                    String trimmed = s.trim();
                                    if (!trimmed.isEmpty()) {
                            %>
                                <span class="skill-tag">⚡ <%= HtmlUtil.escape(trimmed) %></span>
                            <% 
                                    }
                                } 
                            %>
                        </div>
                    <% } %>

                    <!-- Description Preview -->
                    <div class="job-desc-snippet">
                        <% 
                            String desc = job.getDescription();
                            if (desc != null && desc.length() > 300) {
                                desc = desc.substring(0, 300) + "...";
                            }
                        %>
                        <%= (desc != null) ? HtmlUtil.escape(desc) : "" %>
                    </div>

                    <!-- Card Actions -->
                    <div class="job-card-footer">
                        <div style="font-size: 0.88rem; color: var(--gray-500);">
                            Owner: <strong style="color: var(--white);">You</strong> (Recruiter ID #<%= job.getRecruiterId() %>)
                        </div>
                        <div style="display: flex; gap: 0.75rem; align-items: center; flex-wrap: wrap;">
                            <!-- View Applicants Button -->
                            <a href="${pageContext.request.contextPath}/recruiter/applicants?jobId=<%= job.getId() %>" 
                               class="btn btn-primary btn-sm">
                                👥 View Applicants
                            </a>

                            <!-- Edit Button -->
                            <a href="${pageContext.request.contextPath}/recruiter/edit-job?id=<%= job.getId() %>" 
                               class="btn btn-outline btn-sm">
                                ✏️ Edit Job
                            </a>

                            <!-- Delete Form -->
                            <form action="${pageContext.request.contextPath}/recruiter/delete-job" 
                                  method="POST" 
                                  style="display: inline;" 
                                  onsubmit="return confirm('Are you sure you want to delete this job vacancy: \'<%= HtmlUtil.escape(job.getTitle()).replace("'", "\\'") %>\'?\n\nDeleting this job will also remove any applications associated with it.\nThis action cannot be undone.');">
                                <input type="hidden" name="id" value="<%= job.getId() %>">
                                <button type="submit" class="btn btn-danger-outline btn-sm">
                                    🗑️ Delete Job
                                </button>
                            </form>
                        </div>
                    </div>
                </article>
            <% } %>

        <% } %>

    </main>

    <!-- Footer -->
    <footer class="footer">
        <p>&copy; 2026 Syntra Job Portal System — Second Year FSJP Mini Project</p>
    </footer>

</body>
</html>
