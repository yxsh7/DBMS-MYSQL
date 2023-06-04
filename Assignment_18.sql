/*
1. Create above tables with all constraints and appropriate data types
2. Insert 10 records in each table.
3. Display hourly rates in incremental order and corresponding employee name
4. List which salaried employees live in Pune
5. Display the oldest salaried and hourly employees
6. Which employee has lowest & highest annual salary
7. Identify employees who have annual salary more than 10000 and less than or equal to 
20000
8. Write a function / procedure to calculate the daily salary of each hourly employee 
working 8 hours daily
9. Use inner and outer joins on all tables
10. Use delete and drop function
*/

-- 1. Create above tables with all constraints and appropriate data types

CREATE DATABASE mock;

USE mock;

CREATE TABLE city (
  id INT,
  city VARCHAR(30),
  PRIMARY KEY (id)
);

CREATE TABLE employee (
  id INT,
  employee_name VARCHAR(50),
  employee_number VARCHAR(10),
  date_hired DATE,
  city_id INT,
  PRIMARY KEY (id),
  FOREIGN KEY (city_id) REFERENCES city (id)
);

CREATE TABLE hourly_employee (
  id INT,
  hourly_rate FLOAT,
  employee_id INT,
  PRIMARY KEY (id),
  FOREIGN KEY (employee_id) REFERENCES employee (id)
);

CREATE TABLE salaried_employee (
  id INT,
  annual_salary FLOAT,
  employee_id INT,
  PRIMARY KEY (id),
  FOREIGN KEY (employee_id) REFERENCES employee (id)
);

-- 2. Insert 10 records in each table.

-- Inserting into the city table
INSERT INTO city VALUES
(101, "city01"),
(102, "city02"),
(103, "city03"),
(104, "city04"),
(105, "city05"),
(106, "city06"),
(107, "city07"),
(108, "city08"),
(109, "city09"),
(110, "city10");

-- Inserting into the employee table
INSERT INTO employee VALUES
(201, "employee01", "em01", '0101-01-01', 101),
(202, "employee02", "em02", '0202-02-02', 102),
(203, "employee03", "em03", '0303-03-03', 103),
(204, "employee04", "em04", '0404-04-04', 104),
(205, "employee05", "em05", '0505-05-05', 105),
(206, "employee06", "em06", '0606-06-06', 106),
(207, "employee07", "em07", '0202-02-02', 107),
(208, "employee08", "em08", '0303-03-03', 108),
(209, "employee09", "em09", '0404-04-04', 109),
(210, "employee10", "em10", '1010-10-10', 110);

-- Inserting into the hourly_employee table
INSERT INTO hourly_employee VALUES
(1, 10.01, 201),
(2, 20.02, 202),
(3, 30.03, 203),
(4, 40.04, 204),
(5, 50.05, 205),
(6, 10.01, 206),
(7, 20.02, 207),
(8, 30.03, 208),
(9, 40.04, 209),
(10, 0.10, 210);

-- Inserting into the salaried_employee table
INSERT INTO salaried_employee VALUES
(301, 100001, 201),
(302, 200002, 202),
(303, 300003, 203),
(304, 400004, 204),
(305, 500005, 205),
(306, 600006, 206),
(307, 700007, 207),
(308, 800008, 208),
(309, 90009, 209),
(310, 10010, 210);

-- 3. Display hourly rates in incremental order and corresponding employee name
SELECT e.employee_name, he.hourly_rate
FROM employee e
JOIN hourly_employee he ON e.id = he.employee_id
ORDER BY he.hourly_rate;

-- 4. List which salaried employees live in Pune
SELECT e.employee_name
FROM employee e
JOIN salaried_employee se ON e.id = se.employee_id
JOIN city c ON e.city_id = c.id
WHERE c.city = 'Pune';

-- 5. Display the oldest salaried and hourly employees
SELECT e.employee_name, se.employee_id, e.date_hired
FROM employee e
JOIN salaried_employee se ON e.id = se.employee_id
WHERE e.date_hired = (
  SELECT MIN(date_hired)
  FROM employee
);

SELECT e.employee_name, he.employee_id, e.date_hired
FROM employee e
JOIN hourly_employee he ON e.id = he.employee_id
WHERE e.date_hired = (
  SELECT MIN(date_hired)
  FROM employee
);

-- 6. Which employee has the lowest & highest annual salary
SELECT e.employee_name, se.annual_salary
FROM employee e
JOIN salaried_employee se ON e.id = se.employee_id
WHERE se.annual_salary = (
  SELECT MIN(annual_salary)
  FROM salaried_employee
);

SELECT e.employee_name, se.annual_salary
FROM employee e
JOIN salaried_employee se ON e.id = se.employee_id
WHERE se.annual_salary = (
  SELECT MAX(annual_salary)
  FROM salaried_employee
);

-- 7. Identify employees who have an annual salary more than 10000 and less than or equal to 20000
SELECT e.employee_name, se.annual_salary
FROM employee e
JOIN salaried_employee se ON e.id = se.employee_id
WHERE se.annual_salary > 10000 AND se.annual_salary <= 20000;

