/*
Q15. 
Route(RouteNo, RDescription)
Fares(FareType, FDescription)
Tariff(RouteNo, FareType, Price)
Flight(FlightNo, FromAirport, ToAirport, scheduled_dep, DepTime, scheduled_arrival, ArrTime, 
Departure_delay, AircraftType, RouteNo, status)
1. Create above tables with all constraints
2. Insert 10 records in each table.
3. List in decreasing order the routes according to price
4. Display distinct count of flights taking off from each airport
5. Display the name of airport where least number of flights are going 
6. List the busiest RouteNo and its starting and ending locations
7. Write a function to calculate the departure_delay and use it to update the appropriate 
attribute in Flight table
8. Write a trigger to maintain a separate record of flights whose status is “canceled”
9. List the fare types of flights with aircraftType like “Boeing”
10. Use delete and drop commands

*/

-- Task 1: Create above tables with all constraints
CREATE TABLE Route (
  RouteNo INT PRIMARY KEY,
  RDescription VARCHAR(100)
);

CREATE TABLE Fares (
  FareType VARCHAR(50) PRIMARY KEY,
  FDescription VARCHAR(100)
);

CREATE TABLE Tariff (
  RouteNo INT,
  FareType VARCHAR(50),
  Price DECIMAL(10,2),
  PRIMARY KEY (RouteNo, FareType),
  FOREIGN KEY (RouteNo) REFERENCES Route(RouteNo),
  FOREIGN KEY (FareType) REFERENCES Fares(FareType)
);

CREATE TABLE Flight (
  FlightNo INT PRIMARY KEY,
  FromAirport VARCHAR(50),
  ToAirport VARCHAR(50),
  scheduled_dep DATE,
  DepTime TIME,
  scheduled_arrival DATE,
  ArrTime TIME,
  Departure_delay INT,
  AircraftType VARCHAR(50),
  RouteNo INT,
  Status VARCHAR(20),
  FOREIGN KEY (RouteNo) REFERENCES Route(RouteNo)
);

-- Task 2: Insert 10 records in each table (Sample data)
INSERT INTO Route (RouteNo, RDescription) VALUES
  (100, 'Description 1'),
  (200, 'Description 2');

INSERT INTO Fares (FareType, FDescription) VALUES
  ('Economy', 'Description 1'),
  ('Business', 'Description 2');

INSERT INTO Tariff (RouteNo, FareType, Price) VALUES
  (100, 'Economy', 100),
  (200, 'Business', 200);

INSERT INTO Flight (FlightNo, FromAirport, ToAirport, scheduled_dep, DepTime, scheduled_arrival, ArrTime, Departure_delay, AircraftType, RouteNo, Status) VALUES
  (1, 'Airport 1', 'Airport 2', '2023-06-01', '08:00:00', '2023-06-01', '14:00:00', 30, 'Boeing', 100, 'On Time'),
  (2, 'Airport 2', 'Airport 3', '2023-06-02', '10:00:00', '2023-06-02', '12:00:00', 0, 'Airbus', 200, 'Delayed');

-- Task 3: List in decreasing order the routes according to price
SELECT r.RouteNo, r.RDescription, MAX(t.Price) AS MaxPrice
FROM Route r
JOIN Tariff t ON r.RouteNo = t.RouteNo
GROUP BY r.RouteNo, r.RDescription
ORDER BY MaxPrice DESC;

-- Task 4: Display distinct count of flights taking off from each airport
SELECT FromAirport, COUNT(DISTINCT FlightNo) AS FlightCount
FROM Flight
GROUP BY FromAirport;

-- Task 5: Display the name of the airport where the least number of flights are going
SELECT FromAirport
FROM Flight
GROUP BY FromAirport
HAVING COUNT(*) = (
  SELECT COUNT(*)
  FROM Flight
  GROUP BY FromAirport
  ORDER BY COUNT(*) ASC
  LIMIT 1
);

-- Task 6: List the busiest RouteNo and its starting and ending locations
SELECT r.RouteNo, r.RDescription, f.FromAirport, f.ToAirport
FROM Route r
JOIN Flight f ON r.RouteNo = f.RouteNo
GROUP BY r.RouteNo, r.RDescription, f.FromAirport, f.ToAirport
HAVING COUNT(*) = (
  SELECT COUNT(*)
  FROM Flight
  GROUP BY RouteNo
  ORDER BY COUNT(*) DESC
  LIMIT 1
);

-- Task 7: Function to calculate the departure_delay and use it to update the appropriate attribute in Flight table
DELIMITER $$
CREATE FUNCTION CalculateDepartureDelay() RETURNS INT
BEGIN
  DECLARE avgDelay INT;
  SET avgDelay = (SELECT AVG(Departure_delay) FROM Flight);
  
  UPDATE Flight
  SET Departure_delay = avgDelay;
  
  RETURN avgDelay;
END $$
DELIMITER ;

-- Task 8: Trigger to maintain a separate record of flights whose status is "canceled"
DELIMITER $$
CREATE TRIGGER BackupCanceledFlights
AFTER UPDATE ON Flight
FOR EACH ROW
BEGIN
  IF NEW.Status = 'Canceled' THEN
    INSERT INTO CanceledFlights (FlightNo, FromAirport, ToAirport, Status) 
    VALUES (OLD.FlightNo, OLD.FromAirport, OLD.ToAirport, OLD.Status);
  END IF;
END $$
DELIMITER ;

-- Task 9: List the fare types of flights with AircraftType like "Boeing"
SELECT DISTINCT t.FareType
FROM Tariff t
JOIN Flight f ON t.RouteNo = f.RouteNo
WHERE f.AircraftType LIKE 'Boeing%';

-- Task 10: Use delete and drop commands
DELETE FROM Flight WHERE FlightNo = 1;
DROP TABLE Passenger;
