# Java Mini Project — Presentation Context

> **Note for ChatGPT:**  
> This document is an exhaustive, production-grade technical overview of an academic **Full Stack Java Programming (FSJP)** mini-project titled **Syntra Job Portal**.  
> Use the structured context, routes, real class names, methods, database schemas, demo steps, and viva Q&A below to craft a high-impact presentation and live demo script for college teachers and evaluators. No external repository access is required.

---

## 1. Project Overview

- **Project Name:** Syntra Job Portal (Job Portal System)
- **Academic Context:** Second-Year Academic Mini-Project for **Full Stack Java Programming (FSJP)**, Bachelor of Engineering / Technology in Computer Science / IT.
- **Main Purpose:** A centralized, web-based recruitment platform connecting job seekers seeking employment opportunities with recruiters hiring qualified talent.
- **Target Users:**
  1. **Job Seekers:** Students, freshers, and professionals creating profiles, searching for job vacancies based on keywords, skills, and locations, applying with one click, and tracking review statuses in real-time.
  2. **Recruiters / Employers:** HR representatives and company hiring managers publishing job openings, managing active vacancies (edit/delete), reviewing candidate qualifications, and moving applicants through a formal hiring pipeline.
- **Architectural Philosophy:** Developed strictly using **Core Java Enterprise Web Technologies** (**Jakarta Servlets, JSP, JDBC, MySQL, and Apache Tomcat**). Higher-level abstractions (Spring Boot, Spring Security, Hibernate, JPA) and frontend frameworks (React, Angular) were intentionally excluded to demonstrate foundational mastery of HTTP request lifecycle, servlet container behavior, session management, transaction integrity, and low-level SQL optimization.

---

## 2. Problem Statement

1. **Fragmented Hiring Communication:** Job seekers often apply to multiple jobs via disconnected email threads or static forms, leading to lost resumes and complete lack of visibility into application review progress.
2. **Manual Recruiter Overhead:** Small businesses and recruiters lack lightweight, organized systems to post vacancies, filter candidates by specific skill tags, and track recruitment progress without costly Enterprise Resource Planning (ERP) or Software-as-a-Service (SaaS) suites.
3. **Data Inconsistency & Ghosting:** Without relational constraints and automated state machines, duplicate applications are submitted, jobs are deleted while applications dangle, and job seekers are left unaware of whether their profiles were viewed, shortlisted, or rejected.

---

## 3. Solution

Syntra Job Portal delivers an end-to-end relational web portal providing:
- **Role-Based Authentication & Navigation:** Separate workspaces for Job Seekers and Recruiters protected by an HTTP Servlet Filter (`AuthenticationFilter`).
- **Dynamic Job Matching & Search:** Multi-token SQL query generation (`LIKE %token%` with `AND`/`OR` grouping) to search across job titles, descriptions, skills, and geographic locations.
- **Two-Tier Application Deduplication:** Prevents duplicate job applications at both the servlet controller layer and the database layer (`uk_job_jobseeker` unique constraint).
- **Enforced State-Machine Hiring Pipeline:** Recruiter status transitions follow a finite workflow (`APPLIED` $\rightarrow$ `UNDER_REVIEW` $\rightarrow$ `SHORTLISTED` or `REJECTED`), strictly barring illegal or out-of-order transitions.
- **Atomic Relational Persistence:** MySQL InnoDB foreign key cascades (`ON DELETE CASCADE`) guarantee that deleting a recruiter or job automatically purges orphaned profile and application records without data corruption.

---

## 4. Technology Stack

### Backend Technologies
- **Programming Language:** Java 17 LTS / Java 25 compatible (Compiled with `javac --release 17`).
- **Servlet Specification:** Jakarta Servlet API 6.0.0 (`jakarta.servlet.*`).
- **View Engine:** Jakarta Server Pages (JSP) 3.1.0 (`jakarta.servlet.jsp.*`).
- **Data Access:** Java Database Connectivity (JDBC) using `java.sql.*` (`DriverManager`, `Connection`, `PreparedStatement`, `ResultSet`).
- **Cryptography & Security:** Java Standard Cryptographic Architecture (`javax.crypto.SecretKeyFactory`, `PBEKeySpec`, `java.security.SecureRandom`) implementing **PBKDF2WithHmacSHA256** with 65,536 iterations and unique 16-byte random salts.
- **Session & State Management:** `jakarta.servlet.http.HttpSession` with cookie-based `JSESSIONID`, timeout configured to 30 minutes in `web.xml`, and session fixation protection.

### Database
- **RDBMS:** MySQL 8.0+ Community Server.
- **Storage Engine:** InnoDB (Supports ACID transactions, row-level locking, and foreign keys).
- **Character Encoding:** `utf8mb4` with `utf8mb4_unicode_ci`.
- **Driver:** MySQL Connector/J 8.3.0 (`com.mysql.cj.jdbc.Driver`).

### Web Server & Build Tool
- **Servlet Container / Web Server:** Apache Tomcat 11.0.26 (Port 8080, HTTP/1.1 NIO Protocol Handler).
- **Build & Dependency Automation:** Apache Maven 3.9.x (`pom.xml`, packaging `war`).

### Frontend Technologies
- **Structure:** Semantic HTML5 (`<header>`, `<main>`, `<section>`, `<article>`, `<footer>`).
- **Styling:** Custom Vanilla CSS3 featuring the **Syntra Dark-Tech Design System**:
  - Deep OLED black (`#000000`) and navy surfaces (`#000010`, `#000020`, `#001030`).
  - Electric blue accents (`#005CFF`, `#0077FF`, `#1683FF`).
  - Frosted glassmorphism (`backdrop-filter: blur(16px)`).
  - Modern typography: High contrast pure white text (`#FFFFFF`) with muted secondary labels (`#B8BDC7`).
  - Responsive flexbox and CSS multi-column grid layouts without Bootstrap or Tailwind.
- **Client-Side Scripting:** Vanilla JavaScript (`register.js` for instant tab switching, form input regex validation, and dynamic error banner feedback).

### Communication Protocol
- **Client-to-Server:** Standard HTTP/1.1 requests (`GET` for idempotent data fetches and page rendering; `POST` for state mutations, creations, updates, and deletions).
- **Server-to-Client:** HTML markup rendered on the server via JSP; query results forwarded using `request.getRequestDispatcher().forward()` or redirected via `response.sendRedirect()` following the **Post/Redirect/Get (PRG)** design pattern.

---

## 5. Architecture

The project implements a classic **Layered Model-View-Controller (MVC)** architectural pattern adapted for servlet containers.

```
       +---------------------------------------------------------+
       |                   CLIENT (Web Browser)                  |
       |  HTML5 + Syntra Design System CSS + Vanilla JavaScript  |
       +----------------------------+----------------------------+
                                    | HTTP Requests (GET / POST)
                                    v
       +---------------------------------------------------------+
       |               FILTER LAYER (Security Gate)              |
       |  AuthenticationFilter (/jobseeker/* and /recruiter/*)   |
       +----------------------------+----------------------------+
                                    | Authorized Chain
                                    v
       +---------------------------------------------------------+
       |             CONTROLLER LAYER (Java Servlets)            |
       |  Login, Register, PostJob, ApplyJob, JobSearch, etc.    |
       |  - Session verification & RBAC role checks              |
       |  - Server-side parameter validation & sanitization      |
       |  - Transaction orchestration & PRG redirection          |
       +--------------+---------------------------+--------------+
                      | Passes DTO / Models       | Invokes DAO
                      v                           v
       +----------------------------+  +-------------------------+
       |         VIEW LAYER         |  |    DATA ACCESS LAYER    |
       |         JSP Pages          |  |       (DAO Pattern)     |
       |  EL, Scriptlets, HTMLUtil  |  |  UserDAO, JobDAO,       |
       |  Dynamic UI rendering      |  |  ApplicationDAO,        |
       +----------------------------+  |  ProfileDAO             |
                                       +------------+------------+
                                                    | JDBC (PreparedStatements)
                                                    v
                                       +-------------------------+
                                       |     DATABASE LAYER      |
                                       |     MySQL 8.0 RDBMS     |
                                       |   InnoDB Foreign Keys   |
                                       +-------------------------+
```

