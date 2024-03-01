-- Checking for duplicates in data
SELECT *,
	ROW_NUMBER() OVER(
		PARTITION BY 
			BROKERTITLE, TYPE, PRICE, BEDS, BATH, PROPERTYSQFT, ADDRESS, STATE, 
            MAIN_ADDRESS, LOCALITY, SUBLOCALITY, STREET_NAME, LONG_NAME,
            FORMATTED_ADDRESS, latitude, LONGITUDE) AS row_num
FROM 
	ny_housing
ORDER BY 
	row_num DESC;

-- Create new table without duplicates using a CTE
CREATE TABLE NY_housing_clean AS(
    WITH duplicate AS (
    SELECT *,
        ROW_NUMBER() OVER(
            PARTITION BY BROKERTITLE, TYPE, PRICE, BEDS, BATH, PROPERTYSQFT, ADDRESS, STATE, 
               MAIN_ADDRESS, LOCALITY, SUBLOCALITY, STREET_NAME, LONG_NAME, FORMATTED_ADDRESS, latitude, LONGITUDE) 
               AS row_num
FROM ny_housing 
)
SELECT *
FROM duplicate
WHERE row_num = 1);

-- Correcting number of baths
UPDATE ny_housing_clean 
SET 
    BATH = 2.5
WHERE
    BATH LIKE '%.%';
    
-- Renaming table
RENAME TABLE ny_housing_clean TO ny_housing;

-- Drop row_num column created
ALTER TABLE ny_housing
DROP COLUMN row_num;

-- Average cost of each type of house
SELECT 
	DISTINCT type,
    ROUND(AVG(price) OVER(PARTITION BY type), 2) AS average_price
FROM 
	ny_housing
ORDER BY 2 DESC;

-- Number of each house type and it's percetage of the total listings
SELECT 
    type,
    COUNT(type) AS num_of_listings,
    ROUND((COUNT(type) / (SELECT 
                    COUNT(*)
                FROM
                    ny_housing)) * 100,
            1) AS '%'
FROM
    ny_housing
GROUP BY 1
ORDER BY 2 DESC;