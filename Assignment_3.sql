/*
Q3. Consider following database schema
dept(dept_no(PK), dname, location, manager_code)
emp(emp_no(PK), dept_no (FK), proj_no(FK),ename, designation)
project(proj_no(PK)(Check -- proj_no >0), proj_name,status)
Write queries for the following:
1. Create above tables and apply all types of constraints
2. Insert 10 records in each table.
3. Display list of projects having status incomplete.
4. Display list of department from pune location
5. List all employees of ‘INVENTORY’ department of ‘PUNE’ location.
6. Give the names of employees who are working on ‘Blood Bank’ project.
7. Given the name of managers from ‘MARKETING’ department in descending order.
8. Give all the employees working under status ‘INCOMPLETE’ projects.
9. Display all employees department wise.
10. Perform inner and full outer join
11. Write a trigger to log project details into backup table when a project entry is deleted from
project table
12. Use delete and drop command
*/

--1. Create above tables and apply all types of constraints
CREATE TABLE dept (
dept_no int PRIMARY KEY,
dname VARCHAR(255),
location VARCHAR(255),
manager_code int
);

CREATE TABLE project (
proj_no int PRIMARY KEY,
proj_name VARCHAR(255),
STATUS VARCHAR(255),
CHECK (proj_no > 0)
);

CREATE TABLE emp (
emp_no int PRIMARY KEY,
dept_no int,
proj_no int,
ename VARCHAR(255),
designation VARCHAR(255),
FOREIGN KEY (dept_no) REFERENCES dept(dept_no),
FOREIGN KEY (proj_no) REFERENCES project(proj_no)
);

--2. Insert 10 records in each table.
INSERT INTO dept (dept_no, dname, location, manager_code)
VALUES
(1, 'IT','PUNE', '2')

INSERT INTO dept (dept_no, dname, location, manager_code)
VALUES
  (1, 'Dept A', 'Location 1', 100),
  (2, 'Dept B', 'Location 2', 200),
  (3, 'Dept C', 'Location 3', 300),
  (4, 'Dept D', 'Location 4', 400),
  (5, 'Dept E', 'Location 5', 500),
  (6, 'Dept F', 'Location 6', 600),
  (7, 'Dept G', 'Location 7', 700),
  (8, 'Dept H', 'Location 8', 800),
  (9, 'Dept I', 'Location 9', 900),
  (10, 'Dept J', 'Location 10', 1000);
  
  INSERT INTO project (proj_no, proj_name, status)
VALUES
  (1, 'Project X', 'Active'),
  (2, 'Project Y', 'Inactive'),
  (3, 'Project Z', 'Active'),
  (4, 'Project A', 'Inactive'),
  (5, 'Project B', 'Active'),
  (6, 'Project C', 'Inactive'),
  (7, 'Project D', 'Active'),
  (8, 'Project E', 'Inactive'),
  (9, 'Project F', 'Active'),
  (10, 'Project G', 'Inactive');
  
  INSERT INTO emp (emp_no, dept_no, proj_no, ename, designation)
VALUES
  (1, 1, 1, 'John Doe', 'Manager'),
  (2, 1, 2, 'Jane Smith', 'Engineer'),
  (3, 2, 1, 'David Johnson', 'Analyst'),
  (4, 2, 3, 'Sarah Williams', 'Designer'),
  (5, 3, 2, 'Michael Brown', 'Developer'),
  (6, 3, 3, 'Emily Davis', 'Manager'),
  (7, 4, 1, 'Christopher Jones', 'Engineer'),
  (8, 4, 2, 'Jessica Taylor', 'Analyst'),
  (9, 5, 3, 'Matthew Wilson', 'Designer'),
  (10, 5, 1, 'Olivia Anderson', 'Developer');

--3. Display list of projects having status incomplete.
SELECT proj_name FROM project 
WHERE status = 'Active';

--4. Display list of department from pune location
SELECT dname from dept 
WHERE location = 'PUNE';

--5. List all employees of ‘INVENTORY’ department of ‘PUNE’ location.
SELECT ename from emp 
WHERE dept.dname = 'Dept A' AND dept.location = 'Location A';


SELECT ename FROM 
FROM emp
WHERE dept_no = (
  SELECT dept_no
  FROM dept
  WHERE dname = 'INVENTORY' AND location = 'PUNE'
);

--6. Give the names of employees who are working on ‘Blood Bank’ project.
SELECT ename from emp 
WHERE proj_no = (
SELECT proj_no
FROM project
WHERE proj_name = 'Project X'
);

--7. Given the name of managers from ‘MARKETING’ department in descending order.
SELECT ename
FROM emp
WHERE dept_no IN (
  SELECT dept_no
  FROM dept
  WHERE dname = 'MARKETING'
) AND designation = 'Manager'
ORDER BY ename DESC;

--8. Give all the employees working under status ‘INCOMPLETE’ projects.
SELECT ename from emp
WHERE proj_no IN (
SELECT proj_no
FROM project
WHERE status = 'Active'
);

-- Display all employees department wise.
SELECT dept_no, GROUP_CONCAT(ename) AS employees
FROM emp
GROUP BY dept_no;

--10. Perform inner and full outer join
SELECT *
FROM emp
INNER JOIN dept
ON emp.dept_no = dept.dept_no;


SELECT *
FROM emp
LEFT OUTER JOIN dept
ON emp.dept_no = dept.dept_no
UNION
SELECT *
FROM emp
RIGHT OUTER JOIN dept
ON emp.dept_no = dept.dept_no
WHERE emp.dept_no IS NULL;

--11. Write a trigger to log project details into backup table when a project entry is deleted from
--project table
-- Create backup table if it doesn't exist
CREATE TABLE IF NOT EXISTS project_backup (
  proj_no INT,
  proj_name VARCHAR(255),
  status VARCHAR(255),
  deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create trigger
DELIMITER //
CREATE TRIGGER project_delete_trigger
AFTER DELETE ON project
FOR EACH ROW
BEGIN
  INSERT INTO project_backup (proj_no, proj_name, status)
  VALUES (OLD.proj_no, OLD.proj_name, OLD.status);
END //
DELIMITER ;

--12. Use delete and drop command
DELETE FROM project WHERE proj_no = '10';

DROP TABLE emp;

