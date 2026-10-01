# Job Portal System — Architecture Documentation

## 1. Project Overview

The **Job Portal System** is a web-based application developed as a Second Year Mini Project for **FSJP (Full Stack Java Programming)**.

The system provides a platform where:

* Job Seekers can create accounts, manage their profiles, search for jobs, apply for jobs, and track application status.
* Recruiters can create accounts, post job openings, manage their posted jobs, view applicants, and update application status.

The project is intentionally developed using core Java web technologies so that the complete request-response flow can be understood easily.

### Technology Stack

| Layer                          | Technology            |
| ------------------------------ | --------------------- |
| Frontend                       | HTML, CSS, JavaScript |
| View Layer                     | JSP                   |
| Controller Layer               | Java Servlets         |
| Data Access                    | JDBC                  |
| Database                       | MySQL                 |
| Web Server / Servlet Container | Apache Tomcat         |
| Build Tool                     | Maven                 |
| Development Assistant          | Antigravity           |

### Technologies NOT Used

The project should not use:

* Spring Boot
* Spring MVC
* Hibernate
* JPA
* React
* Angular
* Node.js
* Express.js
* Any ORM framework

The purpose is to demonstrate the use of **Servlets, JSP and JDBC** directly.

---

# 2. High-Level Architecture

The application follows a simple **MVC-inspired layered architecture**.

```text
                    +----------------------+
                    |       USER           |
                    | Job Seeker /         |
                    | Recruiter            |
                    +----------+-----------+
                               |
                               | HTTP Request
                               v
                    +----------------------+
                    |        JSP           |
                    |    Presentation      |
                    |       Layer         |
                    +----------+-----------+
                               |
                               | Request
                               v
                    +----------------------+
                    |    JAVA SERVLET      |
                    |   Controller Layer   |
                    +----------+-----------+
                               |
                               | Method Call
                               v
                    +----------------------+
                    |        DAO           |
                    |   Data Access Layer  |
                    +----------+-----------+
                               |
                               | JDBC
                               v
                    +----------------------+
                    |        MYSQL         |
                    |      Database        |
                    +----------------------+
```

The response follows the reverse direction:

```text
MySQL
  |
  v
DAO
  |
  v
Servlet
  |
  v
JSP
  |
  v
Browser
```

---

# 3. Architectural Pattern

The project uses a **layered MVC-inspired architecture**.

The main components are:

```text
Model
View
Controller
DAO
Database
```

### Model

Java classes representing application data.

Examples:

```text
User.java
Job.java
Application.java
JobSeekerProfile.java
RecruiterProfile.java
```

### View

JSP pages responsible for displaying information and collecting user input.

Examples:

```text
login.jsp
register.jsp
jobseeker/dashboard.jsp
recruiter/dashboard.jsp
search-jobs.jsp
applicants.jsp
```

### Controller

Servlets receive HTTP requests, validate input, call appropriate DAO methods and decide which JSP should be displayed.

Examples:

```text
LoginServlet.java
RegisterServlet.java
PostJobServlet.java
ApplyJobServlet.java
SearchJobServlet.java
UpdateApplicationServlet.java
LogoutServlet.java
```

### DAO

DAO stands for **Data Access Object**.

DAO classes contain database-related operations using JDBC.

Examples:

```text
UserDAO.java
JobDAO.java
ApplicationDAO.java
ProfileDAO.java
```

### Database

MySQL stores users, jobs, profiles and applications.

---

# 4. System Architecture

The complete system can be represented as:

