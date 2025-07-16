Use Walmart_db
Select *
--- dayname
 SELECT 
  DATENAME(WEEKDAY, CAST([date] AS DATE)) AS dayname
FROM 
  [Walmart Sales]
WHERE 
  ISDATE([date]) = 1;
  ---Generic Questions
-- 1.How many distinct cities are present in the dataset?
Select *
From [Walmart Sales]
Select Count(distinct(City)) as distinctcity
From [Walmart Sales]
 SELECT DISTINCT city FROM [Walmart Sales];
 ---- 2.What is the most common payment method?
 Select  payment, count(payment) as PaymentMode
 From [Walmart Sales]
 Group By Payment
 Order By PaymentMode Desc;
 ---- 3.What is the most selling product line?
 SELECT Top 3 E.[Product line], COUNT(E.[Product line]) AS CntProduct
FROM [Walmart Sales] E
GROUP BY E.[Product line]
ORDER BY CntProduct Desc;
----- 4.What is the total revenue by month?
--Select Sum(Cast([unit price]as float) * Cast([Quantity]as float)) as TotalRev,
--From [Walmart Sales]
SELECT 
  FORMAT(CONVERT(date, [Date], 105), 'MMM-yyyy') AS MonthYear,
  SUM(CAST([Unit Price] AS FLOAT) * CAST([Quantity] AS FLOAT)) AS TotalRevenue
FROM [Walmart Sales]
GROUP BY FORMAT(CONVERT(date, [Date], 105), 'MMM-yyyy')
ORDER BY MIN(CONVERT(date, [Date], 105));
---- 5.Which month recorded the highest Cost of Goods Sold (COGS)?
 SELECT 
  FORMAT(CONVERT(date, [Date], 105), 'MMMM') AS MonthN,
  SUM(Cast([COGS] as Float)) AS TotalCOGS
FROM [Walmart Sales]
GROUP BY FORMAT(CONVERT(date, [Date], 105), 'MMMM')
ORDER BY TotalCOGS DESC;
-- 6.Which product line generated the highest revenue?
Select [Product line],Sum(Cast([Unit price] As float)*Cast([Quantity] as float)) As Revenue
From [Walmart Sales]
Group By [Product line]
Order By Revenue
sp_help [Walmart Sales]
---- 7.Which city has the highest revenue?
Select City, Sum(Cast([Unit price] As Float)) As Price
From [Walmart Sales]
Group by City
Order By Price desc;
 --- 9.Retrieve each product line and add a column product_category,
 --indicating 'Good' or 'Bad,'based on whether its sales are above the average.
 SELECT 
  [Product line],
  SUM(CAST([Total] AS FLOAT)) AS Sales,
  CASE 
    WHEN SUM(CAST([Total] AS FLOAT)) > (
        SELECT AVG(TotalSales)
        FROM (
            SELECT SUM(CAST([Total] AS FLOAT)) AS TotalSales
            FROM [Walmart Sales]
            GROUP BY [Product line]
        ) AS AvgTable
    )
    THEN 'Good'
    ELSE 'Bad'
  END AS product_category
FROM [Walmart Sales]
GROUP BY [Product line];
-- 10.Which branch sold more products than average product sold?
 SELECT 
  Branch, 
  SUM(CAST([Quantity] AS FLOAT)) AS total_quantity
FROM [Walmart Sales]
GROUP BY Branch
HAVING SUM(CAST([Quantity] AS FLOAT)) > (
  SELECT AVG(branch_quantity)
  FROM (
    SELECT SUM(CAST([Quantity] AS FLOAT)) AS branch_quantity
    FROM [Walmart Sales]
    GROUP BY Branch
  ) AS avg_table
)
ORDER BY total_quantity DESC;
 --- Extra Question 
 ---Q: Show total sales (Total) for each Branch. 
 --Sort branches by sales in descending order.
 Select *
 From [Walmart Sales];
 SELECT 
  Branch, 
  SUM(CAST([Unit price] AS FLOAT) * CAST([Quantity] AS FLOAT)) AS TotalSales
