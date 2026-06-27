create database bank_system;
USE bank_system;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender ENUM('Male','Female','Other') NOT NULL,
    date_of_birth DATE NOT NULL,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    address VARCHAR(255) NOT NULL,
    aadhaar_no VARCHAR(12) UNIQUE,
    customer_status ENUM('Active','Inactive','Blocked')
        DEFAULT 'Active',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
show tables;
desc customers;	

CREATE TABLE branches (
    branch_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    ifsc_code VARCHAR(20) UNIQUE NOT NULL,
    phone VARCHAR(15)
);
SHOW TABLES;
desc branches;

CREATE TABLE account_types(
account_type_id INT AUTO_INCREMENT PRIMARY KEY,
type_name VARCHAR(30) UNIQUE NOT NULL,
minimum_balance DECIMAL(12,2) NOT NULL
);
DESC account_types;

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    designation VARCHAR(50) NOT NULL,
    salary DECIMAL(12,2) NOT NULL,
    hire_date DATE NOT NULL,
    phone VARCHAR(15) UNIQUE,
    FOREIGN KEY (branch_id)REFERENCES branches(branch_id)
);
desc employees;

CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    account_type_id INT NOT NULL,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    balance DECIMAL(15,2) NOT NULL,
    open_date DATE NOT NULL,
    account_status ENUM('Active','Dormant','Closed') DEFAULT 'Active',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
	FOREIGN KEY (account_type_id) REFERENCES account_types(account_type_id)
);
desc accounts;
SHOW CREATE TABLE accounts;

CREATE TABLE beneficiaries (
    beneficiary_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    beneficiary_name VARCHAR(100) NOT NULL,
    beneficiary_account_no VARCHAR(20) NOT NULL,
    bank_name VARCHAR(100) NOT NULL,
    ifsc_code VARCHAR(20) NOT NULL,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);
desc beneficiaries;

CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    beneficiary_id INT,
    transaction_type ENUM('Deposit','Withdrawal','Transfer') NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    transaction_status ENUM('Success','Failed','Pending') DEFAULT 'Success',
    FOREIGN KEY (account_id) REFERENCES accounts(account_id), 
    FOREIGN KEY (beneficiary_id) REFERENCES beneficiaries(beneficiary_id)
);
desc transactions;
show tables;

CREATE TABLE cards (
    card_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    card_number VARCHAR(20) UNIQUE NOT NULL,
    card_type ENUM('Debit','Credit') NOT NULL,
    issue_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    card_status ENUM('Active','Blocked','Expired') DEFAULT 'Active',
    FOREIGN KEY (account_id)
    REFERENCES accounts(account_id)
);
desc cards;

CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    loan_type VARCHAR(50) NOT NULL,
    loan_amount DECIMAL(15,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    start_date DATE NOT NULL,
    tenure_months INT NOT NULL,
    loan_status ENUM('Active','Closed') DEFAULT 'Active',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE emi_payments (
    emi_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    emi_amount DECIMAL(15,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_status ENUM('Paid','Pending','Missed') DEFAULT 'Pending',
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);
desc emi_payments;

CREATE TABLE fraud_alerts (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT NOT NULL,
    alert_type VARCHAR(100) NOT NULL,
    risk_level ENUM('Low','Medium','High') NOT NULL,
    alert_date DATETIME DEFAULT CURRENT_TIMESTAMP,
	alert_status ENUM('Open','Investigating','Resolved') DEFAULT 'Open',
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);
desc fraud_alerts;

show tables;

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE REFERENCED_TABLE_NAME IS NOT NULL
AND TABLE_SCHEMA = DATABASE();

INSERT INTO branches
(branch_name, city, state, ifsc_code, phone)
VALUES
('Chennai Main Branch', 'Chennai', 'Tamil Nadu', 'SBIN0001001', '9876500001'),
('Coimbatore Branch', 'Coimbatore', 'Tamil Nadu', 'SBIN0001002', '9876500002'),
('Madurai Branch', 'Madurai', 'Tamil Nadu', 'SBIN0001003', '9876500003'),
('Bangalore Branch', 'Bangalore', 'Karnataka', 'SBIN0001004', '9876500004'),
('Hyderabad Branch', 'Hyderabad', 'Telangana', 'SBIN0001005', '9876500005');

select * from branches;

INSERT INTO account_types
(type_name, minimum_balance)
VALUES
('Savings', 1000.00),
('Current', 5000.00),
('Salary', 0.00);
select * from account_types;

INSERT INTO customers
(first_name, last_name, gender, date_of_birth, phone, email, address, aadhaar_no, customer_status)
VALUES
('Arun', 'Kumar', 'Male', '1995-03-15', '9000000001', 'arun.kumar@gmail.com', 'Chennai', '123456789001', 'Active'),
('Priya', 'Sharma', 'Female', '1998-07-22', '9000000002', 'priya.sharma@gmail.com', 'Coimbatore', '123456789002', 'Active'),
('Rahul', 'Verma', 'Male', '1992-11-10', '9000000003', 'rahul.verma@yahoo.com', 'Madurai', '123456789003', 'Active'),
('Sneha', 'Reddy', 'Female', '1997-05-18', '9000000004', 'sneha.reddy@gmail.com', 'Hyderabad', '123456789004', 'Active'),
('Karthik', 'Rajan', 'Male', '1994-09-25', '9000000005', 'karthik.rajan@gmail.com', 'Chennai', '123456789005', 'Inactive'),
('Divya', 'Nair', 'Female', '1996-12-30', '9000000006', 'divya.nair@gmail.com', 'Bangalore', '123456789006', 'Active'),
('Vijay', 'Singh', 'Male', '1991-08-14', '9000000007', 'vijay.singh@yahoo.com', 'Coimbatore', '123456789007', 'Blocked'),
('Anitha', 'Das', 'Female', '1999-04-12', '9000000008', 'anitha.das@gmail.com', 'Madurai', '123456789008', 'Active'),
('Rohit', 'Mehta', 'Male', '1993-06-08', '9000000009', 'rohit.mehta@gmail.com', 'Hyderabad', '123456789009', 'Active'),
('Meera', 'Iyer', 'Female', '1995-01-20', '9000000010', 'meera.iyer@gmail.com', 'Chennai', '123456789010', 'Active');
SELECT COUNT(*) FROM customers;
INSERT INTO customers
(first_name, last_name, gender, date_of_birth, phone, email, address, aadhaar_no, customer_status)
VALUES
('Ajay','Menon','Male','1994-02-11','9000000011','ajay.menon@gmail.com','Bangalore','123456789011','Active'),
('Lakshmi','Krishnan','Female','1997-03-22','9000000012','lakshmi.krishnan@gmail.com','Chennai','123456789012','Active'),
('Suresh','Patel','Male','1990-07-19','9000000013','suresh.patel@yahoo.com','Hyderabad','123456789013','Active'),
('Keerthana','Mohan','Female','1998-05-14','9000000014','keerthana.mohan@gmail.com','Madurai','123456789014','Active'),
('Manoj','Kumar','Male','1993-09-09','9000000015','manoj.kumar@gmail.com','Coimbatore','123456789015','Inactive'),
('Nisha','Rao','Female','1996-11-25','9000000016','nisha.rao@gmail.com','Bangalore','123456789016','Active'),
('Praveen','Joshi','Male','1991-08-30','9000000017','praveen.joshi@yahoo.com','Chennai','123456789017','Blocked'),
('Asha','Gupta','Female','1995-12-17','9000000018','asha.gupta@gmail.com','Hyderabad','123456789018','Active'),
('Deepak','Sharma','Male','1992-04-06','9000000019','deepak.sharma@gmail.com','Madurai','123456789019','Active'),
('Pooja','Nair','Female','1999-01-28','9000000020','pooja.nair@gmail.com','Coimbatore','123456789020','Active');
SELECT COUNT(*) FROM customers;
INSERT INTO customers
(first_name, last_name, gender, date_of_birth, phone, email, address, aadhaar_no, customer_status)
VALUES
('Harish','Babu','Male','1994-06-15','9000000021','harish.babu@gmail.com','Chennai','123456789021','Active'),
('Swathi','Ramesh','Female','1997-02-18','9000000022','swathi.ramesh@gmail.com','Bangalore','123456789022','Active'),
('Naveen','Karthik','Male','1993-09-21','9000000023','naveen.karthik@yahoo.com','Coimbatore','123456789023','Active'),
('Bhavya','Srinivas','Female','1998-12-05','9000000024','bhavya.srinivas@gmail.com','Hyderabad','123456789024','Active'),
('Arvind','Rao','Male','1991-03-14','9000000025','arvind.rao@gmail.com','Madurai','123456789025','Inactive'),
('Gayathri','Menon','Female','1996-08-27','9000000026','gayathri.menon@gmail.com','Chennai','123456789026','Active'),
('Sanjay','Patil','Male','1992-11-30','9000000027','sanjay.patil@yahoo.com','Bangalore','123456789027','Blocked'),
('Ritika','Jain','Female','1999-04-11','9000000028','ritika.jain@gmail.com','Hyderabad','123456789028','Active'),
('Vignesh','Kumar','Male','1995-07-19','9000000029','vignesh.kumar@gmail.com','Coimbatore','123456789029','Active'),
('Preethi','Iyer','Female','1997-10-23','9000000030','preethi.iyer@gmail.com','Madurai','123456789030','Active');
INSERT INTO customers
(first_name, last_name, gender, date_of_birth, phone, email, address, aadhaar_no, customer_status)
VALUES
('Kiran','Shetty','Male','1990-01-17','9000000031','kiran.shetty@gmail.com','Bangalore','123456789031','Active'),
('Anjali','Reddy','Female','1998-06-09','9000000032','anjali.reddy@gmail.com','Hyderabad','123456789032','Active'),
('Madhan','Vel','Male','1993-12-25','9000000033','madhan.vel@yahoo.com','Chennai','123456789033','Active'),
('Shalini','Nair','Female','1996-05-14','9000000034','shalini.nair@gmail.com','Coimbatore','123456789034','Active'),
('Prakash','Singh','Male','1992-08-18','9000000035','prakash.singh@gmail.com','Madurai','123456789035','Inactive'),
('Keerthi','Das','Female','1997-11-21','9000000036','keerthi.das@gmail.com','Bangalore','123456789036','Active'),
('Ramesh','Kumar','Male','1991-04-28','9000000037','ramesh.kumar@yahoo.com','Hyderabad','123456789037','Blocked'),
('Divya','Patel','Female','1999-09-03','9000000038','divya.patel@gmail.com','Chennai','123456789038','Active'),
('Lokesh','Mohan','Male','1994-02-07','9000000039','lokesh.mohan@gmail.com','Coimbatore','123456789039','Active'),
('Nandhini','Raj','Female','1998-07-30','9000000040','nandhini.raj@gmail.com','Madurai','123456789040','Active');
INSERT INTO customers
(first_name, last_name, gender, date_of_birth, phone, email, address, aadhaar_no, customer_status)
VALUES
('Ashok','Verma','Male','1993-05-16','9000000041','ashok.verma@gmail.com','Chennai','123456789041','Active'),
('Megha','Sharma','Female','1997-01-12','9000000042','megha.sharma@gmail.com','Bangalore','123456789042','Active'),
('Ravi','Krishna','Male','1990-10-20','9000000043','ravi.krishna@yahoo.com','Hyderabad','123456789043','Active'),
('Pavithra','Menon','Female','1998-03-08','9000000044','pavithra.menon@gmail.com','Coimbatore','123456789044','Active'),
('Dinesh','Rajan','Male','1994-12-15','9000000045','dinesh.rajan@gmail.com','Madurai','123456789045','Active'),
('Monika','Gupta','Female','1996-07-27','9000000046','monika.gupta@gmail.com','Chennai','123456789046','Inactive'),
('Sathish','Babu','Male','1992-09-04','9000000047','sathish.babu@yahoo.com','Bangalore','123456789047','Blocked'),
('Aarthi','Suresh','Female','1999-02-19','9000000048','aarthi.suresh@gmail.com','Hyderabad','123456789048','Active'),
('Vinod','Patel','Male','1991-11-11','9000000049','vinod.patel@gmail.com','Coimbatore','123456789049','Active'),
('Revathi','Kannan','Female','1997-08-24','9000000050','revathi.kannan@gmail.com','Madurai','123456789050','Active');
SELECT * FROM customers;

INSERT INTO employees
(branch_id, first_name, last_name, designation, salary, hire_date, phone)
VALUES
(1,'Rajesh','Kumar','Manager',75000.00,'2020-01-15','8000000001'),
(1,'Priya','Menon','Cashier',35000.00,'2021-03-10','8000000002'),
(1,'Vignesh','Rao','Officer',45000.00,'2022-06-20','8000000003'),
(1,'Meena','Iyer','Clerk',30000.00,'2023-02-12','8000000004'),
(1,'Harish','Kumar','Customer Service Executive',32000.00,'2023-06-15','8000000005'),
(2,'Suresh','Patel','Manager',72000.00,'2019-08-18','8000000006'),
(2,'Anitha','Das','Cashier',34000.00,'2021-04-15','8000000007'),
(2,'Karthik','Rajan','Officer',44000.00,'2022-07-01','8000000008'),
(2,'Pooja','Sharma','Clerk',29000.00,'2023-01-08','8000000009'),
(2,'Gayathri','Menon','Customer Service Executive',32000.00,'2023-06-18','8000000010'),
(3,'Arun','Babu','Manager',71000.00,'2020-05-11','8000000011'),
(3,'Lakshmi','Nair','Cashier',33000.00,'2021-06-14','8000000012'),
(3,'Deepak','Verma','Officer',43000.00,'2022-08-21','8000000013'),
(3,'Sneha','Reddy','Clerk',28000.00,'2023-03-04','8000000014'),
(3,'Praveen','Joshi','Customer Service Executive',32000.00,'2023-06-20','8000000015'),
(4,'Ravi','Krishna','Manager',76000.00,'2019-12-01','8000000016'),
(4,'Divya','Patel','Cashier',36000.00,'2021-02-17','8000000017'),
(4,'Lokesh','Mohan','Officer',46000.00,'2022-05-19','8000000018'),
(4,'Asha','Gupta','Clerk',31000.00,'2023-04-10','8000000019'),
(4,'Keerthi','Das','Customer Service Executive',32000.00,'2023-06-22','8000000020'),
(5,'Madhan','Vel','Manager',74000.00,'2020-09-25','8000000021'),
(5,'Bhavya','Srinivas','Cashier',35000.00,'2021-07-12','8000000022'),
(5,'Naveen','Karthik','Officer',45000.00,'2022-10-15','8000000023'),
(5,'Ritika','Jain','Clerk',30000.00,'2023-05-22','8000000024'),
(5,'Vinod','Patel','Customer Service Executive',32000.00,'2023-06-25','8000000025');

select * from employees;

INSERT INTO accounts
(customer_id, branch_id, account_type_id, account_number, balance, open_date, account_status)
VALUES
(1,1,1,'ACC100001',25000,'2023-01-15','Active'),
(2,2,1,'ACC100002',18000,'2023-02-10','Active'),
(3,3,2,'ACC100003',75000,'2023-01-25','Active'),
(4,5,1,'ACC100004',22000,'2023-03-12','Active'),
(5,1,3,'ACC100005',45000,'2023-04-05','Active'),
(6,4,1,'ACC100006',15000,'2023-02-20','Active'),
(7,2,2,'ACC100007',98000,'2023-01-18','Blocked'),
(8,3,1,'ACC100008',12000,'2023-05-14','Active'),
(9,5,1,'ACC100009',33000,'2023-03-08','Active'),
(10,1,3,'ACC100010',50000,'2023-02-28','Active'),

(11,4,1,'ACC100011',26000,'2023-01-30','Active'),
(12,1,1,'ACC100012',17000,'2023-04-18','Active'),
(13,5,2,'ACC100013',82000,'2023-03-11','Active'),
(14,3,1,'ACC100014',14000,'2023-05-01','Active'),
(15,2,3,'ACC100015',38000,'2023-01-09','Dormant'),
(16,4,1,'ACC100016',21000,'2023-04-22','Active'),
(17,1,2,'ACC100017',92000,'2023-02-14','Blocked'),
(18,5,1,'ACC100018',16000,'2023-03-25','Active'),
(19,3,1,'ACC100019',28000,'2023-04-02','Active'),
(20,2,3,'ACC100020',47000,'2023-05-10','Active');

ALTER TABLE accounts
MODIFY account_status ENUM(
    'Active',
    'Dormant',
    'Blocked',
    'Closed'
) DEFAULT 'Active';

select * from accounts;

INSERT INTO accounts
(customer_id, branch_id, account_type_id, account_number, balance, open_date, account_status)
VALUES
(1,1,2,'ACC100021',85000,'2024-01-10','Active'),
(2,2,3,'ACC100022',42000,'2024-01-15','Active'),
(3,3,1,'ACC100023',30000,'2024-01-18','Active'),
(4,5,2,'ACC100024',95000,'2024-01-20','Active'),
(5,1,1,'ACC100025',22000,'2024-01-22','Active'),
(6,4,3,'ACC100026',55000,'2024-01-25','Active'),
(7,2,1,'ACC100027',12000,'2024-01-28','Dormant'),
(8,3,2,'ACC100028',78000,'2024-02-01','Active'),
(9,5,3,'ACC100029',46000,'2024-02-04','Active'),
(10,1,1,'ACC100030',31000,'2024-02-06','Active'),

(11,4,2,'ACC100031',88000,'2024-02-08','Active'),
(12,1,3,'ACC100032',39000,'2024-02-10','Active'),
(13,5,1,'ACC100033',27000,'2024-02-12','Active'),
(14,3,2,'ACC100034',92000,'2024-02-14','Active'),
(15,2,1,'ACC100035',18000,'2024-02-16','Dormant'),
(16,4,3,'ACC100036',51000,'2024-02-18','Active'),
(17,1,1,'ACC100037',25000,'2024-02-20','Blocked'),
(18,5,2,'ACC100038',76000,'2024-02-22','Active'),
(19,3,3,'ACC100039',47000,'2024-02-24','Active'),
(20,2,1,'ACC100040',29000,'2024-02-26','Active');

INSERT INTO accounts
(customer_id, branch_id, account_type_id, account_number, balance, open_date, account_status)
VALUES
(21,1,1,'ACC100041',24000,'2024-03-01','Active'),
(22,4,1,'ACC100042',18000,'2024-03-02','Active'),
(23,2,2,'ACC100043',82000,'2024-03-03','Active'),
(24,5,1,'ACC100044',21000,'2024-03-04','Active'),
(25,3,3,'ACC100045',45000,'2024-03-05','Dormant'),

(26,1,1,'ACC100046',28000,'2024-03-06','Active'),
(27,4,2,'ACC100047',96000,'2024-03-07','Blocked'),
(28,5,1,'ACC100048',15000,'2024-03-08','Active'),
(29,2,1,'ACC100049',34000,'2024-03-09','Active'),
(30,3,3,'ACC100050',52000,'2024-03-10','Active'),

(31,4,1,'ACC100051',26000,'2024-03-11','Active'),
(32,5,2,'ACC100052',87000,'2024-03-12','Active'),
(33,1,1,'ACC100053',19000,'2024-03-13','Active'),
(34,2,1,'ACC100054',22000,'2024-03-14','Active'),
(35,3,3,'ACC100055',41000,'2024-03-15','Dormant'),

(36,4,1,'ACC100056',31000,'2024-03-16','Active'),
(37,5,2,'ACC100057',91000,'2024-03-17','Blocked'),
(38,1,1,'ACC100058',17000,'2024-03-18','Active'),
(39,2,1,'ACC100059',29000,'2024-03-19','Active'),
(40,3,3,'ACC100060',48000,'2024-03-20','Active'),

(41,1,1,'ACC100061',23000,'2024-03-21','Active'),
(42,4,1,'ACC100062',27000,'2024-03-22','Active'),
(43,5,2,'ACC100063',84000,'2024-03-23','Active'),
(44,2,1,'ACC100064',20000,'2024-03-24','Active'),
(45,3,3,'ACC100065',46000,'2024-03-25','Active'),

(46,1,1,'ACC100066',16000,'2024-03-26','Dormant'),
(47,4,2,'ACC100067',99000,'2024-03-27','Blocked'),
(48,5,1,'ACC100068',25000,'2024-03-28','Active'),
(49,2,1,'ACC100069',33000,'2024-03-29','Active'),
(50,3,3,'ACC100070',55000,'2024-03-30','Active');
SELECT COUNT(*) AS total_accounts;
SELECT customer_id, COUNT(*) AS total_accounts
FROM accounts
GROUP BY customer_id
ORDER BY customer_id;
SELECT account_status,
       COUNT(*) AS total_accounts
FROM accounts
GROUP BY account_status;
SELECT account_type_id,
       COUNT(*) AS total_accounts
FROM accounts
GROUP BY account_type_id;
DESC beneficiaries;

INSERT INTO beneficiaries
(account_id, beneficiary_name, beneficiary_account_no, bank_name, ifsc_code)
VALUES
(1,'Ravi Kumar','BEN100001','HDFC Bank','HDFC0001001'),
(2,'Priya Sharma','BEN100002','ICICI Bank','ICIC0001002'),
(3,'Karthik Rajan','BEN100003','SBI','SBIN0001003'),
(4,'Sneha Reddy','BEN100004','Axis Bank','UTIB0001004'),
(5,'Vijay Singh','BEN100005','HDFC Bank','HDFC0001005'),
(6,'Anitha Das','BEN100006','ICICI Bank','ICIC0001006'),
(7,'Deepak Verma','BEN100007','SBI','SBIN0001007'),
(8,'Lakshmi Nair','BEN100008','Axis Bank','UTIB0001008'),
(9,'Harish Babu','BEN100009','HDFC Bank','HDFC0001009'),
(10,'Asha Gupta','BEN100010','ICICI Bank','ICIC0001010'),

(11,'Naveen Karthik','BEN100011','SBI','SBIN0001011'),
(12,'Bhavya Srinivas','BEN100012','Axis Bank','UTIB0001012'),
(13,'Praveen Joshi','BEN100013','HDFC Bank','HDFC0001013'),
(14,'Gayathri Menon','BEN100014','ICICI Bank','ICIC0001014'),
(15,'Ritika Jain','BEN100015','SBI','SBIN0001015'),
(16,'Keerthi Das','BEN100016','Axis Bank','UTIB0001016'),
(17,'Vinod Patel','BEN100017','HDFC Bank','HDFC0001017'),
(18,'Monika Gupta','BEN100018','ICICI Bank','ICIC0001018'),
(19,'Revathi Kannan','BEN100019','SBI','SBIN0001019'),
(20,'Ashok Verma','BEN100020','Axis Bank','UTIB0001020'),

(21,'Megha Sharma','BEN100021','HDFC Bank','HDFC0001021'),
(22,'Ravi Krishna','BEN100022','ICICI Bank','ICIC0001022'),
(23,'Pavithra Menon','BEN100023','SBI','SBIN0001023'),
(24,'Dinesh Rajan','BEN100024','Axis Bank','UTIB0001024'),
(25,'Sathish Babu','BEN100025','HDFC Bank','HDFC0001025');

INSERT INTO beneficiaries
(account_id, beneficiary_name, beneficiary_account_no, bank_name, ifsc_code)
VALUES
(26,'Arun Kumar','BEN100026','ICICI Bank','ICIC0001026'),
(27,'Priya Menon','BEN100027','SBI','SBIN0001027'),
(28,'Vignesh Rao','BEN100028','Axis Bank','UTIB0001028'),
(29,'Meena Iyer','BEN100029','HDFC Bank','HDFC0001029'),
(30,'Suresh Patel','BEN100030','ICICI Bank','ICIC0001030'),

(31,'Pooja Sharma','BEN100031','SBI','SBIN0001031'),
(32,'Arun Babu','BEN100032','Axis Bank','UTIB0001032'),
(33,'Divya Patel','BEN100033','HDFC Bank','HDFC0001033'),
(34,'Lokesh Mohan','BEN100034','ICICI Bank','ICIC0001034'),
(35,'Madhan Vel','BEN100035','SBI','SBIN0001035'),

(36,'Ajay Menon','BEN100036','Axis Bank','UTIB0001036'),
(37,'Lakshmi Krishnan','BEN100037','HDFC Bank','HDFC0001037'),
(38,'Suresh Kumar','BEN100038','ICICI Bank','ICIC0001038'),
(39,'Keerthana Mohan','BEN100039','SBI','SBIN0001039'),
(40,'Manoj Kumar','BEN100040','Axis Bank','UTIB0001040'),

(41,'Nisha Rao','BEN100041','HDFC Bank','HDFC0001041'),
(42,'Asha Gupta','BEN100042','ICICI Bank','ICIC0001042'),
(43,'Deepak Sharma','BEN100043','SBI','SBIN0001043'),
(44,'Pooja Nair','BEN100044','Axis Bank','UTIB0001044'),
(45,'Swathi Ramesh','BEN100045','HDFC Bank','HDFC0001045'),

(46,'Naveen Kumar','BEN100046','ICICI Bank','ICIC0001046'),
(47,'Bhavya Rao','BEN100047','SBI','SBIN0001047'),
(48,'Gayathri Nair','BEN100048','Axis Bank','UTIB0001048'),
(49,'Ritika Sharma','BEN100049','HDFC Bank','HDFC0001049'),
(50,'Vinod Kumar','BEN100050','ICICI Bank','ICIC0001050');

SELECT COUNT(*) AS total_beneficiaries FROM beneficiaries;

SELECT
    bank_name,
    COUNT(*) AS total
FROM beneficiaries
GROUP BY bank_name;

desc transactions;

INSERT INTO transactions
(account_id, beneficiary_id, transaction_type, amount, transaction_date, transaction_status)
VALUES
(1,NULL,'Deposit',10000,'2025-01-01 10:00:00','Success'),
(2,NULL,'Deposit',5000,'2025-01-02 11:00:00','Success'),
(3,NULL,'Withdrawal',2000,'2025-01-03 09:30:00','Success'),
(4,NULL,'Deposit',15000,'2025-01-04 14:20:00','Success'),
(5,NULL,'Withdrawal',3000,'2025-01-05 12:15:00','Success'),

(6,6,'Transfer',2500,'2025-01-06 15:00:00','Success'),
(7,7,'Transfer',4000,'2025-01-07 16:10:00','Success'),
(8,8,'Transfer',1500,'2025-01-08 13:25:00','Success'),
(9,9,'Transfer',6000,'2025-01-09 17:45:00','Pending'),
(10,10,'Transfer',3500,'2025-01-10 18:00:00','Success'),

(11,NULL,'Deposit',8000,'2025-01-11 10:30:00','Success'),
(12,NULL,'Withdrawal',1000,'2025-01-12 11:40:00','Success'),
(13,13,'Transfer',7000,'2025-01-13 14:00:00','Success'),
(14,14,'Transfer',4500,'2025-01-14 09:15:00','Success'),
(15,NULL,'Deposit',12000,'2025-01-15 16:45:00','Success'),

(16,NULL,'Withdrawal',2500,'2025-01-16 12:00:00','Success'),
(17,17,'Transfer',8500,'2025-01-17 15:10:00','Failed'),
(18,18,'Transfer',2200,'2025-01-18 13:35:00','Success'),
(19,NULL,'Deposit',9500,'2025-01-19 10:50:00','Success'),
(20,NULL,'Withdrawal',1800,'2025-01-20 11:20:00','Success'),

(21,21,'Transfer',5000,'2025-01-21 14:10:00','Success'),
(22,NULL,'Deposit',11000,'2025-01-22 09:00:00','Success'),
(23,NULL,'Withdrawal',3200,'2025-01-23 12:30:00','Success'),
(24,24,'Transfer',4700,'2025-01-24 16:20:00','Pending'),
(25,NULL,'Deposit',6000,'2025-01-25 10:10:00','Success');

INSERT INTO transactions
(account_id, beneficiary_id, transaction_type, amount, transaction_date, transaction_status)
VALUES
(26,NULL,'Deposit',7000,'2025-01-26 10:00:00','Success'),
(27,NULL,'Withdrawal',2500,'2025-01-27 11:15:00','Success'),
(28,28,'Transfer',3000,'2025-01-28 13:00:00','Success'),
(29,29,'Transfer',4200,'2025-01-29 14:25:00','Success'),
(30,NULL,'Deposit',10000,'2025-01-30 09:45:00','Success'),

(31,NULL,'Withdrawal',1800,'2025-01-31 15:20:00','Success'),
(32,32,'Transfer',5500,'2025-02-01 12:10:00','Success'),
(33,NULL,'Deposit',9000,'2025-02-02 11:00:00','Success'),
(34,34,'Transfer',2800,'2025-02-03 16:40:00','Failed'),
(35,NULL,'Withdrawal',3500,'2025-02-04 10:30:00','Success'),

(36,NULL,'Deposit',15000,'2025-02-05 09:50:00','Success'),
(37,37,'Transfer',8000,'2025-02-06 13:15:00','Success'),
(38,NULL,'Withdrawal',2200,'2025-02-07 14:45:00','Success'),
(39,NULL,'Deposit',7500,'2025-02-08 12:30:00','Success'),
(40,40,'Transfer',6200,'2025-02-09 17:10:00','Success'),

(41,NULL,'Deposit',5000,'2025-02-10 10:00:00','Success'),
(42,NULL,'Withdrawal',1400,'2025-02-11 11:45:00','Success'),
(43,43,'Transfer',9100,'2025-02-12 15:20:00','Pending'),
(44,NULL,'Deposit',8000,'2025-02-13 09:30:00','Success'),
(45,NULL,'Withdrawal',2600,'2025-02-14 12:00:00','Success'),

(46,46,'Transfer',4800,'2025-02-15 16:10:00','Success'),
(47,NULL,'Deposit',12000,'2025-02-16 10:40:00','Success'),
(48,NULL,'Withdrawal',3000,'2025-02-17 13:30:00','Success'),
(49,49,'Transfer',5700,'2025-02-18 15:00:00','Success'),
(50,NULL,'Deposit',6500,'2025-02-19 11:20:00','Success');
SELECT COUNT(*) AS total_transactions FROM transactions;

SELECT COUNT(*) AS total_transactions
FROM transactions;

SELECT transaction_type,
       COUNT(*) AS total
FROM transactions
GROUP BY transaction_type;

SELECT transaction_status,
       COUNT(*) AS total
FROM transactions
GROUP BY transaction_status;

INSERT INTO transactions
(account_id, beneficiary_id, transaction_type, amount, transaction_date, transaction_status)
VALUES
(51,NULL,'Deposit',8500,'2025-02-20 10:00:00','Success'),
(52,NULL,'Withdrawal',2000,'2025-02-20 11:15:00','Success'),
(53,3,'Transfer',4500,'2025-02-20 14:00:00','Success'),
(54,NULL,'Deposit',12000,'2025-02-21 09:45:00','Success'),
(55,5,'Transfer',6000,'2025-02-21 15:20:00','Success'),

(56,NULL,'Withdrawal',3500,'2025-02-22 12:10:00','Success'),
(57,NULL,'Deposit',15000,'2025-02-22 16:00:00','Success'),
(58,8,'Transfer',7200,'2025-02-23 13:45:00','Pending'),
(59,NULL,'Deposit',5000,'2025-02-23 10:30:00','Success'),
(60,NULL,'Withdrawal',1800,'2025-02-23 17:15:00','Success'),

(61,11,'Transfer',9000,'2025-02-24 11:20:00','Success'),
(62,NULL,'Deposit',11000,'2025-02-24 09:10:00','Success'),
(63,NULL,'Withdrawal',2500,'2025-02-24 15:40:00','Success'),
(64,14,'Transfer',3800,'2025-02-25 14:15:00','Success'),
(65,NULL,'Deposit',7000,'2025-02-25 10:00:00','Success'),

(66,NULL,'Withdrawal',4000,'2025-02-25 18:20:00','Success'),
(67,17,'Transfer',12500,'2025-02-26 13:00:00','Failed'),
(68,NULL,'Deposit',9500,'2025-02-26 09:45:00','Success'),
(69,19,'Transfer',4700,'2025-02-26 16:10:00','Success'),
(70,NULL,'Withdrawal',3000,'2025-02-27 11:30:00','Success'),

(1,NULL,'Deposit',6000,'2025-02-27 09:00:00','Success'),
(2,22,'Transfer',5200,'2025-02-27 15:45:00','Success'),
(3,NULL,'Withdrawal',1500,'2025-02-28 10:20:00','Success'),
(4,NULL,'Deposit',13000,'2025-02-28 12:00:00','Success'),
(5,25,'Transfer',8400,'2025-02-28 17:00:00','Success'),

(6,NULL,'Deposit',7500,'2025-03-01 09:30:00','Success'),
(7,NULL,'Withdrawal',2200,'2025-03-01 11:00:00','Success'),
(8,28,'Transfer',4100,'2025-03-01 14:40:00','Success'),
(9,NULL,'Deposit',10500,'2025-03-02 10:10:00','Success'),
(10,30,'Transfer',5800,'2025-03-02 16:20:00','Pending'),

(11,NULL,'Withdrawal',2800,'2025-03-03 12:15:00','Success'),
(12,NULL,'Deposit',8900,'2025-03-03 09:50:00','Success'),
(13,33,'Transfer',15000,'2025-03-03 15:30:00','Success'),
(14,NULL,'Deposit',7200,'2025-03-04 10:45:00','Success'),
(15,NULL,'Withdrawal',3200,'2025-03-04 13:20:00','Success'),

(16,36,'Transfer',6600,'2025-03-05 14:00:00','Success'),
(17,NULL,'Deposit',14000,'2025-03-05 09:00:00','Success'),
(18,NULL,'Withdrawal',2100,'2025-03-05 16:10:00','Success'),
(19,39,'Transfer',5300,'2025-03-06 11:25:00','Success'),
(20,NULL,'Deposit',7800,'2025-03-06 09:15:00','Success'),

(21,NULL,'Withdrawal',2500,'2025-03-06 17:00:00','Success'),
(22,42,'Transfer',9700,'2025-03-07 13:40:00','Success'),
(23,NULL,'Deposit',11500,'2025-03-07 10:30:00','Success'),
(24,NULL,'Withdrawal',1800,'2025-03-07 18:10:00','Success'),
(25,45,'Transfer',6200,'2025-03-08 15:20:00','Success'),

(26,NULL,'Deposit',8400,'2025-03-08 09:20:00','Success'),
(27,NULL,'Withdrawal',2900,'2025-03-08 12:40:00','Success'),
(28,48,'Transfer',7300,'2025-03-09 14:30:00','Success'),
(29,NULL,'Deposit',10000,'2025-03-09 10:00:00','Success'),
(30,50,'Transfer',8900,'2025-03-09 16:45:00','Success');

select count(*) from transactions ;

INSERT INTO transactions
(account_id, beneficiary_id, transaction_type, amount, transaction_date, transaction_status)
VALUES
(31,NULL,'Deposit',9500,'2025-03-10 09:15:00','Success'),
(32,2,'Transfer',7200,'2025-03-10 14:20:00','Success'),
(33,NULL,'Withdrawal',1800,'2025-03-10 17:10:00','Success'),
(34,NULL,'Deposit',12500,'2025-03-11 10:30:00','Success'),
(35,5,'Transfer',8300,'2025-03-11 15:45:00','Success'),

(36,NULL,'Withdrawal',2500,'2025-03-12 11:20:00','Success'),
(37,NULL,'Deposit',18000,'2025-03-12 16:10:00','Success'),
(38,8,'Transfer',5400,'2025-03-13 13:00:00','Pending'),
(39,NULL,'Deposit',6200,'2025-03-13 09:40:00','Success'),
(40,NULL,'Withdrawal',3000,'2025-03-13 18:20:00','Success'),

(41,11,'Transfer',15000,'2025-03-14 14:15:00','Success'),
(42,NULL,'Deposit',9800,'2025-03-14 10:10:00','Success'),
(43,NULL,'Withdrawal',2200,'2025-03-14 17:40:00','Success'),
(44,14,'Transfer',6700,'2025-03-15 12:30:00','Success'),
(45,NULL,'Deposit',11500,'2025-03-15 09:20:00','Success'),

(46,NULL,'Withdrawal',2700,'2025-03-16 11:50:00','Success'),
(47,17,'Transfer',25000,'2025-03-16 15:30:00','Failed'),
(48,NULL,'Deposit',7300,'2025-03-16 10:00:00','Success'),
(49,19,'Transfer',5800,'2025-03-17 13:40:00','Success'),
(50,NULL,'Withdrawal',3200,'2025-03-17 17:15:00','Success'),

(51,NULL,'Deposit',8400,'2025-03-18 09:30:00','Success'),
(52,22,'Transfer',9100,'2025-03-18 14:10:00','Success'),
(53,NULL,'Withdrawal',1500,'2025-03-18 18:00:00','Success'),
(54,NULL,'Deposit',13200,'2025-03-19 10:40:00','Success'),
(55,25,'Transfer',7600,'2025-03-19 15:20:00','Success'),

(56,NULL,'Deposit',6700,'2025-03-20 09:00:00','Success'),
(57,NULL,'Withdrawal',2100,'2025-03-20 12:15:00','Success'),
(58,28,'Transfer',6300,'2025-03-20 16:45:00','Success'),
(59,NULL,'Deposit',11800,'2025-03-21 10:00:00','Success'),
(60,30,'Transfer',8400,'2025-03-21 15:50:00','Pending'),

(61,NULL,'Withdrawal',2900,'2025-03-22 11:00:00','Success'),
(62,NULL,'Deposit',9200,'2025-03-22 09:25:00','Success'),
(63,33,'Transfer',18500,'2025-03-22 14:30:00','Success'),
(64,NULL,'Deposit',7500,'2025-03-23 10:10:00','Success'),
(65,NULL,'Withdrawal',2400,'2025-03-23 17:20:00','Success'),

(66,36,'Transfer',7100,'2025-03-24 13:15:00','Success'),
(67,NULL,'Deposit',16000,'2025-03-24 09:40:00','Success'),
(68,NULL,'Withdrawal',1900,'2025-03-24 18:10:00','Success'),
(69,39,'Transfer',9800,'2025-03-25 14:20:00','Success'),
(70,NULL,'Deposit',8800,'2025-03-25 10:30:00','Success'),

(1,NULL,'Withdrawal',2500,'2025-03-26 11:10:00','Success'),
(2,42,'Transfer',12000,'2025-03-26 15:00:00','Success'),
(3,NULL,'Deposit',6900,'2025-03-26 09:15:00','Success'),
(4,NULL,'Withdrawal',1700,'2025-03-27 12:00:00','Success'),
(5,45,'Transfer',8200,'2025-03-27 16:10:00','Success'),

(6,NULL,'Deposit',9700,'2025-03-28 09:45:00','Success'),
(7,NULL,'Withdrawal',3300,'2025-03-28 11:50:00','Success'),
(8,48,'Transfer',15500,'2025-03-28 14:40:00','Success'),
(9,NULL,'Deposit',10400,'2025-03-29 10:20:00','Success'),
(10,50,'Transfer',9200,'2025-03-29 16:30:00','Success');

INSERT INTO transactions
(account_id, beneficiary_id, transaction_type, amount, transaction_date, transaction_status)
VALUES
(11,NULL,'Deposit',12500,'2025-03-30 09:10:00','Success'),
(12,NULL,'Withdrawal',2200,'2025-03-30 11:40:00','Success'),
(13,13,'Transfer',18000,'2025-03-30 15:20:00','Success'),
(14,NULL,'Deposit',8400,'2025-03-31 10:00:00','Success'),
(15,NULL,'Withdrawal',1500,'2025-03-31 17:15:00','Success'),

(16,16,'Transfer',6200,'2025-04-01 14:10:00','Success'),
(17,NULL,'Deposit',17000,'2025-04-01 09:30:00','Success'),
(18,NULL,'Withdrawal',2700,'2025-04-01 18:00:00','Success'),
(19,19,'Transfer',9500,'2025-04-02 13:25:00','Success'),
(20,NULL,'Deposit',7600,'2025-04-02 10:15:00','Success'),

(21,NULL,'Withdrawal',3200,'2025-04-02 17:20:00','Success'),
(22,22,'Transfer',14500,'2025-04-03 14:30:00','Success'),
(23,NULL,'Deposit',9200,'2025-04-03 09:00:00','Success'),
(24,NULL,'Withdrawal',1800,'2025-04-03 18:10:00','Success'),
(25,25,'Transfer',7100,'2025-04-04 15:40:00','Success'),

(26,NULL,'Deposit',13500,'2025-04-04 10:10:00','Success'),
(27,NULL,'Withdrawal',2500,'2025-04-04 12:50:00','Success'),
(28,28,'Transfer',22000,'2025-04-05 14:20:00','Pending'),
(29,NULL,'Deposit',9800,'2025-04-05 09:40:00','Success'),
(30,30,'Transfer',8400,'2025-04-05 16:30:00','Success'),

(31,NULL,'Withdrawal',2100,'2025-04-06 11:20:00','Success'),
(32,NULL,'Deposit',11000,'2025-04-06 09:30:00','Success'),
(33,33,'Transfer',28000,'2025-04-06 15:00:00','Failed'),
(34,NULL,'Deposit',7000,'2025-04-07 10:15:00','Success'),
(35,NULL,'Withdrawal',2600,'2025-04-07 17:45:00','Success'),

(36,36,'Transfer',8300,'2025-04-08 13:30:00','Success'),
(37,NULL,'Deposit',19500,'2025-04-08 09:00:00','Success'),
(38,NULL,'Withdrawal',3400,'2025-04-08 18:00:00','Success'),
(39,39,'Transfer',16500,'2025-04-09 14:40:00','Success'),
(40,NULL,'Deposit',8900,'2025-04-09 10:30:00','Success'),

(41,NULL,'Withdrawal',1700,'2025-04-10 12:00:00','Success'),
(42,42,'Transfer',35000,'2025-04-10 15:20:00','Success'),
(43,NULL,'Deposit',10200,'2025-04-10 09:20:00','Success'),
(44,NULL,'Withdrawal',2800,'2025-04-11 11:10:00','Success'),
(45,45,'Transfer',12400,'2025-04-11 16:10:00','Success'),

(46,NULL,'Deposit',8700,'2025-04-12 09:50:00','Success'),
(47,NULL,'Withdrawal',3000,'2025-04-12 12:20:00','Success'),
(48,48,'Transfer',45000,'2025-04-12 14:45:00','Pending'),
(49,NULL,'Deposit',11500,'2025-04-13 10:00:00','Success'),
(50,50,'Transfer',9200,'2025-04-13 16:30:00','Success'),

(42,42,'Transfer',40000,'2025-04-13 17:10:00','Success'),
(42,42,'Transfer',42000,'2025-04-13 17:25:00','Success'),
(42,42,'Transfer',38000,'2025-04-13 17:40:00','Success'),
(48,48,'Transfer',50000,'2025-04-14 11:00:00','Success'),
(48,48,'Transfer',55000,'2025-04-14 11:15:00','Success'),

(33,33,'Transfer',30000,'2025-04-14 15:00:00','Failed'),
(33,33,'Transfer',32000,'2025-04-14 15:05:00','Failed'),
(33,33,'Transfer',31000,'2025-04-14 15:10:00','Failed'),
(17,17,'Transfer',27000,'2025-04-15 12:00:00','Failed'),
(17,17,'Transfer',29000,'2025-04-15 12:10:00','Failed');

select count(*) from transactions;

INSERT INTO cards
(account_id, card_number, card_type, issue_date, expiry_date, card_status)
VALUES
(1,'5000000000000001','Debit','2024-01-01','2029-01-01','Active'),
(2,'5000000000000002','Debit','2024-01-01','2029-01-01','Active'),
(3,'5000000000000003','Credit','2024-01-01','2029-01-01','Active'),
(4,'5000000000000004','Debit','2024-01-01','2029-01-01','Active'),
(5,'5000000000000005','Credit','2024-01-01','2029-01-01','Active'),
(6,'5000000000000006','Debit','2024-01-01','2029-01-01','Active'),
(7,'5000000000000007','Credit','2024-01-01','2029-01-01','Blocked'),
(8,'5000000000000008','Debit','2024-01-01','2029-01-01','Active'),
(9,'5000000000000009','Debit','2024-01-01','2029-01-01','Active'),
(10,'5000000000000010','Credit','2024-01-01','2029-01-01','Active'),
(11,'5000000000000011','Debit','2024-01-01','2029-01-01','Active'),
(12,'5000000000000012','Debit','2024-01-01','2029-01-01','Active'),
(13,'5000000000000013','Credit','2024-01-01','2029-01-01','Active'),
(14,'5000000000000014','Debit','2024-01-01','2029-01-01','Active'),
(15,'5000000000000015','Credit','2024-01-01','2029-01-01','Blocked'),
(16,'5000000000000016','Debit','2024-01-01','2029-01-01','Active'),
(17,'5000000000000017','Credit','2024-01-01','2029-01-01','Blocked'),
(18,'5000000000000018','Debit','2024-01-01','2029-01-01','Active'),
(19,'5000000000000019','Debit','2024-01-01','2029-01-01','Active'),
(20,'5000000000000020','Credit','2024-01-01','2029-01-01','Active');

INSERT INTO loans
(customer_id, loan_type, loan_amount, interest_rate, start_date, tenure_months, loan_status)
VALUES
(1,'Home Loan',2500000,8.50,'2024-01-15',240,'Active'),
(3,'Car Loan',800000,9.25,'2024-02-10',60,'Active'),
(5,'Personal Loan',300000,12.50,'2024-03-05',36,'Active'),
(7,'Education Loan',600000,7.80,'2024-01-20',84,'Active'),
(9,'Home Loan',3200000,8.75,'2024-04-01',240,'Active'),
(11,'Car Loan',900000,9.10,'2024-02-18',60,'Active'),
(13,'Personal Loan',250000,13.00,'2024-05-10',24,'Active'),
(15,'Education Loan',750000,8.20,'2024-03-15',96,'Active'),
(17,'Home Loan',2800000,8.60,'2024-01-25',240,'Active'),
(19,'Car Loan',700000,9.40,'2024-04-12',60,'Active'),
(21,'Personal Loan',400000,12.75,'2024-02-05',48,'Active'),
(23,'Home Loan',3500000,8.45,'2024-03-22',240,'Active'),
(25,'Education Loan',500000,7.90,'2024-05-01',72,'Active'),
(27,'Car Loan',850000,9.15,'2024-01-28',60,'Active'),
(29,'Personal Loan',275000,12.25,'2024-04-18',36,'Active'),
(31,'Home Loan',3000000,8.55,'2024-02-14',240,'Active'),
(33,'Car Loan',950000,9.05,'2024-03-08',60,'Closed'),
(35,'Education Loan',650000,8.10,'2024-04-20',84,'Active'),
(37,'Personal Loan',350000,12.90,'2024-05-12',36,'Active'),
(39,'Home Loan',4000000,8.40,'2024-01-10',240,'Active');

INSERT INTO fraud_alerts
(transaction_id, alert_type, risk_level, alert_date, alert_status)
VALUES
(147,'High Value Transfer','Medium','2025-04-06 15:05:00','Open'),
(156,'High Value Transfer','Medium','2025-04-10 15:25:00','Open'),
(162,'Multiple Failed Transfers','High','2025-04-14 15:15:00','Investigating'),
(163,'Multiple Failed Transfers','High','2025-04-14 15:20:00','Investigating'),
(164,'Multiple Failed Transfers','High','2025-04-14 15:25:00','Investigating'),

(151,'Large Transfer Amount','Medium','2025-04-05 14:30:00','Open'),
(158,'Suspicious Transfer Pattern','High','2025-04-12 14:50:00','Open'),
(166,'Repeated Failed Transactions','High','2025-04-15 12:05:00','Investigating'),
(167,'Repeated Failed Transactions','High','2025-04-15 12:15:00','Investigating'),
(152,'Unusual Account Activity','Medium','2025-04-05 16:35:00','Open'),

(159,'Large Transfer Amount','High','2025-04-13 17:15:00','Open'),
(160,'Large Transfer Amount','High','2025-04-13 17:30:00','Open'),
(161,'Large Transfer Amount','High','2025-04-13 17:45:00','Open'),
(165,'Large Transfer Amount','High','2025-04-14 11:05:00','Open'),
(168,'Large Transfer Amount','High','2025-04-14 11:20:00','Open'),

(148,'Unusual Withdrawal Pattern','Low','2025-04-07 17:50:00','Resolved'),
(149,'High Frequency Transfers','Medium','2025-04-08 13:35:00','Resolved'),
(150,'Beneficiary Risk Alert','Medium','2025-04-09 14:45:00','Resolved'),
(153,'High Value Deposit','Low','2025-04-06 09:35:00','Resolved'),
(154,'Transfer Velocity Alert','Medium','2025-04-10 15:30:00','Resolved');

INSERT INTO emi_payments
(loan_id, emi_amount, payment_date, payment_status)
VALUES
(1,24500,'2025-01-05','Paid'),
(1,24500,'2025-02-05','Paid'),
(1,24500,'2025-03-05','Paid'),

(2,16500,'2025-01-10','Paid'),
(2,16500,'2025-02-10','Paid'),
(2,16500,'2025-03-10','Pending'),

(3,9800,'2025-01-15','Paid'),
(3,9800,'2025-02-15','Paid'),
(3,9800,'2025-03-15','Paid'),

(4,7200,'2025-01-20','Paid'),
(4,7200,'2025-02-20','Pending'),
(4,7200,'2025-03-20','Pending'),

(5,31000,'2025-01-25','Paid'),
(5,31000,'2025-02-25','Paid'),
(5,31000,'2025-03-25','Paid'),

(6,17500,'2025-01-08','Paid'),
(6,17500,'2025-02-08','Paid'),
(6,17500,'2025-03-08','Paid'),

(7,10500,'2025-01-12','Paid'),
(7,10500,'2025-02-12','Pending'),
(7,10500,'2025-03-12','Pending'),

(8,7800,'2025-01-18','Paid'),
(8,7800,'2025-02-18','Paid'),
(8,7800,'2025-03-18','Missed'),

(9,26500,'2025-01-22','Paid'),
(9,26500,'2025-02-22','Paid'),
(9,26500,'2025-03-22','Paid'),

(10,15200,'2025-01-28','Paid'),
(10,15200,'2025-02-28','Pending'),
(10,15200,'2025-03-28','Pending'),

(11,11800,'2025-01-07','Paid'),
(11,11800,'2025-02-07','Paid'),
(11,11800,'2025-03-07','Paid'),

(12,34000,'2025-01-11','Paid'),
(12,34000,'2025-02-11','Paid'),
(12,34000,'2025-03-11','Paid'),

(13,6900,'2025-01-16','Paid'),
(13,6900,'2025-02-16','Paid'),
(13,6900,'2025-03-16','Pending'),

(14,16800,'2025-01-19','Paid'),
(14,16800,'2025-02-19','Paid'),
(14,16800,'2025-03-19','Paid'),

(15,9500,'2025-01-24','Paid'),
(15,9500,'2025-02-24','Missed'),
(15,9500,'2025-03-24','Pending'),

(16,28500,'2025-01-27','Paid'),
(16,28500,'2025-02-27','Paid'),
(16,28500,'2025-03-27','Paid'),

(17,18000,'2025-01-30','Paid'),
(17,18000,'2025-02-28','Paid'),
(17,18000,'2025-03-30','Paid'),

(18,8300,'2025-01-14','Paid'),
(18,8300,'2025-02-14','Pending'),
(18,8300,'2025-03-14','Missed'),

(19,11200,'2025-01-21','Paid'),
(19,11200,'2025-02-21','Paid'),
(19,11200,'2025-03-21','Paid'),

(20,36000,'2025-01-26','Paid'),
(20,36000,'2025-02-26','Paid'),
(20,36000,'2025-03-26','Paid');

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM employees;
SELECT COUNT(*) FROM accounts;
SELECT COUNT(*) FROM beneficiaries;
SELECT COUNT(*) FROM transactions;
SELECT COUNT(*) FROM loans;
SELECT COUNT(*) FROM emi_payments;
SELECT COUNT(*) FROM fraud_alerts;
SELECT COUNT(*) FROM cards;

INSERT INTO cards
(account_id, card_number, card_type, issue_date, expiry_date, card_status)
VALUES
(21,'5000000000000021','Debit','2024-01-01','2029-01-01','Active'),
(22,'5000000000000022','Debit','2024-01-01','2029-01-01','Active'),
(23,'5000000000000023','Credit','2024-01-01','2029-01-01','Active'),
(24,'5000000000000024','Debit','2024-01-01','2029-01-01','Active'),
(25,'5000000000000025','Credit','2024-01-01','2029-01-01','Active'),
(26,'5000000000000026','Debit','2024-01-01','2029-01-01','Active'),
(27,'5000000000000027','Credit','2024-01-01','2029-01-01','Blocked'),
(28,'5000000000000028','Debit','2024-01-01','2029-01-01','Active'),
(29,'5000000000000029','Debit','2024-01-01','2029-01-01','Active'),
(30,'5000000000000030','Credit','2024-01-01','2029-01-01','Active'),

(31,'5000000000000031','Debit','2024-01-01','2029-01-01','Active'),
(32,'5000000000000032','Debit','2024-01-01','2029-01-01','Active'),
(33,'5000000000000033','Credit','2024-01-01','2029-01-01','Active'),
(34,'5000000000000034','Debit','2024-01-01','2029-01-01','Active'),
(35,'5000000000000035','Credit','2024-01-01','2029-01-01','Blocked'),
(36,'5000000000000036','Debit','2024-01-01','2029-01-01','Active'),
(37,'5000000000000037','Credit','2024-01-01','2029-01-01','Active'),
(38,'5000000000000038','Debit','2024-01-01','2029-01-01','Active'),
(39,'5000000000000039','Debit','2024-01-01','2029-01-01','Active'),
(40,'5000000000000040','Credit','2024-01-01','2029-01-01','Active'),

(41,'5000000000000041','Debit','2024-01-01','2029-01-01','Active'),
(42,'5000000000000042','Credit','2024-01-01','2029-01-01','Active'),
(43,'5000000000000043','Debit','2024-01-01','2029-01-01','Active'),
(44,'5000000000000044','Debit','2024-01-01','2029-01-01','Active'),
(45,'5000000000000045','Credit','2024-01-01','2029-01-01','Active'),
(46,'5000000000000046','Debit','2024-01-01','2029-01-01','Active'),
(47,'5000000000000047','Credit','2024-01-01','2029-01-01','Blocked'),
(48,'5000000000000048','Debit','2024-01-01','2029-01-01','Active'),
(49,'5000000000000049','Debit','2024-01-01','2029-01-01','Active'),
(50,'5000000000000050','Credit','2024-01-01','2029-01-01','Active'),

(51,'5000000000000051','Debit','2024-01-01','2029-01-01','Active'),
(52,'5000000000000052','Debit','2024-01-01','2029-01-01','Active'),
(53,'5000000000000053','Credit','2024-01-01','2029-01-01','Active'),
(54,'5000000000000054','Debit','2024-01-01','2029-01-01','Active'),
(55,'5000000000000055','Credit','2024-01-01','2029-01-01','Active'),
(56,'5000000000000056','Debit','2024-01-01','2029-01-01','Active'),
(57,'5000000000000057','Credit','2024-01-01','2029-01-01','Active'),
(58,'5000000000000058','Debit','2024-01-01','2029-01-01','Active'),
(59,'5000000000000059','Debit','2024-01-01','2029-01-01','Active'),
(60,'5000000000000060','Credit','2024-01-01','2029-01-01','Active'),

(61,'5000000000000061','Debit','2024-01-01','2029-01-01','Active'),
(62,'5000000000000062','Debit','2024-01-01','2029-01-01','Active'),
(63,'5000000000000063','Credit','2024-01-01','2029-01-01','Active'),
(64,'5000000000000064','Debit','2024-01-01','2029-01-01','Active'),
(65,'5000000000000065','Credit','2024-01-01','2029-01-01','Blocked'),
(66,'5000000000000066','Debit','2024-01-01','2029-01-01','Active'),
(67,'5000000000000067','Credit','2024-01-01','2029-01-01','Active'),
(68,'5000000000000068','Debit','2024-01-01','2029-01-01','Active'),
(69,'5000000000000069','Debit','2024-01-01','2029-01-01','Active'),
(70,'5000000000000070','Credit','2024-01-01','2029-01-01','Active');
SELECT MAX(account_id) FROM cards;

-- Basic Queries

-- Display all customers.
select * from customers;
-- Display active customers.
select * from customers where customer_status = 'active';
-- Display customers from Chennai.
select * from customers where address = 'chennai';
-- Display accounts with balance between 20,000 and 50,000.
select * from accounts where balance between 20000 and 50000;
-- Display the latest 10 transactions.
select * from transactions order by transaction_date limit 10;
-- Display all credit cards.
select * from cards where card_type='credit';
-- Display pending EMI payments.
select * from emi_payments where payment_status = 'pending';

-- Aggregate Functions

-- Count Total Customers
select address,count(*) as total_customers from customers group by address;
-- Find Total Balance Maintained in the Bank
select sum(balance) as total_balance from accounts;
-- Find Average Account Balance
select avg(balance) as average_balance from accounts;
-- Find Highest and Lowest  Account Balance
select max(balance) as Highest_Account_Balance ,min(balance) lowest_Account_Balance from accounts;
-- Find Total Loan Amount Issued
select sum(loan_amount) as total_loan from loans;

-- GROUP BY & HAVING

-- Count Employees Branch-Wise
select  branch_id, COUNT(*) AS total_employees from employees group by branch_id;
-- Count Customers City-Wise
select address ,count(*) from customers group by address;
-- Count Transactions by Transaction Type
select transaction_type,count(*) as total_transactions from transactions group by transaction_type;
-- Show Branches Having More Than 10 Accounts
select count(*) as total_accounts,branch_id from accounts group by branch_id having total_accounts > 10;
-- Show Customers Having More Than One Account
select customer_id,count(*) as total_accounts from accounts group by customer_id having total_accounts > 1;

-- JOINS

-- Display Customer Details with Account Details
select c.customer_id,c.first_name,c.last_name,a.account_id,a.balance from customers c 
join accounts a on c.customer_id = a.customer_id;
-- Display Customer Details with Branch Details
select c.customer_id,c.first_name,c.last_name,b.branch_name from customers c 
join accounts a on c.customer_id = a.customer_id
join branches b on a.branch_id = b.branch_id;
-- Display Fraud Alerts with Transaction Details
select f.alert_id, f.alert_type,t.transaction_id,t.amount from fraud_alerts f
join transactions t on f.transaction_id = t.transaction_id;
-- Complete Customer Profile Report
select c.customer_id,c.first_name,c.last_name,a.account_id,a.balance,b.branch_name,cd.card_type,l.loan_amount
from customers c
left join accounts a on c.customer_id = a.customer_id
left join branches b on a.branch_id = b.branch_id
left join cards cd on a.account_id = cd.account_id
left join loans l on c.customer_id = l.customer_id;
-- Customers and Their Total Account Balance
select c.customer_id,c.first_name,sum(a.balance) from customers c 
join accounts a on c.customer_id = a.customer_id group by c.customer_id,c.first_name;
-- Customers Without Loans
select c.customer_id,c.first_name from customers c 
left join loans l on c.customer_id = l.customer_id 
where l.loan_id is null;
-- Fraud Alerts with Customer Information
select c.first_name, t.transaction_id,f.alert_type from customers c
join accounts a  on c.customer_id = a.customer_id 
join transactions t on a.account_id = t.account_id
join fraud_alerts f on t.transaction_id = f.transaction_id;

-- Subquery

-- Find Accounts Having Balance Above Average Balance
select account_id,balance from accounts where balance > (
select avg(balance) from accounts); 
-- Find Accounts With No Transactions
select account_id from accounts where account_id not in ( 
select account_id from transactions );
-- Find the Second Highest Account Balance
select  max(balance) from accounts where balance < (
select max(balance) from accounts);
-- Find Accounts Having Balance Greater Than the Average Balance of Their Branch
select a.account_id,a.branch_id,a.balance from accounts a where a.balance > (
select avg(balance) from accounts where branch_id = a.branch_id);
-- Find Customers Who Have Both a Loan and a Credit Card
select c.customer_id,c.first_name from customers c 	where c.customer_id in (
select customer_id from loans) and c.customer_id in (select a.customer_id from accounts a 
join cards cd on a.account_id=cd.account_id where cd.card_type='credit');

-- CASE Statements & Views

-- Categorize Accounts as Low, Medium, High Balance
select account_id,balance ,
case
   when balance < 25000 then 'Low balance'
   when balance between 25000 and 75000 then 'Medium balance'
   else 'High balance'
end as balance_category
from accounts;
-- Categorize Loans as Small, Medium, Large
select loan_id ,loan_amount,
case 
when loan_amount < 100000 then 'Small loan'
when loan_amount between 100000 and 500000 then 'Medium loan'
else 'large loan '
end as loan_category	
from loans;
-- Find EMI Status
select emi_id,payment_date,
case 
when payment_date < curdate() and payment_status ='pending' then 'overdue'
else 'ontime'
end as emi_status
from emi_payments;
-- Create a View for Active Customers
create view active_customers as 
select * from customers where customer_status ='Active';
select * from active_customers;
-- Branch Performance View 
create view branch_performance as
select  b.branch_id,b.branch_name,count(a.account_id) as total_accounts,sum(a.balance) as total_deposit from branches b 
join accounts a on b.branch_id = a.branch_id
group by  b.branch_id, b.branch_name;
select * from branch_performance;
-- EMI Defaulters View
create view emi_defaulters as 
select  c.customer_id,c.first_name,l.loan_id,e.emi_id,e.payment_date from customers c
join loans l on c.customer_id=l.customer_id
join emi_payments e on l.loan_id = e.loan_id
where e.payment_status='pending';
select * from emi_defaulters;

-- CTE & Window Functions

-- Rank Customers by Total Account Balance
with customer_balance as
(
select c.customer_id,c.first_name,sum(a.balance) as total_balance from customers c
join accounts a on c.customer_id = a.customer_id
group by c.customer_id,c.first_name
)
select customer_id,first_name,total_balance,
rank() over(order by total_balance  desc) as customer_rank from customer_balance;
-- Highest Balance Account in Each Branch
with ranked_accounts as
(
select a.account_id,a.branch_id,a.balance,
row_number() over (
partition by a.branch_id order by a.balance desc) as rn from accounts a
)
select * from ranked_accounts where rn= 1;
-- Running Balance of Transactions
select account_id,transaction_id,amount,SUM(amount)
over(partition by account_id order by transaction_date) as runnning_total from transactions;

-- Procedures, Functions & Triggers

-- Get Customer Details by Customer ID
DELIMITER $$

CREATE PROCEDURE GetCustomerDetails(IN p_customer_id INT)
BEGIN
    SELECT c.customer_id,
           c.first_name,
           c.last_name,
           a.account_id,
           a.balance,
           b.branch_name
    FROM customers c
    JOIN accounts a
        ON c.customer_id = a.customer_id
    JOIN branches b
        ON a.branch_id = b.branch_id
    WHERE c.customer_id = p_customer_id;
END $$

DELIMITER ;

CALL GetCustomerDetails(34);
-- Transfer Money
DELIMITER $$
CREATE PROCEDURE TransferMoney
(
    IN p_sender INT,IN p_receiver INT,IN p_amount DECIMAL(10,2)
)
BEGIN
    UPDATE accounts
    SET balance = balance - p_amount
    WHERE account_id = p_sender;
    UPDATE accounts
    SET balance = balance + p_amount
    WHERE account_id = p_receiver;
END $$
DELIMITER ;
CALL TransferMoney(101,102,5000);
-- Deposit Money 
DELIMITER $$
CREATE PROCEDURE DepositMoney
(
    IN p_account_id INT,IN p_amount DECIMAL(10,2)
)
BEGIN
    UPDATE accounts
    SET balance = balance + p_amount
    WHERE account_id = p_account_id;
END $$
DELIMITER ;
CALL DepositMoney(101,10000);

-- Withdraw Money
DELIMITER $$
CREATE PROCEDURE WithdrawMoney
(
    IN p_account_id INT,IN p_amount DECIMAL(10,2)
)
BEGIN
    UPDATE accounts
    SET balance = balance - p_amount
    WHERE account_id = p_account_id;
END $$
DELIMITER ;
-- Prevent Negative Account Balance
DELIMITER $$
CREATE TRIGGER PreventNegativeBalance
BEFORE UPDATE
ON accounts
FOR EACH ROW
BEGIN
    IF NEW.balance < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient Balance';
    END IF;
END $$
DELIMITER ;

-- Dashboard Query
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    b.branch_name,
    at.type_name,
    a.balance,
    cd.card_type,
    COALESCE(l.loan_amount, 0) AS loan_amount
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
JOIN branches b
    ON a.branch_id = b.branch_id
JOIN account_types at
    ON a.account_type_id = at.account_type_id
LEFT JOIN cards cd
    ON a.account_id = cd.account_id
LEFT JOIN loans l
    ON c.customer_id = l.customer_id
ORDER BY a.balance DESC;  
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------