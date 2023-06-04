/*
Q12. tblPatient (patient_id (PK), name, age, gender (Check value: M or F),address, disease, 
doctor_id (FK))
tblDoctor (doctor_id (PK), name, age, gender (Check value: M or F), address)
tblLab (lab_no (PK), patient_id (FK), doctor_id (FK), date, amount)
1. Create above tables with all constraints
2. Insert 10 records in each table.
3. Display all patients which are being treated by doctor whose name contains ‘r’ & ‘a’
4. Display all patients which have taken a test in lab along with the total amount spent by 
the patient till date on lab tests
5. List the names of doctors who have never suggested any lab test till date
6. Check if there are any doctors who are also patients
7. Perform inner & right outer join 
8. Display the top 3 patients who have taken the highest number of tests till date
9. Use trigger to check the doctor_id and patient_id being inserted is not the same
10. Use drop and delete command
*/

-- Create the tblDoctor table
CREATE TABLE tblDoctor (
  doctor_id INT PRIMARY KEY,
  name VARCHAR(100),
  age INT,
  gender ENUM('M', 'F') CHECK (gender IN ('M', 'F')),
  address VARCHAR(100)
);

-- Create the tblPatient table
CREATE TABLE tblPatient (
  patient_id INT PRIMARY KEY,
  name VARCHAR(100),
  age INT,
  gender ENUM('M', 'F') CHECK (gender IN ('M', 'F')),
  address VARCHAR(100),
  disease VARCHAR(100),
  doctor_id INT,
  FOREIGN KEY (doctor_id) REFERENCES tblDoctor (doctor_id)
);

-- Create the tblLab table
CREATE TABLE tblLab (
  lab_no INT PRIMARY KEY,
  patient_id INT,
  doctor_id INT,
  date DATE,
  amount DECIMAL(10, 2),
  FOREIGN KEY (patient_id) REFERENCES tblPatient (patient_id),
  FOREIGN KEY (doctor_id) REFERENCES tblDoctor (doctor_id)
);

-- Insert 10 records into the tblDoctor table
INSERT INTO tblDoctor (doctor_id, name, age, gender, address)
VALUES
  (1, 'Dr. Roberts', 40, 'M', '123 Main St'),
  (2, 'Dr. Adams', 35, 'F', '456 Elm St'),
  (3, 'Dr. Walker', 38, 'M', '789 Oak St'),
  (4, 'Dr. Parker', 42, 'F', '321 Maple Ave'),
  (5, 'Dr. Evans', 39, 'M', '654 Pine St'),
  (6, 'Dr. Cooper', 37, 'F', '987 Cedar St'),
  (7, 'Dr. Hughes', 44, 'M', '741 Birch Ave'),
  (8, 'Dr. Morris', 41, 'F', '852 Walnut St'),
  (9, 'Dr. Rogers', 36, 'M', '369 Spruce Ave'),
  (10, 'Dr. Peterson', 33, 'F', '951 Fir St');

-- Insert 10 records into the tblPatient table
INSERT INTO tblPatient (patient_id, name, age, gender, address, disease, doctor_id)
VALUES
  (1, 'John Doe', 35, 'M', '123 Main St', 'Fever', 1),
  (2, 'Jane Smith', 42, 'F', '456 Elm St', 'Cough', 2),
  (3, 'Michael Johnson', 28, 'M', '789 Oak St', 'Headache', 1),
  (4, 'Emily Brown', 39, 'F', '321 Maple Ave', 'Back Pain', 3),
  (5, 'David Taylor', 45, 'M', '654 Pine St', 'Allergies', 2),
  (6, 'Sarah Wilson', 32, 'F', '987 Cedar St', 'Stomachache', 1),
  (7, 'Daniel Anderson', 37, 'M', '741 Birch Ave', 'Flu', 3),
  (8, 'Jessica Miller', 29, 'F', '852 Walnut St', 'Sore Throat', 2),
  (9, 'Andrew Thomas', 41, 'M', '369 Spruce Ave', 'Arthritis', 1),
  (10, 'Olivia Jackson', 33, 'F', '951 Fir St', 'Migraine', 3);

-- Insert 10 records into the tblLab table
INSERT INTO tblLab (lab_no, patient_id, doctor_id, date, amount)
VALUES
  (1, 1, 1, '2022-01-01', 100.00),
  (2, 2, 2, '2022-02-01', 150.00),
  (3, 3, 1, '2022-03-01', 200.00),
  (4, 4, 3, '2022-04-01', 120.00),
  (5, 5, 2, '2022-05-01', 180.00),
  (6, 6, 1, '2022-06-01', 90.00),
  (7, 7, 3, '2022-07-01', 140.00),
  (8, 8, 2, '2022-08-01', 160.00),
  (9, 9, 1, '2022-09-01', 210.00),
  (10, 10, 3, '2022-10-01', 130.00);

-- 3. Display all patients being treated by doctors whose names contain 'r' and 'a'
SELECT p.name AS patient_name, d.name AS doctor_name
FROM tblPatient p
JOIN tblDoctor d ON p.doctor_id = d.doctor_id
WHERE d.name LIKE '%r%' AND d.name LIKE '%a%';

-- 4. Display all patients who have taken a test in the lab along with the total amount spent by the patient till date on lab tests
SELECT p.name AS patient_name, SUM(l.amount) AS total_amount_spent
FROM tblPatient p
JOIN tblLab l ON p.patient_id = l.patient_id
GROUP BY p.patient_id;

-- 5. List the names of doctors who have never suggested any lab test till date
SELECT d.name AS doctor_name
FROM tblDoctor d
LEFT JOIN tblLab l ON d.doctor_id = l.doctor_id
WHERE l.doctor_id IS NULL;

-- 6. Check if there are any doctors who are also patients
SELECT COUNT(*) AS count
FROM tblDoctor d
JOIN tblPatient p ON d.doctor_id = p.doctor_id;

-- 7. Perform inner join
SELECT p.name AS patient_name, d.name AS doctor_name
FROM tblPatient p
JOIN tblDoctor d ON p.doctor_id = d.doctor_id;

-- 7. Perform right outer join
SELECT p.name AS patient_name, d.name AS doctor_name
FROM tblPatient p
RIGHT JOIN tblDoctor d ON p.doctor_id = d.doctor_id;

-- 8. Display the top 3 patients who have taken the highest number of tests till date
SELECT p.name AS patient_name, COUNT(l.lab_no) AS test_count
FROM tblPatient p
LEFT JOIN tblLab l ON p.patient_id = l.patient_id
GROUP BY p.patient_id
ORDER BY test_count DESC
LIMIT 3;

-- 9. Use trigger to check that the doctor_id and patient_id being inserted are not the same
DELIMITER //
CREATE TRIGGER check_doctor_patient_insert
BEFORE INSERT ON tblPatient
FOR EACH ROW
BEGIN
  IF NEW.doctor_id = NEW.patient_id THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The doctor_id and patient_id cannot be the same.';
  END IF;
END //
DELIMITER ;

-- 10. Use DROP and DELETE commands
DROP TABLE IF EXISTS tblLab;
DELETE FROM tblPatient;
DELETE FROM tblDoctor;

