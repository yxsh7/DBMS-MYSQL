/*
Q14. Aircraft(AircraftType, ADescription, NoSeats)
Flight(FlightNo, FromAirport, ToAirport, scheduled_dep, DepTime, scheduled_arrival, ArrTime, 
Departure_delay, AircraftType, RouteNo)
Passenger(Pid, Name, Address, TelNo)
Ticket(TicketNo, TicketDate, Pid)
Itinerary(TicketNo, FlightNo, FlightDate, FareType)
1. Create above tables with all constraints
2. Insert 10 records in each table.
3. Display the list of passengers traveling from London to New Delhi
4. Calculate the average delay of flights from Mumbai airport 
5. Display the frequent flyer passenger details for boeing787 aircraft
6. Write a procedure to display passenger and flight details by passing the ticket no & flight no 
details to procedure
7. Write a function to calculate the departure_delay and use it to update the appropriate 
attribute in Flight table
8. List the flight_no, name, telephone number and address of passengers traveling on flightDate 
= “18 may 2022”
9. Use delete and drop commands
*/

-- Task 1: Create above tables with all constraints
CREATE TABLE Aircraft (
  AircraftType VARCHAR(50) PRIMARY KEY,
  ADescription VARCHAR(100),
  NoSeats INT
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
  FOREIGN KEY (AircraftType) REFERENCES Aircraft(AircraftType)
);

CREATE TABLE Passenger (
  Pid INT PRIMARY KEY,
  Name VARCHAR(50),
  Address VARCHAR(100),
  TelNo VARCHAR(20)
);

CREATE TABLE Ticket (
  TicketNo INT PRIMARY KEY,
  TicketDate DATE,
  Pid INT,
  FOREIGN KEY (Pid) REFERENCES Passenger(Pid)
);

CREATE TABLE Itinerary (
  TicketNo INT,
  FlightNo INT,
  FlightDate DATE,
  FareType VARCHAR(50),
  PRIMARY KEY (TicketNo, FlightNo),
  FOREIGN KEY (TicketNo) REFERENCES Ticket(TicketNo),
  FOREIGN KEY (FlightNo) REFERENCES Flight(FlightNo)
);

-- Task 2: Insert 10 records in each table (Sample data)
INSERT INTO Aircraft (AircraftType, ADescription, NoSeats) VALUES
  ('Boeing787', 'Description 1', 200),
  ('AirbusA320', 'Description 2', 150),
  ('Boeing737', 'Description 3', 180);

INSERT INTO Flight (FlightNo, FromAirport, ToAirport, scheduled_dep, DepTime, scheduled_arrival, ArrTime, Departure_delay, AircraftType, RouteNo) VALUES
  (1, 'London', 'New Delhi', '2023-06-01', '08:00:00', '2023-06-01', '14:00:00', 30, 'Boeing787', 100),
  (2, 'Mumbai', 'Delhi', '2023-06-02', '10:00:00', '2023-06-02', '12:00:00', 0, 'AirbusA320', 200),
  (3, 'Mumbai', 'London', '2023-06-03', '12:00:00', '2023-06-03', '18:00:00', 15, 'Boeing787', 300);

INSERT INTO Passenger (Pid, Name, Address, TelNo) VALUES
  (1, 'John Doe', 'Address 1', '1234567890'),
  (2, 'Jane Smith', 'Address 2', '9876543210');

INSERT INTO Ticket (TicketNo, TicketDate, Pid) VALUES
  (1, '2023-06-01', 1),
  (2, '2023-06-02', 2);

INSERT INTO Itinerary (TicketNo, FlightNo, FlightDate, FareType) VALUES
  (1, 1, '2023-06-01', 'Economy'),
  (2, 2, '2023-06-02', 'Business');

-- Task 3: Display the list of passengers traveling from London to New Delhi
SELECT p.Name
FROM Passenger p
JOIN Ticket t ON p.Pid = t.Pid
JOIN Itinerary i ON t.TicketNo = i.TicketNo
JOIN Flight f ON i.FlightNo = f.FlightNo
WHERE f.FromAirport = 'London' AND f.ToAirport = 'New Delhi';

-- Task 4: Calculate the average delay of flights from Mumbai airport
SELECT AVG(Departure_delay) AS AverageDelay
FROM Flight
WHERE FromAirport = 'Mumbai';

-- Task 5: Display the frequent flyer passenger details for Boeing787 aircraft
SELECT p.Pid, p.Name, p.Address, p.TelNo
FROM Passenger p
JOIN Ticket t ON p.Pid = t.Pid
JOIN Itinerary i ON t.TicketNo = i.TicketNo
JOIN Flight f ON i.FlightNo = f.FlightNo
WHERE f.AircraftType = 'Boeing787';

-- Task 6: Procedure to display passenger and flight details by passing the ticket no & flight no details to the procedure
DELIMITER $$
CREATE PROCEDURE GetPassengerFlightDetails(IN ticketNo INT, IN flightNo INT)
BEGIN
  SELECT p.Name, p.Address, p.TelNo, f.FromAirport, f.ToAirport
  FROM Passenger p
  JOIN Ticket t ON p.Pid = t.Pid
  JOIN Itinerary i ON t.TicketNo = i.TicketNo
  JOIN Flight f ON i.FlightNo = f.FlightNo
  WHERE t.TicketNo = ticketNo AND f.FlightNo = flightNo;
END $$
DELIMITER ;

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

-- Task 8: List the flight_no, name, telephone number, and address of passengers traveling on flightDate = "18 May 2022"
SELECT f.FlightNo, p.Name, p.TelNo, p.Address
FROM Flight f
JOIN Itinerary i ON f.FlightNo = i.FlightNo
JOIN Ticket t ON i.TicketNo = t.TicketNo
JOIN Passenger p ON t.Pid = p.Pid
WHERE i.FlightDate = '2022-05-18';

-- Task 9: Use delete and drop commands
DELETE FROM Flight WHERE FlightNo = 1;
DROP TABLE Passenger;
