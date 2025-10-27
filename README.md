# ☕ Coffee Sales Data Analysis  

### 🎯 Objective  
The purpose of this project is to perform an **end-to-end SQL analysis** on *Coffee’s sales data* — a company that has been selling coffee products online since **January 2023**.  

The goal is to uncover **data-driven insights** to help the company identify the **top three major Indian cities** for opening new coffee shop outlets based on **sales performance, rent, population, and estimated coffee consumer base**.  

This project also demonstrates **data analytics and data science thinking**, using SQL to derive actionable business insights from real-world datasets.

---

## 📊 Key Business Questions  

1. **☕ Coffee Consumers Count**  
   Estimate how many people in each city consume coffee (assuming 25% of the population).

2. **💰 Total Revenue**  
   Calculate the total revenue generated across all cities in the last quarter of 2023.

3. **📦 Sales by Product**  
   Determine how many units of each coffee product have been sold and which ones perform best.

4. **🏙️ Average Sales per City**  
   Calculate the average sales amount per customer in each city.

5. **👥 City Population vs Coffee Consumers**  
   Compare city population with estimated coffee consumers.

6. **🏆 Top-Selling Products by City**  
   Identify the top 3 selling coffee products per city.

7. **📈 Monthly Sales Growth**  
   Analyze monthly growth or decline in total coffee sales.

8. **💼 Average Sale vs Rent**  
   Compare the average sale per customer with average rent per customer to measure affordability and profit ratio.

9. **🌆 Market Potential Analysis**  
   Identify top 3 cities for new store openings based on revenue, rent, customers, and coffee consumer data.
.
.
.


---

## 🧠 Tools & Technologies Used  

- **SQL (PostgreSQL)** – Core data analysis  
- **CTEs (Common Table Expressions)** – For modular and reusable queries  
- **Aggregate Functions** – To calculate totals, averages, and counts  
- **Window Functions** – For trend and ranking analysis  
- **Joins & Subqueries** – For combining multiple data sources  
- **Type Casting & Rounding** – For numeric precision and clean reporting  

---

## 📂 Dataset Description  

| Table Name | Description |
|-------------|-------------|
| **sales** | Contains all sales transactions with total amount, rating, customer_id, product_id, and sale_date. |
| **customers** | Includes details of customers such as customer_id, customer_name and city_id. |
| **city** | Holds city-level data such as city_id, city_name, population, and estimated_rent. |
| **product** | Stores product-level details like product_id, product_name, and price. |

---

## 🚀 Key SQL Insights  

| Query Focus | Insight |
|--------------|----------|
| **Revenue per Population** | Measures total revenue generated per 1,000 residents in each city. |
| **Customer Segmentation** | Counts unique customers per city to analyze market size. |
| **Product Insights** | Identifies best-performing coffee products across regions. |
| **Monthly Growth Rate** | Tracks sales growth over time for business forecasting. |
| **Market Potential** | Combines sales, rent, and population to find ideal expansion locations. |

---


## 📌 Summary  

This project highlights how **data analytics and SQL** can transform raw data into **actionable business insights**.  
By analyzing metrics like revenue, customer behavior, population, and rent, businesses like  *Coffee sales data* can make **data-backed decisions** for expansion and investment.

---

## 🧩 Future Enhancements  

- Build a **Power BI dashboard** for visual representation of the insights.  
- Apply **machine learning models** for sales forecasting and trend prediction.  
- Extend the dataset to include **marketing and operational costs** for deeper financial analysis.  

---
