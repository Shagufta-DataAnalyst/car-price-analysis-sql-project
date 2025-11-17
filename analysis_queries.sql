-- Total cars
SELECT COUNT(*) FROM car_data;

-- Average price per brand
SELECT brand, AVG(price) 
FROM car_data
GROUP BY brand
ORDER BY AVG(price) DESC;

-- Mileage buckets
SELECT
  CASE WHEN mileage < 20000 THEN 'Low'
       WHEN mileage BETWEEN 20000 AND 60000 THEN 'Medium'
       ELSE 'High' END AS mileage_category,
  AVG(price)
FROM car_data
GROUP BY mileage_category;

-- Condition analysis
SELECT condition, AVG(price)
FROM car_data
GROUP BY condition;


-- Top 5 most expensive cars per brand
SELECT *
FROM (
    SELECT brand, model, price,
           ROW_NUMBER() OVER(PARTITION BY brand ORDER BY price DESC) AS rn
    FROM car_data
) t
WHERE rn <= 5;

-- Cheapest car per brand
SELECT brand, model, price
FROM car_data
WHERE price IN (
    SELECT MIN(price) FROM car_data GROUP BY brand
);

-- Cars priced above brand average
SELECT c.*
FROM car_data c
JOIN (
    SELECT brand, AVG(price) AS avg_price
    FROM car_data
    GROUP BY brand
) b
ON c.brand = b.brand
WHERE c.price > b.avg_price;

-- Price segmentation
SELECT model, price,
       NTILE(4) OVER(ORDER BY price) AS price_quartile
FROM car_data;
