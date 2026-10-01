# Product Requirements Document (PRD)

# Job Portal System

**Project Type:** Second Year Mini Project — FSJP
**Platform:** Web Application
**Primary Users:** Job Seekers and Recruiters
**Backend:** Java Servlets
**Frontend:** JSP, HTML, CSS, JavaScript
**Database:** MySQL
**Database Connectivity:** JDBC
**Server:** Apache Tomcat
**Build Tool:** Maven

---

# 1. Product Overview

## 1.1 Product Name

**Job Portal System**

---

## 1.2 Product Description

The Job Portal System is a web-based application that connects **Job Seekers** with **Recruiters**.

The application allows Job Seekers to:

* Create an account
* Create and manage their profile
* Search available jobs
* Search using required skills
* View job details
* Apply for jobs
* Track their applications
* View application status

The application allows Recruiters to:

* Create an account
* Manage company information
* Post job openings
* Manage their job postings
* View applicants
* Update application status

The system will use **Java Servlets, JSP and JDBC with MySQL** to demonstrate the complete flow of a Java web application.

---

# 2. Problem Statement

Finding and managing job opportunities can involve multiple disconnected steps.

Job seekers need a way to:

* Find relevant job opportunities
* Search jobs based on their skills
* Apply to jobs
* Keep track of applications
* Know the current status of their applications

Recruiters need a way to:

* Publish job openings
* Manage their job postings
* View candidates who have applied
* Track and update candidate application status

The Job Portal System provides a single web-based platform for these activities.

---

# 3. Product Goals

The primary goals are:

### Goal 1 — Job Discovery

Provide Job Seekers with a simple way to discover available jobs.

### Goal 2 — Skill-Based Search

Allow Job Seekers to search for jobs using skills in addition to job titles and locations.

### Goal 3 — Application Management

Allow Job Seekers to apply for jobs and view their application history.

### Goal 4 — Application Tracking

Allow Job Seekers to see the current status of their applications.

### Goal 5 — Recruiter Job Management

Allow Recruiters to create and manage their own job postings.

### Goal 6 — Candidate Management

Allow Recruiters to view applicants and update application statuses.

### Goal 7 — Demonstrate Full-Stack Java Concepts

Demonstrate practical implementation of:

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
```

---

# 4. Product Scope

The product has two primary modules:

```text
                    JOB PORTAL
                         |
            +------------+------------+
            |                         |
            v                         v
       JOB SEEKER                  RECRUITER
```

---

## 4.1 Job Seeker Module

The Job Seeker can:

* Register
* Login
* Logout
* Manage profile
* Search jobs
* Search by skills
* View job details
* Apply for jobs
* View submitted applications
* Track application status

---

## 4.2 Recruiter Module

The Recruiter can:

* Register
* Login
* Logout
* Manage recruiter/company profile
* Post jobs
* View own jobs
* Manage own jobs
* View applicants
* Update application status

---

# 5. Target Users

## 5.1 Job Seeker

A person looking for employment opportunities.

Typical workflow:

```text
Register
   ↓
Login
   ↓
Complete Profile
   ↓
Search Jobs
   ↓
View Job
   ↓
Apply
   ↓
Track Application
```

---

## 5.2 Recruiter

A company representative or recruiter who wants to publish job openings and manage applications.

Typical workflow:

```text
Register
   ↓
Login
   ↓
Complete Company Profile
   ↓
Post Job
   ↓
View Applicants
   ↓
Review Applications
   ↓
Update Status
```

---

# 6. Unique Selling Propositions

The project will have three primary USPs.

---

## USP 1 — Skill-Based Job Search

Job Seekers can search for jobs based on required skills.

For example:

```text
Search:
Java SQL JSP
```

The system can return jobs containing matching skills in their job requirements.

The feature will be implemented using SQL/JDBC and does not require AI or machine learning.

---

## USP 2 — Application Status Tracking

Job Seekers can track the status of applications.

Supported statuses:

```text
APPLIED
UNDER_REVIEW
SHORTLISTED
REJECTED
```

Example:

```text
Java Developer
       |
       v
APPLIED
       |
       v
UNDER_REVIEW
       |
       +------> SHORTLISTED
       |
       +------> REJECTED
```

---

## USP 3 — Recruiter Applicant Dashboard

Recruiters can view candidates who have applied to their jobs.

Example:

```text
Java Developer

