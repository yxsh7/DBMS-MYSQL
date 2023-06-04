/*
Q10. University(uid(PK),uname,location,state)
College(collegecode(pk),collegename (Not Null), address,contactno,email(Unique), 
total_no_dept, universityid(FK))
1. Create above table with constraints.
2. Insert 10 records in each table.
3. Display name of university in “Maharashtra state”.
4. Display list of all colleges having total dept count is 5.
5. Display list of universities contains “un”
6. Display name of colleges belongs to “SPPU University”
7. Display any three random collge details.
8. Create view on college table with college name and address.
9. Write trigger/cursor/procedure / function to display details from University relation.
10. Perform any one join operation
11. Use truncate and delete table command.
*/

-- Create the University table
CREATE TABLE University (
  uid INT PRIMARY KEY,
  uname VARCHAR(100),
  location VARCHAR(100),
  state VARCHAR(100)
);

-- Create the College table
CREATE TABLE College (
  collegecode INT PRIMARY KEY,
  collegename VARCHAR(100) NOT NULL,
  address VARCHAR(100),
  contactno VARCHAR(20),
  email VARCHAR(100) UNIQUE,
  total_no_dept INT,
  universityid INT,
  FOREIGN KEY (universityid) REFERENCES University (uid)
);

-- Insert 10 records into the University table
INSERT INTO University (uid, uname, location, state)
VALUES
  (1, 'University A', 'Location A', 'Maharashtra'),
  (2, 'University B', 'Location B', 'Maharashtra'),
  (3, 'University C', 'Location C', 'Karnataka'),
  (4, 'University D', 'Location D', 'Tamil Nadu'),
  (5, 'University E', 'Location E', 'Maharashtra'),
  (6, 'University F', 'Location F', 'Karnataka'),
  (7, 'University G', 'Location G', 'Tamil Nadu'),
  (8, 'University H', 'Location H', 'Maharashtra'),
  (9, 'University I', 'Location I', 'Karnataka'),
  (10, 'University J', 'Location J', 'Maharashtra');

-- Insert 10 records into the College table
INSERT INTO College (collegecode, collegename, address, contactno, email, total_no_dept, universityid)
VALUES
  (1, 'College A', 'Address A', '1234567890', 'collegeA@example.com', 5, 1),
  (2, 'College B', 'Address B', '9876543210', 'collegeB@example.com', 3, 2),
  (3, 'College C', 'Address C', '4561237890', 'collegeC@example.com', 4, 3),
  (4, 'College D', 'Address D', '7894561230', 'collegeD@example.com', 5, 1),
  (5, 'College E', 'Address E', '3216549870', 'collegeE@example.com', 2, 2),
  (6, 'College F', 'Address F', '6547893210', 'collegeF@example.com', 5, 1),
  (7, 'College G', 'Address G', '9873216540', 'collegeG@example.com', 3, 2),
  (8, 'College H', 'Address H', '6541237890', 'collegeH@example.com', 4, 3),
  (9, 'College I', 'Address I', '3217896540', 'collegeI@example.com', 5, 1),
  (10, 'College J', 'Address J', '7891234560', 'collegeJ@example.com', 2, 2);

-- Display the name of universities in "Maharashtra" state
SELECT uname
FROM University
WHERE state = 'Maharashtra';

-- Display the list of colleges having a total department count of 5
SELECT *
FROM College
WHERE total_no_dept = 5;

-- Display the list of universities containing "un"
SELECT *
FROM University
WHERE uname LIKE '%un%';

-- Display the names of colleges belonging to "SPPU University"
SELECT collegename
FROM College
WHERE universityid = (
  SELECT uid
  FROM University
  WHERE uname = 'SPPU University'
);

-- Display any three random college details
SELECT *
FROM College
ORDER BY RAND()
LIMIT 3;

-- Create a view on the College table with college name and address
CREATE VIEW CollegeView AS
SELECT collegename, address
FROM College;

-- Perform a join operation (INNER JOIN)
SELECT c.collegename, u.uname
FROM College c
INNER JOIN University u ON c.universityid = u.uid;

-- Truncate the tables
TRUNCATE TABLE University;
TRUNCATE TABLE College;