FROM [Walmart Sales]
GROUP BY Branch
ORDER BY TotalSales DESC;
--  GROUP BY + HAVING + AVG
---Q: Show average rating per Product line, 
---but only include product lines where average rating is above 4.5.
Select [Product line], Avg(cast([Rating] as float)) as Avgrating
From [Walmart Sales]
Group by [Product line]
Having Avg(Cast([Rating] As float)) > 4.5 ;
 ---CASE Statement + GROUP BY
 ----: For each Payment method, label it as:
--'Digital' if it's Ewallet
--'Card' if it's Credit card
---'Other' otherwise.
--Then count how many times each category appears.
Select 
Case 
when Payment = 'Ewallet' Then 'Digital'
When Payment = 'Credit card' Then 'Card'
Else 'Other'
End As PaymentCategory,
Count(*) As CntCatgry
From [Walmart Sales]
Group by 
Case 
when Payment = 'Ewallet' Then 'Digital'
When Payment = 'Credit card' Then 'Card'
Else 'Other'
End ;
-- Subquery (Inner query) + HAVING
---Show Branch names that have total quantity sold more than 
--the average of all branches.
Select Avg(Cast([Total] as float)) as Avgsales, Branch
From [Walmart Sales]
Group by Branch;
Select Branch, Sum(cast([Total] as Float))as Totalsales
From [Walmart Sales]
having Sum(cast([Total] as Float)) > Select Avg(Cast([Total] as float)) as Avgsales, Branch
From [Walmart Sales]
Group by Branch;
--. ORDER BY with CASE
--Q: Show Product line and its total income.
--Sort so that products earning more than ₹10,000 come on top.
Select [Product Line], Sum(Cast([Unit price] as float) * Cast([Quantity]as Float)) as TotalRevenue 
From [Walmart Sales]
Group By [Product line] 
Having Sum(Cast([Unit price] as float) * Cast([Quantity]as Float)) > 50000
Order by TotalRevenue Desc;
---- 11.What is the most common product line by gender?
Select [Gender],[Product line],count(Gender) as Cntgender
From [Walmart Sales]
Group By [Gender],[Product line]
order by Cntgender desc;
-- Sales Analysis
----Identify the customer type that generates the highest revenue.
Select [Customer type], Sum(cast([Unit price] As float) * cast([Quantity] as float))As revenue
From [Walmart Sales]
Group By [Customer type]
Order By revenue Desc;
--Which city has the largest tax percent/ VAT (Value Added Tax)?
Select [City],Cast([Tax 5%] as Float) as Tax
From [Walmart Sales]
Group By [City]
Order By Tax ;
----Which customer type pays the most in VAT?
Select [Customer type],Sum(Cast([Tax 5%]as Float)) as TaxAmt
From [Walmart Sales]
Group By [Customer type]
Order By Sum(Cast([Tax 5%]as Float))  Desc;
--Customer Analysis
----How many unique customer types does the data have?
SELECT COUNT(DISTINCT [customer type]) as customertype
FROM [Walmart Sales];
--How many unique payment methods does the data have?
Select Count(Distinct([Payment])) As PaymentType
From [Walmart Sales];
--Which is the most common customer type?
Select Top 1 [Customer type],Count([Customer type]) as CntCustomer
From [Walmart Sales]
Group by [Customer type]
Order By CntCustomer Desc;
--Which customer type buys the most?
select [Customer type],Sum(cast([total] as float)) as totalSales
From [Walmart Sales]
Group By [Customer type]
Order By totalSales Desc;
SELECT [Customer type], COUNT(*) AS most_buyer
FROM [Walmart Sales] 
GROUP BY [Customer type] 
ORDER BY most_buyer DESC;
----What is the gender of most of the customers?
Select [Gender],Count(*) as Most_Gender 
From [Walmart Sales]
Group By [Gender]
Order By Most_Gender;
--What is the gender distribution per branch?
select [Branch],Count(Gender) As ContGender
From [Walmart Sales]
Group By [Branch]
Order By ContGender Desc;
--Which time of the day do customers give most ratings?
  SELECT [Time], Avg(cast([Rating] AS Float)) AS average_rating
FROM [Walmart Sales]
GROUP BY [time]
ORDER BY average_rating DESC;
---Which time of the day do customers give most ratings?
SELECT [Time], COUNT([Rating]) AS total_ratings
FROM [Walmart Sales]
GROUP BY [Time]
ORDER BY total_ratings DESC;
