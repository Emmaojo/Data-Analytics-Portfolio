--This project first of all transform AdventureWorks 2019 database into a star schema, then create fact and dimension tables, and then perform SQL-based data analysis in the following areas: 
--Sales performance
--Customer segmentation
--Product inventory and performance
--Employee performance
--Time-based financial trends

/*
Tables							Type							Description
FactSales						Fact							Core transactional data from SalesOrderHeader + SalesOrderDetail
DimCustomer						Dimension						Combines Customer, Person, Address
DimProduct						Dimension						Combines Product, ProductSubcategory, ProductCategory
DimEmployee						Dimension						From Employee, EmployeeDepartmentHistory, Department
DimDate							Dimension						Generated date table with Year, Month, Quarter, Weekday

*/


-- To Create DimProduct Table 
CREATE TABLE DimProduct (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    ProductNumber NVARCHAR(50),
    Color NVARCHAR(50),
    StandardCost MONEY,
    ListPrice MONEY,
    Subcategory NVARCHAR(100),
    Category NVARCHAR(100)
);

--To input into the DimProduct Table created
INSERT INTO DimProduct
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    p.ProductNumber,
    p.Color,
    p.StandardCost,
    p.ListPrice,
    sc.Name AS Subcategory,
    c.Name AS Category
FROM Production.Product p
JOIN Production.ProductSubcategory sc ON p.ProductSubcategoryID = sc.ProductSubcategoryID
JOIN Production.ProductCategory c ON sc.ProductCategoryID = c.ProductCategoryID;

--To create DimCustomer Table
CREATE TABLE DimCustomer (
    CustomerID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    City NVARCHAR(100),
    StateProvinceID INT,
    State NVARCHAR(100),
    CountryRegionCode NVARCHAR(10)
);

--To insert into the created DimCustomer Table created
--there is an error inserting directly into the DimCustomer table because of duplicates. Hence the need to use CTE. 

WITH RankedAddresses AS (
    SELECT 
        c.CustomerID,
        per.FirstName,
        per.LastName,
        a.City,
        a.StateProvinceID,
        sp.Name AS State,
        sp.CountryRegionCode,
        ROW_NUMBER() OVER (PARTITION BY c.CustomerID ORDER BY bea.ModifiedDate DESC) AS rn
    FROM Sales.Customer c
    JOIN Person.Person per ON c.PersonID = per.BusinessEntityID
    JOIN Person.BusinessEntityAddress bea ON c.CustomerID = bea.BusinessEntityID
    JOIN Person.Address a ON bea.AddressID = a.AddressID
    JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
)
INSERT INTO DimCustomer
SELECT 
    CustomerID,
    FirstName,
    LastName,
    City,
    StateProvinceID,
    State,
    CountryRegionCode
FROM RankedAddresses
WHERE rn = 1;

-- To create the DimDate Table
CREATE TABLE DimDate (
    DateKey DATE PRIMARY KEY,
    FullDate DATE,
    Year INT,
    Quarter INT,
    Month INT,
    MonthName VARCHAR(20),
    WeekdayName VARCHAR(20)
);
-- populate the table, we use CTE 
WITH Dates AS (
    SELECT CAST('2010-01-01' AS DATE) AS DateValue
    UNION ALL
    SELECT DATEADD(DAY, 1, DateValue)
    FROM Dates
    WHERE DateValue < '2020-12-31'
)
INSERT INTO DimDate
SELECT 
    DateValue AS DateKey,
    DateValue AS FullDate,
    YEAR(DateValue) AS Year,
    DATEPART(QUARTER, DateValue) AS Quarter,
    MONTH(DateValue) AS Month,
    DATENAME(MONTH, DateValue) AS MonthName,
    DATENAME(WEEKDAY, DateValue) AS WeekdayName
FROM Dates
OPTION (MAXRECURSION 0);


-- To create the DimEmployee Table 
CREATE TABLE DimEmployee (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    JobTitle NVARCHAR(100),
    DepartmentID INT,
    Department NVARCHAR(100)
);


-- Now Populate the Employee Table 
INSERT INTO DimEmployee
SELECT 
    e.BusinessEntityID AS EmployeeID,
    p.FirstName,
    p.LastName,
    e.JobTitle,
    edh.DepartmentID,
    d.Name AS Department
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL;

-- Now lets create the FactSales Table 
CREATE TABLE FactSales (
    SalesOrderID INT,
    SalesOrderDetailID INT PRIMARY KEY,
    OrderDate DATE,
    CustomerID INT,
    ProductID INT,
    EmployeeID INT,
    OrderQty SMALLINT,
    UnitPrice MONEY,
    LineTotal MONEY
);
-- Now, we populate the table 
INSERT INTO FactSales
SELECT 
    sod.SalesOrderID,
    sod.SalesOrderDetailID,
    soh.OrderDate,
    soh.CustomerID,
    sod.ProductID,
    soh.SalesPersonID AS EmployeeID,
    sod.OrderQty,
    sod.UnitPrice,
    sod.LineTotal
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh 
    ON sod.SalesOrderID = soh.SalesOrderID;

-- FIVE TABLES HAVE CREATED AND POPULATED FOR THE QUERY IN THIS PROJECT
--1. DimProduct
--2. DimCustomer
--3. DimEmployee
--4. DimDate 
--5. FactSales

