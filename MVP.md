# Job Portal System — MVP Specification

## 1. Purpose

This document defines the **Minimum Viable Product (MVP)** for the Job Portal System.

The MVP is the minimum complete version of the project that must be implemented and working before additional features or UI improvements are added.

The project is a **Second Year FSJP Mini Project** and must demonstrate practical use of:

* Java Servlets
* JSP
* JDBC
* MySQL
* Apache Tomcat
* HTML
* CSS
* Basic JavaScript

The project should remain simple enough for a second-year student to understand, explain and demonstrate during a viva.

---

# 2. MVP Goal

The primary goal is to build a functional web-based job portal where:

### Job Seekers can:

1. Register
2. Login
3. Manage their profile
4. Search jobs
5. View job details
6. Apply for jobs
7. View their applications
8. Track application status
9. Logout

### Recruiters can:

1. Register
2. Login
3. Manage their profile
4. Post jobs
5. View their posted jobs
6. View applicants
7. Update application status
8. Logout

---

# 3. Technology Constraints

The MVP must use the following technologies:

```text
Frontend:
HTML
CSS
JavaScript
JSP

Backend:
Java Servlets

Database Connectivity:
JDBC

Database:
MySQL

Server:
Apache Tomcat

Build:
Maven
```

## Technologies that must NOT be introduced

Do not introduce the following technologies unless explicitly requested later:

```text
Spring Boot
Spring MVC
Hibernate
JPA
React
Angular
Node.js
Express
PHP
Python backend
Firebase
MongoDB
Any ORM framework
```

The project is specifically intended to demonstrate **Servlet + JSP + JDBC**.

---

# 4. User Roles

The MVP has exactly two primary user roles.

```text
JOBSEEKER
RECRUITER
```

The role must be stored in the `users` table.

Example:

```text
role = JOBSEEKER

role = RECRUITER
```

The role determines which dashboard and operations the user can access.

---

# 5. Core MVP Features

The following features are mandatory.

---

## 5.1 Home Page

The application must have a simple landing page.

It should contain:

```text
Job Portal System

Find your next opportunity.

[Login]
[Register]
```

The home page should provide navigation to:

* Login
* Registration

It does not need complicated animations or marketing sections.

---

# 6. User Registration

A common registration page should allow users to create an account.

Required fields:

```text
Name
Email
Password
Role
```

Role options:

```text
Job Seeker
Recruiter
```

### Registration flow

```text
register.jsp
      |
      v
RegisterServlet
      |
      v
UserDAO
      |
      v
JDBC
      |
      v
MySQL
```

### Validation

The system must:

* Reject empty fields.
* Validate email format.
* Prevent duplicate email addresses.
* Validate minimum password requirements.
* Validate that a valid role is selected.

### Success

After successful registration:

```text
Registration successful.
Please login.
```

The user can then go to the login page.

---

# 7. Login

The login page must contain:

```text
Email
Password

[Login]
```

### Login flow

```text
login.jsp
     |
     v
LoginServlet
     |
     v
UserDAO
     |
     v
MySQL
```

If credentials are correct:

```text
Create HttpSession
        |
        v
Check Role
    /       \
   /         \
Job Seeker   Recruiter
   |             |
   v             v
Dashboard     Dashboard
```

If credentials are incorrect:

```text
Invalid email or password.
```

---

# 8. Session Management

The system must use `HttpSession`.

After successful login, store at minimum:

```text
userId
name
role
```

Example:

```java
session.setAttribute("userId", user.getUserId());
session.setAttribute("name", user.getName());
session.setAttribute("role", user.getRole());
```

Protected pages must check whether a valid session exists.

---

# 9. Logout

A logout operation is mandatory.

When the user clicks:

```text
Logout
```

the system must:

1. Invalidate the current session.
2. Redirect the user to the login or home page.

Conceptually:

```text
User
 |
 v
Logout
 |
 v
session.invalidate()
 |
 v
Login/Home
```

---

# 10. Job Seeker MVP

The Job Seeker module must contain the following features.

---

## 10.1 Job Seeker Dashboard

The dashboard should display:

```text
Welcome, <Name>

[Search Jobs]
[My Applications]
[My Profile]
[Logout]
```