Candidate       Skills          Status
------------------------------------------
Rahul           Java, SQL       Applied
Amit            Java, JSP       Under Review
Sneha           Java, HTML      Shortlisted
```

Recruiters can update the application status.

---

# 7. User Roles and Permissions

The system will have two roles.

```text
JOBSEEKER
RECRUITER
```

---

## 7.1 Job Seeker Permissions

| Function                  | Access |
| ------------------------- | ------ |
| Register                  | Yes    |
| Login                     | Yes    |
| Logout                    | Yes    |
| Manage Profile            | Yes    |
| Search Jobs               | Yes    |
| View Job Details          | Yes    |
| Apply for Jobs            | Yes    |
| View Own Applications     | Yes    |
| Track Status              | Yes    |
| Post Jobs                 | No     |
| View Applicants           | No     |
| Update Application Status | No     |

---

## 7.2 Recruiter Permissions

| Function                  | Access   |
| ------------------------- | -------- |
| Register                  | Yes      |
| Login                     | Yes      |
| Logout                    | Yes      |
| Manage Profile            | Yes      |
| Search Jobs               | Optional |
| View Job Details          | Yes      |
| Apply for Jobs            | No       |
| Post Jobs                 | Yes      |
| Manage Own Jobs           | Yes      |
| View Applicants           | Yes      |
| Update Application Status | Yes      |

---

# 8. Functional Requirements

## FR-01 — User Registration

The system shall allow a new user to create an account.

Required fields:

```text
Name
Email
Password
Role
```

The system shall:

* Validate required fields.
* Validate email format.
* Prevent duplicate email addresses.
* Store the selected role.
* Store the account in MySQL.

---

# 9. FR-02 — User Login

The system shall allow registered users to log in using:

```text
Email
Password
```

The system shall:

1. Validate the credentials.
2. Create an HTTP session.
3. Store user information in the session.
4. Identify the user's role.
5. Redirect the user to the appropriate dashboard.

---

# 10. FR-03 — Logout

The system shall allow authenticated users to logout.

Logout shall:

1. Invalidate the current session.
2. Redirect the user to the login or home page.

---

# 11. FR-04 — Job Seeker Profile

A Job Seeker shall be able to manage:

```text
Phone
Education
Skills
Experience
Resume
```

The profile shall be associated with the corresponding user account.

---

# 12. FR-05 — Recruiter Profile

A Recruiter shall be able to manage:

```text
Company Name
Company Description
Company Location
```

The profile shall be associated with the corresponding recruiter account.

---

# 13. FR-06 — Job Posting

A Recruiter shall be able to create a job posting.

Required information:

```text
Job Title
Job Description
Required Skills
Location
Salary
Job Type
```

The system shall automatically record the posting date.

Each job shall belong to the recruiter who created it.

---

# 14. FR-07 — Job Management

Recruiters shall be able to view jobs posted by themselves.

The system should ensure that a recruiter cannot modify jobs belonging to another recruiter.

---

# 15. FR-08 — Job Search

Job Seekers shall be able to search for jobs using:

```text
Job Title
Skills
Location
```

The system shall return jobs matching the provided criteria.

Search should not require every field to be filled.

---

# 16. FR-09 — Job Details

The system shall provide a detailed view of a selected job.

The page should display:

```text
Job Title
Company
Description
Required Skills
Location
Salary
Job Type
Posted Date
```

---

# 17. FR-10 — Job Application

A logged-in Job Seeker shall be able to apply for a job.

The application shall contain:

```text
Job ID
Job Seeker ID
Application Date
Status
```

The initial status shall be:

```text
APPLIED
```

---

# 18. FR-11 — Duplicate Application Prevention

The system shall prevent a Job Seeker from applying to the same job more than once.

Before creating an application, the system shall check whether an application already exists for:

```text
job_id + jobseeker_id
```

If an application exists, the system shall display an appropriate message.

---

# 19. FR-12 — View Applications

Job Seekers shall be able to view their own applications.

The page should contain:

```text
Job
Company
Application Date
Current Status
```

---

# 20. FR-13 — View Applicants

Recruiters shall be able to view applicants for their own jobs.

The system should display relevant candidate information such as:

```text
Candidate Name
Email
Skills
Education
Experience
Application Date
Application Status
```

The exact information can depend on the available profile data.

---

# 21. FR-14 — Update Application Status

Recruiters shall be able to update an application's status.

Allowed values:

```text
APPLIED
UNDER_REVIEW
SHORTLISTED
REJECTED
```

The updated status shall be stored in MySQL.

The Job Seeker shall see the updated status when viewing their applications.

---

# 22. FR-15 — Role-Based Authorization

The system shall enforce role-based access.

A Job Seeker shall not be able to access recruiter-only operations.

A Recruiter shall not be able to perform Job Seeker-only operations such as applying for jobs.

Authorization shall be checked on the server side.

---

# 23. FR-16 — Session Management

The system shall use `HttpSession` to maintain authenticated users.

At minimum, the session should store:

```text
userId
name
role
```

Protected resources must verify that the user is logged in.

---

# 24. FR-17 — Input Validation

The system shall validate user input.

Validation should occur on:

### Frontend

Using HTML/JavaScript.

### Backend

Using Java Servlet validation.

Backend validation is mandatory.

---

# 25. FR-18 — SQL Injection Prevention

Database queries involving user input shall use:

```text
PreparedStatement
```

The application should not construct SQL queries by directly concatenating user input.

---

# 26. Non-Functional Requirements

## NFR-01 — Usability

The interface should be simple enough for first-time users to understand.

---

## NFR-02 — Performance

Normal operations such as:

* Login
* Job search
* Job viewing
* Application submission

should respond quickly on a local development environment.

---

## NFR-03 — Reliability

The system should not lose application data after successful database operations.

---

## NFR-04 — Maintainability

The code should be separated into:

```text
Model
DAO
Servlet/Controller
JSP/View
Utility
```

This makes individual components easier to understand and modify.

---

## NFR-05 — Security

The application should:

* Validate input.
* Use PreparedStatement.
* Protect authenticated pages.
* Enforce role-based access.
* Avoid exposing raw database errors to users.

---

## NFR-06 — Compatibility

The application should work in modern desktop browsers such as:

```text
Google Chrome
Microsoft Edge
Mozilla Firefox
```

---

# 27. Technology Requirements

The application must use:

```text
Java
Java Servlets
JSP
JDBC
MySQL
Apache Tomcat
HTML
CSS
JavaScript
Maven
```

---

# 28. System Architecture

The system shall follow this basic architecture:

```text
                  USER
                   |
                   v
                  JSP
                   |
                   v
               SERVLET
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

