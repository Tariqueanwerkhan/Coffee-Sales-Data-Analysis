select * from city;
select * from customers;
select * from products;
select * from sales;


-- Q1. Coffee Consumers Count
-- How many people in each city are estimated to consume coffee, given that 25% of the population does?
SELECT city_name, population, 
		ROUND(population * 0.23) as estimated_coffee_consumers,
		city_rank
FROM city
ORDER BY population DESC



-- Q2. Peak Sales Month
-- Find the month in which the maximum total sales occurred across all cities.
SELECT
	TO_CHAR(sale_date, 'YYYY-MM') AS month,
	SUM(total) as total_sales
FROM Sales
	GROUP BY to_char(sale_date, 'YYYY-MM')
	ORDER BY total_sales DESC
limit 1;



-- Q3. Total Revenue from Coffee Sales 
-- What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?
SELECT 
	SUM(total) as total_revenue
FROM sales
WHERE sale_date BETWEEN '2023-10-01' AND '2023-12-31'


-- Alternate solution
SELECT
	SUM(total) as total_revenue
FROM sales
WHERE EXTRACT(YEAR from sale_date) = 2023 and EXTRACT(QUARTER from sale_date) = 4;


-- If you ever want to show quarter-wise breakdown, you can extend it:
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(QUARTER FROM sale_date) AS quarter,
    SUM(total) AS total_revenue
FROM sales
GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(QUARTER FROM sale_date)
ORDER BY year, quarter;



-- Q4. Product Performance by Rating
-- Find the average rating received by each product and order them from highest to lowest.
select p.product_name,
	round(avg(s.rating), 2) as avg_rating
from sales s
join products p on s.product_id = p.product_id
group by p.product_name
order by avg_rating desc;



-- Q5. Sales Count for Each Product
-- How many units of each coffee product have been sold?
select p.product_name, 
	count(s.sale_id) as total_orders
from products p 
left join sales s
	on p.product_id = s.product_id
group by p.product_name
order by total_orders desc;



-- Q6. High-Value Customers
-- Identify customers who have spent more than ₹5000 in total purchases.
select 
	c.customer_name,
	sum(s.total) as total_amount_spent
from sales s
join customers c on s.customer_id = c.customer_id
group by c.customer_name
having sum(s.total) > 5000
order by total_amount_spent desc;



-- Q7. Average Sales Amount per City
-- What is the average sales amount per customer in each city?
-- city abd total sale, no cx in each these city
SELECT 
	ci.city_name,
	SUM(s.total) as total_revenue,
	COUNT(DISTINCT s.customer_id) as total_cx,
	ROUND(
			SUM(s.total)::numeric/
				COUNT(DISTINCT s.customer_id)::numeric
			,2) as avg_sale_pr_cx
	
FROM sales as s
JOIN customers as c
ON s.customer_id = c.customer_id
JOIN city as ci
ON ci.city_id = c.city_id
GROUP BY ci.city_name
ORDER BY total_revenue DESC;



-- Q8. City with Highest Average Rating
-- Find the city that has the highest average product rating.
SELECT 
    ci.city_name,
    ROUND(AVG(s.rating), 2) AS avg_city_rating
FROM sales s
JOIN customers cu ON s.customer_id = cu.customer_id
JOIN city ci ON cu.city_id = ci.city_id
GROUP BY ci.city_name
ORDER BY avg_city_rating DESC
LIMIT 1;



-- Q9. City Population and Coffee Consumers (25%)
-- Provide a list of cities along with their populations and estimated coffee consumers.
-- return city_name, total current cx, estimated coffee consumers (25%)
WITH city_table as 
(
	SELECT 
		city_name,
		ROUND((population * 0.25)/1000000, 2) as coffee_consumers
	FROM city
),
customers_table
AS
(
	SELECT 
		ci.city_name,
		COUNT(DISTINCT c.customer_id) as unique_cx
	FROM sales as s
	JOIN customers as c
	ON c.customer_id = s.customer_id
	JOIN city as ci
	ON ci.city_id = c.city_id
	GROUP BY ci.city_name,  ci.population 
)
SELECT 
	customers_table.city_name,
	city_table.coffee_consumers as coffee_consumer_in_millions,
	customers_table.unique_cx
FROM city_table
JOIN 
customers_table
ON city_table.city_name = customers_table.city_name;


-- Alternate Solution
SELECT 
    ci.city_name,
    ROUND((ci.population * 0.25)/1000000, 2) AS coffee_consumers_in_millions,
    COUNT(DISTINCT c.customer_id) AS unique_cx
