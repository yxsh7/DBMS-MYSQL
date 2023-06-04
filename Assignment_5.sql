/*
Q5. Use following schema
emp(empid(PK),name,city,salary,age(check>0),Jdate:Not null,designation,projectid(FK))
project(projectid(PK),projectname, budget)
1. Create above table with defined constraints.
2. Insert minimum 10 records in each table.
3. Display employee details having highest salary.
4. Find the names of all employees whose name starts with ‘S’.
5. List all the employees name and salary whose age is less than 40 years.
6. Select the employees whose salary is between Rs. 20000 and Rs. 30000.
7. Write a procedure to display highest salary of an employee without using aggregate functions.
8. Create view for any table
9. Add new column domain in project table
10. Update project domain name for project id=101
11. Write a procedure using cursor to display the sum of salaries given to employees wrt each 
project .
*/

-- Create tables with defined constraints

CREATE TABLE project (
  projectid INT PRIMARY KEY,
  projectname VARCHAR(100),
  budget DECIMAL(10, 2)
);

CREATE TABLE emp (
  empid INT PRIMARY KEY,
  name VARCHAR(100),
  city VARCHAR(100),
  salary DECIMAL(10, 2),
  age INT CHECK (age > 0),
  Jdate DATE NOT NULL,
  designation VARCHAR(100),
  projectid INT,
  FOREIGN KEY (projectid) REFERENCES project(projectid)
);


INSERT INTO emp (empid, name, city, salary, age, Jdate, designation, projectid)
VALUES
(1, 'John Doe', 'New York', 50000.00, 30, '2022-01-01', 'Manager', 101),
(2, 'Jane Smith', 'Los Angeles', 45000.00, 28, '2021-06-15', 'Developer', 102),
(3, 'Mike Johnson', 'Chicago', 55000.00, 35, '2023-02-28', 'Analyst', 101),
(4, 'Sarah Williams', 'San Francisco', 60000.00, 32, '2022-09-10', 'Manager', 103),
(5, 'Emily Davis', 'Boston', 40000.00, 26, '2021-03-05', 'Developer', 102),
(6, 'David Brown', 'Houston', 48000.00, 29, '2023-05-20', 'Designer', 103),
(7, 'Jessica Wilson', 'Dallas', 52000.00, 34, '2022-07-12', 'Analyst', 101),
(8, 'Andrew Miller', 'Seattle', 42000.00, 27, '2021-09-25', 'Developer', 102),
(9, 'Olivia Taylor', 'Austin', 55000.00, 31, '2023-04-18', 'Manager', 103),
(10, 'Daniel Anderson', 'Denver', 47000.00, 33, '2022-11-30', 'Designer', 103);

INSERT INTO project (projectid, projectname, budget)
VALUES
(101, 'Project A', 100000.00),
(102, 'Project B', 80000.00),
(103, 'Project C', 120000.00);


-- Display employee details having highest salary
SELECT *
FROM emp
WHERE salary = (SELECT MAX(salary) FROM emp);

-- Find the names of all employees whose name starts with 'S'
SELECT name
FROM emp
WHERE name LIKE 'S%';

-- List all the employees' names and salaries whose age is less than 40 years
SELECT name, salary
FROM emp
WHERE age < 40;

-- Select the employees whose salary is between Rs. 20000 and Rs. 30000
SELECT *
FROM emp
WHERE salary BETWEEN 20000 AND 30000;

-- Write a procedure to display the highest salary of an employee without using aggregate functions
DELIMITER //

CREATE PROCEDURE FindHighestSalary()
BEGIN
  DECLARE highest_salary DECIMAL(10, 2);
  
  SELECT MAX(salary) INTO highest_salary FROM emp;
  
  SELECT * FROM emp WHERE salary = highest_salary;
END //

DELIMITER ;

-- Create a view for the emp table
CREATE VIEW emp_view AS
SELECT empid, name, city, salary
FROM emp;

-- Add a new column "domain" in the project table
ALTER TABLE project
ADD domain VARCHAR(100);

-- Update project domain name for project id = 101
UPDATE project
SET domain = 'New Domain'
WHERE projectid = 101;

-- Write a procedure using a cursor to display the sum of salaries given to employees with respect to each project
DELIMITER //

CREATE PROCEDURE CalculateSalarySum()
BEGIN
  DECLARE project_id INT;
  DECLARE project_name VARCHAR(100);
  DECLARE total_salary DECIMAL(10, 2);
  
  DECLARE done INT DEFAULT FALSE;
  DECLARE cur CURSOR FOR SELECT projectid, projectname FROM project;
  
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  OPEN cur;
  
  read_loop: LOOP
    FETCH cur INTO project_id, project_name;
    
    IF done THEN
      LEAVE read_loop;
    END IF;
    
    SELECT SUM(salary) INTO total_salary FROM emp WHERE projectid = project_id;
    
    SELECT CONCAT('Project: ', project_name, ', Total Salary: Rs. ', total_salary) AS result;
  END LOOP;
  
  CLOSE cur;
END //

DELIMITER ;

-- Call the procedure to calculate salary sum
CALL CalculateSalarySum();