```text
+------------------------------------------------------------+
|                        CLIENT                             |
|                                                            |
|              Web Browser                                  |
|          Chrome / Edge / Firefox                           |
+----------------------------+-------------------------------+
                             |
                             | HTTP / HTTPS
                             v
+------------------------------------------------------------+
|                     APACHE TOMCAT                         |
|                                                            |
|  +------------------------------------------------------+  |
|  |                    JSP LAYER                         |  |
|  |                                                      |  |
|  | login.jsp                                           |  |
|  | register.jsp                                        |  |
|  | dashboard.jsp                                       |  |
|  | search-jobs.jsp                                     |  |
|  | applicants.jsp                                      |  |
|  +-------------------------+----------------------------+  |
|                            |                               |
|                            v                               |
|  +------------------------------------------------------+  |
|  |                 SERVLET LAYER                       |  |
|  |                                                      |  |
|  | LoginServlet                                        |  |
|  | RegisterServlet                                     |  |
|  | PostJobServlet                                      |  |
|  | ApplyJobServlet                                     |  |
|  | SearchJobServlet                                    |  |
|  | UpdateApplicationServlet                             |  |
|  +-------------------------+----------------------------+  |
|                            |                               |
|                            v                               |
|  +------------------------------------------------------+  |
|  |                    DAO LAYER                        |  |
|  |                                                      |  |
|  | UserDAO                                             |  |
|  | JobDAO                                              |  |
|  | ApplicationDAO                                      |  |
|  | ProfileDAO                                          |  |
|  +-------------------------+----------------------------+  |
|                            |                               |
|                            v                               |
|  +------------------------------------------------------+  |
|  |                    JDBC                             |  |
|  |             Database Connectivity                   |  |
|  +-------------------------+----------------------------+  |
+----------------------------|-------------------------------+
                             |
                             v
+------------------------------------------------------------+
|                         MYSQL                              |
|                                                            |
|  users                                                     |
|  jobseeker_profile                                         |
|  recruiter_profile                                         |
|  jobs                                                      |
|  applications                                              |
|  saved_jobs                                                |
+------------------------------------------------------------+
```

---

# 5. Project Directory Structure

The recommended project structure is:

```text
JobPortal/
│
├── pom.xml
│
├── src/
│   └── main/
│       │
│       ├── java/
│       │   └── com/
│       │       └── jobportal/
│       │           │
│       │           ├── controller/
│       │           │   ├── LoginServlet.java
│       │           │   ├── RegisterServlet.java
│       │           │   ├── LogoutServlet.java
│       │           │   ├── PostJobServlet.java
│       │           │   ├── SearchJobServlet.java
│       │           │   ├── ApplyJobServlet.java
│       │           │   ├── UpdateApplicationServlet.java
│       │           │   └── ProfileServlet.java
│       │           │
│       │           ├── dao/
│       │           │   ├── UserDAO.java
│       │           │   ├── JobDAO.java
│       │           │   ├── ApplicationDAO.java
│       │           │   └── ProfileDAO.java
│       │           │
│       │           ├── model/
│       │           │   ├── User.java
│       │           │   ├── Job.java
│       │           │   ├── Application.java
│       │           │   ├── JobSeekerProfile.java
│       │           │   └── RecruiterProfile.java
│       │           │
│       │           └── util/
│       │               └── DBConnection.java
│       │
│       └── webapp/
│           │
│           ├── index.jsp
│           ├── login.jsp
│           ├── register.jsp
│           │
│           ├── css/
│           │   └── style.css
│           │
│           ├── js/
│           │   └── validation.js
│           │
│           ├── jobseeker/
│           │   ├── dashboard.jsp
│           │   ├── profile.jsp
│           │   ├── search-jobs.jsp
│           │   ├── job-details.jsp
│           │   └── my-applications.jsp
│           │
│           └── recruiter/
│               ├── dashboard.jsp
│               ├── profile.jsp
│               ├── post-job.jsp
│               ├── manage-jobs.jsp
│               └── applicants.jsp
│
└── README.md
```

---

# 6. Component Responsibilities

## 6.1 JSP — Presentation Layer

JSP pages are responsible for the user interface.

They should:

* Display data
* Collect user input
* Submit forms
* Display success/error messages
* Display job listings
* Display application information

JSP pages should **not contain complex database code**.

Example:

```text
login.jsp
```

contains:

```html
<form action="login" method="post">
```

The form sends the request to:

```text
LoginServlet
```

---

# 7. Servlet Layer

Servlets act as controllers.

Their responsibilities include:

1. Receive HTTP requests.
2. Read form parameters.
3. Validate input.
4. Check user session where required.
5. Call DAO methods.
6. Store results in request/session attributes.
7. Redirect or forward to JSP pages.

Example flow:

```text
login.jsp
     |
     | POST /login
     v
LoginServlet
     |
     | validate input
     v
UserDAO
     |
     | JDBC
     v
MySQL
     |
     | result
     v
LoginServlet
     |
     +---- success ---> Dashboard
     |
     +---- failure ---> login.jsp
```

---

# 8. DAO Layer

DAO classes isolate database operations from Servlets.

For example:

```text
UserDAO
```

may contain:

