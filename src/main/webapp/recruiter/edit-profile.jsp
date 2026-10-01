<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.RecruiterProfile" %>
<%@ page import="util.HtmlUtil" %>
<%
    User user = (User) request.getAttribute("user");
    RecruiterProfile profile = (RecruiterProfile) request.getAttribute("profile");
    String errorMessage = (String) request.getAttribute("errorMessage");

    String displayName = (user != null && user.getName() != null) ? user.getName() : "Recruiter";
    String companyName = (profile != null && profile.getCompanyName() != null) ? profile.getCompanyName() : "";
    String phone = (profile != null && profile.getPhone() != null) ? profile.getPhone() : "";
    String location = (profile != null && profile.getLocation() != null) ? profile.getLocation() : "";
    String description = (profile != null && profile.getDescription() != null) ? profile.getDescription() : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Company Profile — Syntra Job Portal</title>
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

        <!-- Error Message Alert -->
        <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
            <div class="alert alert-error">
                <span class="alert-icon">⚠️</span>
                <span><%= HtmlUtil.escape(errorMessage) %></span>
            </div>
        <% } %>

        <div class="profile-card">
            <div class="profile-header">
                <div>
                    <h2><span>✏️</span> Edit Company Profile</h2>
                    <p style="color: var(--gray-300); font-size: 0.95rem; margin-top: 0.35rem;">
                        Update your organization information visible to job seekers across the portal.
                    </p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/recruiter/profile" class="btn btn-secondary btn-sm">
                        Cancel & Return
                    </a>
                </div>
            </div>

            <!-- Read-Only Credentials Summary -->
            <div class="section-title">
                <span>🔒</span> Read-Only Account Details
            </div>

            <div class="data-grid" style="margin-bottom: 2rem;">
                <div class="data-item">
                    <span class="data-label">Recruiter Full Name</span>
                    <span class="data-value">
                        <%= (user != null && user.getName() != null) ? HtmlUtil.escape(user.getName()) : "N/A" %>
                    </span>
                </div>
                <div class="data-item">
                    <span class="data-label">Account Email</span>
                    <span class="data-value">
                        <%= (user != null && user.getEmail() != null) ? HtmlUtil.escape(user.getEmail()) : "N/A" %>
                    </span>
                </div>
                <div class="data-item">
                    <span class="data-label">Account Role</span>
                    <span class="data-value">
                        <span class="badge badge-recruiter">
                            <%= (user != null && user.getRole() != null) ? HtmlUtil.escape(user.getRole()) : "RECRUITER" %>
                        </span>
                    </span>
                </div>
            </div>

            <!-- Editable Form -->
            <div class="section-title">
                <span>🏢</span> Editable Company Information
            </div>

            <form action="${pageContext.request.contextPath}/recruiter/profile/update" method="POST" style="margin-top: 1.5rem;">

                <!-- Company Name (Required) -->
                <div class="form-group">
                    <label for="companyName" class="form-label">
                        Company Name <span class="required">*</span>
                    </label>
                    <input type="text" 
                           id="companyName" 
                           name="companyName" 
                           class="form-control" 
                           maxlength="150" 
                           required 
                           value="<%= HtmlUtil.escape(companyName) %>" 
                           placeholder="e.g. Acme Corporation, TechVentures LLC">
                    <div class="form-hint">Maximum 150 characters. Required.</div>
                </div>

                <!-- Contact Phone -->
                <div class="form-group">
                    <label for="phone" class="form-label">Contact Phone</label>
                    <input type="text" 
                           id="phone" 
                           name="phone" 
                           class="form-control" 
                           maxlength="20" 
                           value="<%= HtmlUtil.escape(phone) %>" 
                           placeholder="e.g. +1 555-0199 or 9876543210">
                    <div class="form-hint">Maximum 20 characters. Digits, spaces, hyphens, and + allowed.</div>
                </div>

                <!-- Location / Headquarters -->
                <div class="form-group">
                    <label for="location" class="form-label">Headquarters / Location</label>
                    <input type="text" 
                           id="location" 
                           name="location" 
                           class="form-control" 
                           maxlength="100" 
                           value="<%= HtmlUtil.escape(location) %>" 
                           placeholder="e.g. San Francisco, CA or Remote">
                    <div class="form-hint">Maximum 100 characters. City, State, Country or Remote.</div>
                </div>

                <!-- Company Description -->
                <div class="form-group">
                    <label for="description" class="form-label">Company Description / Overview</label>
                    <textarea id="description" 
                              name="description" 
                              class="form-control" 
                              rows="6" 
                              maxlength="2000" 
                              placeholder="Describe your company, work culture, missions, and what makes working here exciting..."><%= HtmlUtil.escape(description) %></textarea>
                    <div class="form-hint">Maximum 2000 characters.</div>
                </div>

                <!-- Form Action Buttons -->
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        💾 Save Changes
                    </button>
                    <a href="${pageContext.request.contextPath}/recruiter/profile" class="btn btn-outline">
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
