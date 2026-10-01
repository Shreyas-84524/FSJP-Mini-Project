<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check authenticated session state
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
    <title>Job Portal System — Connect & Recruit</title>
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
            <% if (!isAuthenticated) { %>
                <!-- Anonymous Navigation -->
                <li><a href="${pageContext.request.contextPath}/register.jsp">Register</a></li>
                <li><a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline btn-sm">Login</a></li>
            <% } else if ("JOB_SEEKER".equalsIgnoreCase(userRole)) { %>
                <!-- Job Seeker Navigation -->
                <li class="nav-user">
                    <span>👤 <%= userName %></span>
                    <span class="badge badge-jobseeker">Job Seeker</span>
                </li>
                <li><a href="${pageContext.request.contextPath}/jobseeker/dashboard.jsp">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/jobseeker/profile">Profile</a></li>
                <li><a href="${pageContext.request.contextPath}/jobseeker/search-jobs">Search Jobs</a></li>
                <li><a href="${pageContext.request.contextPath}/jobseeker/applications">My Applications</a></li>
                <li>
                    <form action="${pageContext.request.contextPath}/logout" method="POST" style="display: inline;">
                        <button type="submit" class="btn btn-outline btn-sm">Logout</button>
                    </form>
                </li>
            <% } else if ("RECRUITER".equalsIgnoreCase(userRole)) { %>
                <!-- Recruiter Navigation -->
                <li class="nav-user">
                    <span>🏢 <%= userName %></span>
                    <span class="badge badge-recruiter">Recruiter</span>
                </li>
                <li><a href="${pageContext.request.contextPath}/recruiter/dashboard.jsp">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/recruiter/profile">Profile</a></li>
                <li><a href="${pageContext.request.contextPath}/recruiter/post-job">Post Job</a></li>
                <li>
                    <form action="${pageContext.request.contextPath}/logout" method="POST" style="display: inline;">
                        <button type="submit" class="btn btn-outline btn-sm">Logout</button>
                    </form>
                </li>
            <% } %>
        </ul>
    </header>

    <!-- Main Content Container -->
    <main class="main-wrapper">

        <% if (!isAuthenticated) { %>
            <!-- 1. Anonymous Landing View (Syntra Hero Aesthetic) -->
            <div style="max-width: 880px; width: 100%; text-align: center; margin: 0 auto; position: relative; z-index: 1;">
                
                <div style="margin-bottom: 1.25rem;">
                    <span class="badge" style="background: rgba(0, 92, 255, 0.14); border: 1px solid rgba(0, 119, 255, 0.35); color: var(--blue-soft); padding: 0.4rem 1rem;">
                        ⚡ Academic FSJP Production Platform
                    </span>
                </div>

                <h1 style="font-size: clamp(2.4rem, 5vw, 3.6rem); font-weight: 700; color: var(--white-pure); line-height: 1.15; letter-spacing: -0.03em; margin-bottom: 1.25rem;">
                    Modern Career Opportunities. <br>
                    <span style="background: linear-gradient(135deg, #FFFFFF 30%, #4DA3FF 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                        Intelligent Hiring Connections.
                    </span>
                </h1>

                <p style="font-size: 1.15rem; color: var(--gray-300); max-width: 640px; margin: 0 auto 2.5rem auto; line-height: 1.6;">
                    Discover curated tech roles or source top candidates. Streamlined application tracking, skill-based searching, and real-time recruitment lifecycle management.
                </p>

                <!-- Dual Action CTAs -->
                <div style="display: flex; justify-content: center; align-items: center; gap: 1.25rem; flex-wrap: wrap; margin-bottom: 3.5rem;">
                    <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-primary" style="padding: 0.9rem 2.25rem; font-size: 1.05rem;">
                        Get Started — Register Now &rarr;
                    </a>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-secondary" style="padding: 0.9rem 2rem; font-size: 1.05rem;">
                        Sign In to Portal
                    </a>
                </div>

                <!-- Three Core Capability Panels -->
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem; text-align: left;">
                    
                    <div class="card" style="padding: 1.75rem;">
                        <div style="font-size: 1.8rem; margin-bottom: 0.75rem;">🔍</div>
                        <h3 style="font-size: 1.15rem; color: var(--white-pure); margin-bottom: 0.4rem; font-weight: 600;">Skill-Based Discovery</h3>
                        <p style="font-size: 0.9rem; color: var(--gray-300); line-height: 1.5;">
                            Target career opportunities matching your specific skills, desired role, and preferred location.
                        </p>
                    </div>

                    <div class="card" style="padding: 1.75rem;">
                        <div style="font-size: 1.8rem; margin-bottom: 0.75rem;">📊</div>
                        <h3 style="font-size: 1.15rem; color: var(--white-pure); margin-bottom: 0.4rem; font-weight: 600;">Application Tracking</h3>
                        <p style="font-size: 0.9rem; color: var(--gray-300); line-height: 1.5;">
                            Monitor real-time status transitions: Applied, Under Review, Shortlisted, and Decision Finalized.
                        </p>
                    </div>

                    <div class="card" style="padding: 1.75rem;">
                        <div style="font-size: 1.8rem; margin-bottom: 0.75rem;">🏢</div>
                        <h3 style="font-size: 1.15rem; color: var(--white-pure); margin-bottom: 0.4rem; font-weight: 600;">Recruiter Pipeline</h3>
                        <p style="font-size: 0.9rem; color: var(--gray-300); line-height: 1.5;">
                            Post vacancies, review applicant dossiers, and manage candidate shortlists seamlessly.
                        </p>
                    </div>

                </div>

                <div style="font-size: 0.88rem; color: var(--gray-500); margin-top: 3rem;">
                    Second-Year Academic Mini-Project &bull; Servlets &bull; JSP &bull; JDBC &bull; MySQL
                </div>

            </div>

        <% } else if ("JOB_SEEKER".equalsIgnoreCase(userRole)) { %>
            <!-- 2. Authenticated Job Seeker View -->
            <div class="register-card" style="max-width: 600px; text-align: center;">
                <div class="card-header">
                    <div style="margin-bottom: 0.75rem;">
                        <span class="badge badge-jobseeker">Job Seeker Portal</span>
                    </div>
                    <h1>Welcome back, <%= userName %>!</h1>
                    <p>Find new career opportunities and track submitted applications.</p>
                </div>

                <div style="margin: 2rem 0; display: flex; flex-direction: column; gap: 0.9rem;">
                    <a href="${pageContext.request.contextPath}/jobseeker/dashboard.jsp" class="btn btn-primary" style="font-size: 1.05rem;">
                        📊 Go to Job Seeker Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/jobseeker/search-jobs" class="btn btn-secondary" style="font-size: 1.05rem;">
                        🔍 Search & Apply for Jobs
                    </a>
                    <a href="${pageContext.request.contextPath}/jobseeker/applications" class="btn btn-secondary" style="font-size: 1.05rem;">
                        📄 View My Applications
                    </a>
                    <form action="${pageContext.request.contextPath}/logout" method="POST" style="margin-top: 0.5rem;">
                        <button type="submit" class="btn btn-outline" style="width: 100%;">
                            Sign Out
                        </button>
                    </form>
                </div>

                <div style="font-size: 0.88rem; color: var(--gray-500); border-top: 1px solid rgba(255,255,255,0.08); padding-top: 1.25rem;">
                    <p>Second-Year Academic Mini-Project (FSJP)</p>
                    <p>Servlets • JSP • JDBC • MySQL</p>
                </div>
            </div>

        <% } else if ("RECRUITER".equalsIgnoreCase(userRole)) { %>
            <!-- 3. Authenticated Recruiter View -->
            <div class="register-card" style="max-width: 600px; text-align: center;">
                <div class="card-header">
                    <div style="margin-bottom: 0.75rem;">
                        <span class="badge badge-recruiter">Recruiter Portal</span>
                    </div>
                    <h1>Welcome back, <%= userName %>!</h1>
                    <p>Publish job openings, manage candidates, and update company profile information.</p>
                </div>

                <div style="margin: 2rem 0; display: flex; flex-direction: column; gap: 0.9rem;">
                    <a href="${pageContext.request.contextPath}/recruiter/dashboard.jsp" class="btn btn-primary" style="font-size: 1.05rem;">
                        📊 Go to Recruiter Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/recruiter/applicants" class="btn btn-secondary" style="font-size: 1.05rem;">
                        👥 View Candidate Applications
                    </a>
                    <a href="${pageContext.request.contextPath}/recruiter/post-job" class="btn btn-secondary" style="font-size: 1.05rem;">
                        ➕ Post a New Job Vacancy
                    </a>
                    <a href="${pageContext.request.contextPath}/recruiter/manage-jobs" class="btn btn-secondary" style="font-size: 1.05rem;">
                        💼 Manage Job Postings
                    </a>
                    <a href="${pageContext.request.contextPath}/recruiter/profile" class="btn btn-secondary" style="font-size: 1.05rem;">
                        🏢 View & Edit Company Profile
                    </a>
                    <form action="${pageContext.request.contextPath}/logout" method="POST" style="margin-top: 0.5rem;">
                        <button type="submit" class="btn btn-outline" style="width: 100%;">
                            Sign Out
                        </button>
                    </form>
                </div>

                <div style="font-size: 0.88rem; color: var(--gray-500); border-top: 1px solid rgba(255,255,255,0.08); padding-top: 1.25rem;">
                    <p>Second-Year Academic Mini-Project (FSJP)</p>
                    <p>Servlets • JSP • JDBC • MySQL</p>
                </div>
            </div>

        <% } %>

    </main>

    <!-- Footer -->
    <footer class="footer">
        <p>&copy; 2026 Syntra Job Portal System — Second Year FSJP Mini Project</p>
    </footer>

</body>
</html>
