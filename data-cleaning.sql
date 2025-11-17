-- Remove duplicates
DELETE FROM car_data
WHERE car_id IN (
    SELECT car_id
    FROM (
        SELECT car_id,
               ROW_NUMBER() OVER(PARTITION BY brand, model, year, mileage, price ORDER BY car_id) AS rn
        FROM car_data
    ) t
    WHERE t.rn > 1
);

-- Find missing values
SELECT 
   SUM(CASE WHEN price IS NULL THEN 1 END) AS missing_price,
   SUM(CASE WHEN mileage IS NULL THEN 1 END) AS missing_mileage
FROM car_data;

-- Remove invalid records
DELETE FROM car_data
WHERE price = 0 OR mileage < 0;
