/*
Q7. Consider following schema
Book---> {ISBNNO(PK), Title (Not NULL), PID(FK), Edition, Price (check -- price >0), 
Quantity}
Publisher---> {PubID(PK), PubName, mobileno, PEmail}
1. Create above Tables and apply constraints
2. Add unique constraints for email of authors
3. Insert 10 records for each table
4. Add attribute city in publisher table (default value for city= 'Pune')
5. Display list of all books published by Pubid:101
6. Rename City attribute as Pub_city in publisher
7. Remove books details for ISBN no:B101
8. Create virtual table”BookData” showing book Title and publisher name for all books.
9. Display all publishers whose name contains “sh”
10. Write a trigger to not allow quantity of a book below two copies
11. Truncate both the tables
*/
-- Create the Publisher table
CREATE TABLE Publisher (
  PubID INT PRIMARY KEY,
  PubName VARCHAR(100),
  mobileno VARCHAR(15),
  PEmail VARCHAR(100) UNIQUE,
  City VARCHAR(50) DEFAULT 'Pune'
);

-- Create the Book table
CREATE TABLE Book (
  ISBNNO VARCHAR(10) PRIMARY KEY,
  Title VARCHAR(100) NOT NULL,
  PID INT,
  Edition INT,
  Price DECIMAL(10, 2) CHECK (Price > 0),
  Quantity INT,
  FOREIGN KEY (PID) REFERENCES Publisher (PubID)
);

-- Insert 10 records into the Publisher table
INSERT INTO Publisher (PubID, PubName, mobileno, PEmail)
VALUES
  (101, 'Publisher 1', '1234567890', 'pub1@example.com'),
  (102, 'Publisher 2', '9876543210', 'pub2@example.com'),
  (103, 'Publisher 3', '5678901234', 'pub3@example.com'),
  (104, 'Publisher 4', '4321098765', 'pub4@example.com'),
  (105, 'Publisher 5', '6789012345', 'pub5@example.com');


-- Insert 10 records into the Book table
INSERT INTO Book (ISBNNO, Title, PID, Edition, Price, Quantity)
VALUES
  ('ISBN001', 'Book 1', 101, 1, 10.99, 5),
  ('ISBN002', 'Book 2', 102, 2, 19.99, 8),
  ('ISBN003', 'Book 3', 103, 1, 15.99, 12),
  ('ISBN004', 'Book 4', 101, 2, 9.99, 3),
  ('ISBN005', 'Book 5', 102, 3, 14.99, 7),
  ('ISBN006', 'Book 6', 103, 1, 12.99, 10),
  ('ISBN007', 'Book 7', 104, 2, 18.99, 6),
  ('ISBN008', 'Book 8', 104, 1, 16.99, 9),
  ('ISBN009', 'Book 9', 105, 2, 11.99, 4),
  ('ISBN010', 'Book 10', 105, 3, 13.99, 11);




-- Add the 'city' attribute to the Publisher table with a default value of 'Pune'
ALTER TABLE Publisher
ADD COLUMN City VARCHAR(50) DEFAULT 'Pune';

-- Display the list of all books published by PubID:101
SELECT b.Title, p.PubName
FROM Book b
JOIN Publisher p ON b.PID = p.PubID
WHERE b.PID = 101;

-- Rename the 'City' attribute to 'Pub_city' in the Publisher table
ALTER TABLE Publisher
CHANGE COLUMN City Pub_city VARCHAR(50);

-- Remove the book details for ISBN no: B101
DELETE FROM Book WHERE ISBNNO = 'B101';

-- Create a virtual table 'BookData' showing book Title and publisher name for all books
CREATE VIEW BookData AS
SELECT b.Title, p.PubName
FROM Book b
JOIN Publisher p ON b.PID = p.PubID;

-- Display all publishers whose name contains 'sh'
SELECT *
FROM Publisher
WHERE PubName LIKE '%sh%';

-- Create a trigger to not allow the quantity of a book below two copies
DELIMITER //
CREATE TRIGGER CheckQuantity
BEFORE UPDATE ON Book
FOR EACH ROW
BEGIN
  IF NEW.Quantity < 2 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Book quantity cannot be less than 2.';
  END IF;
END //
DELIMITER ;


