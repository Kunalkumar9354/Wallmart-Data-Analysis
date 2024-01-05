-- Exploratory data analysis

-- Generic Question
-- How many unique cities does the data have?
select count(distinct city) as unique_cities
from walmart_data;
-- how many branch in each city?
select distinct city,branch
from walmart_data;

-- Product
-- How many unique product lines does the data have?
select count(distinct product_line) as unique_product_line
from walmart_data;
-- What is the most common payment method?
with most_use_method as(select payment as payment_method,count(invoice_id) as total_paymnents,
rank() over(order by total_payments desc) as pay_rank
from walmart_data
group by payment)
select payment_method from most_use_method 
where pay_rank = 1; 
-- What is the most selling product line?
with most_selling_product_line as(select product_line,sum(cogs) as total_sales_by_product ,
rank() over(order by sum(cogs)desc) as product_rank 
from walmart_data
group by product_line)
select product_line,total_sales_by_product from most_selling_product_line
where product_rank = 1; 
-- What is the total revenue by month?
select month_name,sum(cogs) as total_revenue_by_month
from walmart_data
group by month_name
order by total_revenue_by_month desc;
-- What month had the largest COGS?
with largest_cogs as(select month_name,sum(cogs) as total_revenue_by_month,
rank() over(order by sum(cogs) desc ) as largest_cogs_check
from walmart_data
group by month_name
order by total_revenue_by_month desc)
select month_name
from largest_cogs
where largest_cogs_check = 1 ;
-- What product line had the largest revenue?
with most_selling_product_line as(select product_line,sum(cogs) as total_sales_by_product ,
rank() over(order by sum(cogs)desc) as product_rank 
from walmart_data
group by product_line)
select product_line,total_sales_by_product from most_selling_product_line
where product_rank = 1; 
-- What is the city with the largest revenue?
with city_revenue as(select city,sum(cogs) as total_sales_by_city,
rank() over(order by sum(cogs)desc) as city_rnk
from walmart_data
group by city)
select city,total_sales_by_city 
from city_revenue
where city_rnk = 1; 
-- What product line had the largest VAT?
with largest_vat as(select product_line,sum(vat) as total_vat_by_product ,
rank() over(order by sum(vat)desc) as product_rank 
from walmart_data
group by product_line)
select product_line,total_vat_by_product from largest_vat
where product_rank = 1; 
-- Fetch each product line and add a column to those product line showing 
#"Good", "Bad". Good if its greater than average sales
with product_line_table as (select product_line,sum(cogs) as total_sales, avg(sum(cogs)) over() as avg_sales
from walmart_data
group by product_line)
select product_line,case when total_sales>avg_sales then "Good"
		else "Bad"
        end as product_status
from product_line_table;
-- Which branch sold more products than average product sold?
with branch_table as (select branch , count(invoice_id) as total_products_sold_by_branch,
round(avg(count(invoice_id)) over(),2) as avg_product_sold  
from walmart_data
group by branch)
select  branch 
from branch_table
where total_products_sold_by_branch>avg_product_sold;
-- What is the most common product line by gender?
with product_line_by_gender as (select gender ,product_line,count(invoice_id) as total_products,
rank() over(partition by  gender order by count(invoice_id) desc ) as pr_rnk
from walmart_data
group by gender,product_line
order by gender,total_products desc)
select gender , product_line as most_common_product_line_by_gender
from product_line_by_gender
where pr_rnk = 1;
-- What is the average rating of each product line?
select  product_line , round(avg(ratings),2) as avg_ratings
from walmart_data
group by product_line
order by avg_ratings desc;
-- Sales
-- Number of sales made in each time of the day per weekday
select * from walmart_data;
select dayofweek(date) as week_day,day_name,count(invoice_id) as total_sales
from walmart_data
group by week_day,day_name
order by week_day;
-- Which of the customer types brings the most revenue?
with largest_revenue as(select customer_type,round(sum(cogs),2) as total_revenue_by_customer_type ,
rank() over(order by sum(cogs)desc) as rev_rank 
from walmart_data
group by customer_type)
select customer_type,total_revenue_by_customer_type from largest_revenue
where rev_rank = 1; 
-- Which city has the largest tax percent/ VAT (Value Added Tax)?
with largest_vat as(select city,round(sum(vat),2) as total_vat_by_product ,
rank() over(order by sum(vat)desc) as city_rank 
from walmart_data
group by city)
select city,total_vat_by_product from largest_vat
where city_rank = 1; 
-- Which customer type pays the most in VAT?
with largest_vat as(select customer_type,round(sum(vat),2) as total_vat_by_customer_type ,
rank() over(order by sum(vat)desc) as vat_rank 
from walmart_data
group by customer_type)
select customer_type,total_vat_by_customer_type from largest_vat
where vat_rank = 1; 
-- Customer
-- How many unique customer types does the data have?
select count(distinct customer_type) as unique_customer_type from walmart_data;
-- How many unique payment methods does the data have?
select count(distinct payment) as unique_payment_count
from walmart_data;
-- What is the most common customer type?
with most_common_customer_type as (select customer_type , count(invoice_id) as total_transactions,
rank() over(order by count(invoice_id) desc ) as customer_type_rank
from walmart_data
group by customer_type)
select customer_type
from most_common_customer_type
where customer_type_rank = 1;
-- Which customer type buys the most?
with most_common_customer_type as (select customer_type , count(invoice_id) as total_transactions,
rank() over(order by count(invoice_id) desc ) as customer_type_rank
from walmart_data
group by customer_type)
select customer_type
from most_common_customer_type
where customer_type_rank = 1;
-- What is the gender of most of the customers?
with most_customer_type as(select gender,count(customer_type) as total_customer,
rank() over(order by count(customer_type) desc ) as most_cus
from walmart_data
group by gender)
select gender
from most_customer_type
where most_cus = 1;
-- What is the gender distribution per branch?
select branch , count(gender) as gender_count
from walmart_data
group by branch;
-- Which time of the day do customers give most ratings?
select time_of_day , max(ratings) as most_rating
from walmart_data
group by time_of_day;
-- Which time of the day do customers give most ratings per branch?
with most_rating_table as(select branch , time_of_day,max(ratings) as max_rating,
rank() over(partition by branch order by max(ratings) desc ) as branch_rank
from walmart_data
group by branch,time_of_day
order by branch)
select branch, time_of_day,max_rating
from most_rating_table
where branch_rank = 1;
-- Which day fo the week has the best avg ratings?
with best_average_day_of_week as(select dayofweek(date) as week_day,day_name,round(avg(ratings),2) as avg_ratings,
rank() over(order by round(avg(ratings),2) desc ) as rnk_based_on_rating
from walmart_data
group by week_day,day_name)
select week_day,day_name,avg_ratings
from best_average_day_of_week
where rnk_based_on_rating = 1;
-- Which day of the week has the best average ratings per branch?
with best_average_day_of_week as
	(select branch,dayofweek(date) as week_day,day_name,round(avg(ratings),2) as avg_ratings,
	rank() over(order by round(avg(ratings),2) desc ) as rnk_based_on_rating
	from walmart_data
	group by branch,week_day,day_name)
select branch,week_day,day_name,avg_ratings
from best_average_day_of_week
where rnk_based_on_rating = 1;

