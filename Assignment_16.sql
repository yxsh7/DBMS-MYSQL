/*
donor(donor_ID(pk), blood_type_ID(fk), name, contact_number, donor_card ID(fk))
donor transaction(d_trans_ID(pk), donor_ID(fk), donation_confirmation, health_condition, date)
donation card(card_ID(pk), donor_id(fk), details)
recipient transactions(r_trans_id(pk), recipient_ID(fk), blood_type_ID(fk), recipient_request, date, donor_card ID(fk))
blood type(blood_type_ID(pk), name, desciption)
recipient(recipient_ID(pk), donor_ID(FK), blood_type_ID(fk),name,contact_number)

1. Insert 10 records in each table.
2. Display list of recipients whose name contains 4 or more characters
3. List the names of recipients who have received blood after 1 Jan 2022 and before today
4. List the names of recipients who have received blood excluding dates mentioned above
5. Display the names of recipients and their respective donors using PL/SQL block
6. Display the count of donors for distinct blood_type in increasing order
7. Alter table to add donor and recipient age & city columns.
8. Alter table to add check constraint that age should be more than 18
9. List the donors who are also receivers 
10. Use delete and drop command

*/
-- Create tables
CREATE TABLE donor (
    donor_ID INT PRIMARY KEY,
    blood_type_ID INT,
    name VARCHAR(50),
    contact_number VARCHAR(20),
    donor_card_ID INT
);

CREATE TABLE donor_transaction (
    d_trans_ID INT PRIMARY KEY,
    donor_ID INT,
    donation_confirmation VARCHAR(20),
    health_condition VARCHAR(20),
    date DATE
);

CREATE TABLE donation_card (
    card_ID INT PRIMARY KEY,
    donor_ID INT,
    details VARCHAR(100)
);

CREATE TABLE recipient_transactions (
    r_trans_id INT PRIMARY KEY,
    recipient_ID INT,
    blood_type_ID INT,
    recipient_request VARCHAR(100),
    date DATE,
    donor_card_ID INT
);

CREATE TABLE blood_type (
    blood_type_ID INT PRIMARY KEY,
    name VARCHAR(20),
    description VARCHAR(100)
);

CREATE TABLE recipient (
    recipient_ID INT PRIMARY KEY,
    donor_ID INT,
    blood_type_ID INT,
    name VARCHAR(50),
    contact_number VARCHAR(20)
);

-- Insert records into tables
INSERT INTO donor VALUES
    (1, 1, 'John Doe', '1234567890', 1),
    (2, 2, 'Jane Smith', '2345678901', 2),
    (3, 3, 'David Johnson', '3456789012', 3),
    (4, 1, 'Sarah Davis', '4567890123', 4),
    (5, 2, 'Michael Brown', '5678901234', 5),
    (6, 3, 'Emily Wilson', '6789012345', 6),
    (7, 1, 'Christopher Lee', '7890123456', 7),
    (8, 2, 'Olivia Taylor', '8901234567', 8),
    (9, 3, 'Daniel Clark', '9012345678', 9),
    (10, 1, 'Sophia Hernandez', '0123456789', 10);

INSERT INTO donor_transaction VALUES
    (1, 1, 'Confirmed', 'Good', '2023-05-30'),
    (2, 2, 'Confirmed', 'Excellent', '2023-05-29'),
    (3, 3, 'Confirmed', 'Fair', '2023-05-28'),
    (4, 4, 'Confirmed', 'Good', '2023-05-27'),
    (5, 5, 'Confirmed', 'Excellent', '2023-05-26'),
    (6, 6, 'Confirmed', 'Fair', '2023-05-25'),
    (7, 7, 'Confirmed', 'Good', '2023-05-24'),
    (8, 8, 'Confirmed', 'Excellent', '2023-05-23'),
    (9, 9, 'Confirmed', 'Fair', '2023-05-22'),
    (10, 10, 'Confirmed', 'Good', '2023-05-21');