It may also display a small summary:

```text
Applications: 5
Shortlisted: 1
Under Review: 2
Rejected: 2
```

The summary is optional if time is limited.

---

# 11. Job Seeker Profile

The job seeker must be able to maintain basic profile information.

Required fields:

```text
Phone
Education
Skills
Experience
Resume
```

For the MVP, the resume may initially be stored as a file path or filename rather than implementing complex file storage.

The profile must be linked to the logged-in user using `user_id`.

---

# 12. Job Search

Job seekers must be able to search for available jobs.

The search page should support:

```text
Job Title
Skills
Location
```

The user may enter one or more search terms.

Example:

```text
Search: Java
Location: Mumbai
```

The system should return matching jobs.

---

# 13. USP 1 — Skill-Based Job Search

Skill-based searching is a mandatory USP.

The system should allow users to search jobs using skills such as:

```text
Java
SQL
JSP
Servlet
HTML
CSS
```

Example:

```text
User searches:

Java SQL
```

The system should display jobs whose title or required skills contain relevant terms.

The implementation should use SQL/JDBC.

No AI/ML recommendation engine is required for the MVP.

Example conceptual query:

```sql
SELECT *
FROM jobs
WHERE title LIKE ?
   OR skills_required LIKE ?
   OR location LIKE ?;
```

---

# 14. Job Details

Every job listing must provide a detailed view.

The job details page should display:

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

Example:

```text
Java Developer

Company: ABC Technologies
Location: Mumbai

Required Skills:
Java, JSP, Servlet, MySQL

Salary:
₹5 LPA

Job Type:
Full Time

[Apply Now]
```

---

# 15. Apply for Job

A logged-in Job Seeker must be able to apply for a job.

The application should store:

```text
job_id
jobseeker_id
application_date
status
```

Initial status:

```text
APPLIED
```

### Application flow

```text
Job Details
     |
     v
Apply Now
     |
     v
ApplyJobServlet
     |
     v
Check Login
     |
     v
Check Existing Application
     |
     v
ApplicationDAO
     |
     v
MySQL
```

---

# 16. Duplicate Application Prevention

A Job Seeker must not be able to apply to the same job more than once.

Before inserting an application, the system must check:

```text
Does an application already exist
for this user and this job?
```

If yes:

```text
You have already applied for this job.
```

If no:

```text
Application submitted successfully.
```

---

# 17. USP 2 — Application Tracking

Every Job Seeker must have a:

```text
My Applications
```

page.

It should display:

| Job             | Company  | Date    | Status       |
| --------------- | -------- | ------- | ------------ |
| Java Developer  | ABC Tech | 20 Sept | Under Review |
| Web Developer   | XYZ Ltd  | 18 Sept | Shortlisted  |
| Software Intern | PQR Ltd  | 17 Sept | Rejected     |

Possible statuses:

```text
APPLIED
UNDER_REVIEW
SHORTLISTED
REJECTED
```

The status must come from the database.

---

# 18. Recruiter MVP

The Recruiter module must contain:

```text
Dashboard
Profile
Post Job
Manage Jobs
View Applicants
Update Application Status
Logout
```

---

# 19. Recruiter Dashboard

The recruiter dashboard should display:

```text
Welcome, <Recruiter Name>

[Post Job]
[Manage Jobs]
[View Applicants]
[Profile]
[Logout]
```

Optional summary:

```text
Jobs Posted: 5
Total Applications: 37
```

This summary is not mandatory for the MVP.

---

# 20. Recruiter Profile

The recruiter should be able to store:

```text
Company Name
Company Description
Company Location
```

The profile must be linked to the logged-in recruiter.

---

# 21. Post Job

Recruiters must be able to create job postings.

Required fields:

```text
Job Title
Job Description
Required Skills
Location
Salary
Job Type
```

Example:

```text
Title:
Java Developer

Description:
Develop and maintain Java web applications.

Required Skills:
Java, JSP, Servlet, MySQL

Location:
Mumbai

Salary:
50000

Job Type:
Full Time
```

---

# 22. Manage Jobs

Recruiters must be able to see jobs posted by themselves.

Example:

```text
My Jobs

Java Developer
Mumbai
12 Applications

[View Applicants]

Web Developer
Pune
7 Applications

[View Applicants]
```

The recruiter should only be able to manage jobs belonging to that recruiter.

---

# 23. USP 3 — Recruiter Applicant Dashboard

Recruiters must be able to view applicants for their jobs.

Example:

```text
Java Developer
-------------------------------------------

Candidate     Skills           Status

Rahul         Java, SQL        APPLIED
Amit          Java, JSP        UNDER_REVIEW
Sneha         Java, HTML       SHORTLISTED
```

The recruiter should be able to see relevant candidate information.

---

# 24. Update Application Status

Recruiters must be able to change the status of an application.

Allowed statuses:

```text
APPLIED
UNDER_REVIEW
SHORTLISTED
REJECTED
```

Example:

```text
Candidate: Rahul

Current Status:
APPLIED

[UNDER REVIEW]
[SHORTLIST]
[REJECT]
```

When the recruiter updates the status, the value must be stored in MySQL.

The Job Seeker should see the updated status on the next visit to:

```text
My Applications
```

---

# 25. Authorization Rules

The application must enforce role-based access.

## Job Seeker

Allowed:

```text
View jobs
Search jobs
Apply
View own applications
Manage own profile
```

Not allowed:

```text
Post jobs
View recruiter dashboard
View other candidates
Update application status
```

## Recruiter

Allowed:

```text
Post jobs
Manage own jobs
View applicants for own jobs
Update application status
Manage own profile
```

Not allowed:

```text
Apply for jobs as a recruiter
View another recruiter's private applicant data
Modify another recruiter's jobs
```

---

# 26. Database MVP

The minimum database should contain these tables:

```text
users
jobseeker_profile
recruiter_profile
jobs
applications
```

The `saved_jobs` table is optional and can be excluded from the MVP.

---

# 27. Required Database Relationships

### User → Job Seeker Profile

```text
users 1 ---- 1 jobseeker_profile
```

### User → Recruiter Profile

```text
users 1 ---- 1 recruiter_profile
```

### Recruiter → Jobs

```text
recruiter 1 ---- N jobs
```

### Job Seeker → Applications

```text
jobseeker 1 ---- N applications
```

### Job → Applications

```text
job 1 ---- N applications
```

---

# 28. Minimum Database Fields

## users

```text
user_id
name
email
password
role
```

## jobseeker_profile

```text
profile_id
user_id
phone
education
skills
experience
resume
```

## recruiter_profile

```text
recruiter_id
user_id
company_name
company_description
company_location
```

## jobs

```text
job_id
recruiter_id
title
description
skills_required
location
salary
job_type
posted_date
```

## applications

```text
application_id
job_id
jobseeker_id
application_date
status
```

---

# 29. Minimum JSP Pages

The MVP should contain at least:

```text
index.jsp
login.jsp
register.jsp
```

### Job Seeker

```text
jobseeker/dashboard.jsp
jobseeker/profile.jsp
jobseeker/search-jobs.jsp
jobseeker/job-details.jsp
jobseeker/my-applications.jsp
```

### Recruiter

```text
recruiter/dashboard.jsp
recruiter/profile.jsp
recruiter/post-job.jsp
recruiter/manage-jobs.jsp
recruiter/applicants.jsp
```

---

# 30. Minimum Servlets

The MVP should contain approximately:

```text
LoginServlet
RegisterServlet
LogoutServlet
ProfileServlet
PostJobServlet
SearchJobServlet
ApplyJobServlet
UpdateApplicationServlet
```

Additional Servlets can be introduced if they make the code cleaner.

Do not create unnecessary Servlets simply to increase the number of files.

---

# 31. Minimum DAO Classes

The MVP should contain:

```text
UserDAO
JobDAO
ApplicationDAO
ProfileDAO
```

If profile operations are separated further, additional DAO classes are acceptable.

---

# 32. Minimum Model Classes

The MVP should contain:

```text
User
Job
Application
JobSeekerProfile
RecruiterProfile
```

Each model should contain:

* Private fields
* Constructors
* Getters
* Setters

---

# 33. Database Connection