FROM city ci
JOIN customers c ON ci.city_id = c.city_id
JOIN sales s ON s.customer_id = c.customer_id
GROUP BY ci.city_name, ci.population;




-- Q10. Product Revenue Share
-- For each product, calculate what percentage of total revenue it contributes.
SELECT 
    p.product_name,
    ROUND(
        (SUM(s.total) * 100.0 / (SELECT SUM(total) FROM sales))::numeric,
        2
    ) AS revenue_percentage
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue_percentage DESC;



-- Q11. Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume?

SELECT * 
FROM
(SELECT 
		ci.city_name,
		p.product_name,
		COUNT(s.sale_id) as total_orders,
		DENSE_RANK() OVER(PARTITION BY ci.city_name ORDER BY COUNT(s.sale_id) DESC) as rank
	FROM sales as s
	JOIN products as p
	ON s.product_id = p.product_id
	JOIN customers as c
	ON c.customer_id = s.customer_id
	JOIN city as ci
	ON ci.city_id = c.city_id
	GROUP BY ci.city_name, p.product_name
	ORDER BY ci.city_name, total_orders DESC
) as t1
WHERE rank <= 3



-- Q12. Repeat Customers
-- Find customers who made more than 3 purchases.
SELECT 
    c.customer_name,
    COUNT(s.sale_id) AS purchase_count
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_name
HAVING COUNT(s.sale_id) > 3
ORDER BY purchase_count DESC;



-- Q13. Customer Segmentation by City
-- How many unique customers are there in each city who have purchased coffee products?
SELECT 
	ci.city_name,
	COUNT(DISTINCT c.customer_id) as unique_cx
FROM city as ci
LEFT JOIN
customers as c
ON c.city_id = ci.city_id
JOIN sales as s
ON s.customer_id = c.customer_id
WHERE 
	s.product_id IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)
GROUP BY ci.city_name;



-- Q14. City Rent vs Revenue Correlation
-- List each city’s average rent and total sales to compare living cost vs business revenue.
SELECT 
    ci.city_name,
    ROUND(AVG(ci.estimated_rent)::numeric, 2) AS avg_rent,
    SUM(s.total) AS total_sales
FROM sales s
JOIN customers cu ON s.customer_id = cu.customer_id
JOIN city ci ON cu.city_id = ci.city_id
GROUP BY ci.city_name
ORDER BY total_sales DESC;



-- Q15. Average Sale vs Rent
-- Find each city and their average sale per customer and avg rent per customer
SELECT 
    ci.city_name,
    ROUND(SUM(s.total)::numeric / COUNT(DISTINCT s.customer_id)::numeric, 2) AS avg_sale_per_customer,
    ROUND(ci.estimated_rent::numeric / COUNT(DISTINCT s.customer_id)::numeric, 2) AS avg_rent_per_customer,
    COUNT(DISTINCT s.customer_id) AS total_customers
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN city ci ON ci.city_id = c.city_id
GROUP BY ci.city_name, ci.estimated_rent
ORDER BY avg_sale_per_customer DESC;



-- Q16. Least Performing Products
-- Find bottom 3 products based on total sales amount.
SELECT 
    p.product_name,
    SUM(s.total) AS total_sales
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales ASC
LIMIT 3;



-- Q17. Monthly Sales Growth
-- Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly)
-- by each city
WITH
monthly_sales
AS
(
	SELECT 
		ci.city_name,
		EXTRACT(MONTH FROM sale_date) as month,
		EXTRACT(YEAR FROM sale_date) as YEAR,
		SUM(s.total) as total_sale
	FROM sales as s
	JOIN customers as c
	ON c.customer_id = s.customer_id
	JOIN city as ci
	ON ci.city_id = c.city_id
	GROUP BY ci.city_name, EXTRACT(MONTH FROM sale_date), EXTRACT(YEAR FROM sale_date)
	ORDER BY ci.city_name, YEAR, month
),
growth_ratio
AS
(
		SELECT
			city_name,
			month,
			year,
			total_sale as cr_month_sale,
			LAG(total_sale, 1) OVER(PARTITION BY city_name ORDER BY year, month) as last_month_sale
		FROM monthly_sales
)

SELECT
	city_name,
	month,
	year,
	cr_month_sale,
	last_month_sale,
	ROUND(
		(cr_month_sale-last_month_sale)::numeric/last_month_sale::numeric * 100
		, 2
		) as growth_ratio

FROM growth_ratio
WHERE 
	last_month_sale IS NOT NULL;