### Architectural Responsibilities:
1. **View Layer (JSP):** Pure presentation. Reads request attributes populated by servlets (`${jobs}`, `${user}`, `${profile}`) and renders semantic HTML. It never executes raw SQL or instantiates database connections.
2. **Controller Layer (Java Servlets):** Traffic director. Intercepts incoming HTTP requests, checks session identity (`session.getAttribute("userId")`), performs defensive input validation, triggers DAO operations, and decides whether to forward to a JSP view or issue an HTTP redirect.
3. **Model Layer (POJOs / DTOs):** Encapsulated Java classes representing business entities (`User`, `Job`, `Application`, `JobSeekerProfile`, `RecruiterProfile`) and joined Data Transfer Objects (`ApplicationItem`, `RecruiterApplicantItem`).
4. **Data Access Layer (DAO Pattern):** Isolates all JDBC code. Contains SQL queries, parameter binding, `try-with-resources` connection handling, and result set mapping into Java objects.
5. **Utility Layer (`util` package):** Reusable singleton/static helpers: `DBConnection` (database configuration & connection pooling interface), `PasswordUtil` (PBKDF2 cryptographic hashing), and `HtmlUtil` (XSS sanitization).

---

## 6. Important Files / Classes

### Controller Package (`controller`)
- `AuthenticationFilter.java`: Servlet Filter mapped to `/jobseeker/*` and `/recruiter/*`. Blocks unauthenticated traffic, redirects guests to `/login.jsp`, and enforces strict Role-Based Access Control (RBAC) by returning HTTP 403 Forbidden on role mismatch.
- `RegisterServlet.java` (`/register`): Manages registration. Validates input, verifies email uniqueness, hashes passwords via PBKDF2, and executes a multi-table database transaction (`users` + profile) with `conn.setAutoCommit(false)`, `commit()`, and `rollback()`.
- `LoginServlet.java` (`/login`): Verifies credentials against salted PBKDF2 hashes, destroys existing sessions to prevent session fixation attacks, provisions fresh `HttpSession` attributes (`userId`, `name`, `role`), and routes to the dashboard.
- `LogoutServlet.java` (`/logout`): Invalidates the active `HttpSession` and redirects to `login.jsp`.
- `ProfileServlet.java` (`/jobseeker/profile`): Reads the authenticated user's ID strictly from session, queries `UserDAO` and `ProfileDAO`, sanitizes user credentials by stripping password hashes, and forwards to `profile.jsp`.
- `UpdateJobSeekerProfileServlet.java` (`/jobseeker/profile/edit`, `/jobseeker/profile/update`): Loads and updates the job seeker's contact info, skills, education, and experience.
- `JobSearchServlet.java` (`/jobseeker/search-jobs`): Extracts filter query parameters (`keyword`, `skills`, `location`), executes dynamic SQL queries in `JobDAO`, and re-populates search fields for seamless UX.
- `JobDetailsServlet.java` (`/jobseeker/job-details`): Validates the numeric `id` query parameter, loads job specifications, and calls `ApplicationDAO.hasApplied()` to toggle the UI between "Apply Now" and "Already Applied".
- `ApplyJobServlet.java` (`/jobseeker/apply`): Accepts `POST` job applications, derives `jobseekerId` from session, conducts two-tier duplicate verification, persists the application record, and redirects back via PRG.
- `MyApplicationsServlet.java` (`/jobseeker/applications`): Loads all applications submitted by the logged-in candidate with joined job titles and company data in a single SQL query.
- `PostJobServlet.java` (`/recruiter/post-job`): Handles recruiter job creation with input length validation and PRG redirection.
- `ManageJobsServlet.java` (`/recruiter/manage-jobs`): Displays all active job listings posted by the logged-in recruiter.
- `EditJobServlet.java` (`/recruiter/edit-job`): Loads job edit forms and updates vacancies, strictly validating that the job belongs to the authenticated recruiter (`recruiterId`).
- `DeleteJobServlet.java` (`/recruiter/delete-job`): Accepts `POST` requests to delete a job opening. Blocks `GET` requests with HTTP 405 Method Not Allowed to prevent CSRF link attacks, and relies on MySQL `ON DELETE CASCADE` to clean up related applications.
- `RecruiterApplicantsServlet.java` (`/recruiter/applicants`): Displays candidate applications across all posted jobs or filtered by a specific `jobId` dropdown, ensuring cross-recruiter data isolation.
- `UpdateApplicationStatusServlet.java` (`/recruiter/update-application-status`): State machine controller executing status updates (`APPLIED` $\rightarrow$ `UNDER_REVIEW` $\rightarrow$ `SHORTLISTED` / `REJECTED`) using joined SQL update queries.

### DAO Package (`dao`)
- `UserDAO.java`: Performs CRUD on `users`. Includes overloaded `createUser(conn, user)` for transaction participation, `getUserByEmail(email)`, and `emailExists(email)`.
- `JobDAO.java`: Performs CRUD on `jobs`. Features `searchJobs(keyword, skills, location)` with dynamic `StringBuilder` SQL construction, and ownership-enforcing methods `getJobByIdAndRecruiterId()`, `updateJob()`, and `deleteJob()`.
- `ApplicationDAO.java`: Manages the `applications` table. Features multi-table joins (`getApplicationsByJobseekerId()`, `getApplicantsByRecruiterId()`), constraint checking (`hasApplied()`), and status mutation with recruiter ownership verification (`updateApplicationStatus()`).
- `ProfileDAO.java`: Manages `jobseeker_profile` and `recruiter_profile` tables with fallback upsert logic.

### Model Package (`model`)
- `User.java`: Entity representing an account (`id`, `name`, `email`, `password`, `role`, `createdAt`).
- `Job.java`: Entity representing a vacancy (`id`, `recruiterId`, `title`, `description`, `skills`, `location`, `createdAt`).
- `Application.java`: Entity representing an application link (`id`, `jobId`, `jobseekerId`, `status`, `appliedAt`).
- `JobSeekerProfile.java`: Candidate profile attributes (`userId`, `phone`, `skills`, `education`, `experience`, `location`).
- `RecruiterProfile.java`: Recruiter company profile (`userId`, `companyName`, `phone`, `location`, `description`).
- `ApplicationItem.java`: DTO joining `Application` fields with `Job` title, location, and description to eliminate N+1 queries.
- `RecruiterApplicantItem.java`: DTO joining `Application`, candidate `User`, candidate `JobSeekerProfile`, and `Job` attributes for the recruiter candidate dashboard.

### Utility Package (`util`)
- `DBConnection.java`: Reads `db.properties` via `ClassLoader.getResourceAsStream()`. Manages JDBC connection lifecycle, provides connection overriding hooks for testing, and handles environment variables.
- `PasswordUtil.java`: Implements PBKDF2WithHmacSHA256 password hashing (16-byte random salt, 65,536 iterations, Base64 encoding) and constant-time equality checks (`MessageDigest.isEqual`) against timing attacks.
- `HtmlUtil.java`: Static XSS sanitization helper replacing `&`, `<`, `>`, `"`, and `'` with HTML entity equivalents.

---

## 7. Database Structure

The database `job_portal_db` is normalized in 3NF and enforces relational integrity via InnoDB foreign keys.

