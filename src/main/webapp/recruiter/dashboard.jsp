<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.ProfileDAO" %>
<%@ page import="model.RecruiterProfile" %>
<%@ page import="util.HtmlUtil" %>
<%
    // Obtain session state (AuthenticationFilter guarantees role is RECRUITER)
    HttpSession currentSession = request.getSession(false);
    String userName = (currentSession != null && currentSession.getAttribute("name") != null) 
            ? (String) currentSession.getAttribute("name") : "Recruiter";
    
    Integer userId = (currentSession != null && currentSession.getAttribute("userId") != null)
            ? (Integer) currentSession.getAttribute("userId") : null;

    RecruiterProfile profile = null;
    if (userId != null) {
        ProfileDAO profileDAO = new ProfileDAO();
        profile = profileDAO.getRecruiterProfileByUserId(userId);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recruiter Dashboard — Syntra Job Portal</title>
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
            <li><a href="${pageContext.request.contextPath}/recruiter/dashboard.jsp" class="active">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/recruiter/profile">Profile</a></li>
            <li><a href="${pageContext.request.contextPath}/recruiter/post-job">Post Job</a></li>
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

        <!-- Welcome Hero Banner (Syntra Atmospheric Glow) -->
        <section class="welcome-hero">
            <div class="hero-text">
                <div style="margin-bottom: 0.75rem;">
                    <span class="badge badge-recruiter">
                        Recruiter Workspace
                    </span>
                </div>
                <h1>Welcome, <%= HtmlUtil.escape(userName) %>!</h1>
                <p>
                    Manage your hiring presence, keep your company profile updated, and publish career opportunities for qualified candidates.
                </p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/recruiter/post-job" class="btn btn-primary">
                    ➕ Post a Job Opening
                </a>
            </div>
        </section>

        <!-- Company Overview Summary Card -->
        <% if (profile != null && profile.getCompanyName() != null && !profile.getCompanyName().isEmpty()) { %>
            <section class="profile-card" style="margin-bottom: 2.5rem;">
                <div class="profile-header">
                    <h2><span>🏢</span> <%= HtmlUtil.escape(profile.getCompanyName()) %></h2>
                    <a href="${pageContext.request.contextPath}/recruiter/profile/edit" class="btn btn-secondary btn-sm">
                        ✏️ Edit Company Details
                    </a>
                </div>
                <div class="data-grid">
                    <div class="data-item">
                        <span class="data-label">Company Name</span>
                        <span class="data-value"><%= HtmlUtil.escape(profile.getCompanyName()) %></span>
                    </div>
                    <div class="data-item">
                        <span class="data-label">Contact Phone</span>
                        <span class="data-value <%= (profile.getPhone() == null || profile.getPhone().isEmpty()) ? "empty-text" : "" %>">
                            <%= (profile.getPhone() != null && !profile.getPhone().isEmpty()) ? HtmlUtil.escape(profile.getPhone()) : "Not provided" %>
                        </span>
                    </div>
                    <div class="data-item">
                        <span class="data-label">Headquarters / Location</span>
                        <span class="data-value <%= (profile.getLocation() == null || profile.getLocation().isEmpty()) ? "empty-text" : "" %>">
                            <%= (profile.getLocation() != null && !profile.getLocation().isEmpty()) ? HtmlUtil.escape(profile.getLocation()) : "Not specified" %>
                        </span>
                    </div>
                </div>
                <% if (profile.getDescription() != null && !profile.getDescription().trim().isEmpty()) { %>
                    <div class="data-item">
                        <span class="data-label">Company Overview</span>
                        <div class="description-box" style="margin-top: 0.5rem;">
                            <%= HtmlUtil.escape(profile.getDescription()) %>
                        </div>
                    </div>
                <% } %>
            </section>
        <% } %>

        <!-- Action Cards Grid -->
        <h2 style="font-size: 1.4rem; font-weight: 700; margin-bottom: 1.25rem; color: var(--white-pure); letter-spacing: -0.01em;">
            Recruiter Workspace Actions
        </h2>

        <section class="action-grid">

            <!-- Card 1: Company Profile (Active) -->
            <div class="action-card">
                <div>
                    <span class="card-icon">🏢</span>
                    <div class="card-title">
                        Company Profile
                        <span class="badge badge-recruiter" style="font-size: 0.7rem;">Active</span>
                    </div>
                    <p class="card-description">
                        View and update your company details, recruitment contact information, location, and organization overview.
                    </p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/recruiter/profile" class="btn btn-primary" style="width: 100%;">
                        View & Edit Profile &rarr;
                    </a>
                </div>
            </div>

            <!-- Card 2: Post Job (Active) -->
            <div class="action-card">
                <div>
                    <span class="card-icon">➕</span>
                    <div class="card-title">
                        Post a Job Opening
                        <span class="badge badge-recruiter" style="font-size: 0.7rem;">Active</span>
                    </div>
                    <p class="card-description">
                        Publish new job vacancies with title, required skill tags, job location, and detailed role descriptions.
                    </p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/recruiter/post-job" class="btn btn-primary" style="width: 100%;">
                        Post a Job Vacancy &rarr;
                    </a>
                </div>
            </div>

            <!-- Card 3: Manage Jobs (Active) -->
            <div class="action-card">
                <div>
                    <span class="card-icon">💼</span>
                    <div class="card-title">
                        Manage Job Postings
                        <span class="badge badge-recruiter" style="font-size: 0.7rem;">Active</span>
                    </div>
                    <p class="card-description">
                        Track your active listings, edit role specifications, and delete outdated vacancies.
                    </p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/recruiter/manage-jobs" class="btn btn-primary" style="width: 100%;">
                        Manage Job Postings &rarr;
                    </a>
                </div>
            </div>

            <!-- Card 4: Applicant Dashboard (Active) -->
            <div class="action-card">
                <div>
                    <span class="card-icon">👥</span>
                    <div class="card-title">
                        Applicant Dashboard
                        <span class="badge badge-recruiter" style="font-size: 0.7rem;">Active</span>
                    </div>
                    <p class="card-description">
                        Review incoming candidate applications, inspect matched skills, education, and track application statuses.
                    </p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/recruiter/applicants" class="btn btn-primary" style="width: 100%;">
                        View Applicants &rarr;
                    </a>
                </div>
            </div>

        </section>

    </main>

    <!-- Footer -->
    <footer class="footer">
        <p>&copy; 2026 Syntra Job Portal System — Second Year FSJP Mini Project</p>
    </footer>

</body>
</html>
