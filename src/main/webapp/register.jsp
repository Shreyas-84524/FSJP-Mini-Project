<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if user is already authenticated
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
    <title>Register — Syntra Job Portal</title>
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
            <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
            <% if (!isAuthenticated) { %>
                <li><a href="${pageContext.request.contextPath}/login.jsp">Login</a></li>
            <% } else { %>
                <li class="nav-user">
                    <span><%= "JOB_SEEKER".equalsIgnoreCase(userRole) ? "👤" : "🏢" %> <%= userName %></span>
                    <span class="badge <%= "JOB_SEEKER".equalsIgnoreCase(userRole) ? "badge-jobseeker" : "badge-recruiter" %>">
                        <%= "JOB_SEEKER".equalsIgnoreCase(userRole) ? "Job Seeker" : "Recruiter" %>
                    </span>
                </li>
                <li>
                    <form action="${pageContext.request.contextPath}/logout" method="POST" style="display: inline;">
                        <button type="submit" class="btn btn-outline btn-sm">Logout</button>
                    </form>
                </li>
            <% } %>
        </ul>
    </header>

    <!-- Main Registration Container -->
    <main class="main-wrapper">
        <div class="register-card">

            <% if (isAuthenticated) { %>
                <!-- Already Logged In State View -->
                <div class="card-header">
                    <h1>Active Session Found</h1>
                    <p>You currently have an authenticated session.</p>
                </div>

                <div class="alert alert-success">
                    <span class="alert-icon">ℹ️</span>
                    <div>
                        Signed in as <strong><%= userName %></strong> (<%= "JOB_SEEKER".equalsIgnoreCase(userRole) ? "Job Seeker" : "Recruiter" %>).
                    </div>
                </div>

                <div style="margin: 1.75rem 0; display: flex; flex-direction: column; gap: 0.95rem; max-width: 480px; margin-left: auto; margin-right: auto;">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary" style="font-size: 1.02rem;">
                        Return to Home / Dashboard
                    </a>
                    <form action="${pageContext.request.contextPath}/logout" method="POST">
                        <button type="submit" class="btn btn-secondary" style="width: 100%;">
                            Sign Out (Register a New Account)
                        </button>
                    </form>
                </div>

            <% } else { %>
                <!-- Standard Registration Form View -->
                <div class="card-header">
                    <h1>Create an Account</h1>
                    <p>Join Syntra Job Portal to discover career opportunities or hire skilled talent.</p>
                </div>

                <!-- Server-Side Error Alert Banner -->
                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-error" id="serverErrorBanner">
                        <span class="alert-icon">⚠️</span>
                        <span><%= request.getAttribute("errorMessage") %></span>
                    </div>
                <% } %>

                <!-- Server-Side Success Alert Banner -->
                <% if (request.getAttribute("successMessage") != null) { %>
                    <div class="alert alert-success" id="serverSuccessBanner">
                        <span class="alert-icon">✅</span>
                        <span><%= request.getAttribute("successMessage") %></span>
                    </div>
                <% } %>

                <!-- Client-Side Validation Error Banner (hidden by default) -->
                <div class="alert alert-error" id="clientErrorBanner" style="display: none;"></div>

                <!-- Registration Form -->
                <form id="registrationForm" action="${pageContext.request.contextPath}/register" method="POST" novalidate>

                    <!-- Section 1: Account Type Selection -->
                    <div class="form-section">
                        <h2 class="section-title">1. Select Account Type</h2>
                        <div class="role-options">
                            <label class="role-card selected" id="roleCardJobSeeker" for="roleJobSeeker">
                                <input type="radio" name="role" id="roleJobSeeker" value="JOB_SEEKER" 
                                       <%= (!"RECRUITER".equals(request.getParameter("role"))) ? "checked" : "" %>>
                                <span class="role-card-text">
                                    <span class="role-card-title">Job Seeker</span>
                                    <span class="role-card-desc">Search for jobs, apply with your profile, and track application status.</span>
                                </span>
                            </label>

                            <label class="role-card" id="roleCardRecruiter" for="roleRecruiter">
                                <input type="radio" name="role" id="roleRecruiter" value="RECRUITER"
                                       <%= ("RECRUITER".equals(request.getParameter("role"))) ? "checked" : "" %>>
                                <span class="role-card-text">
                                    <span class="role-card-title">Recruiter</span>
                                    <span class="role-card-desc">Post open job positions, manage candidates, and review applications.</span>
                                </span>
                            </label>
                        </div>
                    </div>

                    <!-- Section 2: Account Credentials -->
                    <div class="form-section">
                        <h2 class="section-title">2. Account Information</h2>
                        
                        <div class="form-group">
                            <label class="form-label" for="name">Full Name <span class="required">*</span></label>
                            <input type="text" id="name" name="name" class="form-control" 
                                   value="<%= request.getParameter("name") != null ? request.getParameter("name") : "" %>"
                                   maxlength="100" placeholder="e.g. John Doe" required>
                            <span class="field-error" id="nameError"></span>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label" for="email">Email Address <span class="required">*</span></label>
                                <input type="email" id="email" name="email" class="form-control" 
                                       value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                                       maxlength="150" placeholder="e.g. john@example.com" required>
                                <span class="field-error" id="emailError"></span>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="password">Password <span class="required">*</span></label>
                                <input type="password" id="password" name="password" class="form-control" 
                                       minlength="6" placeholder="Minimum 6 characters" required>
                                <span class="field-error" id="passwordError"></span>
                            </div>
                        </div>
                    </div>

                    <!-- Section 3A: Job Seeker Profile Fields -->
                    <div class="form-section" id="jobSeekerSection">
                        <h2 class="section-title">3. Job Seeker Profile Details</h2>
                        
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label" for="phone">Phone Number</label>
                                <input type="tel" id="phone" name="phone" class="form-control" 
                                       value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>"
                                       maxlength="20" placeholder="e.g. +91 9876543210">
                                <span class="field-error" id="phoneError"></span>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="location">Location / City</label>
                                <input type="text" id="location" name="location" class="form-control" 
                                       value="<%= request.getParameter("location") != null ? request.getParameter("location") : "" %>"
                                       maxlength="100" placeholder="e.g. Mumbai, Maharashtra">
                                <span class="field-error" id="locationError"></span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="skills">Key Skills</label>
                            <input type="text" id="skills" name="skills" class="form-control" 
                                   value="<%= request.getParameter("skills") != null ? request.getParameter("skills") : "" %>"
                                   maxlength="500" placeholder="e.g. Java, JSP, Servlets, MySQL, HTML, CSS">
                            <span class="help-text">Separate multiple skills with commas.</span>
                            <span class="field-error" id="skillsError"></span>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label" for="education">Highest Education</label>
                                <input type="text" id="education" name="education" class="form-control" 
                                       value="<%= request.getParameter("education") != null ? request.getParameter("education") : "" %>"
                                       maxlength="255" placeholder="e.g. B.Tech Computer Science">
                                <span class="field-error" id="educationError"></span>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="experience">Experience Level</label>
                                <input type="text" id="experience" name="experience" class="form-control" 
                                       value="<%= request.getParameter("experience") != null ? request.getParameter("experience") : "" %>"
                                       maxlength="255" placeholder="e.g. Fresher / 1-2 Years">
                                <span class="field-error" id="experienceError"></span>
                            </div>
                        </div>
                    </div>

                    <!-- Section 3B: Recruiter Profile Fields (Shown when Recruiter is selected) -->
                    <div class="form-section hidden-section" id="recruiterSection">
                        <h2 class="section-title">3. Company & Organization Details</h2>

                        <div class="form-group">
                            <label class="form-label" for="companyName">Company / Organization Name <span class="required">*</span></label>
                            <input type="text" id="companyName" name="companyName" class="form-control" 
                                   value="<%= request.getParameter("companyName") != null ? request.getParameter("companyName") : "" %>"
                                   maxlength="150" placeholder="e.g. Acme Software Solutions Pvt Ltd">
                            <span class="field-error" id="companyNameError"></span>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label" for="recruiterPhone">Contact Phone</label>
                                <input type="tel" id="recruiterPhone" name="phone" class="form-control" 
                                       value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>"
                                       maxlength="20" placeholder="e.g. +91 9876543210">
                                <span class="field-error" id="recruiterPhoneError"></span>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="recruiterLocation">Company Location</label>
                                <input type="text" id="recruiterLocation" name="location" class="form-control" 
                                       value="<%= request.getParameter("location") != null ? request.getParameter("location") : "" %>"
                                       maxlength="100" placeholder="e.g. Bengaluru, Karnataka">
                                <span class="field-error" id="recruiterLocationError"></span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="description">Company Description</label>
                            <textarea id="description" name="description" class="form-control" rows="3" 
                                      placeholder="Brief overview of company business, industry domain, or hiring scope..."><%= request.getParameter("description") != null ? request.getParameter("description") : "" %></textarea>
                            <span class="field-error" id="descriptionError"></span>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <div class="form-group" style="margin-top: 1.75rem;">
                        <button type="submit" id="submitBtn" class="btn btn-primary" style="width: 100%;">Create Account</button>
                    </div>
                </form>

                <div class="card-footer">
                    Already have an account? <a href="${pageContext.request.contextPath}/login.jsp">Log In</a>
                </div>

                <!-- Client-side Logic Script -->
                <script src="${pageContext.request.contextPath}/js/register.js"></script>
            <% } %>

        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <p>&copy; 2026 Syntra Job Portal System — Second Year FSJP Mini Project</p>
    </footer>

</body>
</html>
