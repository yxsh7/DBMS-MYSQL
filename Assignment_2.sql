/*
Q2. Database Schema for a Employee-pay scenario
employee(emp_id(PK), emp_name)
department(dept_id(PK), dept_name,dept_location)
paydetails(emp_id(FK), dept_id(FK), basic, deductions, additions, DOJ: date Not null)
payroll(emp_id(FK), pay_date: date,amount(check>500))
For the above schema, perform the following operation
1. Create the tables with the appropriate integrity constraints
2. Insert around 10 records in each of the tables
3. List the employee details department wise
4. List all the employee names who joined after particular date
5. List the details of employees whose basic salary is between 10,000 and 20,000
6. Give a count of how many employees are working in each department
7. Give a names of the employees whose netsalary>10,000
8. List the details for an employee_id=5
9. Create a view which lists the emp_name and his netsalary
10. List all employee names start ‘P’.
11. Use cursor and procedure / function to calculate and display the yearly salary of each
employee
----------------------------
*/

--1. Create the tables with the appropriate integrity constraints
CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(255)
);

CREATE TABLE department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(255),
    dept_location VARCHAR(255)
);

CREATE TABLE paydetails (
    emp_id INT,
    dept_id INT,
    basic DECIMAL(10, 2),
    deductions DECIMAL(10, 2),
    additions DECIMAL(10, 2),
    DOJ DATE NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id),
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

CREATE TABLE payroll (
    emp_id INT,
    pay_date DATE,
    amount DECIMAL(10, 2),
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id),
    CHECK (amount > 500)
);

--2. Insert around 10 records in each of the tables
INSERT INTO employee (emp_id, emp_name)
VALUES
    (1, 'John Doe'),
    (2, 'Jane Smith'),
    (3, 'Michael Johnson'),
    (4, 'Emily Brown'),
    (5, 'Robert Anderson'),
    (6, 'Olivia Martinez'),
    (7, 'Daniel Lee'),
    (8, 'Sophia Kim'),
    (9, 'David Johnson'),
    (10, 'Sarah Taylor');

INSERT INTO department (dept_id, dept_name, dept_location)
VALUES
    (1, 'Finance', 'New York'),
    (2, 'Marketing', 'Los Angeles'),
    (3, 'Sales', 'Chicago'),
    (4, 'IT', 'San Francisco'),
    (5, 'Human Resources', 'Boston'),
    (6, 'Operations', 'Dallas'),
    (7, 'Research and Development', 'Seattle'),
    (8, 'Customer Service', 'Houston'),
    (9, 'Legal', 'Washington, D.C.'),
    (10, 'Production', 'Atlanta');
    
    INSERT INTO paydetails (emp_id, dept_id, basic, deductions, additions, DOJ)
VALUES
    (1, 1, 5000.00, 500.00, 1000.00, '2022-01-01'),
    (2, 2, 4500.00, 400.00, 800.00, '2022-02-01'),
    (3, 3, 5500.00, 550.00, 1100.00, '2022-03-01'),
    (4, 4, 6000.00, 600.00, 1200.00, '2022-04-01'),
    (5, 5, 4800.00, 480.00, 960.00, '2022-05-01'),
    (6, 6, 5200.00, 520.00, 1040.00, '2022-06-01'),
    (7, 7, 4700.00, 470.00, 940.00, '2022-07-01'),
    (8, 8, 5100.00, 510.00, 1020.00, '2022-08-01'),
    (9, 9, 4900.00, 490.00, 980.00, '2022-09-01'),
    (10, 10, 5300.00, 530.00, 1060.00, '2022-10-01');

INSERT INTO payroll (emp_id, pay_date, amount)
VALUES
    (1, '2022-01-31', 1000.00),
    (2, '2022-02-28', 900.00),
    (3, '2022-03-31', 1100.00),
    (4, '2022-04-30', 1200.00),
    (5, '2022-05-31', 960.00),
    (6, '2022-06-30', 1040.00),
    (7, '2022-07-31', 940.00),
    (8, '2022-08-31', 1020.00),
    (9, '2022-09-30', 980.00),
    (10, '2022-10-31', 1060.00);

--3. List the employee details department wise    
    
SELECT *
FROM employee
WHERE emp_id IN (SELECT emp_id FROM paydetails WHERE dept_id = 1);

--4. List all the employee names who joined after particular date
SELECT *
FROM employee
WHERE emp_id IN (
    SELECT emp_id
    FROM paydetails
    WHERE DOJ > '2022-05-01'
);

--5. List the details of employees whose basic salary is between 5000 and 10000
SELECT *
FROM employee
WHERE emp_id IN (
    SELECT emp_id
    FROM paydetails
    WHERE basic BETWEEN 5000 AND 10000
);

--6. Give a count of how many employees are working in each department
SELECT
dept_id,
COUNT(*) AS employee_count
FROM paydetails
GROUP BY dept_id;

--7. Give a names of the employees whose netsalary>5000 
SELECT emp_name
FROM employee
WHERE emp_id IN (
    SELECT emp_id
    FROM paydetails
    WHERE basic > 5000
);

--8. List the details for an employee_id=5
SELECT *
FROM employee
WHERE emp_id = 5;

--9. Create a view which lists the emp_name and his netsalary
CREATE VIEW emp_salary_view AS
SELECT emp_name, (SELECT basic - deductions + additions FROM paydetails WHERE paydetails.emp_id = employee.emp_id) AS net_salary
FROM employee;

SELECT * FROM emp_salary_view;

--10. List all employee names start ‘J’
SELECT emp_name
FROM employee
WHERE emp_name LIKE 'J%';