```text
registerUser()
loginUser()
getUserById()
updateUser()
```

`JobDAO` may contain:

```text
createJob()
getAllJobs()
searchJobs()
getJobById()
getJobsByRecruiter()
deleteJob()
```

`ApplicationDAO` may contain:

```text
applyForJob()
getApplicationsByJobSeeker()
getApplicantsByJob()
updateApplicationStatus()
hasAlreadyApplied()
```

This keeps SQL code out of the Servlet classes.

---

# 9. Model Layer

Model classes represent application entities.

## User

```text
User
-------------------
userId
name
email
password
role
```

## Job

```text
Job
-------------------
jobId
recruiterId
title
description
skillsRequired
location
salary
jobType
postedDate
```

## Application

```text
Application
-------------------
applicationId
jobId
jobSeekerId
applicationDate
status
```

Models should contain fields, constructors, getters and setters.

---

# 10. Database Architecture

The project uses MySQL.

Database name:

```text
jobportal
```

The primary tables are:

```text
users
jobseeker_profile
recruiter_profile
jobs
applications
saved_jobs
```

---

# 11. Entity Relationship Overview

The database relationship can be represented as:

```text
                    USERS
                      |
              +-------+-------+
              |               |
              v               v
       JOBSEEKER_PROFILE  RECRUITER_PROFILE
              |               |
              |               |
              v               v
        APPLICATIONS <------ JOBS
              |
              |
              v
          JOBS
```

More specifically:

```text
USER 1 -------- 1 JOBSEEKER_PROFILE

USER 1 -------- 1 RECRUITER_PROFILE

RECRUITER 1 -------- N JOBS

JOBSEEKER 1 -------- N APPLICATIONS

JOB 1 -------- N APPLICATIONS
```

---

# 12. Database Tables

## 12.1 users

Stores login and basic account information.

```text
users
--------------------------------
user_id          PRIMARY KEY
name
email            UNIQUE
password
role
```

Possible roles:

```text
JOBSEEKER
RECRUITER
```

---

## 12.2 jobseeker_profile

Stores additional information about job seekers.

```text
jobseeker_profile
--------------------------------
profile_id       PRIMARY KEY
user_id          FOREIGN KEY
phone
education
skills
experience
resume
```

---

## 12.3 recruiter_profile

Stores recruiter/company information.

```text
recruiter_profile
--------------------------------
recruiter_id     PRIMARY KEY
user_id          FOREIGN KEY
company_name
company_description
company_location
```

---

## 12.4 jobs

Stores job advertisements.

```text
jobs
--------------------------------
job_id           PRIMARY KEY
recruiter_id     FOREIGN KEY
title
description
skills_required
location
salary
job_type
posted_date
```

---

## 12.5 applications

Stores job applications.

```text
applications
--------------------------------
application_id   PRIMARY KEY
job_id           FOREIGN KEY
jobseeker_id     FOREIGN KEY
application_date
status
```

Possible statuses:

```text
APPLIED
UNDER_REVIEW
SHORTLISTED
REJECTED
```

---

## 12.6 saved_jobs

Stores jobs saved by job seekers.

```text
saved_jobs
--------------------------------
saved_id         PRIMARY KEY
jobseeker_id     FOREIGN KEY
job_id           FOREIGN KEY
```

This table is optional and can be removed if the project needs to remain smaller.

---

# 13. Authentication Architecture

The system uses `HttpSession` for authentication.

### Login flow

```text
User
 |
 v
login.jsp
 |
 | email + password
 v
LoginServlet
 |
 v
UserDAO
 |
 v
MySQL
 |
 +---- invalid ----> login.jsp
 |
 |
 +---- valid
       |
       v
 HttpSession
       |
       v
 Role Check
       |
       +-------- JOBSEEKER --------> Job Seeker Dashboard
       |
       +-------- RECRUITER --------> Recruiter Dashboard
```

The session can contain:

```text
userId
name
role
```

Example:

```java
session.setAttribute("userId", user.getUserId());
session.setAttribute("role", user.getRole());
```

---

# 14. Authorization

Authentication answers:

> "Who is the user?"

Authorization answers:

> "What is the user allowed to do?"

For example:

### Job Seeker

Can:

```text
Search Jobs
View Job
Apply
View Applications
Update Profile
```

Cannot:

```text
Post Job
View all applicants
Change application status
```

### Recruiter

