/*
Q1.Create schema
Order1(orderid(PK),customerid(fk),orderdate (Check -- date>current_date) ,amount);
Customer(customerid(PK),customername,contactno,country)
Apply constraints as Primary key and foreign key.
Q2. Insert atleast 10 records in each table.
Q3. Select customername and contactno
Q4. Display customer details where country names are same.
Q5. Display total, maximum and minimum amount of the order.
Q6. Perform inner join
Q7. Perform left and right outer Join
Q8. Add one more column in order table as “status”.
Q9. Change the contact number of the any customer.
Q10. Write procedure/ function / trigger to set the status value as paid if amount is greater than
400 else unpaid.
Q11. Use truncate and drop command
*/

/*
Q1.Create schema
Order1(orderid(PK),customerid(fk),orderdate (Check -- date>current_date) ,amount);
Customer(customerid(PK),customername,contactno,country)
Apply constraints as Primary key and foreign key. 
*/
CREATE TABLE Customer (
    customerid INT PRIMARY KEY,
    customername VARCHAR(255),
    contactno VARCHAR(15),
    country VARCHAR(100)
);

CREATE TABLE Order1 (
    orderid INT PRIMARY KEY,
    customerid INT,
    orderdate DATE,
    amount DECIMAL(10, 2),
    FOREIGN KEY (customerid) REFERENCES Customer(customerid),
    CHECK (orderdate > '2023-06-03')
);

--Q2. Insert atleast 10 records in each table.
INSERT INTO Customer (customerid, customername, contactno, country)
VALUES
    (1, 'John Doe', '123456789', 'USA'),
    (2, 'Jane Smith', '987654321', 'Canada'),
    (3, 'David Johnson', '555555555', 'UK'),
    (4, 'Emily Brown', '111222333', 'Australia'),
    (5, 'Michael Wilson', '444444444', 'Germany'),
    (6, 'Sarah Taylor', '999999999', 'France'),
    (7, 'Robert Anderson', '777777777', 'Mexico'),
    (8, 'Olivia Martinez', '666666666', 'Spain'),
    (9, 'Daniel Lee', '222333444', 'Japan'),
    (10, 'Sophia Kim', '888888888', 'South Korea');

INSERT INTO Order1 (orderid, customerid, orderdate, amount)
VALUES
    (1, 1, '2023-06-04', 100.00),
    (2, 1, '2023-06-05', 200.00),
    (3, 2, '2023-06-06', 150.00),
    (4, 3, '2023-06-07', 300.00),
    (5, 4, '2023-06-08', 250.00),
    (6, 5, '2023-06-09', 180.00),
    (7, 6, '2023-06-10', 350.00),
    (8, 7, '2023-06-11', 400.00),
    (9, 8, '2023-06-12', 220.00),
    (10, 9, '2023-06-13', 280.00);

--Q3. Select customername and contactno
SELECT customername, contactno
FROM Customer;

--Q4. Display customer details where country names are same.
SELECT *
FROM Customer
WHERE country IN (
    SELECT country
    FROM Customer
    GROUP BY country
    HAVING COUNT(*) > 1
);

--Q5. Display total, maximum and minimum amount of the order.
SELECT
  SUM(amount) AS total_amount,
  MAX(amount) AS max_amount,
  MIN(amount) AS min_amount
FROM Order1;

--Q6. Perform inner join
SELECT Order1.orderid, Customer.customername, Order1.amount
FROM Order1
INNER JOIN Customer ON Order1.customerid = Customer.customerid;

--Q7. Perform left and right outer Join
SELECT Order1.orderid, Customer.customername, Order1.amount
FROM Order1
LEFT JOIN Customer ON Order1.customerid = Customer.customerid;

SELECT Order1.orderid, Customer.customername, Order1.amount
FROM Order1
RIGHT JOIN Customer ON Order1.customerid = Customer.customerid;

--Q8. Add one more column in order table as “status”.
ALTER TABLE Order1
ADD COLUMN status VARCHAR(50);

--Q9. Change the contact number of the any customer
UPDATE Customer
SET contactno = '9876543210'
WHERE customerid = 1;

--Q10. Write procedure/ function / trigger to set the status value
-- as paid if amount is greater than 400 else unpaid.
DELIMITER //
CREATE TRIGGER update_status_trigger
BEFORE INSERT ON Order1
FOR EACH ROW
BEGIN
    IF NEW.amount > 400 THEN
        SET NEW.status = 'paid';
    ELSE
        SET NEW.status = 'unpaid';
    END IF;
END //
DELIMITER ;

--Q11. Use truncate and drop command
TRUNCATE TABLE Order1;

DROP TABLE Customer;