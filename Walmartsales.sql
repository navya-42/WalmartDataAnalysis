SELECT * FROM walmartsales.sales;

--------------------------------------------------------------------------------------------------------
---------------------------- Feature Engineering -------------------------------------------------------

--- time_of_date
SELECT 
TIME,
 (CASE
    WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
    WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening"
 END
 ) AS Time_Of_Date
FROM sales;

ALTER TABLE sales ADD COLUMN Time_Of_Date VARCHAR(20);

UPDATE sales
SET Time_Of_Date = (
   CASE
     WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
     WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
     ELSE "Evening"
   END
);

-- day_name

SELECT 
    date,
    dayname(date)
    FROM sales;
    
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

--  month_name

SELECT
    date,
    monthname(date)
    FROM sales;
    
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales
SET month_name = monthname(date);

------------------------------------------------------------------------------------------------------
----------------------------------   Generic     -------------------------------------------------------

-- How many unique cities does the data have?

SELECT 
   DISTINCT city 
FROM sales;

-- In which city is each branch?

SELECT 
   DISTINCT branch
FROM sales;

SELECT 
   DISTINCT city, branch
FROM sales;


------------------------------------------------------------------------------------------------------
--------------------------------------- products -----------------------------------------------------

-- How many unique product lines does the data have?

SELECT 
    count(distinct `Product line`)
FROM sales;

-- What is the most common payment method?

SELECT
	Payment,
     count(Payment) AS cnt
FROM sales
group by Payment
ORDER BY cnt DESC;

-- What is the most selling product line?

SELECT
	`Product line`,
     count(`Product line`) AS cnt
FROM sales
group by `Product line`
ORDER BY cnt DESC;

-- What is the total revenue by month?

SELECT 
   month_name AS month, 
   sum(Total) AS Total_revenue
FROM SALES
group by month_name
order by Total_revenue desc;

-- What month had the largest COGS?

SELECT 
   month_name AS month, 
   sum(cogs) AS cogs
FROM SALES
group by month_name
order by cogs desc
LIMIT 1;


-- What product line had the largest revenue?

SELECT
   `Product line`,
   SUM(Total) AS Total_revenue
   FROM sales
GROUP BY `Product line`
ORDER BY Total_revenue DESC
LIMIT 1;

-- What is the city with the largest revenue?

SELECT
	branch,
    City,
    sum(Total) AS Total_revenue
    FROM sales
GROUP BY CITY, branch
ORDER BY Total_revenue DESC
LIMIT 1;

-- What product line had the largest VAT?

SELECT
  `Product line`,
  AVG(`Tax 5%`) AS avg_tax
  FROM sales
  GROUP BY `Product line`
  ORDER BY avg_tax DESC
  LIMIT 1;
  

    
    


-- Which branch sold more products than average product sold?

SELECT
    Branch,
    SUM(Quantity) AS qty
    FROM sales
GROUP BY BRANCH
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales)
LIMIT 1;

-- What is the most common product line by gender?

SELECT
   Gender,
   `Product line`,
   COUNT(Gender) AS total_cnt
   FROM sales
   GROUP BY Gender, `Product line`
   ORDER BY total_cnt DESC
   LIMIT 1;

-- What is the average rating of each product line?

SELECT 
 ROUND(AVG(Rating),2) AS Avg_rating,
`Product line`
FROM sales
GROUP BY `Product line`
ORDER BY Avg_rating DESC;



-----------------------------------------------------------------------------------------------------
--------------------------------- Sales -------------------------------------------------------------


-- Number of sales made in each time of the day per weekday

SELECT
   Time_Of_Date,
   COUNT(*) AS total_sales
   FROM sales
   WHERE day_name = "Monday"
   GROUP BY Time_Of_Date
   ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?

SELECT
   `Customer type`,
    SUM(Total) AS total_revenue
    FROM sales
    GROUP BY `Customer type`
    ORDER BY total_revenue DESC;
    

-- Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT
    City,
    AVG(`Tax 5%`) AS tax_per
    FROM sales
    GROUP BY CITY
    ORDER BY tax_per DESC LIMIT 1;
    

-- Which customer type pays the most in VAT?

SELECT 
    `Customer type`,
     ROUND(AVG(`Tax 5%`),2) AS pay_most_tax
     FROM sales
     GROUP BY `Customer type`
     ORDER BY pay_most_tax DESC;
     
     
     
     
------------------------------------------------------------------------------------------------------
-------------------------------------  Customer  -----------------------------------------------------


-- How many unique customer types does the data have?

SELECT
   DISTINCT `Customer type` 
   FROM sales;
   
-- How many unique payment methods does the data have?

SELECT 
   DISTINCT Payment 
   FROM sales;
   
-- What is the most common customer type?

SELECT 
   DISTINCT `Customer type`
    
    FROM sales;
    
-- Which customer type buys the most?

SELECT 
   `Customer type`,
    COUNT(*) AS customer_count
    FROM sales
    GROUP BY `Customer type`
    ORDER BY customer_count DESC
    LIMIT 1;
    
-- What is the gender of most of the customers?

SELECT 
   Gender,
   COUNT(*) AS common_gender
    FROM sales
    GROUP BY Gender
    ORDER BY common_gender DESC
    LIMIT 1;
    
    
-- What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;


-- Which time of the day do customers give most ratings?

SELECT
   Time_Of_Date,
   ROUND(AVG(rating),2) AS avg_rating
   FROM sales
   GROUP BY Time_Of_Date
   ORDER BY avg_rating DESC;
   
-- Which time of the day do customers give most ratings per branch?

SELECT 
  Time_Of_Date,
  ROUND(AVG(rating),2) as avg_rating
  FROM sales
  WHERE Branch = "A"
  GROUP BY Time_Of_Date
  ORDER BY avg_rating DESC;
  
-- Which day fo the week has the best avg ratings?

SELECT
  day_name,
  ROUND(AVG(Rating),2) AS avg_rating
  FROM sales
  GROUP BY day_name
  ORDER BY avg_rating DESC
  LIMIT 1;
  
  
-- Which day of the week has the best average ratings per branch?

SELECT
   
   day_name,
   ROUND(AVG(rating),2) AS avg_rating
   FROM sales
   WHERE Branch = "C"
   GROUP BY day_name
   ORDER BY avg_rating DESC;
