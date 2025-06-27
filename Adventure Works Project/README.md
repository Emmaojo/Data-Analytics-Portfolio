--This project first of all transform AdventureWorks 2019 database into a star schema, then create fact and dimension tables, and then perform SQL-based data analysis in the following areas: 
--Sales performance
--Customer segmentation
--Product inventory and performance
--Employee performance
--Time-based financial trends

--A star schema is an approach design of tables in a database where a single fact table sits at the center and is surrounded by several dimension tables, in the form of a star. In this project, the fact table (FactSales) will holds transactional measures such as quantities, prices, and totals for each sale. Surrounding it will be dimension tables including (DimCustomer, DimProduct, DimEmployee, DimDate) that store descriptive attributes—for example, customer names and locations, product categories, employee details, and calendar breakdowns. The star schema optimizes query performance and simplifies analytical queries.

Tables							Type							Description
FactSales						Fact							Core transactional data from SalesOrderHeader + SalesOrderDetail
DimCustomer						Dimension						Combines Customer, Person, Address
DimProduct						Dimension						Combines Product, ProductSubcategory, ProductCategory
DimEmployee						Dimension						From Employee, EmployeeDepartmentHistory, Department
DimDate							Dimension						Generated date table with Year, Month, Quarter, Weekday



Key Insight and Recommendation for Sales Analysis: 
* Product Revenue: Top product categories generated the highest revenue, revealing where the company’s core strengths lie, with Bikes and Components leading revenue.
* Regional Sales: States with high sales likely host more active customer bases or better marketing reach.
* Monthly Trends: Peaks in certain months suggest seasonal demand patterns. This helps plan for stocking and staffing during high-sales periods.
* Recommendation: Prioritize the product in the category of Bikes which generate most of the Revenue; and prepare for peak months with promotional offers and larger stock.


Key Insight and Recommendation on Customer's Analysis: 
* Top Customers: A few customers account for a large share of revenue, these suggest key accounts that should be retained at all cost and rewarded.
* Customer Distribution: Regions with more orders and unique customers represent high-engagement markets, suitable for loyalty campaigns or regional sales strategies, with Califonia having the highestest Number of orders and customers. 
* Recommendation: Focus on retention of top clients; expand outreach in active states


Key Insight and Recommendation for product performance and inventory:
* Top Products: A small number of product generate high volume of sales these need consistent stock availability.
* Price Tiers: Products in the mid-to-high range may bring higher revenue per unit, showing that premium pricing strategies could work for select categories.
* Recommendation: Optimize pricing and phase out underperforming SKUs. Optimize product mix and pricing strategy


Key Insight and Recommendation for employee performance:
* Sales Reps: A few individuals are responsible for major sales. This supports recognizing top performers and replicating their strategies.
* Departments: Varying average sales per employee across departments suggests training needs or load imbalance.
* Recommendation: Recognize strong performers and train others.


!https://www.google.com/imgres?q=nigeria&imgurl=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fthumb%2F7%2F79%2FFlag_of_Nigeria.svg%2F960px-Flag_of_Nigeria.svg.png&imgrefurl=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FNigeria&docid=ycxpk3flSyydlM&tbnid=31KV7kTTT2NADM&vet=12ahUKEwi9vauxtJGOAxXJWEEAHV6cEbwQM3oECBsQAA..i&w=960&h=480&hcb=2&itg=1&ved=2ahUKEwi9vauxtJGOAxXJWEEAHV6cEbwQM3oECBsQAA



Key Insight and Recommendation for FINANCIAL AND TIME-BASED ANALYSIS:
* Quarterly Trends: Looking at month with the month with consistent and complete number of Quarters there is no clear pattern, there is need for further analysis of month to explore monthly trend.
* Year-over-Year Growth: A positive trend shows business expansion; a decline year 2014 is due to the length of month (2 Quarters) recorded . 
* Projection: Forecasted revenue gives a baseline for budget planning and target setting with a $32,401,569.74 projected revenue for next year. 
* Recommendation: Plan stock, staffing, and budgets around seasonal surges. Use forecasts for resource allocation and sales targets.
