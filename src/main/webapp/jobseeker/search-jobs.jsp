<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Job" %>
<%@ page import="util.HtmlUtil" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Obtain session state
    HttpSession currentSession = request.getSession(false);
    String sessionName = (currentSession != null && currentSession.getAttribute("name") != null) 
            ? (String) currentSession.getAttribute("name") : "Job Seeker";

    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
    String keyword = (String) request.getAttribute("keyword");
    String skills = (String) request.getAttribute("skills");
    String location = (String) request.getAttribute("location");
    Boolean hasFilters = (Boolean) request.getAttribute("hasFilters");
    Integer resultCount = (Integer) request.getAttribute("resultCount");

    if (keyword == null) keyword = "";
    if (skills == null) skills = "";
    if (location == null) location = "";
    if (hasFilters == null) hasFilters = false;
    if (resultCount == null) resultCount = (jobs != null) ? jobs.size() : 0;

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Jobs — Syntra Job Portal</title>
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

    <!-- Main Content Container -->
    <main class="container">

        <!-- Page Header / Breadcrumb -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <h1 style="font-size: 1.85rem; font-weight: 700; color: var(--white-pure); letter-spacing: -0.02em;">
                    🔍 Explore Career Opportunities
                </h1>
                <p style="color: var(--gray-300); font-size: 0.98rem; margin-top: 0.35rem;">
                    Find relevant positions matching your technical skills, desired title, and preferred location.
                </p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/jobseeker/dashboard.jsp" class="btn btn-outline btn-sm">
                    &larr; Back to Dashboard
                </a>
            </div>
        </div>

        <!-- Search & Filter Card -->
        <section class="search-card">
            <form action="${pageContext.request.contextPath}/jobseeker/search-jobs" method="GET" class="search-grid">
                
                <!-- Keyword Input -->
                <div class="search-field">
                    <label for="keyword">Keyword</label>
                    <input type="text" id="keyword" name="keyword" value="<%= HtmlUtil.escape(keyword) %>" 
                           placeholder="Title, description, or term" maxlength="150">
                </div>

                <!-- Skills Input -->
                <div class="search-field">
                    <label for="skills">Skills</label>
                    <input type="text" id="skills" name="skills" value="<%= HtmlUtil.escape(skills) %>" 
                           placeholder="e.g. Java, SQL, React" maxlength="500">
                </div>

                <!-- Location Input -->
                <div class="search-field">
                    <label for="location">Location</label>
                    <input type="text" id="location" name="location" value="<%= HtmlUtil.escape(location) %>" 
                           placeholder="City, State, or Remote" maxlength="100">
                </div>

                <!-- Action Buttons -->
                <div class="search-actions">
                    <button type="submit" class="btn btn-primary" style="min-width: 120px;">
                        🔍 Search
                    </button>
                    <% if (hasFilters) { %>
                        <a href="${pageContext.request.contextPath}/jobseeker/search-jobs" class="btn btn-secondary" title="Reset all filters">
                            Clear
                        </a>
                    <% } %>
                </div>

            </form>
        </section>

        <!-- Search Results Meta Bar -->
        <section class="results-meta">
            <div class="results-count">
                <span><%= resultCount %> <%= (resultCount == 1) ? "job" : "jobs" %> found</span>
                <% if (hasFilters) { %>
                    <span style="color: var(--gray-500); font-weight: normal; font-size: 0.9rem; margin-left: 0.5rem;">
                        (filtered results)
                    </span>
                <% } %>
            </div>

            <% if (hasFilters) { %>
                <div style="display: flex; gap: 0.5rem; flex-wrap: wrap;">
                    <% if (!keyword.isEmpty()) { %>
                        <span class="active-filter-tag">Keyword: <%= HtmlUtil.escape(keyword) %></span>
                    <% } %>
                    <% if (!skills.isEmpty()) { %>
                        <span class="active-filter-tag">Skills: <%= HtmlUtil.escape(skills) %></span>
                    <% } %>
                    <% if (!location.isEmpty()) { %>
                        <span class="active-filter-tag">Location: <%= HtmlUtil.escape(location) %></span>
                    <% } %>
                </div>
            <% } %>
        </section>

        <!-- Job Listings -->
        <% if (jobs != null && !jobs.isEmpty()) { %>
            <section class="jobs-list">
                <% for (Job job : jobs) { %>
                    <article class="job-item-card">
                        
                        <div class="job-item-header">
                            <div>
                                <h2 style="margin: 0; font-size: 1.35rem;">
                                    <a href="${pageContext.request.contextPath}/jobseeker/job-details?id=<%= job.getId() %>" class="job-title-link">
                                        <%= HtmlUtil.escape(job.getTitle()) %>
                                    </a>
                                </h2>
                                <div class="job-meta-row">
                                    <span class="job-meta-item">
                                        📍 <strong><%= HtmlUtil.escape(job.getLocation()) %></strong>
                                    </span>
                                    <span>•</span>
                                    <span class="job-meta-item">
                                        📅 Posted <%= (job.getCreatedAt() != null) ? dateFormat.format(job.getCreatedAt()) : "Recently" %>
                                    </span>
                                </div>
                            </div>
                            <div>
                                <span class="badge" style="background: rgba(255, 255, 255, 0.05); color: var(--gray-300); border: 1px solid rgba(255, 255, 255, 0.10);">
                                    Job ID #<%= job.getId() %>
                                </span>
                            </div>
                        </div>

                        <!-- Skills Chips -->
                        <div>
                            <div style="font-size: 0.78rem; font-weight: 700; color: var(--gray-500); text-transform: uppercase; letter-spacing: 0.04em; margin-bottom: 0.4rem;">
                                Required Skills
                            </div>
                            <div class="skills-container">
                                <% 
                                    String skillsStr = job.getSkills();
                                    if (skillsStr != null && !skillsStr.trim().isEmpty()) {
                                        String[] skillsArr = skillsStr.split(",");
                                        for (String s : skillsArr) {
                                            String trimmedSkill = s.trim();
                                            if (!trimmedSkill.isEmpty()) {
                                %>
                                    <span class="badge-tag">⚡ <%= HtmlUtil.escape(trimmedSkill) %></span>
                                <% 
                                            }
                                        }
                                    } else { 
                                %>
                                    <span style="color: var(--gray-500); font-size: 0.85rem; font-style: italic;">Not specified</span>
                                <% } %>
                            </div>
                        </div>

                        <!-- Description Snippet -->
                        <div class="job-description-snippet">
                            <%= HtmlUtil.escape(job.getDescription()) %>
                        </div>

                        <!-- Card Footer Action -->
                        <div class="job-item-footer">
                            <span style="color: var(--gray-500); font-size: 0.88rem;">
                                Verified Vacancy &bull; Instant Application
                            </span>
                            <a href="${pageContext.request.contextPath}/jobseeker/job-details?id=<%= job.getId() %>" class="btn btn-primary btn-sm">
                                View Details &rarr;
                            </a>
                        </div>

                    </article>
                <% } %>
            </section>
        <% } else { %>
            <!-- Empty State -->
            <section class="empty-state">
                <div class="empty-state-icon">🔎</div>
                <h3>No jobs found matching your search</h3>
                <p>
                    <% if (hasFilters) { %>
                        We couldn't find any job postings matching your current filter criteria. Try broadening your keywords or removing some filters.
                    <% } else { %>
                        There are currently no active job vacancies available in the system. Please check back later!
                    <% } %>
                </p>
                <% if (hasFilters) { %>
                    <a href="${pageContext.request.contextPath}/jobseeker/search-jobs" class="btn btn-primary">
                        View All Available Jobs
                    </a>
                <% } else { %>
                    <a href="${pageContext.request.contextPath}/jobseeker/dashboard.jsp" class="btn btn-secondary">
                        &larr; Return to Dashboard
                    </a>
                <% } %>
            </section>
        <% } %>

    </main>

    <!-- Footer -->
    <footer class="footer">
        <p>&copy; 2026 Syntra Job Portal System — Second Year FSJP Mini Project</p>
    </footer>

</body>
</html>