A central utility class should manage JDBC connections.

Example:

```text
DBConnection.java
```

Responsibilities:

```text
Create database connection
Return Connection object
Handle connection configuration
```

Database credentials must not be hardcoded into multiple classes.

---

# 34. UI Requirements

The MVP UI should be:

* Clean
* Simple
* Consistent
* Easy to navigate
* Responsive enough for normal desktop use

Required UI elements:

```text
Navigation bar
Forms
Buttons
Tables
Job cards
Status indicators
Success messages
Error messages
```

The UI does not need:

```text
Complex animations
3D graphics
Advanced dashboards
Chat systems
Real-time notifications
```

---

# 35. Error Handling Requirements

The MVP must handle at least:

```text
Invalid login
Duplicate email
Empty fields
Invalid job ID
Duplicate application
Unauthorized access
Database connection failure
```

User-facing messages should be understandable.

Example:

```text
Invalid email or password.
```

instead of displaying raw Java exceptions.

---

# 36. Validation Requirements

Frontend validation:

```text
Required fields
Email format
Password length
Phone format
```

Backend validation:

```text
Required fields
Valid user role
Valid job ID
Valid session
Valid application
```

Backend validation is mandatory even if JavaScript validation exists.

---

# 37. Security Requirements

The MVP should implement basic security practices.

### SQL Injection Protection

Use:

```text
PreparedStatement
```

for SQL queries involving user input.

### Session Protection

Protected pages must verify the session.

### Role Protection

Protected actions must verify the user's role.

### Input Validation

Never directly trust user-submitted values.

---

# 38. MVP Request Flow

Every major feature should follow:

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

No JSP page should directly open a database connection.

No Servlet should contain large amounts of SQL if that SQL can reasonably be placed in a DAO.

---

# 39. MVP Functional Flow

The complete minimum workflow should be:

```text
                    HOME
                      |
             +--------+--------+
             |                 |
          LOGIN             REGISTER
             |                 |
             |          Select Role
             |            /       \
             |           /         \
             |      Job Seeker   Recruiter
             |           |           |
             +-----------+-----------+
                         |
                       LOGIN
                         |
                  Role Verification
                    /          \
                   /            \
                  v              v
           JOB SEEKER        RECRUITER
           DASHBOARD         DASHBOARD
                |                 |
                |                 |
          Search Jobs          Post Job
                |                 |
           View Details       Manage Jobs
                |                 |
              Apply          View Applicants
                |                 |
       My Applications       Update Status
                |                 |
                +--------+--------+
                         |
                       LOGOUT
```

---

# 40. MVP Acceptance Criteria

The MVP is considered complete only when all of the following work.

## Authentication

```text
[ ] User can register
[ ] Duplicate email is rejected
[ ] User can login
[ ] Invalid login is rejected
[ ] Correct dashboard opens based on role
[ ] Logout works
```

## Job Seeker

```text
[ ] Job seeker can update profile
[ ] Job seeker can search jobs
[ ] Job seeker can view job details
[ ] Job seeker can apply
[ ] Duplicate application is prevented
[ ] Job seeker can view applications
[ ] Job seeker can see updated status
```

## Recruiter

```text
[ ] Recruiter can update profile
[ ] Recruiter can post job
[ ] Recruiter can view own jobs
[ ] Recruiter can view applicants
[ ] Recruiter can update application status
```

## Database

```text
[ ] All required tables exist
[ ] Primary keys work
[ ] Foreign keys work
[ ] Data is persisted correctly
[ ] JDBC connection works
```

## Security

```text
[ ] Protected pages require login
[ ] Role restrictions work
[ ] PreparedStatement is used
[ ] Backend validation exists
```

---

# 41. Features Explicitly OUTSIDE the MVP

The following features should NOT be implemented until the complete MVP is stable.

They may be considered future enhancements.

```text
AI job recommendations
AI resume analysis
Chat system
Email notifications
SMS notifications
Video interviews
Online aptitude tests
Payment gateway
Subscription system
Admin analytics
Social networking
Company reviews
Job alerts
Real-time notifications
Advanced recommendation algorithms
OAuth / Google Login
Two-factor authentication
Microservices
Cloud deployment
Mobile application
```

