use paytm_epurchase;

# 1. What does the "Category_Grouped" column represent, and how many unique categories are there?
select distinct Category_Grouped from paytm_epurchase;

# 2. Can you list the top 5 shipping cities in terms of the number of orders?
SELECT * FROM paytm_epurchase.paytm_epurchase_data;
select Shipping_city,count(Category) as Max_orders from paytm_epurchase group by Shipping_city order by Count(Category) desc limit 5 ; 

select Shipping_city,count(Item_NM) as Max_orders from paytm_epurchase group by Shipping_city order by Count(Item_NM) desc limit 5 ; 

# 3. Show me a table with all the data for products that belong to the "Electronics" category.
select Category,Item_NM from paytm_epurchase where Category = 'WATCHES' group by Item_NM;

# 4. Filter the data to show only rows with a "Sale_Flag" of 'Yes'.
select Category from paytm_epurchase where Sale_Flag = 'Yes';
select Category, Sale_Flag,count(Sale_Flag) from paytm_epurchase where Sale_Flag = 'On Sale' group by Category order by count(Sale_Flag) desc;

# 5. Sort the data by "Item_Price" in descending order. What is the most expensive item?
select Category,max(Item_Price) as Highest_Price from paytm_epurchase group by Category order by max(Item_Price) desc;

# 6. Apply conditional formatting to highlight all products with a "Special_Price_effective" value below $50 in red.
select category from paytm_epurchase where Special_Price_effective < 50;

# 7. Create a pivot table to find the total sales value for each category.
select Category,sum(Item_Price) as Total_Sales_Value from paytm_epurchase group by Category order by Total_Sales_Value desc;

# 8. Create a bar chart to visualize the total sales for each category.
select Category,sum(Item_Price) from paytm_epurchase group by Category;

# 9. Create a pie chart to show the distribution of products in the "Family" category.
select Item_NM from paytm_epurchase where Category = 'Family' group by Item_NM;

# 10. Ensure that the "Payment_Method" column only contains valid payment methods (e.g., Visa, MasterCard).
UPDATE paytm_epurchase
SET Payment_Method = 
    CASE 
        WHEN Payment_Method = 'Visa' OR Payment_Method = 'MasterCard' THEN Payment_Method
        ELSE 'Other' -- Replace 'Other' with a valid default value or NULL if needed
    END;
select Payment_Method from paytm_epurchase;

# 11. Calculate the average "Quantity" sold for products in the "Clothing" category, grouped by "Product_Gender."
SELECT Product_Gender, AVG(Quantity) AS Average_Quantity
FROM paytm_epurchase
WHERE Category = 'Clothing'
GROUP BY Product_Gender;

# 12. Find the top 5 products with the highest "Value_CM1" and "Value_CM2" ratios. Create a chart to visualize this data.
SELECT *
FROM (
    SELECT *,
         Value_CM1 / Value_CM2
         AS CM_Ratio
    FROM paytm_epurchase
) AS With_Ratios
WHERE CM_Ratio IS NOT NULL
ORDER BY CM_Ratio DESC
LIMIT 5;

# 13. Identify the top 3 "Class" categories with the highest total sales. Create a stacked bar chart to represent this data.
select Class, sum(Item_Price) as Total_Sales from paytm_epurchase group by Class order by Total_Sales desc limit 3;

# 14. Use VLOOKUP or INDEX-MATCH to retrieve the "Color" of a product with a specific "Item_NM."
select Item_NM,Color from paytm_epurchase where Color = 'Green';

# 15. Calculate the total "coupon_money_effective" and "Coupon_Percentage" for products in the "Electronics" category.
select sum(coupon_money_effective), sum(Coupon_Percentage) from paytm_epurchase where Category = 'Electronics';

# 16. Perform a time series analysis to identify the month with the highest total sales.
SELECT 
    EXTRACT(MONTH FROM date_column) AS Sales_Month,
    SUM(Item_Price) AS Total_Sales
FROM 
    paytm_epurchase
GROUP BY Sales_Month
ORDER BY 
    Total_Sales DESC
LIMIT 1;

# 17. Calculate the total sales for each "Segment" and create a scatter plot to visualize the relationship between "Item_Price" and "Quantity" in this data.
select Segment,sum(Item_Price) as Total_Sales from paytm_epurchase group by Segment;
select Item_Price,Quantity from paytm_epurchase;

# 18. Use the AVERAGEIFS function to find the average "Item_Price" for products that have a "Sale_Flag" of 'Yes.'
select avg(item_Price) from paytm_epurchase where Sale_Flag ='Yes';

# 19. Identify products with a "Paid_pr" higher than the average in their respective "Family" and "Brand" groups.
SELECT *
FROM (
    SELECT *,
        AVG(Paid_pr) OVER (PARTITION BY Family, Brand) AS Avg_Paid_pr_By_Family_Brand
    FROM paytm_epurchase
) AS With_Avg
WHERE Paid_pr > Avg_Paid_pr_By_Family_Brand;

# 20. Create a pivot table to show the total sales for each "Color" within the "Clothing" category and use conditional formatting to highlight the highest sales.
select Color, Sum(Item_Price) as Total_Sales from paytm_epurchase where Category = 'Clothing' group by Color order by Total_Sales desc ;
