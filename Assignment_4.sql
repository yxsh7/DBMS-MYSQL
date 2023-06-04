/*
Q4. Use following schema;
Student(studId(PK),name not null,m1,m2,m3,m4,m5,result, deptId(FK))
Department (deptId (PK),deptname(Not Null),address)
1. Create student and department tables
2. Apply constraints and insert atleast 10 records in each table.
3. Add new column percentage (check -- value between 0 to 100) in student table.
4. Display student name, percentage, result, deptId where dept=”IT” and arranged by student 
name.
5. Calculate percentage using a function for each record.
6. Write a procedure to Update status as pass or fail based on percentage
7. Display student names having only 5 letters
8. Display count of student belongs to same department.
9. Perform inner and outer join
*/
-- Create Department table
CREATE TABLE Department (
  deptId INT PRIMARY KEY,
  deptname VARCHAR(255) NOT NULL,
  address VARCHAR(100)
);

-- Create Student table
CREATE TABLE Student (
  studId INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  m1 INT,
  m2 INT,
  m3 INT,
  m4 INT,
  m5 INT,
  result VARCHAR(10),
  deptId INT,
  percentage FLOAT,
  FOREIGN KEY (deptId) REFERENCES Department(deptId)
);

-- Insert records into the Department table
INSERT INTO Department (deptId, deptname, address) VALUES
(1, 'IT', 'Address 1'),
(2, 'HR', 'Address 2'),
(3, 'Finance', 'Address 3');

-- Insert records into the Student table
INSERT INTO Student (studId, name, m1, m2, m3, m4, m5, result, deptId)
VALUES
(1, 'John Doe', 80, 75, 90, 85, 95, 'Pass', 1),
(2, 'Jane Smith', 70, 85, 80, 90, 75, 'Pass', 2),
(3, 'Mike Johnson', 90, 80, 85, 70, 60, 'Fail', 1),
(4, 'Sarah Williams', 85, 90, 75, 80, 85, 'Pass', 3),
(5, 'Emily Davis', 80, 75, 85, 90, 70, 'Pass', 2),
(6, 'David Brown', 75, 85, 70, 80, 90, 'Pass', 1),
(7, 'Jessica Wilson', 90, 75, 80, 85, 90, 'Pass', 3),
(8, 'Andrew Miller', 80, 90, 75, 80, 85, 'Pass', 1),
(9, 'Olivia Taylor', 70, 80, 90, 85, 75, 'Pass', 2),
(10, 'Daniel Anderson', 75, 70, 85, 90, 80, 'Pass', 3);

-- Drop existing "percentage" column
ALTER TABLE Student
DROP COLUMN percentage;

-- Add new "percentage" column
ALTER TABLE Student
ADD percentage FLOAT CHECK (percentage >= 0 AND percentage <= 100);

-- Display student name, percentage, result, deptId where dept="IT" and arranged by student name
SELECT name, percentage, result, deptId
FROM Student
WHERE deptId IN (SELECT deptId FROM Department WHERE deptname = 'IT')
ORDER BY name;

-- Calculate percentage using a function for each record
UPDATE Student
SET percentage = (m1 + m2 + m3 + m4 + m5) / 5.0;

-- Procedure to update status as pass or fail based on percentage
DELIMITER //
CREATE PROCEDURE UpdateStatus()
BEGIN
  UPDATE Student
  SET result = CASE WHEN percentage >= 50 THEN 'Pass' ELSE 'Fail' END;
END //
DELIMITER ;

CALL UpdateStatus();

-- Display student names having only 5 letters
SELECT name
FROM Student
WHERE LENGTH(name) = 5;

-- Display the count of students belonging to the same department
SELECT d.deptname, COUNT(*) AS student_count
FROM Department d
JOIN Student s ON d.deptId = s.deptId
GROUP BY d.deptname;

-- Inner Join
SELECT s.name, d.deptname
FROM Student s
INNER JOIN Department d ON s.deptId = d.deptId;

-- Left Outer Join
SELECT s.name, d.deptname
FROM Student s
LEFT JOIN Department d ON s.deptId = d.deptId;

-- Right Outer Join
SELECT s.name, d.deptname
FROM Student s
RIGHT JOIN Department d ON s.deptId = d.deptId;