These features increase complexity without being necessary for the mini-project.

---

# 42. Optional Features After MVP

Only after the MVP is fully functional, the following can be considered:

### Saved Jobs

Job seekers can save jobs for later.

### Resume Upload

Allow users to upload PDF resumes.

### Advanced Search

Filters:

```text
Salary
Job Type
Location
Experience
Skills
```

### Dashboard Statistics

For example:

```text
Applications
Shortlisted
Rejected
Jobs Posted
```

### Pagination

Useful if many jobs are displayed.

These features are optional.

---

# 43. What Antigravity Should Build Automatically

Antigravity can assist with:

```text
Project structure
Java model classes
Servlet boilerplate
DAO classes
JDBC queries
JSP pages
HTML
CSS
JavaScript validation
SQL scripts
Form validation
Error handling
Basic documentation
```

However, all generated code must be reviewed and tested.

---

# 44. What the Developer Must Configure Manually

The developer must manually verify:

```text
Java installation
Maven installation
Tomcat installation
MySQL installation
Database creation
Database username
Database password
JDBC driver
Tomcat deployment
Server port
Database port
```

The developer must also manually test:

```text
Registration
Login
Job posting
Job search
Application
Status updates
Logout
Authorization
```

---

# 45. Development Order

The project should be implemented in the following order.

## Step 1 — Environment

```text
Java
Maven
Tomcat
MySQL
IDE
```

## Step 2 — Project Setup

```text
pom.xml
Project structure
DBConnection
Basic JSP
```

## Step 3 — Database

```text
Create database
Create tables
Create relationships
Insert sample data
```

## Step 4 — Authentication

```text
Registration
Login
Session
Logout
Role-based access
```

## Step 5 — Job Seeker

```text
Profile
Search
Job Details
Apply
My Applications
```

## Step 6 — Recruiter

```text
Profile
Post Job
Manage Jobs
Applicants
Status Updates
```

## Step 7 — USPs

```text
Skill Search
Application Tracking
Applicant Dashboard
```

## Step 8 — UI

```text
CSS
Navigation
Cards
Tables
Forms
```

## Step 9 — Testing

```text
Functional Testing
Database Testing
Security Testing
Error Testing
```

## Step 10 — Documentation

```text
README
Architecture
Database Design
Screenshots
ER Diagram
DFD
UML
Test Cases
```

---

# 46. Definition of Done

The Job Portal MVP is considered **DONE** when:

1. A new Job Seeker can register.
2. A new Recruiter can register.
3. Both users can login.
4. Users are redirected to the correct dashboard.
5. Sessions are maintained correctly.
6. Job Seekers can search for jobs.
7. Job Seekers can view job details.
8. Job Seekers can apply for jobs.
9. Duplicate applications are prevented.
10. Job Seekers can view their applications.
11. Recruiters can post jobs.
12. Recruiters can view their jobs.
13. Recruiters can view applicants.
14. Recruiters can update application status.
15. Job Seekers can see updated application status.
16. Logout works.
17. Unauthorized users cannot access protected functionality.
18. Data is correctly stored in MySQL.
19. JDBC is used for database communication.
20. The application runs successfully on Apache Tomcat.

---

# 47. Final MVP Scope

The final MVP should provide the following complete experience:

```text
                         JOB PORTAL
                              |
              +---------------+---------------+
              |                               |
              v                               v
         JOB SEEKER                       RECRUITER
              |                               |
          Register                         Register
              |                               |
            Login                            Login
              |                               |
          Dashboard                       Dashboard
              |                               |
        Search Jobs                       Post Jobs
              |                               |
        View Job                         Manage Jobs
              |                               |
           Apply                       View Applicants
              |                               |
     My Applications                 Update Status
              |                               |
              +---------------+---------------+
                              |
                            MySQL
                              |
                            JDBC
                              |
                          Servlets
                              |
                             JSP
```

The MVP deliberately focuses on the **core job portal workflow** and the three project USPs:

1. **Skill-Based Job Search**
2. **Application Status Tracking**
3. **Recruiter Applicant Dashboard**

Any additional functionality should be implemented only after the above workflow is stable, tested and documented.
