/*
Q17. Login_history (Login_datetime, user_id (FK))
Web_user (user_id (PK), fname, lname, email, active_status, signup_datetime)
Site_post (post_id (PK), user_id (FK), post_datetime, post_title)
1. Create above tables with all constraints and appropriate data types
2. Insert 10 records in each table.
3. List the user who has never logged in to system
4. List the users who have logged in before 18th May 2022 and after 7th April 2022
5. List the users who have and have not created any post yet
6. Write left and right outer join
7. Write a procedure to display the user who have written a post titled “Database Queries”
8. Display List of users who have same post_datetime & Login_datetime
9. List users who have logged in now using the appropriate function
10. Write a trigger to backup deleted posts
*/

CREATE TABLE Web_user (
  user_id INT PRIMARY KEY,
  fname VARCHAR(50),
  lname VARCHAR(50),
  email VARCHAR(100),
  active_status VARCHAR(10),
  signup_datetime DATETIME
);

-- Task 1: Create above tables with all constraints and appropriate data types
CREATE TABLE Login_history (
  Login_datetime DATETIME,
  user_id INT,
  FOREIGN KEY (user_id) REFERENCES Web_user(user_id)
);



CREATE TABLE Site_post (
  post_id INT PRIMARY KEY,
  user_id INT,
  post_datetime DATETIME,
  post_title VARCHAR(100),
  FOREIGN KEY (user_id) REFERENCES Web_user(user_id)
);

INSERT INTO Web_user (user_id, fname, lname, email, active_status, signup_datetime) VALUES
  (1, 'John', 'Doe', 'john.doe@example.com', 'Active', '2022-04-01 08:00:00'),
  (2, 'Jane', 'Smith', 'jane.smith@example.com', 'Active', '2022-04-02 10:00:00');
  
-- Task 2: Insert 10 records in each table (Sample data)
INSERT INTO Login_history (Login_datetime, user_id) VALUES
  ('2022-05-01 10:00:00', 1),
  ('2022-05-02 12:00:00', 2);



INSERT INTO Site_post (post_id, user_id, post_datetime, post_title) VALUES
  (1, 1, '2022-05-01 09:00:00', 'Post 1'),
  (2, 2, '2022-05-02 11:00:00', 'Post 2');

-- Task 3: List the user who has never logged in to the system
SELECT w.user_id, w.fname, w.lname
FROM Web_user w
LEFT JOIN Login_history l ON w.user_id = l.user_id
WHERE l.user_id IS NULL;

-- Task 4: List the users who have logged in before 18th May 2022 and after 7th April 2022
SELECT w.user_id, w.fname, w.lname
FROM Web_user w
JOIN Login_history l ON w.user_id = l.user_id
WHERE l.Login_datetime < '2022-05-18' AND l.Login_datetime > '2022-04-07';

-- Task 5: List the users who have and have not created any post yet
SELECT w.user_id, w.fname, w.lname
FROM Web_user w
LEFT JOIN Site_post p ON w.user_id = p.user_id
WHERE p.user_id IS NULL;

-- Task 6: Write left and right outer join
SELECT w.user_id, w.fname, w.lname, p.post_title
FROM Web_user w
LEFT JOIN Site_post p ON w.user_id = p.user_id;

SELECT w.user_id, w.fname, w.lname, p.post_title
FROM Site_post p
RIGHT JOIN Web_user w ON p.user_id = w.user_id;

-- Task 7: Write a procedure to display the user who have written a post titled "Database Queries"
DELIMITER $$
CREATE PROCEDURE GetUsersWithPostTitle()
BEGIN
  SELECT w.user_id, w.fname, w.lname
  FROM Web_user w
  JOIN Site_post p ON w.user_id = p.user_id
  WHERE p.post_title = 'Database Queries';
END $$
DELIMITER ;

-- Task 8: Display List of users who have the same post_datetime & Login_datetime
SELECT w.user_id, w.fname, w.lname
FROM Web_user w
JOIN Login_history l ON w.user_id = l.user_id
JOIN Site_post p ON w.user_id = p.user_id
WHERE l.Login_datetime = p.post_datetime;

-- Task 9: List users who have logged in now using the appropriate function
SELECT w.user_id, w.fname, w.lname
FROM Web_user w
JOIN Login_history l ON w.user_id = l.user_id
WHERE l.Login_datetime = NOW();

-- Task 10: Write a trigger to backup deleted post
DELIMITER $$
CREATE TRIGGER BackupDeletedPost
AFTER DELETE ON Site_post
FOR EACH ROW
BEGIN
  INSERT INTO DeletedPosts (post_id, user_id, post_datetime, post_title)
  VALUES (OLD.post_id, OLD.user_id, OLD.post_datetime, OLD.post_title);
END $$
DELIMITER ;

/*
-- Task 3: List the user who has never logged in to the system
SELECT user_id, fname, lname
FROM Web_user
WHERE user_id NOT IN (SELECT user_id FROM Login_history);

-- Task 4: List the users who have logged in before 18th May 2022 and after 7th April 2022
SELECT user_id, fname, lname
FROM Web_user
WHERE user_id IN (
  SELECT user_id
  FROM Login_history
  WHERE Login_datetime < '2022-05-18' AND Login_datetime > '2022-04-07'
);

-- Task 5: List the users who have and have not created any post yet
SELECT user_id, fname, lname
FROM Web_user
WHERE user_id IN (
  SELECT user_id
  FROM Site_post
) OR user_id NOT IN (
  SELECT user_id
  FROM Site_post
);

-- Task 6: Display List of users who have the same post_datetime & Login_datetime
SELECT w.user_id, w.fname, w.lname
FROM Web_user w
WHERE EXISTS (
  SELECT *
  FROM Login_history l
  WHERE l.user_id = w.user_id
    AND EXISTS (
      SELECT *
      FROM Site_post p
      WHERE p.user_id = w.user_id
        AND p.post_datetime = l.Login_datetime
    )
);

-- Task 8: List the user who have written a post titled "Database Queries"
DELIMITER $$
CREATE PROCEDURE GetUsersWithPostTitle()
BEGIN
  SELECT user_id, fname, lname
  FROM Web_user
  WHERE user_id IN (
    SELECT user_id
    FROM Site_post
    WHERE post_title = 'Database Queries'
  );
END $$
DELIMITER ;

*/