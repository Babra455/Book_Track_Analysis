CREATE TABLE books_data (
    isbn VARCHAR(20) PRIMARY KEY,
    book_title VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    status VARCHAR(50),
    author VARCHAR(255),
    publisher VARCHAR(255),
    rental_price VARCHAR(20)
);

CREATE TABLE branch_data (
    branch_id VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(20),
    branch_address VARCHAR(255),
    contact_no VARCHAR(50)
);


CREATE TABLE employees_data (
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(255) NOT NULL,
    position VARCHAR(100),
    branch_id VARCHAR(20),
    salary VARCHAR(20)
);
CREATE TABLE issued_status (
    issued_id VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR(10) NOT NULL,   
    issued_book_name VARCHAR(255) NOT NULL,
    issued_date DATE NOT NULL,               
    issued_book_isbn VARCHAR(20) NOT NULL,
    issued_emp_id VARCHAR(10)
);

CREATE TABLE member_data (
    member_id VARCHAR(10) PRIMARY KEY,
    member_name VARCHAR(255) NOT NULL,
    member_address VARCHAR(255),
    reg_date VARCHAR(20)
);

CREATE TABLE return_status (
    return_id VARCHAR(10) PRIMARY KEY,
    return_book_isbn VARCHAR(20) NOT NULL,
    return_book_name VARCHAR(255) NOT NULL,
    return_date VARCHAR(50) NOT NULL,
    book_quality VARCHAR(50),
    issued_id VARCHAR(10)
);

SELECT 
    emp.emp_id,
    emp.emp_name,
    emp.position,
    branch.branch_id,
    branch.branch_address
FROM employees_data emp
INNER JOIN branch_data branch
    ON emp.branch_id = branch.branch_id;

-- Members and overdue dates
SELECT 
    member.member_name,
    issued.issued_book_name,
    issued.issued_date,
    DATEDIFF(CURDATE(), issued.issued_date) AS days_overdue,
    DATEDIFF(CURDATE(), issued.issued_date) * book.rental_price AS fine
FROM issued_status issued
JOIN member_data member ON issued.issued_member_id = member.member_id
JOIN books_data book ON issued.issued_book_isbn = book.isbn
WHERE DATEDIFF(CURDATE(), issued.issued_date) > 30
ORDER BY days_overdue DESC;

UPDATE books_data
SET status = 
    CASE
        WHEN LOWER(status) = 'yes' THEN 'Yes'
        WHEN LOWER(status) = 'no' THEN 'No'
        ELSE status
    END;

-- Convert rental_price
ALTER TABLE books_data
MODIFY COLUMN rental_price DECIMAL(8,2);

-- Convert salary
ALTER TABLE employees_data
MODIFY COLUMN salary DECIMAL(10,2);

-- Branch Performance
SELECT 
    branch.branch_id,
    COUNT(DISTINCT issued.issued_id) AS total_issued,
    COUNT(DISTINCT returns.return_id) AS total_returned,
    SUM(book.rental_price) AS revenue_generated
FROM branch_data AS branch
LEFT JOIN employees_data AS employee
    ON branch.branch_id = employee.branch_id
LEFT JOIN issued_status AS issued
    ON issued.issued_emp_id = employee.emp_id
LEFT JOIN return_status AS returns
    ON returns.issued_id = issued.issued_id
LEFT JOIN books_data AS book
    ON issued.issued_book_isbn = book.isbn
GROUP BY branch.branch_id;

-- Employee Book Processing Summary
SELECT 
    employee.emp_name,
    employee.branch_id,
    COUNT(issued.issued_id) AS books_processed
FROM employees_data AS employee
LEFT JOIN issued_status AS issued
    ON employee.emp_id = issued.issued_emp_id
GROUP BY employee.emp_id
ORDER BY books_processed DESC;

-- Members with Damaged Returns
SELECT 
    member.member_name,
    COUNT(returns.return_id) AS damaged_count
FROM return_status AS returns
JOIN issued_status AS issued
    ON returns.issued_id = issued.issued_id
JOIN member_data AS member
    ON issued.issued_member_id = member.member_id
WHERE UPPER(returns.book_quality) = 'DAMAGED'
GROUP BY member.member_id
HAVING damaged_count > 0;


-- Returned Books and Their Status
SELECT 
    returns.return_book_name,
    returns.return_date,
    returns.book_quality,
    book.status
FROM return_status AS returns
JOIN books_data AS book
    ON returns.return_book_isbn = book.isbn;


-- Overdue Books
SELECT 
    issued.issued_id,
    issued.issued_book_name,
    issued.issued_member_id,
    member.member_name,
    issued.issued_date,
    DATEDIFF(CURDATE(), issued.issued_date) AS days_held
FROM issued_status AS issued
JOIN member_data AS member
    ON issued.issued_member_id = member.member_id
LEFT JOIN return_status AS returns
    ON issued.issued_id = returns.issued_id
WHERE DATEDIFF(CURDATE(), issued.issued_date) > 30
  AND returns.return_date IS NULL;
  
-- Slow Returns
SELECT 
    issued.issued_id,
    issued.issued_book_name,
    issued.issued_member_id,
    issued.issued_date
FROM issued_status AS issued
LEFT JOIN return_status AS returns
    ON issued.issued_id = returns.issued_id
