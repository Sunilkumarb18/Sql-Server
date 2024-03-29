--select * from [Sample - Superstore]

select top 1 State as State,
             City as City,
			 cast(sum(Sales) as decimal(18,2)) as sales,
			 cast(SUM(Profit) as decimal(18,2)) Profit 
from [Sample - Superstore] 
group by State,City 
order by Sales desc,Profit desc

select top 1 Region as Region,
             cast(sum(Sales) as decimal(18,2)) as sales,
			 cast(SUM(Profit) as decimal(18,2)) Profit 
from [Sample - Superstore] group by Region
order by Sales desc,Profit desc

ALTER TABLE [Sample - Superstore] ADD Quater nvarchar(10) NULL;

UPDATE s
SET s.Quater=
				CASE WHEN FORMAT(s.Order_Date, 'MM') IN (4, 5, 6) THEN 'Q1'
					 WHEN FORMAT(s.Order_Date, 'MM') BETWEEN 7 AND 9 THEN 'Q2'
					 WHEN FORMAT(s.Order_Date, 'MM') BETWEEN 10 AND 12 THEN 'Q3'
					 ELSE 'Q4'
				END
FROM [Sample - Superstore] s;


select s.Discount, cast(AVG(Sales) as decimal(18,2)) Avg_Sales 
from [Sample - Superstore] s
            where s.Discount is not null
            group by s.Discount



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

select top 5 Product_Name,SUM(Sales) as Sales 
from [Sample - Superstore]
group by Product_Name
order by Sales desc

select top 5 Product_Name,SUM(Sales) as Sales 
from [Sample - Superstore]
group by Product_Name
order by Sales asc

select top 5 Segment,
             SUM(Sales) as Sales,
	         SUM(Profit) as Profit 
from [Sample - Superstore]
group by Segment
order by Sales, Profit desc


select Region,
       State,
	   COUNT(distinct Customer_ID) [Total customers]
from [Sample - Superstore]
group by Region,State


select Ship_Mode,
       AVG(DATEDIFF(DAY,Order_Date,Ship_Date)) as [Avg Duration] 
from [Sample - Superstore]
group by Ship_Mode