```
       +-----------------------+
       |         users         |
       +-----------------------+
       | PK  id                |<------------+
       |     name              |             |
       | UQ  email             |             |
       |     password          |             |
       |     role              |             |
       |     created_at        |             |
       +-----------+-----------+             |
                   | 1                       |
                   |                         |
         +---------+---------+               |
         | 1                 | 1             |
         v                   v               |
+-------------------+ +-------------------+  |
| jobseeker_profile | | recruiter_profile |  |
+-------------------+ +-------------------+  |
| PK  id            | | PK  id            |  |
| FK  user_id (UQ)  | | FK  user_id (UQ)  |  |
|     phone         | |     company_name  |  |
|     skills        | |     phone         |  |
|     education     | |     location      |  |
|     experience    | |     description   |  |
|     location      | +-------------------+  |
+-------------------+                        |
                                             |
         +-----------------------------------+
         | 1 (recruiter_id)
         v
+-------------------+
|       jobs        |
+-------------------+
| PK  id            |<------------+
| FK  recruiter_id  |             |
|     title         |             |
|     description   |             |
|     skills        |             |
|     location      |             |
|     created_at    |             |
+---------+---------+             |
          | 1                     |
          |                       |
          v                       |
+-------------------+             |
|   applications    |             |
+-------------------+             |
| PK  id            |             |
| FK  job_id        |-------------+
| FK  jobseeker_id  |------------> (FK to users.id)
|     status        |
|     applied_at    |
| UQ(job_id,        |
|    jobseeker_id)  |
+-------------------+
```

### Table Definitions & Roles

1. **`users` Table:**
   - `id INT AUTO_INCREMENT PRIMARY KEY`: Unique user identifier.
   - `name VARCHAR(100) NOT NULL`: Full name of person or contact.
   - `email VARCHAR(150) NOT NULL UNIQUE`: Login email identity.
   - `password VARCHAR(255) NOT NULL`: Salted PBKDF2 hash string (`algorithm:iterations:salt:hash`).
   - `role VARCHAR(20) NOT NULL`: Access role (`JOB_SEEKER` or `RECRUITER`).
   - `created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP`: Account registration timestamp.

2. **`jobseeker_profile` Table:**
   - `id INT AUTO_INCREMENT PRIMARY KEY`.
   - `user_id INT NOT NULL UNIQUE`: Foreign key referencing `users(id)` with `ON DELETE CASCADE`.
   - `phone VARCHAR(20)`, `skills VARCHAR(500)`, `education VARCHAR(255)`, `experience VARCHAR(255)`, `location VARCHAR(100)`.

3. **`recruiter_profile` Table:**
   - `id INT AUTO_INCREMENT PRIMARY KEY`.
   - `user_id INT NOT NULL UNIQUE`: Foreign key referencing `users(id)` with `ON DELETE CASCADE`.
   - `company_name VARCHAR(150) NOT NULL`: Hiring organization brand name.
   - `phone VARCHAR(20)`, `location VARCHAR(100)`, `description TEXT`.

4. **`jobs` Table:**
   - `id INT AUTO_INCREMENT PRIMARY KEY`.
   - `recruiter_id INT NOT NULL`: Foreign key referencing `users(id)` with `ON DELETE CASCADE`.
   - `title VARCHAR(150) NOT NULL`, `description TEXT NOT NULL`, `skills VARCHAR(500) NOT NULL`, `location VARCHAR(100) NOT NULL`.
   - `created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP`.

5. **`applications` Table:**
   - `id INT AUTO_INCREMENT PRIMARY KEY`.
   - `job_id INT NOT NULL`: Foreign key referencing `jobs(id)` with `ON DELETE CASCADE`.
   - `jobseeker_id INT NOT NULL`: Foreign key referencing `users(id)` with `ON DELETE CASCADE`.
   - `status VARCHAR(30) NOT NULL DEFAULT 'APPLIED'`: Status pipeline string (`APPLIED`, `UNDER_REVIEW`, `SHORTLISTED`, `REJECTED`).
   - `applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP`.
   - `CONSTRAINT uk_job_jobseeker UNIQUE (job_id, jobseeker_id)`: **Database-level composite unique constraint preventing duplicate applications.**

---

## 8. Complete Website Page Breakdown

### Page 1: Landing / Homepage
- **Route / URL:** `/JobPortal/` or `/JobPortal/index.jsp`
- **Purpose:** Public portal showcase and intelligent role-aware navigation hub.
- **What the user sees:**
  - Header with branding ("💼 Syntra Job Portal") and contextual navigation links.
  - Hero banner with headline: *"Connecting Ambition with Opportunity"*.
  - Call-to-action buttons ("Find Your Next Role", "Post Vacancies").
  - Feature overview grid explaining candidate profiles, instant applications, and recruiter candidate management.
  - Active session detection: If logged in, greets user by name with a colored role badge (`badge-jobseeker` or `badge-recruiter`) and direct links to their role-specific dashboard.
- **Backend Logic:** Reads `request.getSession(false)` and conditionally renders navigation items.
- **Database Interaction:** None directly (reads session memory).

### Page 2: User Registration
- **Route / URL:** `/JobPortal/register.jsp` (GET) $\rightarrow$ `POST /JobPortal/register` (`RegisterServlet`)
- **Purpose:** Account creation for both Job Seekers and Recruiters with dynamic client/server validation.
- **What the user sees:**
  - Segmented card interface with step-by-step numbering.
  - Interactive radio cards to toggle between "Job Seeker" and "Recruiter".
  - Common credentials: Full Name, Email Address, Password (with minimum 6-character hint).
  - Dynamic profile section toggled by JavaScript:
    - *If Job Seeker:* Phone, City/Location, Key Skills (comma-separated), Highest Education, Experience Level.
    - *If Recruiter:* Company/Organization Name (required), Contact Phone, Company Location, Company Description.
  - Real-time client-side error notifications and server-side flash error banners.
- **Backend Logic:** `RegisterServlet.doPost()` validates regex patterns, hashes password with PBKDF2, opens JDBC connection, turns off auto-commit (`conn.setAutoCommit(false)`), inserts user into `users`, captures generated ID via `getGeneratedKeys()`, inserts role profile into `jobseeker_profile` or `recruiter_profile`, commits the transaction (`conn.commit()`), and forwards to `login.jsp` with a success alert.
- **Database Interaction:** `INSERT INTO users`, then `INSERT INTO jobseeker_profile` or `recruiter_profile` in an atomic transaction.

### Page 3: User Login
- **Route / URL:** `/JobPortal/login.jsp` (GET) $\rightarrow$ `POST /JobPortal/login` (`LoginServlet`)
- **Purpose:** Authenticates users and establishes secure sessions.
- **What the user sees:**
  - Sleek card with email and password inputs.
  - Server-side error alert for invalid credentials (generic message to avoid email enumeration).
  - Success message banner when redirected from successful registration.
  - Session detection banner if an active session is already present, offering "Return to Dashboard" or "Sign Out".
- **Backend Logic:** `LoginServlet.doPost()` sanitizes email, calls `userDAO.getUserByEmail()`, verifies PBKDF2 hash via `PasswordUtil.verifyPassword()`, calls `oldSession.invalidate()` (session fixation defense), provisions `request.getSession(true)`, stores `userId`, `name`, and `role`, then redirects to `index.jsp`.
- **Database Interaction:** `SELECT ... FROM users WHERE email = ?`.

### Page 4: Job Seeker Dashboard
- **Route / URL:** `/JobPortal/jobseeker/dashboard.jsp`
- **Purpose:** Command center for authenticated job seekers.
- **What the user sees:**
  - Ambient glowing hero banner: *"Welcome, [Name]!"* with quick action shortcuts.
  - 3 Action Cards:
    1. **My Profile:** View/edit contact details, skills, education, and experience.
    2. **Search Jobs:** Browse open vacancies filtered by skills and location.
    3. **My Applications:** Track submitted application statuses in real-time.
  - Informative lifecycle guide card explaining status transitions (`Applied` $\rightarrow$ `Under Review` $\rightarrow$ `Shortlisted` / `Rejected`).
- **Backend Logic:** Protected by `AuthenticationFilter`. Sanitizes output with `HtmlUtil.escape()`.
- **Database Interaction:** None directly.

### Page 5: Job Seeker Profile View & Edit
- **Route / URL:**
  - View: `/JobPortal/jobseeker/profile` (`ProfileServlet`) $\rightarrow$ `profile.jsp`
  - Edit: `/JobPortal/jobseeker/profile/edit` (`UpdateJobSeekerProfileServlet`) $\rightarrow$ `edit-profile.jsp`
  - Update Action: `POST /JobPortal/jobseeker/profile/update`