-- SALES ANALYSIS
-- Total revenue grouped by product category
SELECT 
    dp.Category,
    SUM(fs.LineTotal) AS TotalRevenue
FROM FactSales fs
JOIN DimProduct dp ON fs.ProductID = dp.ProductID
GROUP BY dp.Category
ORDER BY TotalRevenue DESC;

---- Total revenue by geographic region (state)
SELECT 
    dc.State,
    SUM(fs.LineTotal) AS TotalRevenue
FROM FactSales fs
JOIN DimCustomer dc ON fs.CustomerID = dc.CustomerID
GROUP BY dc.State
ORDER BY TotalRevenue DESC;

-- Monthly sales trend to analyze seasonality
SELECT 
    dd.Year,
    dd.Month,
    dd.MonthName,
    SUM(fs.LineTotal) AS MonthlySales
FROM FactSales fs
JOIN DimDate dd ON fs.OrderDate = dd.DateKey
GROUP BY dd.Year, dd.Month, dd.MonthName
ORDER BY dd.Year, dd.Month;

-- CUSTOMER INSIGHT
--Top 10 Most Valuable Customers
-- Customers are ranked by their total purchase value
SELECT TOP 10 
    dc.FirstName + ' ' + dc.LastName AS CustomerName,
    SUM(fs.LineTotal) AS TotalSpent
FROM FactSales fs
JOIN DimCustomer dc ON fs.CustomerID = dc.CustomerID
GROUP BY dc.FirstName, dc.LastName
ORDER BY TotalSpent DESC;

-- Customer segmentation based on region and purchase frequency
SELECT 
    dc.State,
    COUNT(DISTINCT fs.SalesOrderID) AS TotalOrders,
    COUNT(DISTINCT dc.CustomerID) AS UniqueCustomers
FROM FactSales fs
JOIN DimCustomer dc ON fs.CustomerID = dc.CustomerID
GROUP BY dc.State
ORDER BY TotalOrders DESC;

-- PRODUCT INVENTORY & PERFORMANCE
-- Products ranked by quantity sold
SELECT TOP 10 
    dp.ProductName,
    SUM(fs.OrderQty) AS TotalQuantitySold
FROM FactSales fs
JOIN DimProduct dp ON fs.ProductID = dp.ProductID
GROUP BY dp.ProductName
ORDER BY TotalQuantitySold DESC;

-- Revenue generation by product price tier and category
SELECT 
    dp.Category,
    CASE 
        WHEN dp.ListPrice < 100 THEN 'Low'
        WHEN dp.ListPrice BETWEEN 100 AND 500 THEN 'Mid'
        ELSE 'High'
    END AS PriceTier,
    COUNT(fs.SalesOrderDetailID) AS Orders,
    SUM(fs.LineTotal) AS Revenue
FROM FactSales fs
JOIN DimProduct dp ON fs.ProductID = dp.ProductID
GROUP BY dp.Category,
         CASE 
            WHEN dp.ListPrice < 100 THEN 'Low'
            WHEN dp.ListPrice BETWEEN 100 AND 500 THEN 'Mid'
            ELSE 'High'
         END
ORDER BY dp.Category, Revenue DESC;

-- EMPLOYEE PERFORMANCE
-- Individual sales reps’ performance
SELECT 
    de.FirstName + ' ' + de.LastName AS SalesRep,
    de.Department,
    SUM(fs.LineTotal) AS TotalSales,
    COUNT(fs.SalesOrderID) AS TotalOrders
FROM FactSales fs
JOIN DimEmployee de ON fs.EmployeeID = de.EmployeeID
GROUP BY de.FirstName, de.LastName, de.Department
ORDER BY TotalSales DESC;

-- Department-level sales efficiency
SELECT 
    de.Department,
    COUNT(DISTINCT de.EmployeeID) AS EmployeeCount,
    SUM(fs.LineTotal) AS TotalSales,
    SUM(fs.LineTotal) / COUNT(DISTINCT de.EmployeeID) AS AvgSalesPerEmployee
FROM FactSales fs
JOIN DimEmployee de ON fs.EmployeeID = de.EmployeeID
GROUP BY de.Department;

--FINANCIAL AND TIME-BASED ANALYSIS
---- Total sales by quarter across all years
SELECT 
    dd.Year,
    dd.Quarter,
    SUM(fs.LineTotal) AS QuarterlySales
FROM FactSales fs
JOIN DimDate dd ON fs.OrderDate = dd.DateKey
GROUP BY dd.Year, dd.Quarter
ORDER BY dd.Year, dd.Quarter;

--Compare sales performance year by year
SELECT 
    dd.Year,
    SUM(fs.LineTotal) AS AnnualSales
FROM FactSales fs
JOIN DimDate dd ON fs.OrderDate = dd.DateKey
GROUP BY dd.Year
ORDER BY dd.Year;


-- -- Simple forecast: average of past 3 years
WITH Annuals AS (
    SELECT 
        dd.Year,
        SUM(fs.LineTotal) AS AnnualSales
    FROM FactSales fs
    JOIN DimDate dd ON fs.OrderDate = dd.DateKey
    GROUP BY dd.Year
)
SELECT 
    AVG(AnnualSales) AS ProjectedRevenueNextYear
FROM Annuals
WHERE Year >= (SELECT MAX(Year) - 2 FROM Annuals);

