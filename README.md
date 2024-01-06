# Sql-Server
Here are some analytics queries using SQL

1. What are total sales and total profits of each year?
select FORMAT(Order_Date,'yyyy') as Year,
          cast(sum(Sales) as decimal(18,2)) as sales,
          cast(SUM(Profit) as decimal(18,2)) Profit 
from [Sample - Superstore] 
group by FORMAT(Order_Date,'yyyy')

2. What are the total profits and total sales per quarter?
ALTER TABLE [Sample - Superstore] ADD Quater nvarchar(10) NULL;

UPDATE s
SET s.Quater=
				CASE WHEN FORMAT(s.Order_Date, 'MM') IN (4, 5, 6) THEN 'Q1'
					 WHEN FORMAT(s.Order_Date, 'MM') BETWEEN 7 AND 9 THEN 'Q2'
					 WHEN FORMAT(s.Order_Date, 'MM') BETWEEN 10 AND 12 THEN 'Q3'
					 ELSE 'Q4'
				END
FROM [Sample - Superstore] s;

3.What region generates the highest sales and profits ?
select top 1 Region as Region,
             cast(sum(Sales) as decimal(18,2)) as sales,
	     cast(SUM(Profit) as decimal(18,2)) Profit 
from [Sample - Superstore] group by Region
order by Sales desc,Profit desc

4. What state and city brings in the highest sales and profits ?
select top 1 State as State,
             City as City,
			 cast(sum(Sales) as decimal(18,2)) as sales,
			 cast(SUM(Profit) as decimal(18,2)) Profit 
from [Sample - Superstore] 
group by State,City 
order by Sales desc,Profit desc

5. The relationship between discount and sales and the total discount per category
select s.Discount, cast(AVG(Sales) as decimal(18,2)) Avg_Sales 
from [Sample - Superstore] s
            where s.Discount is not null
            group by s.Discount

6. What category generates the highest sales and profits in each region and state ?
with cte as(
select Category,
       Region,
	   State,
	   cast(SUM(Sales) as decimal(18,2)) as Sales,
	   cast(SUM(Profit) as decimal(18,2)) as Profit ,
	   DENSE_RANK() over(partition by Region,State order by sum(Sales) desc,sum(Profit) desc) as Ct_rnk
from [Sample - Superstore] s
group by Category,Region,State
)
select Category,Region,State,Sales,Profit from cte where Ct_rnk=1

7. What subcategory generates the highest sales and profits in each region and state ?
with cte as(
select Sub_Category,
       Region,
	   State,
	   cast(SUM(Sales) as decimal(18,2)) as Sales,
	   cast(SUM(Profit) as decimal(18,2)) as Profit ,
	   DENSE_RANK() over(partition by Region,State order by sum(Sales) desc,sum(Profit) desc) as Ct_rnk
from [Sample - Superstore] s
group by Sub_Category,Region,State
)
select Sub_Category,Region,State,Sales,Profit from cte where Ct_rnk=1

8. What are the names of the products that are the most and least profitable to us?

select top 5 Product_Name,SUM(Sales) as Sales 
from [Sample - Superstore]
group by Product_Name
order by Sales desc

select top 5 Product_Name,SUM(Sales) as Sales 
from [Sample - Superstore]
group by Product_Name
order by Sales asc

9.What segment makes the most of our profits and sales ?
select top 5 Segment,
             SUM(Sales) as Sales,
	         SUM(Profit) as Profit 
from [Sample - Superstore]
group by Segment
order by Sales, Profit desc

10.How many customers do we have (unique customer IDs) in total and how much per region and state?
select Region,
       State,
	   COUNT(distinct Customer_ID) [Total customers]
from [Sample - Superstore]
group by Region,State

11. Average shipping time per class and in total
select Ship_Mode,
       AVG(DATEDIFF(DAY,Order_Date,Ship_Date)) as [Avg Duration] 
from [Sample - Superstore]
group by Ship_Mode