WHERE returns.return_date IS NULL;

-- Members Count
SELECT 
    COUNT(*) AS total_members,
    COUNT(issued.issued_date) AS members_with_dates,
    COUNT(*) - COUNT(issued.issued_date) AS members_with_null_dates
FROM member_data AS member
LEFT JOIN issued_status AS issued
    ON member.member_id = issued.issued_member_id;
    
-- Member Engagement
SELECT 
    member.member_id,
    member.member_name,
    MAX(issued.issued_date) AS last_borrowed_date,
    CASE
        WHEN MAX(issued.issued_date) IS NULL THEN 'Never Borrowed'
        WHEN MAX(issued.issued_date) >= DATE_SUB(CURDATE(), INTERVAL 90 DAY) THEN 'Active'
        ELSE 'Inactive'
    END AS engagement_status
FROM member_data AS member
LEFT JOIN issued_status AS issued
    ON member.member_id = issued.issued_member_id
GROUP BY member.member_id, member.member_name;

-- Damaged Books
SELECT
    returns.issued_id,
    issued.issued_book_name,
    issued.issued_member_id,
    member.member_name,
    returns.return_date,
    returns.book_quality
FROM return_status AS returns
JOIN issued_status AS issued
    ON returns.issued_id = issued.issued_id
JOIN member_data AS member
    ON issued.issued_member_id = member.member_id
WHERE UPPER(returns.book_quality) = 'DAMAGED';

-- Book Availability
SELECT 
    issued.issued_book_name,
    COUNT(issued.issued_id) AS times_issued,
    GROUP_CONCAT(issued.issued_member_id) AS member_ids
FROM issued_status AS issued
LEFT JOIN return_status AS returns
    ON issued.issued_id = returns.issued_id
WHERE returns.return_date IS NULL
GROUP BY issued.issued_book_name
HAVING COUNT(issued.issued_id) > 1;

-- Total Books Issued
SELECT 
    branch.branch_id,
    COUNT(DISTINCT issued.issued_id) AS total_issued,
    COUNT(DISTINCT returns.return_id) AS total_returned,
    COUNT(DISTINCT issued.issued_id) - COUNT(DISTINCT returns.return_id) AS outstanding_books,
    ROUND(
        COUNT(DISTINCT returns.return_id) * 100.0 / 
        NULLIF(COUNT(DISTINCT issued.issued_id), 0), 2
    ) AS return_rate_percentage,
    SUM(book.rental_price) AS revenue_generated,
    ROUND(
        SUM(book.rental_price) / 
        NULLIF(COUNT(DISTINCT issued.issued_id), 0), 2
    ) AS avg_revenue_per_issue
FROM branch_data AS branch
LEFT JOIN employees_data AS employee
    ON branch.branch_id = employee.branch_id
LEFT JOIN issued_status AS issued
    ON issued.issued_emp_id = employee.emp_id
LEFT JOIN return_status AS returns
    ON returns.issued_id = issued.issued_id
LEFT JOIN books_data AS book
    ON issued.issued_book_isbn = book.isbn
GROUP BY branch.branch_id;


-- Overdue Days
SELECT 
    issued.issued_id,
    issued.issued_book_name,
    issued.issued_member_id,
    member.member_name,
    issued.issued_date,
    DATEDIFF(CURDATE(), issued.issued_date) AS days_overdue
FROM issued_status AS issued
JOIN member_data AS member
    ON issued.issued_member_id = member.member_id
LEFT JOIN return_status AS returns
    ON issued.issued_id = returns.issued_id
WHERE DATEDIFF(CURDATE(), issued.issued_date) > 30
  AND returns.return_date IS NULL;



-- Automatically identify overdue books (over 30 days and not returned)
SELECT 
    issued.issued_id,
    issued.issued_book_name,
    issued.issued_member_id,
    member.member_name,
    issued.issued_date,
    DATEDIFF(CURDATE(), issued.issued_date) AS days_overdue
FROM issued_status AS issued
JOIN member_data AS member
    ON issued.issued_member_id = member.member_id
LEFT JOIN return_status AS returns
    ON issued.issued_id = returns.issued_id
WHERE DATEDIFF(CURDATE(), issued.issued_date) > 30
  AND returns.return_date IS NULL;
  
-- Overdue Day plus overdue fines
WITH overdue_books AS (
    SELECT 
        issued.issued_id,
        issued.issued_book_name,
        issued.issued_member_id,
        member.member_name,
        issued.issued_date,
        DATEDIFF(CURDATE(), issued.issued_date) AS days_overdue
    FROM issued_status AS issued
    JOIN member_data AS member
        ON issued.issued_member_id = member.member_id
    LEFT JOIN return_status AS returns
        ON issued.issued_id = returns.issued_id
    WHERE DATEDIFF(CURDATE(), issued.issued_date) > 30
      AND returns.return_date IS NULL
)

SELECT 
    overdue_books.issued_id,
    overdue_books.issued_book_name,
    overdue_books.issued_member_id,
    overdue_books.member_name,
    overdue_books.issued_date,
    overdue_books.days_overdue,
    ROUND(overdue_books.days_overdue * 0.5, 0) AS overdue_fine
FROM overdue_books
ORDER BY overdue_books.days_overdue DESC;