Can:

```text
Post Job
Manage Jobs
View Applicants
Update Application Status
Update Profile
```

Cannot:

```text
Apply for jobs as a job seeker
```

The Servlet layer should verify the user's role before allowing protected operations.

---

# 15. Job Seeker Workflow

```text
Register
   |
   v
Login
   |
   v
Dashboard
   |
   +----------------------+
   |                      |
   v                      v
Search Jobs            Profile
   |
   v
View Job
   |
   v
Apply
   |
   v
My Applications
   |
   v
Track Status
```

---

# 16. Recruiter Workflow

```text
Register
   |
   v
Login
   |
   v
Dashboard
   |
   +----------------------+
   |                      |
   v                      v
Post Job              Manage Profile
   |
   v
Manage Jobs
   |
   v
View Applicants
   |
   v
Update Application Status
```

---

# 17. Job Search Architecture

One of the project's main USPs is **skill-based job search**.

The user can enter:

```text
Java SQL JSP
```

The system searches the `skills_required` field.

Example:

```sql
SELECT *
FROM jobs
WHERE title LIKE ?
   OR skills_required LIKE ?
   OR location LIKE ?;
```

The Servlet receives the search term:

```text
SearchJobServlet
       |
       v
JobDAO.searchJobs()
       |
       v
PreparedStatement
       |
       v
MySQL
       |
       v
ResultSet
       |
       v
JSP
```

---

# 18. Job Application Architecture

When a job seeker clicks **Apply**:

```text
job-details.jsp
       |
       | POST jobId
       v
ApplyJobServlet
       |
       +---- Check Login
       |
       +---- Check Existing Application
       |
       +---- Insert Application
       |
       v
ApplicationDAO
       |
       v
MySQL
       |
       v
Success Message
```

The system should prevent a user from applying to the same job multiple times.

---

# 19. Application Tracking Architecture

The application status is stored in:

```text
applications.status
```

Initial status:

```text
APPLIED
```

Recruiter can change it to:

```text
UNDER_REVIEW
SHORTLISTED
REJECTED
```

Flow:

```text
Job Seeker Applies
       |
       v
APPLIED
       |
       v
Recruiter Reviews
       |
       +----> UNDER_REVIEW
       |
       +----> REJECTED
       |
       +----> SHORTLISTED
```

The job seeker can see the latest status from the **My Applications** page.

---

# 20. Recruiter Applicant Dashboard

For each job, recruiters can view applicants.

Example:

```text
Java Developer
------------------------------------------------

Candidate       Skills             Status

Rahul           Java, SQL          APPLIED
Amit            Java, JSP          UNDER_REVIEW
Sneha           Java, HTML         SHORTLISTED
```

The data can be retrieved using SQL joins.

Conceptually:

```text
applications
      |
      +------ jobs
      |
      +------ users
      |
      +------ jobseeker_profile
```

This demonstrates the use of relational database concepts.

---

# 21. JDBC Architecture

JDBC stands for:

**Java Database Connectivity**

It allows Java code to communicate with MySQL.

The basic flow is:

```text
Java Servlet
     |
     v
DAO
     |
     v
JDBC Driver
     |
     v
MySQL
```

Typical JDBC operations are:

```text
Connection
PreparedStatement
ResultSet
```

Example architecture:

```text
Connection
    |
    v
PreparedStatement
    |
    v
SQL Query
    |
    v
executeQuery() / executeUpdate()
    |
    v
ResultSet / affected rows
```

---

# 22. PreparedStatement

All user-provided values should be handled using `PreparedStatement`.

Example:

```java
String sql = "SELECT * FROM users WHERE email = ? AND password = ?";

PreparedStatement ps = connection.prepareStatement(sql);

ps.setString(1, email);
ps.setString(2, password);
```

This is preferred over constructing SQL queries by string concatenation.

---

# 23. Request Flow

A normal request follows this pattern:

```text
Browser
   |
   | HTTP Request
   v
JSP Form
   |
   v
Servlet
   |
   v
DAO
   |
   v
JDBC
   |
   v
MySQL
   |
   | Result
   v
DAO
   |
   v
Servlet
   |
   v
JSP
   |
   v
Browser
```

---

# 24. Forward vs Redirect

The application can use:

### Forward

Used when the server wants to display a JSP using the current request.

```java
request.getRequestDispatcher("dashboard.jsp")
       .forward(request, response);
```