-- 8. Write a function / procedure to calculate the daily salary of each hourly employee working 8 hours daily
DELIMITER //

CREATE FUNCTION CalculateDailySalary(hourly_rate FLOAT)
RETURNS FLOAT
BEGIN
  DECLARE daily_salary FLOAT;
  SET daily_salary = hourly_rate * 8;
  RETURN daily_salary;
END//

DELIMITER ;

-- Usage example:
SELECT employee_name, CalculateDailySalary(hourly_rate) AS daily_salary
FROM employee
JOIN hourly_employee ON employee.id = hourly_employee.employee_id;

-- 9. Use inner and outer joins on all tables

-- Inner join example
SELECT e.employee_name, he.hourly_rate
FROM employee e
INNER JOIN hourly_employee he ON e.id = he.employee_id;

-- Left outer join example
SELECT e.employee_name, se.annual_salary
FROM employee e
LEFT OUTER JOIN salaried_employee se ON e.id = se.employee_id;

-- Right outer join example
SELECT e.employee_name, se.annual_salary
FROM salaried_employee se
RIGHT OUTER JOIN employee e ON se.employee_id = e.id;

-- 10. Use delete and drop function

-- Delete example
DELETE FROM city WHERE id = 101;

-- Drop example
DROP TABLE city;
DROP TABLE employee;
DROP TABLE hourly_employee;
DROP TABLE salaried_employee;

/*
-- 3. Display hourly rates in incremental order and corresponding employee name
SELECT
  (SELECT employee_name FROM employee WHERE id = he.employee_id) AS employee_name,
  hourly_rate
FROM hourly_employee he
ORDER BY hourly_rate;

-- 4. List which salaried employees live in Pune
SELECT
  (SELECT employee_name FROM employee WHERE id = se.employee_id) AS employee_name
FROM salaried_employee se
WHERE (SELECT city FROM city WHERE id = (SELECT city_id FROM employee WHERE id = se.employee_id)) = 'Pune';

-- 5. Display the oldest salaried and hourly employees
SELECT
  (SELECT employee_name FROM employee WHERE id = se.employee_id) AS employee_name,
  (SELECT date_hired FROM employee WHERE id = se.employee_id) AS date_hired
FROM salaried_employee se
WHERE date_hired = (SELECT MIN(date_hired) FROM employee);

SELECT
  (SELECT employee_name FROM employee WHERE id = he.employee_id) AS employee_name,
  (SELECT date_hired FROM employee WHERE id = he.employee_id) AS date_hired
FROM hourly_employee he
WHERE date_hired = (SELECT MIN(date_hired) FROM employee);

-- 6. Which employee has the lowest & highest annual salary
SELECT
  (SELECT employee_name FROM employee WHERE id = se.employee_id) AS employee_name,
  annual_salary
FROM salaried_employee se
WHERE annual_salary = (SELECT MIN(annual_salary) FROM salaried_employee)
   OR annual_salary = (SELECT MAX(annual_salary) FROM salaried_employee);

-- 7. Identify employees who have an annual salary more than 10000 and less than or equal to 20000
SELECT
  (SELECT employee_name FROM employee WHERE id = se.employee_id) AS employee_name,
  annual_salary
FROM salaried_employee se
WHERE annual_salary > 10000 AND annual_salary <= 20000;

-- 8. Write a function / procedure to calculate the daily salary of each hourly employee working 8 hours daily
DELIMITER //

CREATE FUNCTION CalculateDailySalary(hourly_rate FLOAT)
RETURNS FLOAT
BEGIN
  DECLARE daily_salary FLOAT;
  SET daily_salary = hourly_rate * 8;
  RETURN daily_salary;
END//

DELIMITER ;

-- Usage example:
SELECT
  (SELECT employee_name FROM employee WHERE id = he.employee_id) AS employee_name,
  CalculateDailySalary(hourly_rate) AS daily_salary
FROM hourly_employee he;

-- 9. Use inner and outer joins on all tables

-- Inner join example
SELECT
  (SELECT employee_name FROM employee WHERE id = he.employee_id) AS employee_name,
  hourly_rate
FROM hourly_employee he;

-- Left outer join example
SELECT
  (SELECT employee_name FROM employee WHERE id = se.employee_id) AS employee_name,
  annual_salary
FROM salaried_employee se
LEFT JOIN employee e ON se.employee_id = e.id;

-- Right outer join example
SELECT
  (SELECT employee_name FROM employee WHERE id = se.employee_id) AS employee_name,
  annual_salary
FROM employee e
RIGHT JOIN salaried_employee se ON e.id = se.employee_id;

-- 10. Use delete and drop function

-- Delete example
DELETE FROM city WHERE id = 101;

-- Drop example
DROP TABLE city;
DROP TABLE employee;
DROP TABLE hourly_employee;
DROP TABLE salaried_employee;

*/
