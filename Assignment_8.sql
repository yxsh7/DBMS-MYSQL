/*
Q8. Create following tables
Student(studid(PK), sname, saddr, smarks, age (check -- age>18),deptid (FK))
Dept(deptid(PK),deptname(Not NULL))
1. Create above table and apply all the constraints.
2. Insert 10 records in each table.
3. Display count of student department wise.
4. Display list of student staying in “Pune” City.
5. Count the total number of students.
6. Display customer name having “sh” 
7. Display the unique cities of students
8. group by address and show the result in decreasing order.
9. Create view with studentid, name and address for “IT” department only.
10. Write a function to increase the student marks by 5 if it is greater than 70 and decrease it 
by 5 if it is less than 40.
11. find the total marks of students grouped by city
12. Find the maximum and minimum marks student city wise
*/

-- Create the Dept table
CREATE TABLE Dept (
  deptid INT PRIMARY KEY,
  deptname VARCHAR(100) NOT NULL
);

-- Create the Student table
CREATE TABLE Student (
  studid INT PRIMARY KEY,
  sname VARCHAR(100),
  saddr VARCHAR(100),
  smarks INT,
  age INT CHECK (age > 18),
  deptid INT,
  FOREIGN KEY (deptid) REFERENCES Dept (deptid)
);

-- Insert 2 records into the Dept table
INSERT INTO Dept (deptid, deptname)
VALUES
  (1, 'IT'),
  (2, 'Finance');

-- Insert 10 records into the Student table
INSERT INTO Student (studid, sname, saddr, smarks, age, deptid)
VALUES
  (1, 'John Doe', 'Pune', 85, 20, 1),
  (2, 'Jane Smith', 'Mumbai', 75, 21, 1),
  (3, 'Robert Johnson', 'Pune', 90, 22, 2),
  (4, 'Emily Williams', 'Delhi', 65, 19, 2),
  (5, 'Michael Brown', 'Pune', 80, 20, 1),
  (6, 'Jessica Davis', 'Pune', 95, 21, 2),
  (7, 'David Miller', 'Mumbai', 70, 22, 1),
  (8, 'Sarah Wilson', 'Pune', 60, 19, 2),
  (9, 'Andrew Taylor', 'Delhi', 85, 20, 1),
  (10, 'Olivia Anderson', 'Mumbai', 75, 21, 2);



-- Display the count of students department wise
SELECT d.deptname, COUNT(*) AS student_count
FROM Student s
JOIN Dept d ON s.deptid = d.deptid
GROUP BY d.deptname;

-- Display the list of students staying in "Pune" City
SELECT *
FROM Student
WHERE saddr = 'Pune';

-- Count the total number of students
SELECT COUNT(*) AS total_students
FROM Student;

-- Display the customer name having "sh"
SELECT sname
FROM Student
WHERE sname LIKE '%sh%';

-- Display the unique cities of students
SELECT DISTINCT saddr
FROM Student;

-- Group by address and show the result in decreasing order
SELECT saddr, COUNT(*) AS student_count
FROM Student
GROUP BY saddr
ORDER BY student_count DESC;

-- Create a view with studentid, name, and address for "IT" department only
CREATE VIEW IT_Students AS
SELECT studid, sname, saddr
FROM Student
WHERE deptid = 1;

-- Write a function to increase the student marks by 5 if it is greater than 70 and decrease it by 5 if it is less than 40
DELIMITER //
CREATE FUNCTION UpdateMarks(marks INT) RETURNS INT
BEGIN
  IF marks > 70 THEN
    RETURN marks + 5;
  ELSEIF marks < 40 THEN
    RETURN marks - 5;
  ELSE
    RETURN marks;
  END IF;
END //
DELIMITER ;

-- Find the total marks of students grouped by city
SELECT saddr, SUM(smarks) AS total_marks
FROM Student
GROUP BY saddr;

-- Find the maximum and minimum marks student city wise
SELECT saddr, MAX(smarks) AS max_marks, MIN(smarks) AS min_marks
FROM Student
GROUP BY saddr;