### Redirect

Used when the browser should make a new request.

```java
response.sendRedirect("login.jsp");
```

A common pattern after successful form submission is:

```text
POST
 |
 v
Servlet
 |
 v
Database
 |
 v
Redirect
 |
 v
GET
 |
 v
JSP
```

---

# 25. Error Handling

The system should handle common errors gracefully.

Examples:

```text
Invalid login
Email already registered
Missing form fields
Invalid job ID
Duplicate application
Database connection failure
Unauthorized access
```

Instead of displaying technical errors to users, the application should show understandable messages.

Example:

```text
"Invalid email or password."
```

rather than:

```text
SQLException: Communications link failure...
```

Technical errors should be logged for debugging.

---

# 26. Input Validation

Validation should occur at both frontend and backend levels.

### Frontend

JavaScript/HTML validation can check:

```text
Required fields
Email format
Password length
Phone format
Salary format
```

### Backend

Servlets must validate again because frontend validation can be bypassed.

Example:

```text
Browser Validation
       +
Servlet Validation
       |
       v
Database
```

---

# 27. Security Considerations

For a college mini-project, the following basic security practices should be implemented:

### Passwords

The project can initially demonstrate login using database-stored credentials, but a better implementation should store passwords using secure hashing rather than plain text.

### SQL Injection

Use:

```text
PreparedStatement
```

instead of SQL string concatenation.

### Session Security

Protected pages should check whether the user is logged in.

### Authorization

Check the user's role before allowing recruiter/job seeker operations.

### Input Validation

Never assume that user input is valid.

---

# 28. Three Main USPs

The project focuses on three simple but useful differentiating features.

## USP 1 — Skill-Based Job Search

Users can search jobs based on required skills.

Example:

```text
Java + SQL
```

can find jobs requiring those skills.

---

## USP 2 — Application Tracking

Job seekers can track:

```text
APPLIED
   ↓
UNDER_REVIEW
   ↓
SHORTLISTED / REJECTED
```

---

## USP 3 — Recruiter Applicant Dashboard

Recruiters can:

```text
View Job
   ↓
View Applicants
   ↓
Review Candidate
   ↓
Update Status
```

---

# 29. Role-Based Access Matrix

| Feature                   | Job Seeker | Recruiter |
| ------------------------- | ---------: | --------: |
| Register                  |        Yes |       Yes |
| Login                     |        Yes |       Yes |
| Logout                    |        Yes |       Yes |
| Manage Profile            |        Yes |       Yes |
| Search Jobs               |        Yes |  Optional |
| View Job Details          |        Yes |       Yes |
| Apply for Job             |        Yes |        No |
| View Own Applications     |        Yes |        No |
| Post Job                  |         No |       Yes |
| Manage Own Jobs           |         No |       Yes |
| View Applicants           |         No |       Yes |
| Update Application Status |         No |       Yes |

---

# 30. Data Flow Example — Login

```text
                USER
                 |
                 v
             login.jsp
                 |
                 | POST
                 v
           LoginServlet
                 |
                 v
              UserDAO
                 |
                 v
              JDBC
                 |
                 v
              MySQL
                 |
          +------+------+
          |             |
       Success        Failure
          |             |
          v             v
      Session        login.jsp
          |
          v
    Role Verification
       /          \
      /            \
Job Seeker       Recruiter
   |                 |
   v                 v
Dashboard          Dashboard
```

---

# 31. Data Flow Example — Applying for a Job

```text
Job Seeker
    |
    v
Search Jobs
    |
    v
Job Details
    |
    v
Click Apply
    |
    v
ApplyJobServlet
    |
    v
Check Session
    |
    v
Check Existing Application
    |
    v
ApplicationDAO
    |
    v
JDBC
    |
    v
MySQL
    |
    v
Application Created
    |
    v
My Applications
```

---

# 32. Data Flow Example — Recruiter Updating Status

```text
Recruiter
    |
    v
Applicants Page
    |
    v
Select Application
    |
    v
UpdateApplicationServlet
    |
    v
ApplicationDAO
    |
    v
JDBC
    |
    v
MySQL
    |
    v
Status Updated
    |
    v
Job Seeker
    |
    v
My Applications
```

---

# 33. Responsibilities of Antigravity

Antigravity may be used as a development assistant for:

* Generating boilerplate Java code
* Creating JSP pages
* Creating Servlet classes
* Creating DAO classes
* Generating SQL queries
* Creating CSS
* Finding coding errors
* Explaining exceptions
* Refactoring repetitive code
* Creating documentation
* Generating test cases

However, the generated code must be reviewed and tested before being considered part of the final project.

---

# 34. Responsibilities of the Developer

The developer should manually handle and verify:

* MySQL installation
* Database creation
* Database credentials
* Tomcat configuration
* JDBC driver configuration
* Running the application
* Testing all workflows
* Checking database relationships
* Reviewing generated code
* Fixing environment-specific errors
* Taking project screenshots
* Preparing project documentation
* Understanding the architecture for viva

---

# 35. Development Strategy

The project should be developed incrementally.

### Phase 1 — Setup

```text
Java
Tomcat
Maven
MySQL
JDBC
```

### Phase 2 — Database

```text
Create database
Create tables
Create relationships
Insert test data
```

### Phase 3 — Authentication

```text
Registration
Login
Logout
Session
Role-based access
```

### Phase 4 — Job Seeker

```text
Profile
Search Jobs
View Job
Apply
My Applications
```

### Phase 5 — Recruiter

```text
Profile
Post Job
Manage Jobs
View Applicants
Update Status
```

### Phase 6 — USPs

```text
Skill-based Search
Application Tracking
Applicant Dashboard
```

### Phase 7 — UI

```text
CSS
Forms
Cards
Tables
Navigation
Responsive design
```

### Phase 8 — Testing

```text
Functional Testing
Database Testing
Authentication Testing
Authorization Testing
Error Testing
```

---

# 36. Deployment Architecture

For local development:

```text
              Browser
                 |
                 | localhost
                 v
          Apache Tomcat
                 |
                 v
           JobPortal.war
                 |
                 v
          Servlet + JSP
                 |
                 v
              JDBC
                 |
                 v
              MySQL
```

Typical development environment:

```text
Browser
   |
   | http://localhost:8080/JobPortal
   |
Tomcat : 8080
   |
MySQL : 3306
```

The exact port numbers may be changed depending on the local configuration.

---

# 37. Expected Final Application Modules

The completed application should contain:

```text
1. Home Page

2. Registration
   ├── Job Seeker
   └── Recruiter

3. Login

4. Job Seeker Module
   ├── Dashboard
   ├── Profile
   ├── Search Jobs
   ├── Job Details
   ├── Apply
   └── My Applications

5. Recruiter Module
   ├── Dashboard
   ├── Profile
   ├── Post Job
   ├── Manage Jobs
   ├── Applicants
   └── Update Application Status

6. Authentication
   ├── Login
   ├── Logout
   └── Session Management

7. Database
   ├── Users
   ├── Profiles
   ├── Jobs
   └── Applications
```

---

# 38. Design Principles

The project should follow these principles:

### Separation of Concerns

JSP handles presentation.

Servlet handles request processing.

DAO handles database operations.

Model represents data.

---

### Reusability

Common database operations should be kept inside DAO classes.

---

### Simplicity

The project should avoid unnecessary frameworks and advanced architecture because it is intended as a second-year mini-project.

---

### Maintainability

Each major feature should have a clearly identifiable Servlet, DAO and JSP where appropriate.

---

### Security

Use sessions, authorization checks, prepared statements and input validation.

---

# 39. Final Architecture Summary

The final architecture can be summarized as:

```text
                    JOB PORTAL SYSTEM
                           |
              +------------+------------+
              |                         |
         JOB SEEKER                  RECRUITER
              |                         |
              +------------+------------+
                           |
                           v
                         JSP
                           |
                           v
                       SERVLETS
                           |
                           v
                         DAO
                           |
                           v
                         JDBC
                           |
                           v
                         MYSQL
```

The core request flow is:

```text
JSP
 ↓
Servlet
 ↓
DAO
 ↓
JDBC
 ↓
MySQL
 ↓
DAO
 ↓
Servlet
 ↓
JSP
```

The system provides three main USPs:

```text
1. Skill-Based Job Search

2. Application Status Tracking

3. Recruiter Applicant Dashboard
```

The architecture deliberately uses **Servlets, JSP and JDBC directly**, making it suitable for a Second Year FSJP mini-project and allowing the developer to clearly demonstrate how a Java web application communicates with a relational database.