INSERT INTO donation_card VALUES
    (1, 1, 'Card details for John Doe'),
    (2, 2, 'Card details for Jane Smith'),
    (3, 3, 'Card details for David Johnson'),
    (4, 4, 'Card details for Sarah Davis'),
    (5, 5, 'Card details for Michael Brown'),
    (6, 6, 'Card details for Emily Wilson'),
    (7, 7, 'Card details for Christopher Lee'),
    (8, 8, 'Card details for Olivia Taylor'),
    (9, 9, 'Card details for Daniel Clark'),
    (10, 10, 'Card details for Sophia Hernandez');

INSERT INTO recipient_transactions VALUES
    (1, 1, 1, 'Request details for John Doe', '2023-05-30', 1),
    (2, 2, 2, 'Request details for Jane Smith', '2023-05-29', 2),
    (3, 3, 3, 'Request details for David Johnson', '2023-05-28', 3),
    (4, 4, 1, 'Request details for Sarah Davis', '2023-05-27', 4),
    (5, 5, 2, 'Request details for Michael Brown', '2023-05-26', 5),
    (6, 6, 3, 'Request details for Emily Wilson', '2023-05-25', 6),
    (7, 7, 1, 'Request details for Christopher Lee', '2023-05-24', 7),
    (8, 8, 2, 'Request details for Olivia Taylor', '2023-05-23', 8),
    (9, 9, 3, 'Request details for Daniel Clark', '2023-05-22', 9),
    (10, 10, 1, 'Request details for Sophia Hernandez', '2023-05-21', 10);

INSERT INTO blood_type VALUES
    (1, 'A+', 'Compatible with A+ and AB+'),
    (2, 'B+', 'Compatible with B+ and AB+'),
    (3, 'O+', 'Compatible with all positive blood types'),
    (4, 'AB+', 'Compatible with AB+ only'),
    (5, 'A-', 'Compatible with A+ and A-'),
    (6, 'B-', 'Compatible with B+ and B-'),
    (7, 'O-', 'Compatible with all negative blood types'),
    (8, 'AB-', 'Compatible with AB+ and AB-');

INSERT INTO recipient VALUES
    (1, 1, 1, 'Amy Johnson', '1234567890'),
    (2, 2, 2, 'Robert Wilson', '2345678901'),
    (3, 3, 3, 'Linda Davis', '3456789012'),
    (4, 4, 1, 'Thomas Smith', '4567890123'),
    (5, 5, 2, 'Karen Brown', '5678901234'),
    (6, 6, 3, 'Steven Clark', '6789012345'),
    (7, 7, 1, 'Patricia Lee', '7890123456'),
    (8, 8, 2, 'Mark Taylor', '8901234567'),
    (9, 9, 3, 'Laura Hernandez', '9012345678'),
    (10, 10, 1, 'Amelia Lee', '0123456789');

-- Display list of recipients whose name contains 4 or more characters
SELECT * FROM recipient WHERE LENGTH(name) >= 4;

-- List the names of recipients who have received blood after 1 Jan 2022 and before today
SELECT r.name FROM recipient_transactions rt, recipient r
WHERE rt.recipient_ID = r.recipient_ID
AND rt.date > '2022-01-01'
AND rt.date < CURDATE();

-- List the names of recipients who have received blood excluding dates mentioned above
SELECT r.name FROM recipient_transactions rt, recipient r
WHERE rt.recipient_ID = r.recipient_ID
AND (rt.date <= '2022-01-01' OR rt.date >= CURDATE());

-- Display the names of recipients and their respective donors using PL/SQL block
SELECT r.name AS recipient_name, d.name AS donor_name
FROM recipient r, donor d
WHERE r.donor_ID = d.donor_ID;


-- Display the count of donors for distinct blood types in increasing order
SELECT b.name AS blood_type, COUNT(*) AS donor_count
FROM donor d, blood_type b
WHERE d.blood_type_ID = b.blood_type_ID
GROUP BY b.name
ORDER BY donor_count ASC;


-- Alter table to add donor and recipient age & city columns
ALTER TABLE donor ADD COLUMN age INT;
ALTER TABLE donor ADD COLUMN city VARCHAR(50);

ALTER TABLE recipient ADD COLUMN age INT;
ALTER TABLE recipient ADD COLUMN city VARCHAR(50);

