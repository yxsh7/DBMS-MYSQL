/*
Q13. Recipe (recipe_id (PK) auto increment, name, description)
Ingredient (ingredient_id (PK) auto increment, name, type)
recipe_ingredient (recipe_id (FK), ingredient_id (FK), quantity) - composite primary key
1. Create above tables with all constraints
2. Insert appropriate number of records in each table.
3. Display the name of the highest used ingredient
4. Display the names of recipes using “barbecue sauce” as an ingredient
5. Display the recipes that has odd number of ingredients
6. Write a procedure to display the list of recipes that contain ingredients same as a certain 
recipe_id passed as in input parameter
7. Alter Table – change data type of quantity attribute from int to float
8. Write a trigger to store deleted recipie into backup table
9. Use drop and delete command
*/

-- Task 1: Create above tables with all constraints
CREATE TABLE Recipe (
  recipe_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50),
  description VARCHAR(100)
);

CREATE TABLE Ingredient (
  ingredient_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50),
  type VARCHAR(50)
);

CREATE TABLE recipe_ingredient (
  recipe_id INT,
  ingredient_id INT,
  quantity INT,
  PRIMARY KEY (recipe_id, ingredient_id),
  FOREIGN KEY (recipe_id) REFERENCES Recipe(recipe_id),
  FOREIGN KEY (ingredient_id) REFERENCES Ingredient(ingredient_id)
);

-- Task 2: Insert appropriate number of records in each table
INSERT INTO Recipe (name, description) VALUES
  ('Recipe 1', 'Description 1'),
  ('Recipe 2', 'Description 2'),
  ('Recipe 3', 'Description 3');

INSERT INTO Ingredient (name, type) VALUES
  ('Ingredient 1', 'Type 1'),
  ('Ingredient 2', 'Type 2'),
  ('Ingredient 3', 'Type 3');

INSERT INTO recipe_ingredient (recipe_id, ingredient_id, quantity) VALUES
  (1, 1, 2),
  (1, 2, 3),
  (2, 2, 1),
  (2, 3, 2),
  (3, 1, 4),
  (3, 3, 3);

-- Task 3: Display the name of the highest used ingredient
SELECT i.name, COUNT(*) AS usage_count
FROM Ingredient i
JOIN recipe_ingredient ri ON i.ingredient_id = ri.ingredient_id
GROUP BY i.name
ORDER BY usage_count DESC
LIMIT 1;

-- Task 4: Display the names of recipes using "barbecue sauce" as an ingredient
SELECT r.name
FROM Recipe r
JOIN recipe_ingredient ri ON r.recipe_id = ri.recipe_id
JOIN Ingredient i ON ri.ingredient_id = i.ingredient_id
WHERE i.name = 'barbecue sauce';

-- Task 5: Display the recipes that have an odd number of ingredients
SELECT r.name
FROM Recipe r
JOIN recipe_ingredient ri ON r.recipe_id = ri.recipe_id
GROUP BY r.recipe_id
HAVING COUNT(*) % 2 = 1;

-- Task 6: Write a procedure to display the list of recipes that contain ingredients same as a certain recipe_id passed as an input parameter
DELIMITER //

CREATE PROCEDURE FindRecipesWithSameIngredients(IN input_recipe_id INT)
BEGIN
  SELECT r.name
  FROM Recipe r
  JOIN recipe_ingredient ri ON r.recipe_id = ri.recipe_id
  WHERE ri.ingredient_id IN (
    SELECT ingredient_id
    FROM recipe_ingredient
    WHERE recipe_id = input_recipe_id
  );
END //

DELIMITER ;

-- Task 7: Alter Table – change data type of quantity attribute from int to float
ALTER TABLE recipe_ingredient
MODIFY COLUMN quantity FLOAT;

-- Task 8: Write a trigger to store deleted recipe into a backup table
DELIMITER //

CREATE TRIGGER backup_deleted_recipe
BEFORE DELETE ON Recipe
FOR EACH ROW
BEGIN
  INSERT INTO backup_recipe (recipe_id, name, description)
  VALUES (OLD.recipe_id, OLD.name, OLD.description);
END //

DELIMITER ;

-- Task 9: Use DROP and DELETE commands
DROP TABLE IF EXISTS recipe_ingredient;
DROP TABLE IF EXISTS Recipe;
DROP TABLE IF EXISTS Ingredient;