- **Purpose:** Review and update candidate personal and professional qualifications.
- **What the user sees:**
  - Profile summary: Full name, account email, phone, location, education, experience, and key skill badges.
  - Edit Form: Text inputs pre-populated with existing database values; validation bounds for phone formatting and string length limits.
- **Backend Logic:** `ProfileServlet` pulls `userId` strictly from session. Omits password hash before passing the `User` object to the JSP. `UpdateJobSeekerProfileServlet` validates inputs and executes `profileDAO.updateJobSeekerProfile()`.
- **Database Interaction:**
  - `SELECT ... FROM users WHERE id = ?`
  - `SELECT ... FROM jobseeker_profile WHERE user_id = ?`
  - `UPDATE jobseeker_profile SET phone=?, skills=?, education=?, experience=?, location=? WHERE user_id=?`

### Page 6: Job Search & Filtering
- **Route / URL:** `/JobPortal/jobseeker/search-jobs` (`JobSearchServlet`) $\rightarrow$ `search-jobs.jsp`
- **Purpose:** Search and discover job openings matching specific criteria.
- **What the user sees:**
  - Search bar card with 3 filter inputs: **Keyword** (title/description), **Skills** (comma-separated), and **Location**.
  - "Search Jobs" primary button and "Clear Filters" reset button.
  - Results count badge (`e.g., Found 5 Opportunities`).
  - Grid of job cards showing job title, location badge, posting date, required skill tags, a short description snippet, and a "View Details & Apply $\rightarrow$" button.
  - Clean empty state with search advice if no jobs match.
- **Backend Logic:** `JobSearchServlet` reads parameters, delegates to `JobDAO.searchJobs()`, which tokenizes skills (splitting by comma into multiple `skills LIKE ?` conditions) and dynamically constructs parameterized SQL.
- **Database Interaction:**
  - `SELECT ... FROM jobs WHERE (title LIKE ? OR description LIKE ? OR skills LIKE ?) AND (skills LIKE ? OR skills LIKE ?) AND location LIKE ? ORDER BY created_at DESC`.

### Page 7: Job Details & Application Submission
- **Route / URL:**
  - View: `/JobPortal/jobseeker/job-details?id=<jobId>` (`JobDetailsServlet`) $\rightarrow$ `job-details.jsp`
  - Submit: `POST /JobPortal/jobseeker/apply` (`ApplyJobServlet`)
- **Purpose:** Full job specification inspection and one-click application submission.
- **What the user sees:**
  - Full job title, location, posted date, required skill badges, and formatted description.
  - Dynamic Action Section:
    - *If Not Applied:* Big prominent button: **"🚀 Apply for Job"**.
    - *If Already Applied:* Disabled badge: **"✓ Already Applied"** with a direct link to track it in "My Applications".
  - Flash message alerts confirming submission or explaining errors.
- **Backend Logic:**
  - `JobDetailsServlet`: Validates numeric ID, loads job, checks `applicationDAO.hasApplied(jobId, userId)`.
  - `ApplyJobServlet`: Checks session, verifies job existence, re-checks duplicate status, executes `applicationDAO.createApplication()`, catches duplicate key violations gracefully, sets flash message in session, and redirects back to `job-details?id=<jobId>` (PRG pattern).
- **Database Interaction:**
  - `SELECT ... FROM jobs WHERE id = ?`
  - `SELECT COUNT(*) FROM applications WHERE job_id = ? AND jobseeker_id = ?`
  - `INSERT INTO applications (job_id, jobseeker_id, status) VALUES (?, ?, 'APPLIED')`

### Page 8: My Applications Tracking
- **Route / URL:** `/JobPortal/jobseeker/applications` (`MyApplicationsServlet`) $\rightarrow$ `applications.jsp`
- **Purpose:** Real-time tracking of candidate applications and recruiter responses.
- **What the user sees:**
  - List of application cards with job title, location, date applied, and formatted status pill:
    - `Applied` (Blue soft glow)
    - `Under Review` (Amber glow)
    - `Shortlisted` (Emerald green glow)
    - `Rejected` (Rose red glow)
  - Quick link to view original job details.
  - Empty state encouraging user to search for jobs if no applications exist.
- **Backend Logic:** `MyApplicationsServlet` calls `applicationDAO.getApplicationsByJobseekerId(userId)` which performs an `INNER JOIN` between `applications` and `jobs` in a single query.
- **Database Interaction:**
  - `SELECT a.id, a.job_id, a.jobseeker_id, a.status, a.applied_at, j.title, j.description, j.skills, j.location, j.created_at FROM applications a INNER JOIN jobs j ON a.job_id = j.id WHERE a.jobseeker_id = ? ORDER BY a.applied_at DESC`.

### Page 9: Recruiter Dashboard
- **Route / URL:** `/JobPortal/recruiter/dashboard.jsp`
- **Purpose:** Centralized operational overview for recruiters.
- **What the user sees:**
  - Greeting banner with quick link to **"➕ Post a Job Opening"**.
  - Company overview card displaying registered company name, contact phone, headquarters, and organization bio with an "Edit Details" shortcut.
  - 4 Main Action Cards:
    1. **Company Profile:** Update corporate information and recruiter contact.
    2. **Post a Job Opening:** Publish new career vacancies.
    3. **Manage Job Postings:** List, edit, and delete active postings.
    4. **Applicant Dashboard:** Review candidate submissions and progress applicants.
- **Backend Logic:** Protected by `AuthenticationFilter` (verifies role `RECRUITER`). Fetches `RecruiterProfile` for summary rendering.
- **Database Interaction:** `SELECT ... FROM recruiter_profile WHERE user_id = ?`.

### Page 10: Recruiter Company Profile View & Edit
- **Route / URL:**
  - View: `/JobPortal/recruiter/profile` (`RecruiterProfileServlet`) $\rightarrow$ `profile.jsp`
  - Edit: `/JobPortal/recruiter/profile/edit` (`UpdateRecruiterProfileServlet`) $\rightarrow$ `edit-profile.jsp`
  - Update Action: `POST /JobPortal/recruiter/profile/update`
- **Purpose:** Manage hiring company identity, phone, address, and overview.
- **What the user sees:** Company name, contact number, headquarters location, and narrative description. Edit form validates required fields and length limits.
- **Backend Logic:** Reads `recruiterId` strictly from session. Validates phone regex and updates database via `ProfileDAO`.
- **Database Interaction:** `UPDATE recruiter_profile SET company_name=?, phone=?, location=?, description=? WHERE user_id=?`.

### Page 11: Post a Job Opening
- **Route / URL:** `/JobPortal/recruiter/post-job` (`PostJobServlet`) $\rightarrow$ `post-job.jsp`
- **Purpose:** Create and publish new career vacancies.
- **What the user sees:**
  - Form fields: Job Title (`VARCHAR(150)`), Required Skills (`VARCHAR(500)`), Job Location (`VARCHAR(100)`), Detailed Description (`TEXT`).
  - Validation hints and required asterisks.
  - Flash error banners preserving submitted inputs upon failure.
- **Backend Logic:** `PostJobServlet.doPost()` verifies recruiter session, validates string lengths, creates `Job` object with `recruiterId`, calls `jobDAO.createJob()`, sets flash success message, and redirects to `/recruiter/manage-jobs`.
- **Database Interaction:** `INSERT INTO jobs (recruiter_id, title, description, skills, location) VALUES (?, ?, ?, ?, ?)`.

### Page 12: Manage Job Postings
- **Route / URL:** `/JobPortal/recruiter/manage-jobs` (`ManageJobsServlet`) $\rightarrow$ `manage-jobs.jsp`
- **Purpose:** List, edit, or delete vacancies published by the authenticated recruiter.
- **What the user sees:**
  - List of recruiter's posted jobs with posting date, location, required skill tags, and full description snippet.
  - Action buttons per card:
    - **"✏️ Edit Vacancy"** (navigates to `/recruiter/edit-job?id=X`).
    - **"🗑️ Delete Vacancy"** (triggers a confirmation dialog and submits a `POST` form to `/recruiter/delete-job`).
    - **"👥 View Applicants"** (deep link to `/recruiter/applicants?jobId=X`).
  - Empty state with "Post your first job" CTA if none exist.
