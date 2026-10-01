-- =======================================================
-- Job Portal System - Database Schema
-- Phase 2: Database & JDBC Setup
-- Target Database: MySQL 8.0+
-- =======================================================

-- 1. Create Database
CREATE DATABASE IF NOT EXISTS job_portal_db;
USE job_portal_db;

-- 2. Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Job Seeker Profile Table
CREATE TABLE IF NOT EXISTS jobseeker_profile (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    phone VARCHAR(20),
    skills VARCHAR(500),
    education VARCHAR(255),
    experience VARCHAR(255),
    location VARCHAR(100),
    CONSTRAINT fk_jobseeker_user FOREIGN KEY (user_id) 
        REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Recruiter Profile Table
CREATE TABLE IF NOT EXISTS recruiter_profile (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    company_name VARCHAR(150) NOT NULL,
    phone VARCHAR(20),
    location VARCHAR(100),
    description TEXT,
    CONSTRAINT fk_recruiter_user FOREIGN KEY (user_id) 
        REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Jobs Table
CREATE TABLE IF NOT EXISTS jobs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recruiter_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    skills VARCHAR(500) NOT NULL,
    location VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_jobs_recruiter FOREIGN KEY (recruiter_id) 
        REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. Applications Table
CREATE TABLE IF NOT EXISTS applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    job_id INT NOT NULL,
    jobseeker_id INT NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'APPLIED',
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_applications_job FOREIGN KEY (job_id) 
        REFERENCES jobs(id) ON DELETE CASCADE,
    CONSTRAINT fk_applications_jobseeker FOREIGN KEY (jobseeker_id) 
        REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT uk_job_jobseeker UNIQUE (job_id, jobseeker_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
