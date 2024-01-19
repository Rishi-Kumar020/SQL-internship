use pharma_data;

# 1. Retrieve all columns for all records in the dataset.
select * from pharma_data;

# 2. How many unique countries are represented in the dataset?
select distinct Country as Countries from pharma_data;

# 3. Select the names of all the customers on the 'Retail' channel.
Select distinct (Sub_Channel) from pharma_data;
select Customer_Name,Sub_Channel from pharma_data where Sub_Channel = 'Retail';

# 4. Find the total quantity sold for the ' Antibiotics' product class.
select Product_Name, Product_Class, count(Quantity) as Quantity_Sold from pharma_data where Product_Class = 'Antibiotics' group by Product_Name order by Quantity_Sold desc;

# 5. List all the distinct months present in the dataset.
select distinct Month as Month_Name from pharma_data;

# 6. Calculate the total sales for each year.
select Year, sum(Sales) as Total_Sales from pharma_data group by Year;

# 7. Find the customer with the highest sales value.
select Customer_Name, max(Sales) as Highest_Sale_Value from pharma_data group by Customer_Name order by Highest_Sale_Value desc limit 1;

# 8. Get the names of all employees who are Sales Reps and are managed by 'James Goodwill'.
select Name_of_Sales_Rep,Manager from pharma_data where Manager = 'James Goodwill' group by Name_of_Sales_Rep,Manager;

# 9. Retrieve the top 5 cities with the highest sales.
select City, max(Sales) from pharma_data group by City order by max(Sales) desc limit 5;

# 10. Calculate the average price of products in each sub-channel.
select Sub_Channel, avg(Price) as Avg_Product_Price from pharma_data group by Sub_Channel order by Avg_Product_Price desc ;

# 11. Join the 'Employees' table with the 'Sales' table to get the name of the Sales Rep and the corresponding sales records.
-- There is no Employees Table data in the given dataset.

# 12. Retrieve all sales made by employees from ' Rendsburg ' in the year 2018.
Select * from pharma_data where City = 'Rendsburg' and Year = 2018;

# 13. Calculate the total sales for each product class, for each month, and order the results by year, month, and product class.
select Year,Month,Product_Class,sum(Sales) as Total_Sales from pharma_data group by Product_Class,Month,Year order by Year;

# 14. Find the top 3 sales reps with the highest sales in 2019.
select Name_of_Sales_Rep,Year,sum(Sales) from pharma_data where Year = 2019 group by Name_of_Sales_Rep order by sum(Sales) desc limit 3;

# 15.Calculate the monthly total sales for each sub-channel, and then calculate the average monthly sales for each sub-channel over the years.
select Sub_Channel,Month,Year,sum(Sales) as Total_Monthly_Sales,avg(Sales) as Monthly_Average_Sales from pharma_data group by Sub_Channel,Year,Month;

# 16. Create a summary report that includes the total sales, average price, and total quantity sold for each product class.
WITH summary_cte AS (
    SELECT 
        Product_Class,
        SUM(Sales) AS Total_Sales,
        AVG(Price) AS Average_Price,
        COUNT(Quantity) AS Total_Quantity
    FROM pharma_data
    GROUP BY Product_Class
)
SELECT * FROM summary_cte;

# 17. Find the top 5 customers with the highest sales for each year.
WITH RankedCustomers AS (
    SELECT
        Year,
        Customer_Name,
        SUM(Sales) AS Total_Sales,
        ROW_NUMBER() OVER (PARTITION BY Year ORDER BY SUM(Sales) DESC) AS SalesRank
    FROM pharma_data
    GROUP BY Year, Customer_Name
)
SELECT Year, Customer_Name, Total_Sales
FROM RankedCustomers
WHERE SalesRank <= 5;

# 18. Calculate the year-over-year growth in sales for each country.
SELECT 
    Country,
    Year,
    Total_Sales,
    LAG(Total_Sales) OVER (PARTITION BY Country ORDER BY Year) AS Prev_Year_Sales,
    ((Total_Sales - LAG(Total_Sales) OVER (PARTITION BY Country ORDER BY Year)) / LAG(Total_Sales) OVER (PARTITION BY Country ORDER BY Year)) * 100 AS Yearly_Growth
FROM (
    SELECT 
        Country,
        Year,
        SUM(Sales) AS Total_Sales
    FROM pharma_data
    GROUP BY Country, Year
) AS SalesByYear
ORDER BY Country, Year;

# 19. List the months with the lowest sales for each year
SELECT Year, Month, Sales
FROM (
    SELECT
        Year,
        Month,
        Sales,
        RANK() OVER (PARTITION BY Year ORDER BY Sales) AS SalesRank
    FROM pharma_data
) AS RankedSales
WHERE SalesRank = 1
ORDER BY Year, Month;

# 20. Calculate the total sales for each sub-channel in each country, and then find the country with the highest total sales for each sub-channel.
select Country,Sub_Channel,sum(Sales) as Highest_Total_Sales from pharma_data group by Sub_Channel,Country order by Highest_Total_Sales desc;

