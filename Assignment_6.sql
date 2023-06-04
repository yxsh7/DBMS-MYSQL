/*
Q6. Use following schema
Customer (custid(PK), name(not null), address, age(check>0), productid(FK))
Shop(productid(pk), productname, productprice(check>0))
1. Create above tables with all constraints.
2. Insert minimum 10 records in each table.
3. List all customers living in same location.
4. List all customer whose age is in between 30 to 40
5. List all customers having product id 11.
6. List count of customer having same product id.
7. Display list of customer name start with “P”
8. Arrange the data in ascending order by customer name and descending order by age.
9. Write a procedure using cursor to display total price of products purchased per customer
10. Create view on customer table with address:”Pune
*/

-- Create tables with all constraints

CREATE TABLE Shop (
  productid INT PRIMARY KEY,
  productname VARCHAR(100),
  productprice DECIMAL(10, 2) CHECK (productprice > 0)
);


CREATE TABLE Customer (
  custid INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  address VARCHAR(100),
  age INT CHECK (age > 0),
  productid INT,
  FOREIGN KEY (productid) REFERENCES Shop(productid)
);

-- Insert sample data into the Shop table
INSERT INTO Shop (productid, productname, productprice)
VALUES
  (11, 'Product A', 100.00),
  (12, 'Product B', 50.00),
  (13, 'Product C', 75.00);
  
-- Insert sample data into the Customer table
INSERT INTO Customer (custid, name, address, age, productid)
VALUES
  (1, 'John Smith', 'New York', 35, 11),
  (2, 'Emma Johnson', 'Los Angeles', 28, 12),
  (3, 'Michael Brown', 'New York', 42, 11),
  (4, 'Sophia Lee', 'Chicago', 31, 13),
  (5, 'James Davis', 'New York', 39, 11),
  (6, 'Olivia Wilson', 'Los Angeles', 45, 11),
  (7, 'Liam Anderson', 'Chicago', 32, 12),
  (8, 'Ava Thomas', 'New York', 33, 11),
  (9, 'Noah Jackson', 'Los Angeles', 37, 13),
  (10, 'Isabella White', 'Chicago', 41, 12),
  (11, 'Mason Harris', 'New York', 29, 11),
  (12, 'Charlotte Martinez', 'Los Angeles', 36, 13);



-- List all customers living in the same location
SELECT *
FROM Customer
WHERE address IN (
  SELECT address
  FROM Customer
  GROUP BY address
  HAVING COUNT(*) > 1
);

-- List all customers whose age is between 30 and 40
SELECT *
FROM Customer
WHERE age BETWEEN 30 AND 40;

-- List all customers having product id 11
SELECT *
FROM Customer
WHERE productid = 11;

-- List the count of customers having the same product id
SELECT productid, COUNT(*) AS customer_count
FROM Customer
GROUP BY productid;

-- Display a list of customer names starting with "P"
SELECT name
FROM Customer
WHERE name LIKE 'P%';

-- Arrange the data in ascending order by customer name and descending order by age
SELECT *
FROM Customer
ORDER BY name ASC, age DESC;

-- Write a procedure using a cursor to display the total price of products purchased per customer
DELIMITER //

CREATE PROCEDURE CalculateTotalPrice()
BEGIN
  DECLARE cust_id INT;
  DECLARE total_price DECIMAL(10, 2);
  
  DECLARE done INT DEFAULT FALSE;
  DECLARE cur CURSOR FOR SELECT custid FROM Customer;
  
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  OPEN cur;
  
  read_loop: LOOP
    FETCH cur INTO cust_id;
    
    IF done THEN
      LEAVE read_loop;
    END IF;
    
    SELECT SUM(productprice) INTO total_price
    FROM Customer
    INNER JOIN Shop ON Customer.productid = Shop.productid
    WHERE Customer.custid = cust_id;
    
    SELECT CONCAT('Customer ID: ', cust_id, ', Total Price: Rs. ', total_price) AS result;
  END LOOP;
  
  CLOSE cur;
END //

DELIMITER ;

-- Call the procedure to calculate the total price per customer
CALL CalculateTotalPrice();

-- Create a view on the Customer table with address = 'Pune'
CREATE VIEW Customer_Pune AS
SELECT *
FROM Customer
WHERE address = 'Pune';
