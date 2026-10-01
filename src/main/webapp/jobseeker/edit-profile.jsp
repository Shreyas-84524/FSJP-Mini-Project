<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.JobSeekerProfile" %>
<%
    // Obtain session state
    HttpSession currentSession = request.getSession(false);
    String sessionName = (currentSession != null && currentSession.getAttribute("name") != null) 
            ? (String) currentSession.getAttribute("name") : "Job Seeker";

    User user = (User) request.getAttribute("user");
    JobSeekerProfile profile = (JobSeekerProfile) request.getAttribute("profile");
    String errorMessage = (String) request.getAttribute("errorMessage");

    // Safe field extractors to avoid displaying literal "null"
    String safePhone = (profile != null && profile.getPhone() != null) ? profile.getPhone() : "";
    String safeLocation = (profile != null && profile.getLocation() != null) ? profile.getLocation() : "";
    String safeSkills = (profile != null && profile.getSkills() != null) ? profile.getSkills() : "";
    String safeEducation = (profile != null && profile.getEducation() != null) ? profile.getEducation() : "";
    String safeExperience = (profile != null && profile.getExperience() != null) ? profile.getExperience() : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile — Syntra Job Portal</title>
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
                <span>👤 <%= sessionName %></span>
                <span class="badge badge-jobseeker">Job Seeker</span>
            </li>
            <li><a href="${pageContext.request.contextPath}/jobseeker/dashboard.jsp">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/jobseeker/profile" class="active">Profile</a></li>
            <li><a href="${pageContext.request.contextPath}/jobseeker/search-jobs">Search Jobs</a></li>
            <li><a href="${pageContext.request.contextPath}/jobseeker/applications">My Applications</a></li>
            <li>
                <form action="${pageContext.request.contextPath}/logout" method="POST" style="display: inline;">
                    <button type="submit" class="btn btn-outline btn-sm">Logout</button>
                </form>
            </li>
        </ul>
    </header>

    <!-- Main Container -->
    <main class="container" style="max-width: 880px;">

        <!-- Breadcrumb / Back Link -->
        <div style="margin-bottom: 1.5rem;">
            <a href="${pageContext.request.contextPath}/jobseeker/profile" class="btn btn-outline btn-sm">
                &larr; Cancel & Return to Profile
            </a>
        </div>

        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <!-- Validation / Error Alert -->
            <div class="alert alert-error">
                <span class="alert-icon">⚠️</span>
                <div><%= errorMessage %></div>
            </div>
        <% } %>

        <div class="profile-card" style="padding: 2.5rem;">

            <div style="border-bottom: 1px solid rgba(255, 255, 255, 0.08); padding-bottom: 1.25rem; margin-bottom: 2rem;">
                <h2 style="font-size: 1.6rem; font-weight: 700; color: var(--white-pure); letter-spacing: -0.02em;">✏️ Edit Job Seeker Profile</h2>
                <p style="color: var(--gray-300); font-size: 0.95rem; margin-top: 0.35rem;">
                    Update your professional qualifications, skills, and contact details.
                </p>
            </div>

            <!-- Profile Edit Form -->
            <form action="${pageContext.request.contextPath}/jobseeker/profile/update" method="POST">

                <!-- Section 1: Read-Only Account Information -->
                <div style="margin-bottom: 2rem;">
                    <h3 style="font-size: 1.05rem; font-weight: 700; color: var(--white-pure); margin-bottom: 1rem; display: flex; align-items: center; gap: 0.5rem; letter-spacing: -0.01em;">
                        <span>🔒</span> Account Credentials (System Managed)
                    </h3>

                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1.25rem;">
                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label">Full Name</label>
                            <input type="text" class="form-control" value="<%= (user != null && user.getName() != null) ? user.getName() : sessionName %>" readonly title="Account name is managed by system">
                        </div>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label">Email Address</label>
                            <input type="email" class="form-control" value="<%= (user != null && user.getEmail() != null) ? user.getEmail() : "" %>" readonly title="Email address cannot be modified">
                        </div>
                    </div>
                </div>

                <!-- Section 2: Editable Professional Details -->
                <div style="margin-bottom: 2rem;">
                    <h3 style="font-size: 1.05rem; font-weight: 700; color: var(--white-pure); margin-bottom: 1rem; display: flex; align-items: center; gap: 0.5rem; letter-spacing: -0.01em;">
                        <span>🎓</span> Professional Information
                    </h3>

                    <div class="form-group">
                        <label class="form-label" for="skills">Key Skills <span class="help-text" style="display: inline;">(Max 500 chars)</span></label>
                        <textarea id="skills" name="skills" class="form-control" rows="3" placeholder="e.g. Java, Python, SQL, HTML, CSS, Spring Boot, Git" maxlength="500"><%= safeSkills %></textarea>
                        <span class="help-text">List your technical proficiencies separated by commas.</span>
                    </div>

                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1.25rem;">
                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label" for="education">Highest Education <span class="help-text" style="display: inline;">(Max 255 chars)</span></label>
                            <input type="text" id="education" name="education" class="form-control" value="<%= safeEducation %>" placeholder="e.g. B.Tech Computer Science" maxlength="255">
                        </div>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label" for="experience">Experience Level <span class="help-text" style="display: inline;">(Max 255 chars)</span></label>
                            <input type="text" id="experience" name="experience" class="form-control" value="<%= safeExperience %>" placeholder="e.g. 2 Years, Entry-Level, Fresher" maxlength="255">
                        </div>
                    </div>
                </div>

                <!-- Section 3: Editable Contact & Location -->
                <div style="margin-bottom: 2.25rem;">
                    <h3 style="font-size: 1.05rem; font-weight: 700; color: var(--white-pure); margin-bottom: 1rem; display: flex; align-items: center; gap: 0.5rem; letter-spacing: -0.01em;">
                        <span>📍</span> Contact & Location
                    </h3>

                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1.25rem;">
                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label" for="phone">Phone Number <span class="help-text" style="display: inline;">(Max 20 chars)</span></label>
                            <input type="tel" id="phone" name="phone" class="form-control" value="<%= safePhone %>" placeholder="e.g. +1-555-0199 or 9876543210" maxlength="20">
                        </div>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label" for="location">Preferred Location <span class="help-text" style="display: inline;">(Max 100 chars)</span></label>
                            <input type="text" id="location" name="location" class="form-control" value="<%= safeLocation %>" placeholder="e.g. San Francisco, CA or Remote" maxlength="100">
                        </div>
                    </div>
                </div>

                <!-- Form Action Buttons -->
                <div style="display: flex; gap: 1rem; border-top: 1px solid rgba(255, 255, 255, 0.08); padding-top: 1.5rem; flex-wrap: wrap;">
                    <button type="submit" class="btn btn-primary" style="min-width: 160px;">
                        💾 Save Changes
                    </button>
                    <a href="${pageContext.request.contextPath}/jobseeker/profile" class="btn btn-secondary">
                        Cancel
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