-- Alternate Solution 
SELECT 
    ci.city_name,
    EXTRACT(YEAR FROM s.sale_date) AS year,
    EXTRACT(MONTH FROM s.sale_date) AS month,
    SUM(s.total) AS cr_month_sale,
    LAG(SUM(s.total)) OVER(
        PARTITION BY ci.city_name 
        ORDER BY EXTRACT(YEAR FROM s.sale_date), EXTRACT(MONTH FROM s.sale_date)
    ) AS last_month_sale,
    ROUND(
        (
            (SUM(s.total) - 
             LAG(SUM(s.total)) OVER(PARTITION BY ci.city_name ORDER BY EXTRACT(YEAR FROM s.sale_date), EXTRACT(MONTH FROM s.sale_date))
            )::numeric 
            / LAG(SUM(s.total)) OVER(PARTITION BY ci.city_name ORDER BY EXTRACT(YEAR FROM s.sale_date), EXTRACT(MONTH FROM s.sale_date))::numeric
        ) * 100, 
        2
    ) AS growth_ratio
FROM sales s
JOIN customers c ON c.customer_id = s.customer_id
JOIN city ci ON ci.city_id = c.city_id
GROUP BY ci.city_name, EXTRACT(YEAR FROM s.sale_date), EXTRACT(MONTH FROM s.sale_date)
ORDER BY ci.city_name, year, month;




-- Q18. Revenue per Population
-- Find revenue per 1,000 people in each city.
SELECT 
    ci.city_name,
    ci.population,
    ROUND(SUM(s.total)::numeric / (ci.population / 1000), 2) AS revenue_per_1000_people
FROM sales s
JOIN customers cu ON s.customer_id = cu.customer_id
JOIN city ci ON cu.city_id = ci.city_id
GROUP BY ci.city_name, ci.population
ORDER BY revenue_per_1000_people DESC;




-- Q19. Market Potential Analysis
-- Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer
WITH city_table AS
(SELECT 
		ci.city_name,
		SUM(s.total) as total_revenue,
		COUNT(DISTINCT s.customer_id) as total_cx,
		ROUND(
				SUM(s.total)::numeric/
					COUNT(DISTINCT s.customer_id)::numeric
				,2) as avg_sale_pr_cx
		
	FROM sales as s
	JOIN customers as c
	ON s.customer_id = c.customer_id
	JOIN city as ci
	ON ci.city_id = c.city_id
	GROUP BY ci.city_name
	ORDER BY total_revenue DESC
),
city_rent
AS
(
	SELECT 
		city_name, 
		estimated_rent,
		ROUND((population * 0.25)/1000000, 3) as estimated_coffee_consumer_in_millions
	FROM city
)
SELECT 
	cr.city_name,
	ct.total_revenue,
	cr.estimated_rent as total_rent,
	ct.total_cx,
	estimated_coffee_consumer_in_millions,
	ct.avg_sale_pr_cx,
	ROUND(
		cr.estimated_rent::numeric/
									ct.total_cx::numeric
		, 2) as avg_rent_per_cx
FROM city_rent as cr
JOIN city_table as ct
ON cr.city_name = ct.city_name
ORDER BY ct.total_revenue DESC
limit 3;



-- Alternate solution
SELECT 
    ci.city_name,
    SUM(s.total) AS total_revenue,
    ci.estimated_rent AS total_rent,
    COUNT(DISTINCT s.customer_id) AS total_cx,
    ROUND((ci.population * 0.25) / 1000000, 3) AS estimated_coffee_consumer_in_millions,
    ROUND(SUM(s.total)::numeric / COUNT(DISTINCT s.customer_id)::numeric, 2) AS avg_sale_pr_cx,
    ROUND(ci.estimated_rent::numeric / COUNT(DISTINCT s.customer_id)::numeric, 2) AS avg_rent_per_cx
FROM sales AS s
JOIN customers AS c ON s.customer_id = c.customer_id
JOIN city AS ci ON ci.city_id = c.city_id
GROUP BY ci.city_name, ci.estimated_rent, ci.population
ORDER BY total_revenue DESC
LIMIT 3;



-- Q20. Seasonal Trend
-- Compare total sales between Summer months (Apr–Jun) and Winter months (Nov–Jan).
SELECT 
    CASE 
        WHEN EXTRACT(MONTH FROM sale_date) IN (4,5,6) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM sale_date) IN (11,12,1) THEN 'Winter'
        ELSE 'Other'
    END AS season,
    SUM(total) AS total_sales
FROM sales
GROUP BY season
ORDER BY total_sales DESC;



----------------------------------------------------------------------------------------------------------------------