The response flows back through:

```text
MySQL
  ↓
JDBC
  ↓
DAO
  ↓
Servlet
  ↓
JSP
  ↓
User
```

Detailed architectural information is defined in:

```text
ARCHITECTURE.md
```

---

# 29. Database Requirements

The MVP database shall contain the following tables:

```text
users
jobseeker_profile
recruiter_profile
jobs
applications
```

Optional future table:

```text
saved_jobs
```

---

# 30. Entity Relationships

The major relationships are:

```text
USER
 |
 +---- JOBSEEKER_PROFILE
 |
 +---- RECRUITER_PROFILE

RECRUITER
 |
 +---- JOBS
          |
          +---- APPLICATIONS
                       |
                       +---- JOBSEEKER
```

More formally:

```text
User 1 ---- 1 JobSeekerProfile

User 1 ---- 1 RecruiterProfile

Recruiter 1 ---- N Jobs

JobSeeker 1 ---- N Applications

Job 1 ---- N Applications
```

---

# 31. User Journey — Job Seeker

```text
                    HOME
                      |
                      v
                  REGISTER
                      |
                      v
                    LOGIN
                      |
                      v
                 DASHBOARD
                      |
            +---------+---------+
            |                   |
            v                   v
       SEARCH JOBS           PROFILE
            |
            v
       VIEW DETAILS
            |
            v
           APPLY
            |
            v
    MY APPLICATIONS
            |
            v
     TRACK STATUS
            |
            v
          LOGOUT
```

---

# 32. User Journey — Recruiter

```text
                    HOME
                      |
                      v
                  REGISTER
                      |
                      v
                    LOGIN
                      |
                      v
                 DASHBOARD
                      |
             +--------+--------+
             |                 |
             v                 v
          POST JOB          PROFILE
             |
             v
        MANAGE JOBS
             |
             v
      VIEW APPLICANTS
             |
             v
      UPDATE STATUS
             |
             v
           LOGOUT
```

---

# 33. Application Lifecycle

Every application begins with:

```text
APPLIED
```

It can then move to:

```text
APPLIED
   |
   v
UNDER_REVIEW
   |
   +------------+
   |            |
   v            v
SHORTLISTED   REJECTED
```

