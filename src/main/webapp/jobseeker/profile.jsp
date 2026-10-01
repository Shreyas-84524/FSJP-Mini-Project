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
    Boolean profileUnavailable = (Boolean) request.getAttribute("profileUnavailable");
    String errorMessage = (String) request.getAttribute("errorMessage");

    boolean isUnavailable = (profileUnavailable != null && profileUnavailable) || (user == null);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Seeker Profile — Syntra Job Portal</title>
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
    <main class="container">

        <!-- Breadcrumb / Back Link -->
        <div style="margin-bottom: 1.5rem;">
            <a href="${pageContext.request.contextPath}/jobseeker/dashboard.jsp" class="btn btn-outline btn-sm">
                &larr; Back to Dashboard
            </a>
        </div>

        <% 
            String successMsg = (String) request.getAttribute("successMessage");
            if (successMsg == null && currentSession != null) {
                successMsg = (String) currentSession.getAttribute("successMessage");
                if (successMsg != null) {
                    currentSession.removeAttribute("successMessage");
                }
            }
            if (successMsg != null && !successMsg.isEmpty()) { 
        %>
            <!-- Success Message Alert -->
            <div class="alert alert-success">
                <span class="alert-icon">✅</span>
                <div><%= successMsg %></div>
            </div>
        <% } %>

        <% if (isUnavailable) { %>
            <!-- Profile Unavailable Graceful Alert -->
            <div class="alert alert-warning">
                <span class="alert-icon">⚠️</span>
                <div>
                    <strong>Notice:</strong> <%= (errorMessage != null) ? errorMessage : "Profile information is currently unavailable." %>
                </div>
            </div>
        <% } %>

        <!-- Profile Card View -->
        <div class="profile-card">

            <!-- Profile Header / Hero -->
            <div class="profile-hero" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap;">
                <div style="display: flex; align-items: center; gap: 1.75rem;">
                    <div class="profile-avatar">
                        <% 
                            String initial = (user != null && user.getName() != null && !user.getName().trim().isEmpty())
                                    ? user.getName().trim().substring(0, 1).toUpperCase() : "J";
                        %>
                        <%= initial %>
                    </div>
                    <div class="profile-info">
                        <h2><%= (user != null && user.getName() != null) ? user.getName() : sessionName %></h2>
                        <p>
                            <span>✉️ <%= (user != null && user.getEmail() != null) ? user.getEmail() : "N/A" %></span>
                            <span>•</span>
                            <span class="badge badge-jobseeker">Job Seeker</span>
                        </p>
                    </div>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/jobseeker/profile/edit" class="btn btn-primary">
                        ✏️ Edit Profile
                    </a>
                </div>
            </div>

            <!-- Profile Body / Details Grid -->
            <div class="profile-body">

                <!-- Section 1: Basic Account Information -->
                <div class="info-group">
                    <div class="info-group-title">
                        <span>📋</span> Basic Account Information
                    </div>

                    <div class="info-item">
                        <div class="info-label">Full Name</div>
                        <div class="info-value"><%= (user != null && user.getName() != null) ? user.getName() : "N/A" %></div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">Email Address</div>
                        <div class="info-value"><%= (user != null && user.getEmail() != null) ? user.getEmail() : "N/A" %></div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">Account Role</div>
                        <div class="info-value">
                            <span class="badge badge-jobseeker">Job Seeker</span>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">Member Since</div>
                        <div class="info-value" style="color: var(--gray-300); font-size: 0.95rem;">
                            <%= (user != null && user.getCreatedAt() != null) ? user.getCreatedAt().toString() : "Registered Account" %>
                        </div>
                    </div>
                </div>

                <!-- Section 2: Professional Information -->
                <div class="info-group">
                    <div class="info-group-title">
                        <span>🎓</span> Professional Details
                    </div>

                    <div class="info-item">
                        <div class="info-label">Key Skills</div>
                        <div class="skills-container">
                            <% 
                                String skillsStr = (profile != null && profile.getSkills() != null) ? profile.getSkills() : "";
                                if (!skillsStr.trim().isEmpty()) {
                                    String[] skillsArray = skillsStr.split(",");
                                    for (String skill : skillsArray) {
                                        String trimmed = skill.trim();
                                        if (!trimmed.isEmpty()) {
                            %>
                                <span class="badge-tag">⚡ <%= trimmed %></span>
                            <% 
                                        }
                                    }
                                } else { 
                            %>
                                <span class="info-value" style="color: var(--gray-500); font-style: italic;">No skills specified</span>
                            <% } %>
                        </div>
                    </div>

                    <div class="info-item" style="margin-top: 1.25rem;">
                        <div class="info-label">Highest Education</div>
                        <div class="info-value"><%= (profile != null && profile.getEducation() != null && !profile.getEducation().trim().isEmpty()) ? profile.getEducation() : "Not provided" %></div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">Experience Level</div>
                        <div class="info-value"><%= (profile != null && profile.getExperience() != null && !profile.getExperience().trim().isEmpty()) ? profile.getExperience() : "Not provided" %></div>
                    </div>
                </div>

                <!-- Section 3: Contact & Location -->
                <div class="info-group">
                    <div class="info-group-title">
                        <span>📍</span> Contact & Location
                    </div>

                    <div class="info-item">
                        <div class="info-label">Phone Number</div>
                        <div class="info-value"><%= (profile != null && profile.getPhone() != null && !profile.getPhone().trim().isEmpty()) ? profile.getPhone() : "Not provided" %></div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">Preferred Location</div>
                        <div class="info-value"><%= (profile != null && profile.getLocation() != null && !profile.getLocation().trim().isEmpty()) ? profile.getLocation() : "Not provided" %></div>
                    </div>
                </div>

            </div>

        </div>

        <!-- Action Bar -->
        <div style="display: flex; gap: 1rem; margin-bottom: 2.5rem; flex-wrap: wrap;">
            <a href="${pageContext.request.contextPath}/jobseeker/profile/edit" class="btn btn-primary">
                ✏️ Edit Profile
            </a>
            <a href="${pageContext.request.contextPath}/jobseeker/dashboard.jsp" class="btn btn-secondary">
                &larr; Return to Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary">
                🏠 Main Portal Home
            </a>
        </div>

    </main>

    <!-- Footer -->
    <footer class="footer">
        <p>&copy; 2026 Syntra Job Portal System — Second Year FSJP Mini Project</p>
    </footer>

</body>
</html>