- **Backend Logic:** `ManageJobsServlet` extracts `recruiterId` from session and queries `jobDAO.getJobsByRecruiterId(recruiterId)`, preventing cross-recruiter leakage.
- **Database Interaction:** `SELECT ... FROM jobs WHERE recruiter_id = ? ORDER BY created_at DESC`.

### Page 13: Edit Job Opening
- **Route / URL:** `/JobPortal/recruiter/edit-job?id=<jobId>` (`EditJobServlet`) $\rightarrow$ `edit-job.jsp` (GET & POST)
- **Purpose:** Update existing vacancy details while enforcing ownership.
- **What the user sees:** Form pre-loaded with current job data (title, skills, location, description).
- **Backend Logic:** `EditJobServlet` parses `id`, validates ownership using `jobDAO.getJobByIdAndRecruiterId(jobId, recruiterId)`. If unauthorized, redirects with an error banner. On POST, executes `jobDAO.updateJob()`.
- **Database Interaction:**
  - `SELECT ... FROM jobs WHERE id = ? AND recruiter_id = ?`
  - `UPDATE jobs SET title=?, description=?, skills=?, location=? WHERE id=? AND recruiter_id=?`

### Page 14: Recruiter Applicant Dashboard & Status State Machine
- **Route / URL:**
  - Dashboard: `/JobPortal/recruiter/applicants` (`RecruiterApplicantsServlet`) $\rightarrow$ `applicants.jsp`
  - Filter by Job: `/JobPortal/recruiter/applicants?jobId=<jobId>`
  - Status Update Action: `POST /JobPortal/recruiter/update-application-status` (`UpdateApplicationStatusServlet`)
- **Purpose:** Review applicant resumes and transition candidates through the hiring pipeline.
- **What the user sees:**
  - Job filter dropdown selector allowing the recruiter to filter applicants across "All Posted Jobs" or isolate a specific opening.
  - Candidate profile cards showing: Applicant Name, Target Job Title, Location, Email (clickable `mailto:`), Phone, Education, Experience, Applied Date, and Skill Badges.
  - Status Badge (`Applied`, `Under Review`, `Shortlisted`, `Rejected`).
  - **Dynamic State-Machine Action Buttons:**
    - *If status is `Applied`:* Shows **"🔍 Move to Under Review"**.
    - *If status is `Under Review`:* Shows **"🌟 Shortlist Candidate"** (green) and **"❌ Reject Application"** (red).
    - *If status is `Shortlisted` or `Rejected`:* Shows terminal status indicator ("Terminal Stage Reached — Review Completed").
- **Backend Logic:**
  - `RecruiterApplicantsServlet`: Validates recruiter identity, queries `ApplicationDAO` joining `applications`, `jobs`, `users`, and `jobseeker_profile` in one query.
  - `UpdateApplicationStatusServlet`: Checks that application belongs to a job posted by the recruiter, validates allowed transitions via server-side finite state machine logic, executes an `UPDATE ... INNER JOIN` in SQL, and redirects back via PRG.
- **Database Interaction:**
  - 4-Table Join: `SELECT ... FROM applications a INNER JOIN jobs j ON a.job_id = j.id INNER JOIN users u ON a.jobseeker_id = u.id LEFT JOIN jobseeker_profile jp ON jp.user_id = u.id WHERE j.recruiter_id = ? ORDER BY a.applied_at DESC`
  - Status Mutation: `UPDATE applications a INNER JOIN jobs j ON a.job_id = j.id SET a.status = ? WHERE a.id = ? AND j.recruiter_id = ?`

---

## 9. User Workflow

```
[ GUEST / ANONYMOUS USER ]
   |
   +---> Visit Landing Page (/)
   |
   +---> Register (/register.jsp)
   |        |
   |        +---> Select "Job Seeker" ---> Creates account + Job Seeker Profile
   |        |
   |        +---> Select "Recruiter"  ---> Creates account + Recruiter Profile
   |
   +---> Login (/login.jsp) ---> Authenticates via PBKDF2 ---> Session created with Role
            |
            |-- (Role: JOB_SEEKER)
            |      |
            |      +---> Job Seeker Dashboard (/jobseeker/dashboard.jsp)
            |      +---> Update Profile (/jobseeker/profile)
            |      +---> Search Jobs (/jobseeker/search-jobs)
            |      +---> View Job Details (/jobseeker/job-details?id=X)
            |      +---> Apply for Job (POST /jobseeker/apply)
            |      +---> Track Applications & Status (/jobseeker/applications)
            |      +---> Logout (POST /logout)
            |
            |-- (Role: RECRUITER)
                   |
                   +---> Recruiter Dashboard (/recruiter/dashboard.jsp)
                   +---> Update Company Profile (/recruiter/profile)
                   +---> Post New Job Opening (/recruiter/post-job)
                   +---> Manage Active Vacancies (/recruiter/manage-jobs)
                   |        +---> Edit Job (/recruiter/edit-job?id=X)
                   |        +---> Delete Job (POST /recruiter/delete-job)
                   +---> Review Applicants & Filter by Job (/recruiter/applicants)
                   +---> Advance Pipeline (POST /recruiter/update-application-status)
                            |-- Move "Applied" -> "Under Review"
                            |-- Move "Under Review" -> "Shortlisted" or "Rejected"
                   +---> Logout (POST /logout)
```

---

## 10. Recommended Teacher Demo Sequence

Follow this exact 10-step sequence during your presentation to demonstrate the complete, bidirectional interaction between Job Seeker and Recruiter.

### Step 1: Landing Page & Architecture Intro
- **Page to Open:** `http://localhost:8080/JobPortal/`
- **What to Click / Show:** Show the Syntra dark-tech design, responsive navbar, feature cards, and clean typography.
- **What to Say:** *"Respected teachers, this is the Syntra Job Portal, a full-stack web application built using Jakarta Servlets, JSP, JDBC, and MySQL running on Apache Tomcat 11. It implements a layered MVC architecture with strict role-based authorization."*
- **Technical Concept to Highlight:** Layered MVC architecture; Separation of Concerns between presentation (JSP) and business logic (Servlets).

### Step 2: Role-Based Registration & Transaction Management
- **Page to Open:** Click **"Register"** in navbar (`/JobPortal/register.jsp`).
- **What to Click / Show:**
  - Click the **"Recruiter"** radio card. Point out how the form dynamically switches to reveal "Company Name" and organization bio.
  - Switch back to **"Job Seeker"** to show skill tags, education, and experience fields.
  - Fill in candidate registration:
    - Name: `Demo Candidate`
    - Email: `demo.candidate@example.com`
    - Password: `Password@123`
    - Phone: `+91 9876500001`
    - Location: `Mumbai, Maharashtra`
    - Skills: `Java, JSP, Servlets, MySQL, Spring`
    - Education: `B.Tech Computer Science`
    - Experience: `Fresher`
  - Click **"Create Account"**.
- **What to Say:** *"When I submit this form, `RegisterServlet` coordinates a multi-table database transaction. It hashes the password using PBKDF2 with a cryptographic salt, inserts the record into the `users` table, retrieves the generated primary key, and inserts the profile into `jobseeker_profile` under a single atomic transaction using `conn.setAutoCommit(false)` and `conn.commit()`."*
- **Technical Concept to Highlight:** JDBC Transaction Management (`setAutoCommit`, `commit`, `rollback`); PBKDF2 Password Hashing.

### Step 3: Secure Login & Session Fixation Protection
- **Page to Open:** Redirected to `login.jsp` displaying green success banner.
- **What to Enter:**
  - Email: `demo.candidate@example.com`
  - Password: `Password@123`
  - Click **"Sign In"**.