The system should store only the current status in the MVP.

A complete status history is a future enhancement.

---

# 34. Job Lifecycle

A Recruiter creates a job:

```text
CREATE
  |
  v
POSTED
  |
  v
AVAILABLE
  |
  v
APPLICATIONS RECEIVED
```

For the MVP, a job does not require a complicated publishing workflow.

---

# 35. Core Screens

The application should contain the following screens.

## Public

```text
Home
Login
Registration
```

## Job Seeker

```text
Dashboard
Profile
Search Jobs
Job Details
My Applications
```

## Recruiter

```text
Dashboard
Profile
Post Job
Manage Jobs
Applicants
```

---

# 36. Error Scenarios

The application must handle at least the following cases:

| Scenario                   | Expected Result          |
| -------------------------- | ------------------------ |
| Invalid login              | Show login error         |
| Duplicate email            | Reject registration      |
| Empty required field       | Show validation message  |
| Invalid job ID             | Show appropriate error   |
| Duplicate application      | Prevent application      |
| Unauthenticated access     | Redirect to login        |
| Wrong role                 | Deny access              |
| Database failure           | Show user-friendly error |
| Invalid application status | Reject update            |

---

# 37. MVP Acceptance Criteria

The product is considered functional when the following complete workflows work successfully.

## Registration

```text
[ ] Job Seeker can register
[ ] Recruiter can register
[ ] Duplicate email is rejected
[ ] Invalid input is rejected
```

## Authentication

```text
[ ] User can login
[ ] Invalid credentials are rejected
[ ] Correct dashboard is displayed
[ ] Session is created
[ ] Logout destroys session
```

## Job Seeker

```text
[ ] Profile can be updated
[ ] Jobs can be searched
[ ] Jobs can be viewed
[ ] Job can be applied to
[ ] Duplicate application is prevented
[ ] Applications can be viewed
[ ] Application status can be tracked
```

## Recruiter

```text
[ ] Profile can be updated
[ ] Job can be posted
[ ] Own jobs can be viewed
[ ] Applicants can be viewed
[ ] Application status can be updated
```

## Database

```text
[ ] JDBC connection works
[ ] Data is stored correctly
[ ] Foreign keys work
[ ] Relationships work
[ ] SQL queries work
```

## Authorization

```text
[ ] Job Seeker cannot access recruiter functions
[ ] Recruiter cannot modify another recruiter's jobs
[ ] Protected pages require authentication
```

---

# 38. Out of Scope

The following features are intentionally outside the initial product scope:

```text
AI-powered recommendations
AI resume analysis
Chat functionality
Video interviews
Online examinations
Payment gateway
Premium memberships
SMS notifications
Email notification system
Social networking
Company reviews
Advanced analytics
Real-time notifications
Mobile application
Microservices
Cloud-native architecture
Advanced machine learning
OAuth / Google authentication
Two-factor authentication
```

These may be considered future enhancements but should not delay completion of the MVP.

---

# 39. Future Enhancements

After the MVP is complete, possible improvements include:

### Saved Jobs

Allow Job Seekers to bookmark jobs.

### Resume Upload

Allow users to upload PDF resumes.

### Advanced Search

Add:

```text
Salary Range
Experience
Job Type
Location
Skills
```

### Email Notifications

Notify candidates when their application status changes.

### Job Alerts

Notify users about newly posted jobs matching selected skills.

### Admin Module

Introduce an administrator who can:

```text
Manage Users
Manage Jobs
Review Reports
Remove inappropriate content
```

### Dashboard Analytics

Display:

```text
Total Jobs
Total Applications
Shortlisted Candidates
Rejected Candidates
```

These features should only be implemented after the core MVP is stable.

---

# 40. Development Guidelines

The project should be developed incrementally.

Recommended order:

```text
1. Project Setup
        ↓
2. Database
        ↓
3. JDBC Connection
        ↓
4. Registration
        ↓
5. Login + Session
        ↓
6. Job Seeker Module
        ↓
7. Recruiter Module
        ↓
8. Application System
        ↓
9. Application Tracking
        ↓
10. USPs
        ↓
11. UI Improvements
        ↓
12. Testing
        ↓
13. Documentation
```

Each stage should be tested before moving to the next stage.

---

# 41. AI Development Guidelines

Antigravity may be used as a development assistant.

It can assist with:

