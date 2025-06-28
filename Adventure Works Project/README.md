# Project Title: AdventureWorks 2019
## Database backup available on Microsoft website @: https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver17&tabs=ssms

--This project first of all transforms AdventureWorks 2019 database into a star schema, then creates fact and dimension tables, and then performs SQL-based data analysis in the following areas: 
--Sales performance
--Customer segmentation
--Product inventory and performance
--Employee performance
--Time-based financial trends

A star schema is an approach to designing tables in a database where a single fact table sits at the centre and is surrounded by several dimension tables, in the form of a star. In this project, the fact table (FactSales) will hold transactional measures such as quantities, prices, and totals for each sale. Surrounding it will be dimension tables including (DimCustomer, DimProduct, DimEmployee, DimDate) that store descriptive attributes—for example, customer names and locations, product categories, employee details, and calendar breakdowns. The star schema optimises query performance and simplifies analytical queries.

The following are the tables created and their description. 

Tables							Type							Description
FactSales						Fact							Core transactional data from SalesOrderHeader + SalesOrderDetail
DimCustomer					Dimension					Combines Customer, Person, and Address
DimProduct					Dimension					Combines Product, ProductSubcategory, ProductCategory
DimEmployee					Dimension					From Employee, EmployeeDepartmentHistory, Department
DimDate							Dimension					Generated date table with Year, Month, Quarter, Weekday

NB: Also, from the tables created from this table, a visualisation in Power BI is provided. 

### Key Insight and Recommendation for Sales Analysis: 
* Product Revenue: Top product categories generated the highest revenue, revealing where the company’s core strengths lie, with Bikes and Components leading revenue.
* Regional Sales: States with high sales likely host more active customer bases or better marketing reach.
* Monthly Trends: Peaks in certain months suggest seasonal demand patterns. This helps plan for stocking and staffing during high-sales periods.
* Recommendation: Prioritise the product in the category of Bikes, which generates most of the Revenue, and prepare for peak months with promotional offers and larger stock.

### Key Insight and Recommendation on Customer Analysis: 
* Top Customers: A few customers account for a large share of revenue; these suggest key accounts that should be retained at all costs and rewarded.
* Customer Distribution: Regions with more orders and unique customers represent high-engagement markets, suitable for loyalty campaigns or regional sales strategies, with California having the highest Number of orders and customers. 
* Recommendation: Focus on retention of top clients; expand outreach in active states

### Key Insight and Recommendation for product performance and inventory:
* Top Products: A small number of products generate a high volume of sales these need consistent stock availability.
* Price Tiers: Products in the mid-to-high range may bring higher revenue per unit, showing that premium pricing strategies could work for select categories.
* Recommendation: Optimise pricing and phase out underperforming SKUs. Optimise product mix and pricing strategy

### Key Insight and Recommendation for employee performance:
* Sales Reps: A few individuals are responsible for major sales. This supports recognising top performers and replicating their strategies.
* Departments: Varying average sales per employee across departments suggest training needs or load imbalance.
* Recommendation: Recognise strong performers and train others.

### Key Insight and Recommendation for Financial and Time-Based Analysis:
* Quarterly Trends: Looking at  months with consistent and complete numbers of Quarters, there is no clear pattern to explain either an increase or decrease in specific seasons; there is a need for further analysis of monthly performance is required to explore the  monthly trend. Looking at the monthly trend, a peak is recorded in the month of March, which could suggest a seasonality sales effect. 
* Year-over-Year Growth: A positive trend shows business expansion; a decline in year 2014 is seen, and this is due to the length of the month recorded (2 Quarters). 
* Projection: Forecasted revenue gives a baseline for budget planning and target setting, with a $32,401,569.74 projected revenue for next year. 
* Recommendation: Plan stock, staffing, and budgets around seasonal surges. Use forecasts for resource allocation and sales targets.



![snapshot]
