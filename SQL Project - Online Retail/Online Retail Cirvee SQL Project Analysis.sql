-- Project Title: Customer Purchase Behavior and Sales Trend Analysis for Online Retail Optimization 

/* The objective of this project is to gain insights into customer purchase behavior and provide actionable recommendations for improving sales strategies, identifying key customers, and understanding product performance.*/

---To understand the structure of the table 
select *
from ['Online Retail$']

/*
The following are the Colume Names and Description: 
• InvoiceNo: Unique identifier for each transaction.
• StockCode: Unique identifier for each product.
• Description: Product description.
• Quantity: Number of units sold.
• InvoiceDate: Date and time of the transaction.
• UnitPrice: Price per unit.
• CustomerID: Unique identifier for each customer.
• Country: The country where the customer is located.

NB: the Raw Dataset shows an entry of 541,909 rows and Eight (8) column
*/

						--TASK ONE: Customer Segmentation by Purchase Frequency
-- Here we try to know how many customers are in each categories
-- but I waant to first create a table I use to keep this segmentation
CREATE TABLE CustomerSegmentationResult (
    Segment VARCHAR(50),
    NumCustomers INT,
    Revenue DECIMAL(18,2)
);

WITH CustomerPurchases AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS PurchaseCount,
        SUM(Quantity * UnitPrice) AS TotalRevenue
    FROM ['Online Retail$']
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
),
SegmentedCustomers AS (
    SELECT *,
        CASE
            WHEN PurchaseCount = 1 THEN 'One-time'
            WHEN PurchaseCount BETWEEN 2 AND 4 THEN 'Repeat'
            WHEN PurchaseCount >= 5 THEN 'High-frequency'
        END AS Segment
    FROM CustomerPurchases
)
INSERT INTO CustomerSegmentationResult (Segment, NumCustomers, Revenue)
SELECT
    Segment,
    COUNT(CustomerID) AS NumCustomers,
    SUM(TotalRevenue) AS Revenue
FROM SegmentedCustomers
WHERE Segment IS NOT NULL
GROUP BY Segment
ORDER BY Revenue DESC;

select * from CustomerSegmentationResult

-- THERE ARE 1730 REPEAT BUYERS with $1,667,499.473 revenue , 1494 ONE-TIME BUYERS with $521,113.71 revenue, AND 1115 HIGH-FREQUENCY BUYERS with $6,121,863.87 revenue. 

/* Strategic Insight:
- High-frequency buyers contribute the most revenue despite having the lowest numbers of customers. These customer segment should be nurtured through loyalty programs or exclusive offers.
- Repeat buyers can be upsold or encouraged into subscriptions.
- One-time buyers may need re-engagement campaigns, such as personalized emails or cart recovery reminders, or other promotional offers.*/



									--TASK TWO: Top 10 Most Purchased Products
-- Query 1: Top 10 Most Purchased Products by Quantity
SELECT TOP 10
    Description,
    SUM(Quantity) AS TotalQuantitySold
FROM ['Online Retail$']
GROUP BY Description
ORDER BY TotalQuantitySold DESC;

-- Query 2: Country-wise Breakdown for These Top 10 Products
WITH TopProducts AS (
    SELECT TOP 10
        Description
    FROM ['Online Retail$']
    WHERE Description IS NOT NULL AND Quantity > 0
    GROUP BY Description
    ORDER BY SUM(Quantity) DESC
)
SELECT
    o.Description,
    o.Country,
    SUM(o.Quantity) AS TotalQuantitySold
FROM ['Online Retail$'] o
JOIN TopProducts tp ON o.Description = tp.Description
WHERE o.Quantity > 0 AND o.Description IS NOT NULL AND o.Country IS NOT NULL
GROUP BY o.Description, o.Country
ORDER BY o.Description, TotalQuantitySold DESC;

/*
In the first query to determine the top 10 performing product.
TOP 10 fetches the most purchased products based on unit count.
*/

/*
CTE was useed for the (TopProducts), to select the 10 most purchased items.
We then join the main table to this list and aggregate sales per country for each top product.
ORDER BY o.Description, TotalQuantitySold DESC ensures the output is grouped by product and sorted by country-level sales.
*/


					--TASK THREE: Revenue Analysis by Country
-- Top 5 five countries
-- this first query generate the revenue per country
SELECT 
    Country,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM ['Online Retail$']
WHERE CustomerID IS NOT NULL AND Quantity > 0 AND UnitPrice > 0 AND Country IS NOT NULL
GROUP BY Country
ORDER BY TotalRevenue DESC;

-- adding top 5 to it filters it the top five countries generating revenue
SELECT Top 5
    Country,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM ['Online Retail$']
WHERE CustomerID IS NOT NULL AND Quantity > 0 AND UnitPrice > 0 AND Country IS NOT NULL
GROUP BY Country
ORDER BY TotalRevenue DESC;

/*
- using CustomerID IS NOT NULL, helps to focuses only on known customers, allowing for a more reliable country-based behavior insights.
- Also, using Quantity > 0 AND UnitPrice > 0, helps to further filters out returns or erroneous entries (e.g., zero or negative pricing).
-- using GROUP BY Country, helps to aggregates sales per country.
*/


/*Insights & Expansion Opportunities
* Observed Customer Behavior:
-These top 5 countries may likely reflect the high purchasing power, better logistics, and customer trust in the business model. As seen from the output the top five countries are well known countries with strong economic power. 
-Furthermore, the high revenue, in terms of customer  behaviour may suggests repeat purchases, bulk orders, or a larger customer base in these countries.

* Recommendation for Market Expansion Suggestions:
Deepen penetration in top-performing countries through loyalty programs and product bundles.
Localize promotions—offer culturally tailored discounts and language-specific content.
Explore adjacent markets (e.g., neighboring countries with similar consumer profiles).
Analyze product preference in each top country and use those insights to shape product offerings in other emerging regions.*/


						-- TASK FOUR: Monthly Sales Performance