- **What to Say:** *"On authentication, `LoginServlet` retrieves the user record, verifies the salted PBKDF2 hash using `MessageDigest.isEqual` to prevent timing attacks, invalidates any existing session token to defend against Session Fixation attacks, and creates a fresh session containing the user ID and role."*
- **Technical Concept to Highlight:** Password verification, Session Fixation Defense, and Session State Initialization.

### Step 4: Job Seeker Dashboard & Role Protection
- **Page to Open:** Land on `index.jsp` showing logged-in user banner, then click **"Dashboard"** (`/jobseeker/dashboard.jsp`).
- **What to Show:** The greeting banner, profile summary card, and lifecycle guide.
- **What to Say:** *"All pages under `/jobseeker/*` are intercepted by `AuthenticationFilter`. If an unauthenticated user or a user with the 'RECRUITER' role attempts to access this URL directly, the filter denies access and returns an HTTP 403 Forbidden error."*
- **Technical Concept to Highlight:** Servlet Filters (`jakarta.servlet.Filter`) and Role-Based Access Control (RBAC).

### Step 5: Multi-Criteria Job Search & Dynamic SQL
- **Page to Open:** Click **"Search Jobs"** in navbar (`/jobseeker/search-jobs`).
- **What to Enter & Click:**
  - Type `Java` in the **Skills** input or `Mumbai` in **Location**.
  - Click **"Search Jobs"**.
  - Show how the matching jobs appear instantly and the filter inputs stay populated.
- **What to Say:** *"The search feature in `JobSearchServlet` handles multi-field queries. In `JobDAO`, we parse comma-separated skills and dynamically assemble a parameterized SQL query with `PreparedStatement`, ensuring safe pattern matching with `LIKE` while fully preventing SQL injection."*
- **Technical Concept to Highlight:** Dynamic SQL generation with `PreparedStatement`; SQL Injection Prevention.

### Step 6: Job Details & Application Submission (PRG Pattern)
- **Page to Open:** Click **"View Details & Apply $\rightarrow$"** on a job (e.g. *Full Stack Web Developer*).
- **What to Show:** Full job requirements and the glowing **"🚀 Apply for Job"** button.
- **Action:** Click **"Apply for Job"**.
- **What Happens:** The page reloads with a green alert: *"Application submitted successfully"*, and the button changes to a disabled badge: *"✓ Already Applied"*. Refresh the browser page to prove that the form is NOT submitted twice.
- **What to Say:** *"Applying triggers `ApplyJobServlet`. It derives the candidate ID strictly from the active session, preventing Insecure Direct Object References (IDOR). It checks for duplicates in Java code and relies on a database unique constraint `uk_job_jobseeker(job_id, jobseeker_id)`. We use the Post-Redirect-Get pattern so refreshing the page does not re-submit the form."*
- **Technical Concept to Highlight:** Post/Redirect/Get (PRG) Pattern; Two-Tier Duplicate Prevention; Insecure Direct Object Reference (IDOR) Mitigation.

### Step 7: Application Tracking & Single-Query Joins
- **Page to Open:** Click **"My Applications"** in navbar (`/jobseeker/applications`).
- **What to Show:** The submitted application card displaying status badge `Applied`, submission timestamp, and job metadata.
- **What to Say:** *"In `ApplicationDAO`, we join the `applications` and `jobs` tables in a single query mapped to an `ApplicationItem` DTO, completely avoiding N+1 query performance problems."*
- **Technical Concept to Highlight:** Relational SQL `INNER JOIN`; Data Transfer Object (DTO) pattern; Elimination of N+1 query overhead.

### Step 8: Recruiter Persona Switch & Vacancy Management
- **Action:** Click **"Logout"** (POST to `/logout`), then login with the seeded recruiter account:
  - Email: `pixelarlabs@gmail.com`
  - Password: (or register/login as a recruiter account).
- **Page to Open:** `/recruiter/manage-jobs`.
- **What to Show:** Show active vacancies posted by this recruiter.
- **What to Say:** *"Now logged in as a Recruiter, `ManageJobsServlet` filters jobs strictly by the authenticated recruiter's ID (`WHERE recruiter_id = ?`). Even if another recruiter knows the URL, they cannot view, modify, or delete another company's listings."*
- **Technical Concept to Highlight:** Horizontal Privilege Separation; Multi-tenancy isolation.

### Step 9: Recruiter Applicant Dashboard & State Machine Transition
- **Page to Open:** Click **"Applicants"** in navbar (`/recruiter/applicants`).
- **What to Show:**
  - Notice the application submitted in Step 6 by `Demo Candidate`!
  - Point out candidate qualifications: Email, Phone, Location, Education, Experience, and Skill badges (`Java, JSP, Servlets...`).
  - Point out the status control bar displaying: **"🔍 Move to Under Review"**.
- **Action 1:** Click **"🔍 Move to Under Review"**.
  - Show the status pill turn Amber (`Under Review`).
  - Notice the action buttons dynamically change to **"🌟 Shortlist Candidate"** and **"❌ Reject Application"**!
- **Action 2:** Click **"🌟 Shortlist Candidate"**.
  - Show the status pill turn Green (`Shortlisted`).
  - Notice the buttons disappear and display: *"Terminal Stage Reached — Review Completed"*.
- **What to Say:** *"This demonstrates our hiring pipeline state machine implemented in `UpdateApplicationStatusServlet`. We enforce allowed state transitions on the server: an application cannot jump directly from Applied to Shortlisted, and once in a terminal state, it cannot be tampered with."*
- **Technical Concept to Highlight:** Finite State Machine (FSM) business logic; Multi-table `UPDATE ... INNER JOIN` in MySQL.

### Step 10: Cascade Deletion & Relational Cleanliness
- **Page to Open:** Navigate to **"Manage Jobs"** (`/recruiter/manage-jobs`).
- **Action:** Click **"🗑️ Delete Vacancy"** on a test job.
- **What to Say:** *"When a job vacancy is deleted, MySQL's `ON DELETE CASCADE` constraint automatically cleans up all associated application records in the database, preventing orphaned foreign keys and maintaining database integrity."*
- **Technical Concept to Highlight:** Referential Integrity and Foreign Key Cascades (`ON DELETE CASCADE`).

---

## 11. Important Java Concepts Used

| Concept | Location in Project | How It Is Implemented |
| :--- | :--- | :--- |
| **Object-Oriented Programming (OOP)** | Throughout `model`, `dao`, `controller` | Entities (`User`, `Job`, `Application`) encapsulate state with private attributes and public getters/setters. |
| **Encapsulation & Immutability** | `model` classes, `PasswordUtil`, `HtmlUtil` | Internal variables hidden; utility classes use private constructors to prevent instantiation. |
| **Inheritance & Polymorphism** | All Servlets (`controller/*`) | Every controller extends `jakarta.servlet.http.HttpServlet` and overrides `doGet()` and `doPost()` polymorphic methods. |
| **Interfaces & Abstraction** | `AuthenticationFilter`, `ConnectionSupplier` | Implements `jakarta.servlet.Filter` (`init`, `doFilter`, `destroy`); functional interface `ConnectionSupplier` in `DBConnection`. |
| **Java Collections Framework** | `dao` and `controller` | Heavy usage of `List<T>`, `ArrayList<T>`, `StringBuilder`, and type parameterization to handle query result sets. |
| **Exception Handling** | `dao`, `controller`, `util` | Structured `try-catch-finally` and `try-with-resources` managing `SQLException`, `NoSuchAlgorithmException`, `IOException`, and `NumberFormatException`. |
| **Resource Management (`AutoCloseable`)** | All DAO methods | Automatic closing of `Connection`, `PreparedStatement`, and `ResultSet` to prevent connection leaks. |
| **JDBC (Java Database Connectivity)** | `dao.*`, `util.DBConnection` | Low-level driver communication via `DriverManager.getConnection()`, `PreparedStatement`, `Statement.RETURN_GENERATED_KEYS`, and `ResultSet`. |
| **Transaction Management** | `RegisterServlet.java` | Manual transaction control: `conn.setAutoCommit(false)`, `conn.commit()`, and `conn.rollback()` inside catch blocks. |
| **Servlet Lifecycle & Architecture** | `controller.*` | Managed lifecycle: `init()` for DAO instantiation, `service()` routing to `doGet()`/`doPost()`, and container teardown. |
| **Servlet Filters & Interceptors** | `AuthenticationFilter.java` | Intercepts HTTP requests matching `/jobseeker/*` and `/recruiter/*` before reaching servlets to enforce authentication and RBAC. |
| **JSP & Dynamic Web Templating** | `src/main/webapp/**/*.jsp` | Server-Side Rendering (SSR) reading request attributes (`request.getAttribute()`), session objects, and scriptlets. |
| **Session Management & Security** | `LoginServlet`, `LogoutServlet` | `HttpSession` tracking with `getSession(false)`, session fixation defense via `session.invalidate()`, and 30-minute timeout in `web.xml`. |
| **Cryptography & Standard APIs** | `PasswordUtil.java` | PBKDF2 key derivation using `javax.crypto.SecretKeyFactory`, `PBEKeySpec`, and `SecureRandom`. |
| **Design Patterns** | Entire Codebase | **MVC Pattern**, **DAO Pattern**, **DTO / View-Model Pattern**, **Post/Redirect/Get (PRG) Pattern**, **Singleton-like DB Utility**. |

