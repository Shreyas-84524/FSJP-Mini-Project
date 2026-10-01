<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.RecruiterProfile" %>
<%@ page import="util.HtmlUtil" %>
<%
    User user = (User) request.getAttribute("user");
    RecruiterProfile profile = (RecruiterProfile) request.getAttribute("profile");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");

    String displayName = (user != null && user.getName() != null) ? user.getName() : "Recruiter";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recruiter Profile — Syntra Job Portal</title>
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
                <span>🏢 <%= HtmlUtil.escape(displayName) %></span>
                <span class="badge badge-recruiter">Recruiter</span>
            </li>
            <li><a href="${pageContext.request.contextPath}/recruiter/dashboard.jsp">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/recruiter/profile" class="active">Profile</a></li>
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

        <!-- Profile Card -->
        <div class="profile-card">
            <div class="profile-header">
                <div>
                    <h2><span>🏢</span> Recruiter & Company Profile</h2>
                    <p style="color: var(--gray-300); font-size: 0.95rem; margin-top: 0.35rem;">
                        Review your registered recruiter credentials and organization profile information.
                    </p>
                </div>
                <div style="display: flex; gap: 0.85rem;">
                    <a href="${pageContext.request.contextPath}/recruiter/profile/edit" class="btn btn-primary btn-sm">
                        ✏️ Edit Company Profile
                    </a>
                    <a href="${pageContext.request.contextPath}/recruiter/dashboard.jsp" class="btn btn-secondary btn-sm">
                        Back to Dashboard
                    </a>
                </div>
            </div>

            <!-- Section 1: Account Information (Read-Only) -->
            <div class="section-title">
                <span>👤</span> Account Credentials (System Managed)
            </div>

            <div class="data-grid">
                <div class="data-item">
                    <span class="data-label">Full Name</span>
                    <span class="data-value">
                        <%= (user != null && user.getName() != null) ? HtmlUtil.escape(user.getName()) : "N/A" %>
                    </span>
                </div>
                <div class="data-item">
                    <span class="data-label">Email Address</span>
                    <span class="data-value">
                        <%= (user != null && user.getEmail() != null) ? HtmlUtil.escape(user.getEmail()) : "N/A" %>
                    </span>
                </div>
                <div class="data-item">
                    <span class="data-label">Role</span>
                    <span class="data-value">
                        <span class="badge badge-recruiter">
                            <%= (user != null && user.getRole() != null) ? HtmlUtil.escape(user.getRole()) : "RECRUITER" %>
                        </span>
                    </span>
                </div>
                <div class="data-item">
                    <span class="data-label">User ID</span>
                    <span class="data-value">
                        #<%= (user != null) ? user.getId() : "N/A" %>
                    </span>
                </div>
                <div class="data-item">
                    <span class="data-label">Account Created</span>
                    <span class="data-value">
                        <%= (user != null && user.getCreatedAt() != null) ? HtmlUtil.escape(user.getCreatedAt().toString()) : "N/A" %>
                    </span>
                </div>
            </div>

            <!-- Section 2: Company Information (Editable) -->
            <div class="section-title" style="margin-top: 2.25rem;">
                <span>🏢</span> Company & Hiring Details
            </div>

            <div class="data-grid">
                <div class="data-item">
                    <span class="data-label">Company Name</span>
                    <span class="data-value <%= (profile == null || profile.getCompanyName() == null || profile.getCompanyName().isEmpty()) ? "empty-text" : "" %>">
                        <%= (profile != null && profile.getCompanyName() != null && !profile.getCompanyName().isEmpty()) 
                                ? HtmlUtil.escape(profile.getCompanyName()) : "Not provided" %>
                    </span>
                </div>
                <div class="data-item">
                    <span class="data-label">Contact Phone</span>
                    <span class="data-value <%= (profile == null || profile.getPhone() == null || profile.getPhone().isEmpty()) ? "empty-text" : "" %>">
                        <%= (profile != null && profile.getPhone() != null && !profile.getPhone().isEmpty()) 
                                ? HtmlUtil.escape(profile.getPhone()) : "Not provided" %>
                    </span>
                </div>
                <div class="data-item">
                    <span class="data-label">Headquarters / Location</span>
                    <span class="data-value <%= (profile == null || profile.getLocation() == null || profile.getLocation().isEmpty()) ? "empty-text" : "" %>">
                        <%= (profile != null && profile.getLocation() != null && !profile.getLocation().isEmpty()) 
                                ? HtmlUtil.escape(profile.getLocation()) : "Not specified" %>
                    </span>
                </div>
            </div>

            <!-- Company Description -->
            <div class="data-item" style="margin-top: 0.75rem;">
                <span class="data-label">Company Description / Overview</span>
                <% if (profile != null && profile.getDescription() != null && !profile.getDescription().trim().isEmpty()) { %>
                    <div class="description-box" style="margin-top: 0.5rem;">
                        <%= HtmlUtil.escape(profile.getDescription()) %>
                    </div>
                <% } else { %>
                    <div class="description-box empty-text" style="margin-top: 0.5rem;">
                        No company description provided yet. Click "Edit Company Profile" to add an overview of your organization and culture.
                    </div>
                <% } %>
            </div>

            <div style="margin-top: 2.25rem; display: flex; gap: 1rem; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/recruiter/profile/edit" class="btn btn-primary">
                    ✏️ Edit Company Profile
                </a>
                <a href="${pageContext.request.contextPath}/recruiter/dashboard.jsp" class="btn btn-outline">
                    Back to Dashboard
                </a>
            </div>

        </div>

    </main>

    <!-- Footer -->
    <footer class="footer">
        <p>&copy; 2026 Syntra Job Portal System — Second Year FSJP Mini Project</p>
    </footer>

</body>
</html>