SELECT
    DATENAME(MONTH, InvoiceDate) AS MonthName,
    MONTH(InvoiceDate) AS MonthNumber,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM ['Online Retail$']
WHERE CustomerID IS NOT NULL
  AND Quantity > 0 AND UnitPrice > 0 AND InvoiceDate IS NOT NULL
GROUP BY MONTH(InvoiceDate), DATENAME(MONTH, InvoiceDate)
ORDER BY TotalRevenue Desc

/*
Insights & Recommendations: 
* Seasonal Trends:
- the peaks in months are towards the end of the year, including November, December, October, and September which could be due to holiday season purchases. or could suggest that product sold are more needed during these season. 
-- Low sales months are observed in the early month of year in February, April, January, and March respectively. this could indicate product are not so much in need in this period or may be as a result of conservative spending at the beginning of the year. 

* Recommendations:
Capitalize on Peak Months: 
Launch limited-time offers or bulk discounts in high-performing months.
Reinforce logistics and inventory ahead of high seasons.

Boost Low Months:
Run targeted promotions or email reactivation campaigns to dormant customers.
Introduce seasonal product bundles or loyalty rewards during off-peak periods.

Use Predictive Analytics:
If historical patterns hold, forecast inventory and marketing efforts accordingly in advance.

*/

				-- TASK FIVE: Customer Lifetime Value (CLV) Analysis
--  Calculate the Customer Lifetime Value (CLV) by analyzing the total revenue generated by repeat customers over the dataset's time span.
WITH CustomerSales AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS TotalPurchases,
        SUM(Quantity * UnitPrice) AS TotalRevenue
    FROM ['Online Retail$']
    WHERE CustomerID IS NOT NULL AND Quantity > 0 AND UnitPrice > 0
    GROUP BY CustomerID
)
SELECT
    CustomerID,
    TotalPurchases,
    TotalRevenue
FROM CustomerSales
WHERE TotalPurchases > 1
ORDER BY TotalRevenue DESC;


--Identify the top 5 customers based on total sales value and provide an analysis of their purchasing behavior (e.g., preferred products, purchasing frequency)


-- this will calculate the total purchase by the top five customers and the revenue generated by eact of them. 
SELECT TOP 5
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS TotalPurchases,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM ['Online Retail$']
WHERE CustomerID IS NOT NULL
  AND Quantity > 0
  AND UnitPrice > 0
GROUP BY CustomerID
ORDER BY TotalRevenue DESC;

-- this query breaks down each purchase transactions by this top five performing customers to know the product purchased, it's frequency and revenue generated from each products.  
WITH TopCustomers AS (
    SELECT TOP 5
        CustomerID,
        SUM(Quantity * UnitPrice) AS TotalRevenue
    FROM ['Online Retail$']
    WHERE CustomerID IS NOT NULL AND Quantity > 0 AND UnitPrice > 0
    GROUP BY CustomerID
    ORDER BY TotalRevenue DESC
)
SELECT
    o.CustomerID,
    o.Description AS Product,
    COUNT(DISTINCT o.InvoiceNo) AS PurchaseFrequency,
    SUM(o.Quantity) AS TotalUnitsBought,
    SUM(o.Quantity * o.UnitPrice) AS RevenueGenerated
FROM ['Online Retail$'] o
JOIN TopCustomers t ON o.CustomerID = t.CustomerID
WHERE o.Quantity > 0 AND o.UnitPrice > 0 AND o.Description IS NOT NULL
GROUP BY o.CustomerID, o.Description
ORDER BY o.CustomerID, RevenueGenerated DESC;


							-- TASK SIX: Product Performance Analysis by Category
SELECT
    CASE
        WHEN Description LIKE '%MUG%' THEN 'Mugs'
        WHEN Description LIKE '%BAG%' THEN 'Bags'
        WHEN Description LIKE '%CANDLE%' THEN 'Candles'
        WHEN Description LIKE '%CARD%' THEN 'Greeting Cards'
        WHEN Description LIKE '%TOY%' THEN 'Toys'
        ELSE 'Other'
    END AS ProductCategory,
    SUM(Quantity * UnitPrice) AS TotalRevenue,
    COUNT(DISTINCT StockCode) AS ProductCount
FROM ['Online Retail$']
	WHERE Description IS NOT NULL
GROUP BY
    CASE
        WHEN Description LIKE '%MUG%' THEN 'Mugs'
        WHEN Description LIKE '%BAG%' THEN 'Bags'
        WHEN Description LIKE '%CANDLE%' THEN 'Candles'
        WHEN Description LIKE '%CARD%' THEN 'Greeting Cards'
        WHEN Description LIKE '%TOY%' THEN 'Toys'
        ELSE 'Other'
    END
ORDER BY TotalRevenue DESC;

-- This are the few categories that could be easily identified from the description. 
-- Based on the identided categories from the query, Bags, Greeting Cards and Candles seems to be the top performing category. 
-- Prioritize top-performing categories in inventory restocking and marketing spend.
-- Therfore for categories under “Other,” , there is a need to review if a new category could be deduced and also the description of product should be reviewed for easy tracking.
-- The business could consider creating bundled promotions using a top performing product along side a slow product as complementary product categories. This could make customers to try slow performing product. 
--Furthermore, the company could consider seasonal category campaigns (e.g., Candles, and Mugs during holidays).