```text
Project scaffolding
Java classes
Servlets
DAO classes
JDBC queries
JSP pages
HTML
CSS
JavaScript
SQL
Debugging
Documentation
```

However, Antigravity should not introduce technologies outside the approved stack.

It should not automatically add:

```text
Spring
Hibernate
React
Node.js
ORM
External backend services
```

unless explicitly requested.

---

# 42. Developer Responsibilities

The developer is responsible for:

* Setting up Java.
* Setting up MySQL.
* Setting up Tomcat.
* Configuring database credentials.
* Executing SQL scripts.
* Running the application.
* Testing the application.
* Reviewing generated code.
* Understanding the architecture.
* Preparing documentation.
* Preparing for the project viva.

AI-generated code must not be considered correct simply because it compiles.

---

# 43. Product Success Criteria

The project will be considered successful if a user can complete the following end-to-end workflow without manual database intervention.

### Job Seeker

```text
Register
   ↓
Login
   ↓
Search Java Jobs
   ↓
View Job
   ↓
Apply
   ↓
View Application
   ↓
See Updated Status
```

### Recruiter

```text
Register
   ↓
Login
   ↓
Post Java Job
   ↓
View Applicants
   ↓
Update Application Status
```

The updated status should then be visible to the Job Seeker.

---

# 44. Demo Scenario

For the final project demonstration, the following scenario should be prepared.

## Step 1 — Recruiter

Create:

```text
Company:
ABC Technologies

Job:
Java Developer

Skills:
Java, JSP, Servlet, MySQL

Location:
Mumbai
```

---

## Step 2 — Job Seeker

Create:

```text
Name:
Rahul

Skills:
Java, SQL, JSP
```

---

## Step 3 — Search

Search:

```text
Java
```

The Java Developer job should appear.

---

## Step 4 — Apply

Rahul applies for:

```text
Java Developer
```

Status:

```text
APPLIED
```

---

## Step 5 — Recruiter

Recruiter opens:

```text
Applicants
```

Rahul should appear.

Recruiter changes status:

```text
APPLIED
     ↓
UNDER_REVIEW
```

---

## Step 6 — Job Seeker

Rahul opens:

```text
My Applications
```

The application should now display:

```text
UNDER_REVIEW
```

This demonstrates the complete system workflow.

---

# 45. Project Constraints

The project is a **college-level mini-project**, therefore:

* Keep the architecture understandable.
* Avoid unnecessary frameworks.
* Avoid unnecessary complexity.
* Prioritize working features over advanced features.
* Keep database design normalized and simple.
* Use clear Java naming conventions.
* Keep SQL queries readable.
* Keep JSP pages manageable.
* Use comments only where they improve understanding.
* Ensure the student can explain the complete project during viva.

---

# 46. Definition of Done

The product is officially complete when:

```text
[x] Project runs on Apache Tomcat

[x] MySQL connection works

[x] Registration works

[x] Login works

[x] Logout works

[x] Session management works

[x] Role-based access works

[x] Job Seeker profile works

[x] Recruiter profile works

[x] Recruiter can post jobs

[x] Job Seeker can search jobs

[x] Job Seeker can view jobs

[x] Job Seeker can apply

[x] Duplicate applications are prevented

[x] Job Seeker can view applications

[x] Recruiter can view applicants

[x] Recruiter can update application status

[x] Job Seeker can see updated status

[x] Skill-based search works

[x] PreparedStatement is used

[x] Backend validation exists

[x] Major error scenarios are handled

[x] Project documentation is complete
```

---

# 47. Final Product Definition

The final product is a simple web-based **Job Portal System** that connects Job Seekers and Recruiters through a centralized platform.

The core product flow is:

```text
                       JOB PORTAL
                           |
             +-------------+-------------+
             |                           |
             v                           v
        JOB SEEKER                   RECRUITER
             |                           |
          Register                    Register
             |                           |
           Login                       Login
             |                           |
         Dashboard                   Dashboard
             |                           |
       Search Jobs                  Post Jobs
             |                           |
        View Details               Manage Jobs
             |                           |
           Apply                  View Applicants
             |                           |
    Track Applications            Update Status
             |                           |
             +-------------+-------------+
                           |
                           v
                         JDBC
                           |
                           v
                         MySQL
```

The three core differentiating features are:

```text
1. Skill-Based Job Search

2. Application Status Tracking

3. Recruiter Applicant Dashboard
```

The product must first deliver these core workflows reliably before any future enhancement is attempted.
