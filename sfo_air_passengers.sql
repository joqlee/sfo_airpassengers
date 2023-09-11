--Dataset: San Francisco International Airport Report on Monthly Passenger Traffic Statistics by Airline
--Source: https://catalog.data.gov/dataset/air-traffic-passenger-statistics

SELECT
* 
FROM 'Air_Traffic_Passenger_Statistics'

--How many unique airlines are in this dataset?
SELECT 
COUNT(DISTINCT(Operating_Airline)) AS num_airlines
FROM 'Air_Traffic_Passenger_Statistics'
-- 102

--What is the total passenger count by whether the flight was domestic or international?
SELECT
GEO_Summary AS flight_type,
SUM(Passenger_Count) AS total_passengers
FROM 'Air_Traffic_Passenger_Statistics'
GROUP BY flight_type
-- International flights had 581,323,145 passengers, domestic flights had 176,507,332 passengers

--What is the total passenger count by flights to/from a certain geographic region?
SELECT
GEO_Region AS region,
SUM(Passenger_Count) AS total_passengers
FROM 'Air_Traffic_Passenger_Statistics'
GROUP BY region
ORDER BY total_passengers DESC
-- US, Asia, and Europe, in order, have the highest total number of passengers departing to/from SFO

--What is the total passenger count for low-cost and non-low-cost carriers?
SELECT
Price_Category_Code AS price_category,
SUM(Passenger_Count) AS total_passengers
FROM 'Air_Traffic_Passenger_Statistics'
GROUP BY price_category
ORDER BY total_passengers DESC
-- Non-low-cost carriers had 638,557,044 passengers, low cost carriers had 119,273,433 passengers

-- What is the total passenger count by operating airline? Which airlines carried the most passengers?
SELECT
Operating_Airline AS airline,
SUM(Passenger_Count) AS total_passengers
FROM 'Air_Traffic_Passenger_Statistics'
GROUP BY airline
ORDER BY total_passengers DESC
-- United Airlines had the most passengers, followed by SkyWest Airlines and American Airlines

-- Which airlines carried the least passengers?
SELECT
Operating_Airline AS airline,
SUM(Passenger_Count) AS total_passengers
FROM 'Air_Traffic_Passenger_Statistics'
GROUP BY airline
ORDER BY total_passengers 
-- Evergreen International Airlines, Boeing Company, Samsic Airport America, LLC

-- Which low-cost airlines carried the most passengers?
SELECT
Operating_Airline AS airline,
SUM(Passenger_Count) AS total_passengers
FROM 'Air_Traffic_Passenger_Statistics'
WHERE Price_Category_Code = 'Low Fare'
GROUP BY airline
ORDER BY total_passengers DESC
-- Southwest Airlines, Virgin America, JetBlue Airways

-- Which boarding areas had the most passengers?
SELECT
Boarding_Area AS boarding_area,
SUM(Passenger_Count) AS total_passengers
FROM 'Air_Traffic_Passenger_Statistics'
GROUP BY boarding_area
ORDER BY total_passengers DESC
-- Boarding Area F, followed by G and B

-- Which terminals had the most passengers?
SELECT
Terminal,
SUM(Passenger_Count) AS total_passengers
FROM 'Air_Traffic_Passenger_Statistics'
GROUP BY Terminal
ORDER BY total_passengers DESC
-- Terminal 3, International, Terminal 1

-- What is the total passenger count by year? Which years had the most passengers?
SELECT
SUBSTR(Activity_Period, 1, 4) AS year,
SUM(Passenger_Count) AS total_passengers
FROM 'Air_Traffic_Passenger_Statistics'
GROUP BY year
ORDER BY total_passengers DESC
-- 2018, 2019, 2017

-- Which years had the least passengers?
SELECT
SUBSTR(Activity_Period, 1, 4) AS year,
SUM(Passenger_Count) AS total_passengers
FROM 'Air_Traffic_Passenger_Statistics'
GROUP BY year
ORDER BY total_passengers 
-- 2020, 2005, 2023 (dataset was published in 2023)

-- Which months of the year had the most passenger activity on average?
SELECT
SUBSTR(Activity_Period, 5, 2) AS month,
ROUND(AVG(Passenger_Count),2) AS avg_passengers
FROM 'Air_Traffic_Passenger_Statistics'
GROUP BY month
ORDER BY avg_passengers DESC
-- July (32048.6), August (31840.35), June (30956.81)

-- Which months of the year had the least passenger activity on average?
SELECT
SUBSTR(Activity_Period, 5, 2) AS month,
ROUND(AVG(Passenger_Count),2) AS avg_passengers
FROM 'Air_Traffic_Passenger_Statistics'
GROUP BY month
ORDER BY avg_passengers 
-- February (23767.87), January (25339.21), November (27507.23)

-- What is the single month/year that had the most passenger activity?
SELECT
Activity_Period,
SUM(Passenger_Count) AS total_passengers
FROM 'Air_Traffic_Passenger_Statistics'
GROUP BY Activity_Period
ORDER BY total_passengers DESC
-- August 2019 (5742437)

-- Which airline carried the most passengers to/from each geographic region?
SELECT
region,
airline,
total_passengers
FROM
(SELECT
GEO_Region AS region,
SUM(Passenger_Count) AS total_passengers,
Operating_Airline AS airline,
RANK () OVER(PARTITION BY GEO_Region ORDER BY SUM(Passenger_Count) DESC) AS reg_rank
FROM 'Air_Traffic_Passenger_Statistics'
GROUP BY region, airline) sub
WHERE reg_rank = 1

-- What is the #1 carrier for domestic and international flights respectively?
SELECT
flight_type,
airline,
total_passengers
FROM
(SELECT
GEO_Summary AS flight_type,
SUM(Passenger_Count) AS total_passengers,
Operating_Airline AS airline,
RANK () OVER(PARTITION BY GEO_summary ORDER BY SUM(Passenger_Count) DESC) AS ft_rank
FROM 'Air_Traffic_Passenger_Statistics'
GROUP BY flight_type, airline) sub
WHERE ft_rank = 1
-- United Airlines has the most passengers for both domestic and international flights

-- What is the #1 terminal for domestic and international flights?
SELECT
flight_type,
terminal,
total_passengers
FROM
(SELECT
GEO_Summary AS flight_type,
SUM(Passenger_Count) AS total_passengers,
Terminal AS terminal,
RANK () OVER(PARTITION BY GEO_Summary ORDER BY SUM(Passenger_Count) DESC) AS terminal_rank
FROM 'Air_Traffic_Passenger_Statistics'
GROUP BY flight_type, terminal) sub
WHERE terminal_rank = 1
-- Domestic flights: Terminal 3, International fights: International

-- What is the #1 boarding area for domestic and international flights?
SELECT
flight_type,
boarding_area,
total_passengers
FROM
(SELECT
GEO_Summary AS flight_type,
SUM(Passenger_Count) AS total_passengers,
Boarding_Area AS boarding_area,
RANK () OVER(PARTITION BY GEO_Summary ORDER BY SUM(Passenger_Count) DESC) AS ba_rank
FROM 'Air_Traffic_Passenger_Statistics'
GROUP BY flight_type, boarding_area) sub
WHERE ba_rank = 1
-- Domestic: F, International: G
