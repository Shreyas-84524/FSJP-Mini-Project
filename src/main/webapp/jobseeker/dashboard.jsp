<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.HtmlUtil" %>
<%
    // Obtain session state (AuthenticationFilter already guarantees role is JOB_SEEKER)
    HttpSession currentSession = request.getSession(false);
    String userName = (currentSession != null && currentSession.getAttribute("name") != null) 
            ? (String) currentSession.getAttribute("name") : "Job Seeker";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Seeker Dashboard — Syntra Job Portal</title>
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
                <span>👤 <%= HtmlUtil.escape(userName) %></span>
                <span class="badge badge-jobseeker">Job Seeker</span>
            </li>
            <li><a href="${pageContext.request.contextPath}/jobseeker/dashboard.jsp" class="active">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/jobseeker/profile">Profile</a></li>
            <li><a href="${pageContext.request.contextPath}/jobseeker/search-jobs">Search Jobs</a></li>
            <li><a href="${pageContext.request.contextPath}/jobseeker/applications">My Applications</a></li>
            <li>
                <form action="${pageContext.request.contextPath}/logout" method="POST" style="display: inline;">
                    <button type="submit" class="btn btn-outline btn-sm">Logout</button>
                </form>
            </li>
        </ul>
    </header>

    <!-- Main Content Container -->
    <main class="container">

        <!-- Welcome Hero Banner (Syntra Atmospheric Glow) -->
        <section class="hero-banner">
            <div class="hero-content">
                <div style="margin-bottom: 0.75rem;">
                    <span class="badge badge-jobseeker">
                        Job Seeker Portal
                    </span>
                </div>
                <h1>Welcome, <%= HtmlUtil.escape(userName) %>!</h1>
                <p>Manage your professional profile, explore active job openings, and track your submitted applications in real-time.</p>
            </div>
            <div class="hero-actions">
                <a href="${pageContext.request.contextPath}/jobseeker/search-jobs" class="btn btn-primary">
                    🔍 Explore Jobs
                </a>
                <a href="${pageContext.request.contextPath}/jobseeker/profile" class="btn btn-secondary">
                    👤 My Profile
                </a>
            </div>
        </section>

        <!-- Dashboard Action Cards -->
        <section class="cards-grid">

            <!-- Card 1: My Profile -->
            <div class="card">
                <div>
                    <div class="card-header-icon">👤</div>
                    <div class="card-title">
                        My Profile
                        <span class="badge badge-jobseeker" style="font-size: 0.7rem;">Active</span>
                    </div>
                    <p class="card-desc">
                        View and update your registered personal details, contact information, key skills, highest education, and experience level.
                    </p>
                </div>
                <div class="card-footer">
                    <a href="${pageContext.request.contextPath}/jobseeker/profile" class="btn btn-primary" style="width: 100%;">
                        View Full Profile &rarr;
                    </a>
                </div>
            </div>

            <!-- Card 2: Search Jobs -->
            <div class="card">
                <div>
                    <div class="card-header-icon">🔍</div>
                    <div class="card-title">
                        Search Jobs
                        <span class="badge badge-jobseeker" style="font-size: 0.7rem;">Active</span>
                    </div>
                    <p class="card-desc">
                        Discover job opportunities posted by verified recruiters matching your specific skills, experience, and preferred location.
                    </p>
                </div>
                <div class="card-footer">
                    <a href="${pageContext.request.contextPath}/jobseeker/search-jobs" class="btn btn-primary" style="width: 100%;">
                        Search Jobs &rarr;
                    </a>
                </div>
            </div>

            <!-- Card 3: My Applications -->
            <div class="card">
                <div>
                    <div class="card-header-icon">📄</div>
                    <div class="card-title">
                        My Applications
                        <span class="badge badge-jobseeker" style="font-size: 0.7rem;">Active</span>
                    </div>
                    <p class="card-desc">
                        Track the status of all your submitted job applications in real-time (Applied, Under Review, Shortlisted, Rejected).
                    </p>
                </div>
                <div class="card-footer">
                    <a href="${pageContext.request.contextPath}/jobseeker/applications" class="btn btn-primary" style="width: 100%;">
                        View My Applications &rarr;
                    </a>
                </div>
            </div>

        </section>

        <!-- Informative Guide Card -->
        <section class="info-group" style="margin-bottom: 2.5rem;">
            <div class="info-group-title">
                <span>💡</span> Application Status Lifecycle
            </div>
            <p style="color: var(--gray-300); font-size: 0.98rem; line-height: 1.65;">
                When you apply for a job, your initial status is <strong style="color: var(--blue-soft);">Applied</strong>. As recruiters review candidates, your application will advance to <strong style="color: var(--color-warning);">Under Review</strong>, and subsequently to <strong style="color: var(--color-success);">Shortlisted</strong> or <strong style="color: var(--color-error);">Rejected</strong>. Keep your profile up-to-date to improve your visibility!
            </p>
        </section>

    </main>

    <!-- Footer -->
    <footer class="footer">
        <p>&copy; 2026 Syntra Job Portal System — Second Year FSJP Mini Project</p>
    </footer>

</body>
</html>
