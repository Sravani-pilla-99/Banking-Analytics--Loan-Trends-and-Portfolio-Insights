CREATE DATABASE IF NOT EXISTS  bankloan_db;

USE bankloan_db;
SET GLOBAL max_allowed_packet=1073741824;
SET GLOBAL local_infile=1;

CREATE TABLE IF NOT EXISTS bankloan_data (
    id INT PRIMARY KEY,
    address_state VARCHAR(50),
    application_type VARCHAR(50),
    emp_length VARCHAR(50),
    emp_title VARCHAR(255),
    grade CHAR(1),
    home_ownership VARCHAR(50),
    issue_date DATE,
    last_credit_pull_date DATE,
    last_payment_date DATE,
    loan_status VARCHAR(50),
    next_payment_date DATE,
    member_id INT,
    purpose VARCHAR(100),
    sub_grade VARCHAR(50),
    term VARCHAR(50),
    verification_status VARCHAR(50),
    annual_income DECIMAL(10, 2),
    dti DECIMAL(5, 4),
    installment DECIMAL(10, 2),
    int_rate DECIMAL(5, 4),
    loan_amount INT,
    total_acc INT,
    total_payment INT
);

LOAD DATA LOCAL INFILE '/Users/sravanipilla/Downloads/financial_loan_formatted.csv'
INTO TABLE bankloan_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM bankloan_data;

SELECT COUNT(id) as Total_Loan_Applications FROM bankloan_data;

SELECT COUNT(id) as MTD_Total_Loan_Applications FROM bankloan_data
WHERE MONTH(issue_date)=12;

SELECT COUNT(id) as PMTD_Total_Loan_Applications FROM bankloan_data
WHERE MONTH(issue_date)=11;

--  FOR MOM%: MTD-PMTD/PMTD

SELECT SUM(loan_amount) AS Total_Funded_Amount FROM bankloan_data;

SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount FROM bankloan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date)= 2021;

SELECT SUM(loan_amount) AS PMTD_Total_Funded_Amount FROM bankloan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date)= 2021;

SELECT SUM(total_payment) AS Total_Amount_Collected FROM bankloan_data;

SELECT SUM(total_payment) AS MTD_Total_Amount_Collected FROM bankloan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date)= 2021;

SELECT SUM(total_payment) AS PMTD_Total_Amount_Collected FROM bankloan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date)= 2021;

SELECT ROUND(AVG(int_rate)*100,2) AS Avg_Intrest_Rate FROM bankloan_data;

SELECT ROUND(AVG(int_rate)*100,2) AS MTD_Avg_Intrest_Rate FROM bankloan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date)= 2021;

SELECT ROUND(AVG(int_rate)*100,2) AS PMTD_Avg_Intrest_Rate FROM bankloan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date)= 2021;

SELECT ROUND(AVG(dti)*100,2) AS Avg_DTI FROM bankloan_data;

SELECT ROUND(AVG(dti)*100,2) AS MTD_Avg_DTI FROM bankloan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date)= 2021;

SELECT ROUND(AVG(dti)*100,2) AS PMTD_Avg_DTI FROM bankloan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date)= 2021;

-- GOOD LOAN VS BAD LOAN

SELECT
    (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100.0) / 
	COUNT(id) AS Good_Loan_Percentage
FROM bankloan_data;

SELECT COUNT(id) AS Good_Loan_Applications FROM bankloan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

SELECT SUM(loan_amount) AS Good_Loan_Funded_amount FROM bankloan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

SELECT SUM(total_payment) AS Good_Loan_amount_received_amount FROM bankloan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

SELECT
    (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0) / 
	COUNT(id) AS Bad_Loan_Percentage
FROM bankloan_data;

SELECT COUNT(id) AS Bad_Loan_Applications FROM bankloan_data
WHERE loan_status = 'Charged Off';

SELECT SUM(loan_amount) AS Bad_Loan_Funded_amount FROM bankloan_data
WHERE loan_status = 'Charged Off';

SELECT SUM(total_payment) AS Bad_Loan_amount_received FROM bankloan_data
WHERE loan_status = 'Charged Off';

-- LOAN STATUS

SELECT
        loan_status,
        COUNT(id) AS LoanCount,
        SUM(total_payment) AS Total_Amount_Received,
        SUM(loan_amount) AS Total_Funded_Amount,
        AVG(int_rate * 100) AS Interest_Rate,
        AVG(dti * 100) AS DTI
    FROM
        bankloan_data
    GROUP BY
        loan_status;

SELECT 
	loan_status, 
	SUM(total_payment) AS MTD_Total_Amount_Received, 
	SUM(loan_amount) AS MTD_Total_Funded_Amount 
FROM bankloan_data
WHERE MONTH(issue_date) = 12 
GROUP BY loan_status;

-- OVERVIEW DASHBOARD

SELECT 
	MONTH(issue_date) AS Month_number, 
	MONTHNAME(issue_date) AS Month_name, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bankloan_data
GROUP BY MONTH(issue_date), MONTHNAME(issue_date)
ORDER BY MONTH(issue_date);

SELECT 
	address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bankloan_data
GROUP BY address_state
ORDER BY Total_Funded_Amount DESC;

SELECT 
	term AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bankloan_data
GROUP BY term
ORDER BY term;

SELECT 
	emp_length AS Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bankloan_data
GROUP BY emp_length
ORDER BY Total_Loan_Applications DESC;

SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bankloan_data
GROUP BY purpose
ORDER BY Total_Loan_Applications DESC;

SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bankloan_data
GROUP BY home_ownership
ORDER BY Total_Loan_Applications DESC;

-- DETAILS

SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bankloan_data
WHERE grade = 'A'
GROUP BY purpose
ORDER BY purpose;