---

## 12. Complete Technical Request Flow

### Detailed Trace: Job Application Submission (`POST /jobseeker/apply`)

```
[ Browser: Click "Apply for Job" ]
        |
        | 1. HTTP POST /JobPortal/jobseeker/apply (Payload: jobId=1)
        v
[ Apache Tomcat 11: ProtocolHandler http-nio-8080 ]
        |
        | 2. Intercepted by AuthenticationFilter
        |    - Checks session.getAttribute("userId") != null
        |    - Checks session.getAttribute("role").equals("JOB_SEEKER")
        |    - Passes along FilterChain via chain.doFilter()
        v
[ ApplyJobServlet.doPost(request, response) ]
        |
        | 3. Parameter Parsing & Validation
        |    - Extracts jobseekerId strictly from session: (Integer) session.getAttribute("userId")
        |    - Parses request.getParameter("jobId") -> validates positive integer
        |
        | 4. Verification via JobDAO
        |    - Calls jobDAO.getJobById(jobId) -> confirms job is active
        |
        | 5. Application Duplicate Check (Layer 1)
        |    - Calls applicationDAO.hasApplied(jobId, jobseekerId)
        |    - Executes: SELECT COUNT(*) FROM applications WHERE job_id = ? AND jobseeker_id = ?
        |
        | 6. Database Insertion via ApplicationDAO
        |    - Prepares: INSERT INTO applications (job_id, jobseeker_id, status) VALUES (?, ?, 'APPLIED')
        |    - If concurrent thread bypasses Layer 1, MySQL unique key uk_job_jobseeker throws
        |      SQLIntegrityConstraintViolationException (Layer 2 defense)
        |
        | 7. Session Flash Messaging
        |    - session.setAttribute("successMessage", "Application submitted successfully.")
        |
        | 8. Post-Redirect-Get (PRG) Redirection
        |    - response.sendRedirect(contextPath + "/jobseeker/job-details?id=1")
        v
[ Browser: Issues fresh HTTP GET /JobPortal/jobseeker/job-details?id=1 ]
        v
[ JobDetailsServlet.doGet(request, response) ]
        |
        | 9. Consumes flash message from session -> places into request scope -> removes from session
        | 10. Calls applicationDAO.hasApplied(1, userId) -> returns TRUE
        | 11. Sets request.setAttribute("hasApplied", true)
        | 12. Forwards to /jobseeker/job-details.jsp
        v
[ job-details.jsp ]
        | 13. Reads hasApplied == true
        | 14. Renders Green Success Alert & Disabled "✓ Already Applied" button
        v
[ Browser displays updated UI ]
```

---

## 13. Top Features to Demonstrate

### 1. Two-Tier Application Deduplication with PRG Pattern
- **Why It's Technically Important:** Novice web apps suffer from "double-submit on refresh" and race conditions. This project implements a software check (`applicationDAO.hasApplied()`), a database constraint (`UNIQUE(job_id, jobseeker_id)`), and HTTP 302 redirection (Post/Redirect/Get) to guarantee idempotent submissions.

### 2. Multi-Table JDBC Transaction Management in Registration
- **Why It's Technically Important:** When registering a candidate or recruiter, data must be inserted into both `users` and a role-specific profile table (`jobseeker_profile` or `recruiter_profile`). `RegisterServlet` manages an explicit database transaction using `conn.setAutoCommit(false)`, `conn.commit()`, and `conn.rollback()`. If the profile fails, the user record is cleanly rolled back, preventing orphaned records.

### 3. Server-Enforced Hiring Pipeline State Machine
- **Why It's Technically Important:** Recruiters cannot arbitrarily assign statuses. `UpdateApplicationStatusServlet` enforces valid business lifecycle transitions (`APPLIED` $\rightarrow$ `UNDER_REVIEW` $\rightarrow$ `SHORTLISTED` / `REJECTED`). Terminal stages cannot be mutated, preventing unauthorized status manipulation.

### 4. Zero N+1 Queries via SQL Join DTOs
- **Why It's Technically Important:** A common beginner mistake in ORMs and JDBC is querying an entity and then looping through results with individual queries for related data. Syntra uses custom View-Model DTOs (`ApplicationItem`, `RecruiterApplicantItem`) populated by multi-table `INNER JOIN` and `LEFT JOIN` queries, fetching all related data in a single network round-trip.

### 5. Robust Security: PBKDF2 Password Hashing & IDOR Defense
- **Why It's Technically Important:** Passwords are never stored in plaintext or weak MD5/SHA-1; they use `PBKDF2WithHmacSHA256` with 65,536 iterations and unique 16-byte random salts. Furthermore, every servlet derives user identity strictly from `session.getAttribute("userId")`, never trusting user-manipulable URL parameters like `?userId=5`.

---

## 14. Strengths of the Project

1. **Pure Native Java Web Fundamentals:** Built without heavy abstractions (Spring, Hibernate), demonstrating a deep understanding of HTTP servlets, filters, and JDBC.
2. **Defensive Security Posture:**
   - **Password Security:** Salted PBKDF2 hashing.
   - **Timing Attack Resistance:** Constant-time hash comparison (`MessageDigest.isEqual`).
   - **Session Security:** Session fixation invalidation on login; strict 30-minute timeouts.
   - **Access Control:** Centralized filter-based RBAC rejecting horizontal and vertical privilege escalation.
   - **Injection Defense:** 100% parameterized `PreparedStatement` queries; custom `HtmlUtil` XSS escaping.
3. **Database Integrity & Normalization:** Fully normalized 3NF schema with foreign key constraints, `ON DELETE CASCADE` automated cleanup, and unique constraints.
4. **Premium UI/UX:** Syntra Dark-Tech design system with glassmorphism, responsive CSS grid/flexbox, and dynamic client-side JS validation.
5. **Clean Code Structure:** Clear separation into `controller`, `dao`, `model`, and `util` packages following standard enterprise conventions.

---

## 15. Current Limitations

1. **No In-Memory Connection Pool (HikariCP / DBCP):** The current `DBConnection` utility establishes a new physical database connection on each request instead of using a connection pool. Under high enterprise concurrency, this could increase database connection overhead.
2. **Resume Attachment Uploads:** Profiles currently capture candidate qualifications, education, and skills as text strings rather than parsing uploaded PDF/DOCX resume files via `jakarta.servlet.annotation.MultipartConfig`.
3. **Email / SMS Notifications:** Application status transitions update the database in real-time, but do not yet trigger asynchronous background emails (e.g. via JavaMail API) to notify applicants of status updates.
4. **Pagination for Large Result Sets:** Job search and applicant listings display all matching results on a single page with SQL `ORDER BY created_at DESC`, rather than using SQL `LIMIT` and `OFFSET` pagination.

