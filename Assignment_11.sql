/*
1. Create above tables with all constraints
2. Insert 10 records in each table.
3. Display count of movies with same category.
4. Display list of members having name contains “n”
5. Display all movies having profit between 200 to 400
6. Perform cross join
7. Perform inner join
8. Perform left outer join and right outer join.
9. Display all movies with category Animation and profit greater than 300.
10. Use trigger/ cursor/procedure/ function
11. Use drop and delete command.
*/

-- Create the Movie table
CREATE TABLE Movie (
  id INT PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  category VARCHAR(100),
  profit DECIMAL(10, 2)
);

-- Create the Members table
CREATE TABLE Members (
  id INT PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  movie_id INT,
  FOREIGN KEY (movie_id) REFERENCES Movie (id)
);

-- Insert 10 records into the Movie table
INSERT INTO Movie (id, title, category, profit)
VALUES
  (1, 'Movie A', 'Action', 250.50),
  (2, 'Movie B', 'Comedy', 350.75),
  (3, 'Movie C', 'Drama', 400.25),
  (4, 'Movie D', 'Action', 300.80),
  (5, 'Movie E', 'Comedy', 150.60),
  (6, 'Movie F', 'Animation', 500.00),
  (7, 'Movie G', 'Drama', 200.50),
  (8, 'Movie H', 'Animation', 450.25),
  (9, 'Movie I', 'Comedy', 320.90),
  (10, 'Movie J', 'Action', 280.40);

-- Insert 10 records into the Members table
INSERT INTO Members (id, first_name, last_name, movie_id)
VALUES
  (1, 'John', 'Doe', 1),
  (2, 'Jane', 'Smith', 2),
  (3, 'Michael', 'Johnson', 3),
  (4, 'Emily', 'Brown', 1),
  (5, 'David', 'Taylor', 2),
  (6, 'Sarah', 'Wilson', 3),
  (7, 'Daniel', 'Anderson', 1),
  (8, 'Jessica', 'Miller', 2),
  (9, 'Andrew', 'Thomas', 3),
  (10, 'Olivia', 'Jackson', 1);



-- Display the count of movies with the same category
SELECT category, COUNT(*) AS count
FROM Movie
GROUP BY category;

-- Display the list of members whose name contains "n"
SELECT *
FROM Members
WHERE first_name LIKE '%n%' OR last_name LIKE '%n%';

-- Display all movies having profit between 200 and 400
SELECT *
FROM Movie
WHERE profit BETWEEN 200 AND 400;

-- Perform a cross join
SELECT *
FROM Members
CROSS JOIN Movie;

-- Perform an inner join
SELECT m.id, m.first_name, m.last_name, mv.title
FROM Members m
INNER JOIN Movie mv ON m.movie_id = mv.id;

-- Perform a left outer join
SELECT m.id, m.first_name, m.last_name, mv.title
FROM Members m
LEFT OUTER JOIN Movie mv ON m.movie_id = mv.id;

-- Perform a right outer join
SELECT m.id, m.first_name, m.last_name, mv.title
FROM Members m
RIGHT OUTER JOIN Movie mv ON m.movie_id = mv.id;

-- Display all movies with the category "Animation" and profit greater than 300
SELECT *
FROM Movie
WHERE category = 'Animation' AND profit > 300;

-- Drop the Members table
DROP TABLE Members;

-- Delete the Movie table
DELETE FROM Movie;
