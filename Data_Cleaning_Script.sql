-- DATA CLEANING PROJECT USING SQL

SELECT *
FROM health;

-- REMOVING DUPLICATES

CREATE TABLE health2
LIKE health;

INSERT health2
SELECT *
FROM health; 

SELECT *
FROM health2;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY Facility_Name,Location,`Type`, Total_Beds,Rating,`date`,Accreditation_Status, Country,Annual_Visits,`Funding_Received_(Millions)`) AS Row_num
FROM health2;

WITH duplicates AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY Facility_Name,Location,`Type`, Total_Beds,Rating,`date`,Accreditation_Status, Country,Annual_Visits,`Funding_Received_(Millions)`) AS Row_num
FROM health2
)
SELECT * 
FROM duplicates 
WHERE row_num > 1;

-- DOUBLE CHECKING FOR DUPLICATES
SELECT *
FROM health2
WHERE Facility_Name LIKE "FACILITYD" AND LOCATION = 'BERLIN' AND RATING = 3.7;

CREATE TABLE `health3` (
  `Facility_Name` text,
  `Location` text,
  `Type` text,
  `Total_Beds` text,
  `Rating` text,
  `Date` text,
  `Accreditation_Status` text,
  `Country` text,
  `Annual_Visits` int DEFAULT NULL,
  `Funding_Received_(Millions)` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO health3
SELECT *,
ROW_NUMBER() OVER(PARTITION BY Facility_Name,Location,`Type`, Total_Beds,Rating,`date`,Accreditation_Status, Country,Annual_Visits,`Funding_Received_(Millions)`) AS Row_num
FROM health2;

DELETE 
FROM health3
WHERE row_num > 1;

SELECT * 
FROM HEALTH3;

-- STANDARDIZING DATA

SELECT Location, TRIM(Location)
FROM health3;

UPDATE health3
SET location = TRIM(Location);

UPDATE health3
SET Facility_Name = 'Facility D'
WHERE Facility_Name = 'FACILITY_D';

UPDATE health3
SET Facility_Name = 'Facility C'
WHERE Facility_Name = 'FACILITY_C';

UPDATE health3
SET Facility_Name = 'Facility A'
WHERE Facility_Name = 'FACILITY-A';

-- CHANGING DATE FORMATS WITH SOME DATES HAVING '/' INSTEAD OF '-' FORMAT

UPDATE health3
SET `date` = REPLACE(`date`, '/', '-')
WHERE `date` LIKE '%/%';

SELECT `date` 
FROM HEALTH3;


SELECT `date`, STR_TO_DATE(`date`, '%Y-%m-%d') 
FROM health3;

UPDATE health3
SET `date` = STR_TO_DATE(`date`, '%Y-%m-%d');

ALTER TABLE health3
MODIFY COLUMN `Date` DATE; 


-- FILLING IN BLANK/NULL VALUES 

SELECT * 
FROM health3
WHERE total_beds != ''
AND rating = '';


SELECT *
FROM health3 H1
JOIN health3 H2
ON H1.rating = H2.rating
WHERE H1.total_beds = '' AND H2.total_beds != ''; 

UPDATE health3 H1
JOIN health3 H2
	ON H1.rating = H2.rating
SET  H1.rating = H2.rating
WHERE H1.total_beds = '' AND H2.total_beds != ''; 


-- DELETING UNNECESSARY RECORDS/COLUMNS

SELECT * 
FROM health3
WHERE rating = '' AND Total_Beds = '';

ALTER TABLE health3
DROP COLUMN row_num;