-- Alter table to add check constraint that age should be more than 18
ALTER TABLE donor ADD CONSTRAINT chk_donor_age CHECK (age > 18);
ALTER TABLE recipient ADD CONSTRAINT chk_recipient_age CHECK (age > 18);

-- List the donors who are also receivers
SELECT d.name FROM donor d, recipient r
WHERE d.donor_ID = r.donor_ID;

-- Use delete and drop commands
DELETE FROM recipient WHERE recipient_ID = 1;

DROP TABLE recipient_transactions;

/*
-- Create tables
CREATE TABLE donor (
    donor_ID INT PRIMARY KEY,
    blood_type_ID INT,
    name VARCHAR(50),
    contact_number VARCHAR(20),
    donor_card_ID INT
);

CREATE TABLE donor_transaction (
    d_trans_ID INT PRIMARY KEY,
    donor_ID INT,
    donation_confirmation VARCHAR(20),
    health_condition VARCHAR(20),
    date DATE
);

CREATE TABLE donation_card (
    card_ID INT PRIMARY KEY,
    donor_ID INT,
    details VARCHAR(100)
);

CREATE TABLE recipient_transactions (
    r_trans_id INT PRIMARY KEY,
    recipient_ID INT,
    blood_type_ID INT,
    recipient_request VARCHAR(100),
    date DATE,
    donor_card_ID INT
);

CREATE TABLE blood_type (
    blood_type_ID INT PRIMARY KEY,
    name VARCHAR(20),
    description VARCHAR(100)
);

CREATE TABLE recipient (
    recipient_ID INT PRIMARY KEY,
    donor_ID INT,
    blood_type_ID INT,
    name VARCHAR(50),
    contact_number VARCHAR(20)
);

-- Insert records into tables
INSERT INTO donor VALUES
    (1, 1, 'John Doe', '1234567890', 1),
    (2, 2, 'Jane Smith', '2345678901', 2),
    (3, 3, 'David Johnson', '3456789012', 3),
    (4, 1, 'Sarah Davis', '4567890123', 4),
    (5, 2, 'Michael Brown', '5678901234', 5),
    (6, 3, 'Emily Wilson', '6789012345', 6),
    (7, 1, 'Christopher Lee', '7890123456', 7),
    (8, 2, 'Olivia Taylor', '8901234567', 8),
    (9, 3, 'Daniel Clark', '9012345678', 9),
    (10, 1, 'Sophia Hernandez', '0123456789', 10);

INSERT INTO donor_transaction VALUES
    (1, 1, 'Confirmed', 'Good', '2023-05-30'),
    (2, 2, 'Confirmed', 'Excellent', '2023-05-29'),
    (3, 3, 'Confirmed', 'Fair', '2023-05-28'),
    (4, 4, 'Confirmed', 'Good', '2023-05-27'),
    (5, 5, 'Confirmed', 'Excellent', '2023-05-26'),
    (6, 6, 'Confirmed', 'Fair', '2023-05-25'),
    (7, 7, 'Confirmed', 'Good', '2023-05-24'),
    (8, 8, 'Confirmed', 'Excellent', '2023-05-23'),
    (9, 9, 'Confirmed', 'Fair', '2023-05-22'),
    (10, 10, 'Confirmed', 'Good', '2023-05-21');

INSERT INTO donation_card VALUES
    (1, 1, 'Card details for John Doe'),
    (2, 2, 'Card details for Jane Smith'),
    (3, 3, 'Card details for David Johnson'),
    (4, 4, 'Card details for Sarah Davis'),
    (5, 5, 'Card details for Michael Brown'),
    (6, 6, 'Card details for Emily Wilson'),
    (7, 7, 'Card details for Christopher Lee'),
    (8, 8, 'Card details for Olivia Taylor'),
    (9, 9, 'Card details for Daniel Clark'),
    (10, 10, 'Card details for Sophia Hernandez');

INSERT INTO recipient_transactions VALUES
    (1, 1, 1, 'Request details for John Doe', '2023-05-30', 1),
    (2, 2, 2, 'Request details for Jane Smith', '2023-05-29', 2),
    (3, 3, 3, 'Request details for David Johnson', '2023-05-28', 3),
    (4, 4, 1, 'Request details for Sarah Davis', '2023-05-27', 4),
    (5, 5, 2, 'Request details for Michael Brown', '2023-05-26', 5),
    (6, 6, 3, 'Request details for Emily Wilson', '2023-05-25', 6),
    (7, 7, 1, 'Request details for Christopher Lee', '2023-05-24', 7),
    (8, 8, 2, 'Request details for Olivia Taylor', '2023-05-23', 8),
    (9, 9, 3, 'Request details for Daniel Clark', '2023-05-22', 9),
    (10, 10, 1, 'Request details for Sophia Hernandez', '2023-05-21', 10);

INSERT INTO blood_type VALUES
    (1, 'A+', 'Compatible with A+ and AB+'),
    (2, 'B+', 'Compatible with B+ and AB+'),
    (3, 'O+', 'Compatible with all positive blood types'),
    (4, 'AB+', 'Compatible with AB+ only'),
    (5, 'A-', 'Compatible with A+ and A-'),
    (6, 'B-', 'Compatible with B+ and B-'),
    (7, 'O-', 'Compatible with all negative blood types'),
    (8, 'AB-', 'Compatible with AB+ and AB-');

INSERT INTO recipient VALUES
    (1, 1, 1, 'Amy Johnson', '1234567890'),
    (2, 2, 2, 'Robert Wilson', '2345678901'),
    (3, 3, 3, 'Linda Davis', '3456789012'),
    (4, 4, 1, 'Thomas Smith', '4567890123'),
    (5, 5, 2, 'Karen Brown', '5678901234'),
    (6, 6, 3, 'Steven Clark', '6789012345'),
    (7, 7, 1, 'Patricia Lee', '7890123456'),
    (8, 8, 2, 'Mark Taylor', '8901234567'),
    (9, 9, 3, 'Laura Hernandez', '9012345678'),
    (10, 10, 1, 'Amelia Lee', '0123456789');

-- Display list of recipients whose name contains 4 or more characters
SELECT * FROM recipient WHERE LENGTH(name) >= 4;

-- List the names of recipients who have received blood after 1 Jan 2022 and before today
SELECT r.name FROM recipient_transactions rt, recipient r
WHERE rt.recipient_ID = r.recipient_ID
AND rt.date > '2022-01-01'
AND rt.date < CURDATE();

-- List the names of recipients who have received blood excluding dates mentioned above
SELECT r.name FROM recipient_transactions rt, recipient r
WHERE rt.recipient_ID = r.recipient_ID
AND (rt.date <= '2022-01-01' OR rt.date >= CURDATE());

-- Display the names of recipients and their respective donors using PL/SQL block
BEGIN
    FOR rec IN (SELECT r.name AS recipient_name, d.name AS donor_name
                FROM recipient_transactions rt, recipient r, donor d
                WHERE rt.recipient_ID = r.recipient_ID
                AND r.donor_ID = d.donor_ID)
    LOOP
        DBMS_OUTPUT.PUT_LINE('Recipient: ' || rec.recipient_name || ', Donor: ' || rec.donor_name);
    END LOOP;
END;
/

-- Display the count of donors for distinct blood types in increasing order
SELECT b.name AS blood_type, COUNT(*) AS donor_count
FROM donor d, blood_type b
WHERE d.blood_type_ID = b.blood_type_ID
GROUP BY b.name
ORDER BY donor_count;

-- Alter table to add donor and recipient age & city columns
ALTER TABLE donor ADD COLUMN age INT;
ALTER TABLE donor ADD COLUMN city VARCHAR(50);

ALTER TABLE recipient ADD COLUMN age INT;
ALTER TABLE recipient ADD COLUMN city VARCHAR(50);

-- Alter table to add check constraint that age should be more than 18
ALTER TABLE donor ADD CONSTRAINT chk_donor_age CHECK (age > 18);
ALTER TABLE recipient ADD CONSTRAINT chk_recipient_age CHECK (age > 18);

-- List the donors who are also receivers
SELECT d.name FROM donor d, recipient r
WHERE d.donor_ID = r.donor_ID;

-- Use delete and drop commands
DELETE FROM recipient WHERE recipient_ID = 1;

DROP TABLE recipient_transactions;

*/