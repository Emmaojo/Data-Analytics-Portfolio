select * 
from Hackathon
 
					--STEP ONE: Data Pre-processing 
-- Create a table for Department Managers and link it to the Employees table
CREATE TABLE DepartmentManagers (
    ManagerID INT PRIMARY KEY IDENTITY(1,1),
    ManagerName VARCHAR(100),
    Department VARCHAR(50)
);


-- Populate this from unique Manager Name and Department pairs
INSERT INTO DepartmentManagers (ManagerName, Department)
SELECT DISTINCT Manager_Name, Department
FROM Hackathon
WHERE Manager_Name IS NOT NULL;


-- checking to see the department manager table
select * 
from DepartmentManagers



-- To link the tables, we will use a foreign key
ALTER TABLE Hackathon
ADD ManagerID INT;

UPDATE Hackathon
SET ManagerID = dm.ManagerID
FROM Hackathon e
JOIN DepartmentManagers dm
  ON e.Manager_Name = dm.ManagerName AND e.Department = dm.Department;


  -- to view the Table after update 
 select * 
 from Hackathon



								--STEP 2: Sales & Performance Insights
-- 1 Retrieve the first 10 records from the Hackathon table
SELECT TOP 10 * 
FROM Hackathon;


-- 2 Count the number of employees per department. 
SELECT Department, COUNT(*) AS EmployeeCount
FROM Hackathon
GROUP BY Department;



--3 Find the average salary per department
SELECT Department, AVG (Base_Salary) AS AvgSalary
FROM Hackathon
GROUP BY Department;


--4. Retrieve the top 10 highest-earning employees
SELECT TOP 10 First_Name, Last_Name, Base_Salary, Department
FROM Hackathon
ORDER BY Base_Salary DESC; 
-- the top 10 highest paid employees are in IT department


-- 5. Find the number of high-performing employees per department
SELECT Department, COUNT(*) AS HighPerformers
FROM Hackathon
WHERE Sales_Performance_Status = 'High Performer'
GROUP BY Department;


			--Customer Complaints & Satisfaction Analysis
--1. Find the departments with the most customer complaints
SELECT Department, SUM(Customer_Complaints) AS TotalComplaints
FROM Hackathon
WHERE Customer_Complaints IS NOT NULL
GROUP BY Department
ORDER BY TotalComplaints DESC;

--2. Count employees with 'Excellent Service' ratings
--To measure overall service excellence and training effectiveness.
SELECT COUNT(*) AS ExcellentServiceCount
FROM Hackathon
WHERE Customer_Handling_Rating = 'Excellent Service';


--3. Identify employees with poor customer handling
SELECT First_Name, Department, Customer_Rating, Customer_Complaints
FROM Hackathon
WHERE Customer_Rating <= 3 AND Customer_Complaints > 5;