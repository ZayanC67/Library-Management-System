-- ============================================================
-- Library Management System - Database Setup Script
-- Database: library_management_system
-- ============================================================

-- Create and select database
CREATE DATABASE IF NOT EXISTS lms;
USE lms;

-- ============================================================
-- TABLE 1: student
-- ============================================================
CREATE TABLE IF NOT EXISTS student (
    usn         VARCHAR(20) PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    semester    INT NOT NULL,
    branch      VARCHAR(50) NOT NULL,
    phone_no    VARCHAR(15) NOT NULL,
    password    VARCHAR(100) NOT NULL
);

-- ============================================================
-- TABLE 2: books
-- ============================================================
CREATE TABLE IF NOT EXISTS books (
    book_id             INT PRIMARY KEY AUTO_INCREMENT,
    book_name           VARCHAR(150) NOT NULL,
    author_name         VARCHAR(100) NOT NULL,
    availability_status VARCHAR(20) DEFAULT 'Available'
);

-- ============================================================
-- TABLE 3: book_issue
-- ============================================================
CREATE TABLE IF NOT EXISTS book_issue (
    issue_id   INT PRIMARY KEY AUTO_INCREMENT,
    book_id    INT NOT NULL,
    issue_date DATE NOT NULL,
    usn        VARCHAR(20) NOT NULL,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (usn)     REFERENCES student(usn)
);

-- ============================================================
-- TABLE 4: book_return
-- ============================================================
CREATE TABLE IF NOT EXISTS book_return (
    return_id   INT PRIMARY KEY AUTO_INCREMENT,
    book_id     INT NOT NULL,
    return_date DATE NOT NULL,
    usn         VARCHAR(20) NOT NULL,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (usn)     REFERENCES student(usn)
);

-- ============================================================
-- TABLE 5: book_request
-- ============================================================
CREATE TABLE IF NOT EXISTS book_request (
    request_id        INT PRIMARY KEY AUTO_INCREMENT,
    book_id           INT NOT NULL,
    usn               VARCHAR(20) NOT NULL,
    request_date      DATE NOT NULL,
    status            VARCHAR(20) NOT NULL DEFAULT 'Pending',
    librarian_comment VARCHAR(255),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (usn)     REFERENCES student(usn)
);

-- ============================================================
-- TABLE 6: return_request
-- ============================================================
CREATE TABLE IF NOT EXISTS return_request (
    request_id        INT PRIMARY KEY AUTO_INCREMENT,
    book_id           INT NOT NULL,
    usn               VARCHAR(20) NOT NULL,
    request_date      DATE NOT NULL,
    status            VARCHAR(20) NOT NULL DEFAULT 'Pending',
    librarian_comment VARCHAR(255),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (usn)     REFERENCES student(usn)
);

-- ============================================================
-- TABLE 7: issue_receipt
-- ============================================================
CREATE TABLE IF NOT EXISTS issue_receipt (
    receipt_id      INT PRIMARY KEY AUTO_INCREMENT,
    request_id      INT NOT NULL,
    receipt_number  VARCHAR(50) NOT NULL,
    generated_date  DATE NOT NULL,
    due_date        DATE NOT NULL,
    approval_status VARCHAR(20) NOT NULL,
    FOREIGN KEY (request_id) REFERENCES book_request(request_id)
);

-- ============================================================
-- TABLE 8: return_receipt
-- ============================================================
CREATE TABLE IF NOT EXISTS return_receipt (
    receipt_id      INT PRIMARY KEY AUTO_INCREMENT,
    request_id      INT NOT NULL,
    receipt_number  VARCHAR(50) NOT NULL,
    generated_date  DATE NOT NULL,
    fine_amount     DECIMAL(10,2) NOT NULL,
    return_status   VARCHAR(20) NOT NULL,
    FOREIGN KEY (request_id) REFERENCES return_request(request_id)
);

-- ============================================================
-- TABLE 9: librarian
-- ============================================================
CREATE TABLE IF NOT EXISTS librarian (
    librarian_id   INT PRIMARY KEY AUTO_INCREMENT,
    librarian_name VARCHAR(100) NOT NULL,
    username       VARCHAR(50)  NOT NULL UNIQUE,
    password       VARCHAR(100) NOT NULL
);

-- ============================================================
-- TABLE 6: payment
-- ============================================================
CREATE TABLE IF NOT EXISTS payment (
    payment_id   INT PRIMARY KEY AUTO_INCREMENT,
    payment_type VARCHAR(50) NOT NULL,
    payment_date DATE NOT NULL,
    amount       DECIMAL(10,2) NOT NULL,
    usn          VARCHAR(20) NOT NULL,
    FOREIGN KEY (usn) REFERENCES student(usn)
);

-- ============================================================
-- SAMPLE DATA - Librarian accounts
-- ============================================================
INSERT INTO librarian (librarian_name, username, password) VALUES
('Admin Librarian', 'admin', 'admin123'),
('John Smith', 'john', 'john123');

-- ============================================================
-- SAMPLE DATA - Students
-- ============================================================
INSERT INTO student (usn, student_name, semester, branch, phone_no, password) VALUES
('1RN21CS001', 'Alice Johnson', 4, 'CSE', '9876543210', 'alice123'),
('1RN21CS002', 'Bob Williams', 4, 'CSE', '9876543211', 'bob123'),
('1RN21IS001', 'Charlie Brown', 6, 'ISE', '9876543212', 'charlie123');

-- ============================================================
-- SAMPLE DATA - Books
-- ============================================================
INSERT INTO books (book_name, author_name, availability_status) VALUES
('Introduction to Algorithms', 'Thomas H. Cormen', 'Available'),
('Clean Code', 'Robert C. Martin', 'Available'),
('Design Patterns', 'Gang of Four', 'Available'),
('The Pragmatic Programmer', 'Andrew Hunt', 'Available'),
('Java: The Complete Reference', 'Herbert Schildt', 'Available'),
('Database System Concepts', 'Abraham Silberschatz', 'Available'),
('Operating System Concepts', 'Abraham Silberschatz', 'Available'),
('Computer Networks', 'Andrew S. Tanenbaum', 'Available'),
('Artificial Intelligence: A Modern Approach', 'Stuart Russell', 'Available'),
('Structure and Interpretation of Computer Programs', 'Harold Abelson', 'Available');

-- ============================================================
-- End of script
-- ============================================================
