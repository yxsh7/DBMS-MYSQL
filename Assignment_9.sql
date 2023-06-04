/*
Q9. Consider following schema
Student(Rollno(PK), Name,City,mobileno)
Subject(sub_code(PK), sub_name,tot_marks,rollno(FK))
Scored(Rollno, sub_code, marks_obtained)
Write following queries in SQL
1. Create above table with all constraints.
2. Insert 10 records in each table.
3. Display count of student city wise.
4. Add new column result with default value “Pass”
5. Display Highest & lowest marks for every subject.
6. Find students with city staring from ‘P’ 
7. Find students with city name ends with ‘Pur’
8. Create view for attributes -- rollno, sub_name, marks_obtained
9. Use trigger to backup student information when a student is deleted
10. Use left and right join
*/

-- Create the Student table
CREATE TABLE Student (
  Rollno INT PRIMARY KEY,
  Name VARCHAR(100),
  City VARCHAR(100),
  mobileno VARCHAR(20)
);

-- Create the Subject table
CREATE TABLE Subject (
  sub_code INT PRIMARY KEY,
  sub_name VARCHAR(100),
  tot_marks INT,
  rollno INT,
  FOREIGN KEY (rollno) REFERENCES Student (Rollno)
);

-- Create the Scored table
CREATE TABLE Scored (
  Rollno INT,
  sub_code INT,
  marks_obtained INT,
  PRIMARY KEY (Rollno, sub_code),
  FOREIGN KEY (Rollno) REFERENCES Student (Rollno),
  FOREIGN KEY (sub_code) REFERENCES Subject (sub_code)
);

-- Insert 10 records into the Student table
INSERT INTO Student (Rollno, Name, City, mobileno)
VALUES
  (1, 'John Doe', 'Pune', '1234567890'),
  (2, 'Jane Smith', 'Mumbai', '9876543210'),
  (3, 'Robert Johnson', 'Delhi', '7894561230'),
  (4, 'Emily Williams', 'Pune', '6547893210'),
  (5, 'Michael Brown', 'Pune', '3216549870'),
  (6, 'Jessica Davis', 'Mumbai', '4561237890'),
  (7, 'David Miller', 'Delhi', '7891234560'),
  (8, 'Sarah Wilson', 'Pune', '6543219870'),
  (9, 'Andrew Taylor', 'Mumbai', '3217896540'),
  (10, 'Olivia Anderson', 'Pune', '9873216540');

-- Insert 10 records into the Subject table
INSERT INTO Subject (sub_code, sub_name, tot_marks, rollno)
VALUES
  (1, 'Mathematics', 100, 1),
  (2, 'Physics', 100, 2),
  (3, 'Chemistry', 100, 3),
  (4, 'English', 100, 4),
  (5, 'History', 100, 5),
  (6, 'Geography', 100, 6),
  (7, 'Biology', 100, 7),
  (8, 'Computer Science', 100, 8),
  (9, 'Economics', 100, 9),
  (10, 'Business Studies', 100, 10);

-- Insert 10 records into the Scored table
INSERT INTO Scored (Rollno, sub_code, marks_obtained)
VALUES
  (1, 1, 90),
  (2, 2, 85),
  (3, 3, 95),
  (4, 4, 75),
  (5, 5, 80),
  (6, 6, 92),
  (7, 7, 88),
  (8, 8, 82),
  (9, 9, 91),
  (10, 10, 87);

-- Display the count of students city-wise
SELECT City, COUNT(*) AS student_count
FROM Student
GROUP BY City;

-- Add a new column 'result' with a default value of 'Pass' in the Student table
ALTER TABLE Student
ADD result VARCHAR(10) DEFAULT 'Pass';

-- Display the highest and lowest marks for every subject
SELECT sub_code, MAX(marks_obtained) AS highest_marks, MIN(marks_obtained) AS lowest_marks
FROM Scored
GROUP BY sub_code;

-- Find students with city names starting from 'P'
SELECT *
FROM Student
WHERE City LIKE 'P%';

-- Find students with city names ending with 'Pur'
SELECT *
FROM Student
WHERE City LIKE '%Pur';

-- Create a view for the attributes rollno, sub_name, and marks_obtained
CREATE VIEW ScoreView AS
SELECT s.Rollno, sub.sub_name, sc.marks_obtained
FROM Scored sc
JOIN Student s ON sc.Rollno = s.Rollno
JOIN Subject sub ON sc.sub_code = sub.sub_code;

-- Create a trigger to backup student information when a student is deleted
DELIMITER //
CREATE TRIGGER BackupStudent
AFTER DELETE ON Student
FOR EACH ROW
BEGIN
  INSERT INTO StudentBackup (Rollno, Name, City, mobileno)
  VALUES (OLD.Rollno, OLD.Name, OLD.City, OLD.mobileno);
END //
DELIMITER ;

-- Perform a left join and right join
-- Left join: Get all students and their corresponding scores (if any)
SELECT *
FROM Student s
LEFT JOIN Scored sc ON s.Rollno = sc.Rollno;

-- Right join: Get all scores and their corresponding students (if any)
SELECT *
FROM Scored sc
RIGHT JOIN Student s ON sc.Rollno = s.Rollno;

-- Truncate the tables
TRUNCATE TABLE Student;
TRUNCATE TABLE Subject;
TRUNCATE TABLE Scored;