---

## 16. Future Scope

1. **Connection Pooling Integration:** Incorporate HikariCP or Apache Commons DBCP to reuse existing database connections and maximize throughput.
2. **Resume Upload & Parsing:** Implement multipart file uploads storing PDF documents in AWS S3 or server disk, with automated skill extraction.
3. **Automated Asynchronous Email Notifications:** Integrate JavaMail API or SendGrid to send email notifications whenever an application status changes to *Under Review* or *Shortlisted*.
4. **Pagination & Server-Side Sorting:** Add dynamic pagination controls (`LIMIT ? OFFSET ?`) to handle thousands of active jobs seamlessly.
5. **Interview Scheduling Module:** Enable recruiters to schedule interview calendar slots and generate meeting links directly within the portal.

---

## 17. Likely Viva Questions & Answers

### Q1: Why did you build this project using pure Servlets and JSP instead of Spring Boot?
**Answer:** *"We chose native Jakarta Servlets, JSP, and JDBC intentionally to demonstrate foundational understanding of Java web architecture. Using Spring Boot hides the request-response lifecycle, session management, and low-level SQL execution behind annotations. By building this with raw Servlets and JDBC, we gained practical, hands-on experience with servlet containers, HTTP methods, connection lifecycles, and filter pipelines."*

### Q2: How does the frontend communicate with the backend?
**Answer:** *"Communication follows the standard HTTP protocol. The frontend (JSP with HTML forms and JavaScript) sends HTTP `GET` requests for page views/searches and `POST` requests for data mutations. The requests are intercepted by our `AuthenticationFilter`, routed to mapped `@WebServlet` classes, processed by DAOs via JDBC, and returned either by forwarding data objects to JSPs via `request.getRequestDispatcher().forward()` or redirecting via `response.sendRedirect()`."*

### Q3: Explain the role of the `AuthenticationFilter`.
**Answer:** *"The `AuthenticationFilter` implements `jakarta.servlet.Filter` and acts as a security gate for all URLs matching `/jobseeker/*` and `/recruiter/*`. It verifies that an active `HttpSession` exists with valid `userId` and `role` attributes. If an unauthorized guest accesses a protected page, it redirects them to `login.jsp`. If a user with the wrong role attempts to cross role boundaries, it returns an HTTP 403 Forbidden status."*

### Q4: How is database connectivity implemented and managed?
**Answer:** *"Database connectivity is centralized in `util.DBConnection`. It loads database configuration properties (`db.url`, `db.user`, `db.password`, `db.driver`) from `db.properties` using `ClassLoader.getResourceAsStream()`. DAOs call `DBConnection.getConnection()` to obtain a `java.sql.Connection`. All queries use `PreparedStatement` within `try-with-resources` blocks to guarantee that connections, statements, and result sets are closed automatically, preventing resource leaks."*

### Q5: What happens behind the scenes when a candidate applies for a job?
**Answer:** *"The form issues an HTTP `POST` to `/jobseeker/apply`. `ApplyJobServlet` extracts the candidate's `userId` strictly from the session to prevent IDOR attacks. It verifies the job exists and checks whether the candidate has already applied using `applicationDAO.hasApplied()`. If clear, it inserts a new row into `applications`. We also enforce this at the database level with a `UNIQUE(job_id, jobseeker_id)` constraint. Finally, it uses the Post-Redirect-Get pattern to redirect back to the job details page with a flash success message."*

### Q6: Where have you used Object-Oriented Programming (OOP) in this project?
**Answer:**
- *Encapsulation:* In model classes (`User`, `Job`, `Application`) with private fields and getter/setter accessors.
- *Inheritance:* All servlets inherit from `HttpServlet`, reusing its request dispatching infrastructure.
- *Polymorphism:* Overriding `doGet()` and `doPost()` in each servlet, and method overloading in `UserDAO.createUser()`.
- *Abstraction:* Decoupling data access logic behind Data Access Objects (DAOs) so controllers remain independent of specific SQL queries.

### Q7: How do you prevent SQL Injection and XSS attacks?
**Answer:** *"SQL Injection is prevented by using `PreparedStatement` with parameterized placeholders (`?`) for 100% of our SQL queries, ensuring user inputs are treated strictly as data literals rather than executable SQL code. Cross-Site Scripting (XSS) is mitigated using our `HtmlUtil.escape()` utility class, which converts special characters (`<`, `>`, `&`, `"`, `'`) to their corresponding HTML entities before rendering them in JSP views."*

### Q8: What is the Post/Redirect/Get (PRG) pattern and where is it used?
**Answer:** *"PRG is a web development design pattern that prevents duplicate form submissions when a user refreshes their browser. Instead of returning HTML directly from a `POST` request, the servlet performs the database modification, stores a temporary message in the session, and responds with an HTTP redirect (`response.sendRedirect()`) to a `GET` endpoint. We use PRG in `ApplyJobServlet`, `PostJobServlet`, `EditJobServlet`, `DeleteJobServlet`, and `UpdateApplicationStatusServlet`."*

### Q9: What is the N+1 query problem and how did you resolve it?
**Answer:** *"The N+1 problem occurs when an application queries a list of parent records (1 query) and then executes a separate query for each child record to fetch related details (N queries). In our 'My Applications' and 'Recruiter Applicants' modules, instead of looping through applications and querying user/job details individually, we wrote optimized multi-table `INNER JOIN` queries in `ApplicationDAO` that retrieve all required parent and child attributes in a single database round-trip, mapping them directly to DTOs."*

### Q10: How are passwords stored and verified?
**Answer:** *"Passwords are never stored in plaintext. In `PasswordUtil`, we use `PBKDF2WithHmacSHA256`, a salted, slow key derivation function recommended by NIST. When a user registers, we generate a cryptographically secure 16-byte random salt using `SecureRandom`, run 65,536 hash iterations, and store the output formatted as `algorithm:iterations:salt:hash`. On login, we re-compute the hash with the stored salt and use `MessageDigest.isEqual()` for constant-time comparison to guard against timing attacks."*

---

## 18. Important Technical Details ChatGPT Should Know

1. **Context Path:** The application deploys to the web context path `/JobPortal`. All internal redirects and asset URLs are dynamically prefixed with `${pageContext.request.contextPath}` to ensure portability.
2. **Session Attributes:**
   - `userId`: `Integer` (Primary key in `users` table).
   - `name`: `String` (User's display name).
   - `role`: `String` (`JOB_SEEKER` or `RECRUITER`).
   - `successMessage` / `errorMessage`: `String` (Temporary flash messages transferred from session to request scope and cleared immediately).
3. **Database Configuration:**
   - File: `src/main/resources/db.properties`.
   - Keys: `db.url=jdbc:mysql://localhost:3306/job_portal_db`, `db.user=root`, `db.driver=com.mysql.cj.jdbc.Driver`.
4. **Cascading Relational Deletions:**
   - `users` $\rightarrow$ `jobseeker_profile` (`ON DELETE CASCADE`)
   - `users` $\rightarrow$ `recruiter_profile` (`ON DELETE CASCADE`)
   - `users` $\rightarrow$ `jobs` (`ON DELETE CASCADE`)
   - `jobs` $\rightarrow$ `applications` (`ON DELETE CASCADE`)
   - `users` (job seeker) $\rightarrow$ `applications` (`ON DELETE CASCADE`)
5. **Seeded Test Credentials in Active Database:**
   - **Job Seeker 1:** `shreyas84524@gmail.com` (Name: Shreyas Shigwan)
   - **Job Seeker 2:** `rohitp@gmail.com` (Name: Rohit Prajapati)
   - **Recruiter 1:** `pixelarlabs@gmail.com` (Name: Pixelar)
   - **Recruiter 2:** `shivamsingh@tsecmumbai.in` (Name: Shivam Singh)
   - *Note:* New test accounts can be registered on-the-fly during the live demo via `/JobPortal/register.jsp`.
