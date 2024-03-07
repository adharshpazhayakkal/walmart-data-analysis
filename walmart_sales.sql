create database if not exists walmartsalesdata;
USE WALMARTSALESDATA;
create table if not exists sales(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(30) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
vat float(6,4) not null,
total decimal(12,4) not null,
date datetime not null,
time time not null,
payment_method varchar(15) not null,
cogs decimal(10,2) not null,
gross_argin_pct float(11,9),
gross_income decimal(12,4) not null,
rating float(2,1)
);
alter table sales change gross_argin_pct gross_margin_pct float(11,9);
selECT * FROM SALES;
#Analysis List
/*-- Product Analysis
Conduct analysis on the data to understand the different product lines, the products lines performing best and the product lines that need to be improved.

Sales Analysis
This analysis aims to answer the question of the sales trends of product. The result of this can help use measure the effectiveness of each sales strategy the business applies and what modificatoins are needed to gain more sales.

Customer Analysis
This analysis aims to uncover the different customers segments, purchase trends and the profitability of each customer segment.*/

/*Data Wrangling: This is the first step where inspection of data is done to make sure NULL values and missing values are detected and data replacement methods are used to replace, missing or NULL values.
Build a database
Create table and insert the data.
Select columns with null values in them. There are no null values in our database as in creating the tables, we set NOT NULL for each field, hence null values are filtered out.
Feature Engineering: This will help use generate some new columns from existing ones.
Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening. This will help answer the question on which part of the day most sales are made.
Add a new column named day_name that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.
Add a new column named month_name that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). Help determine which month of the year has the most sales and profit.
Exploratory Data Analysis (EDA): Exploratory data analysis is done to answer the listed questions and aims of this project.*/
------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------- feature engineering-------------------------------------------------------------------------------

--- time_of_day


select time,(case
when time between '00:00:00' and '12:00:00' then 'morning'
when time between '12:01:00' and '16:00:00' then 'afternoon'
else 'evening' end) as time_of_date
 from sales;
alter table sales add column TIME_OF_DAY VARCHAR(20);
UPDATE SALES SET TIME_OF_DAY= (case
when time between '00:00:00' and '12:00:00' then 'morning'
when time between '12:01:00' and '16:00:00' then 'afternoon'
else 'evening' end
);
SELECT * FROM SALES; 
-- DAY NAME
SELECT DATE,DAYNAME(DATE) FROM SALES;
ALTER TABLE SALES ADD column DAY_NAME varchar(30) NOT NULL ;
UPDATE SALES SET DAY_NAME= DAYNAME(DATE);
 SELECT * FROM SALES;
 ALTER TABLE SALES MODIFY TIME_OF_DAY VARCHAR(20) AFTER TIME;
 ALTER TABLE SALES MODIFY DAY_NAME VARCHAR(30) AFTER DATE;
ALTER TABLE SALES ADD COLUMN MONTH varchar(30) NOT NULL;
UPDATE SALES SET MONTH= monthname(DATE);
#How many unique cities does the data have?
SELECT distinct(CITY) FROM SALES;
#In which city is each branch?
SELECT DISTINCT CITY,BRANCH FROM SALES;
SELECT* FROM SALES; 
#Product
#How many unique product lines does the data have?
SELECT DISTINCT product_line from sales;

#What is the most common payment method?
select count(*), payment_method from sales group by payment_method order by count(*) desc limit 1;

#What is the most selling product line?
select product_line,count(*) from sales group by product_line order by count(*) desc limit 1;

#What is the total revenue by month?
select * from sales;
select month,sum(total) from sales group by month order by month ;
#What month had the largest COGS?
select month, sum(cogs) from sales group by month order by sum(cogs) desc;

#What product line had the largest revenue?
select product_line,sum(total) from sales group by product_line order by sum(total) desc;

#What is the city with the largest revenue?
select city, sum(total) from sales group by city order by sum(total) desc;
#What product line had the largest VAT?
select * from sales;

select product_line, avg(vat) from sales group by product_line order by avg(vat) desc;
#Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select product_line,sum(total),case when sum(total)>(select avg(sum(total)) from sales) then 'good' else 'bad' end as status_of_sale from sales group by product_line;
#Which branch sold more products than average product sold?
select branch, sum(quantity) as qty from sales group by branch having sum(quantity)>(select avg(SUM(quantity)) from sales);

select DISTINCT(BRANCH) FROM SALES;
SELECT BRANCH,SUM(QUANTITY) AS QTY, AVG(QTY) FROM SALES GROUP BY BRANCH;
#What is the most common product line by gender?
SELECT PRODUCT_LINE, GENDER,COUNT(GENDER) FROM SALES GROUP BY PRODUCT_LINE,GENDER ORDER BY COUNT(GENDER) DESC;
#What is the average rating of each product line?
SELECT PRODUCT_LINE,AVG(RATING) FROM SALES group by PRODUCT_LINE ;

#Sales
#Number of sales made in each time of the day per weekday
SELECT * FROM SALES;
SELECT SUM(TOTAL),DAY_NAME,TIME_OF_DAY FROM SALES GROUP BY DAY_NAME,TIME_OF_DAY ORDER BY SUM(TOTAL) DESC;

#Which of the customer types brings the most revenue?
SELECT CUSTOMER_TYPE,SUM(TOTAL) FROM SALES GROUP BY CUSTOMER_TYPE ORDER BY SUM(TOTAL) DESC;

#Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT CITY,SUM(VAT) FROM SALES GROUP BY CITY ORDER BY SUM(VAT) DESC LIMIT 1;

#Which customer type pays the most in VAT?
SELECT * FROM SALES;
SELECT CUSTOMER_TYPE, SUM(VAT) FROM SALES GROUP BY CUSTOMER_type order  by sum(vat) desc limit 1;

#How many unique customer types does the data have?
select distinct(customer_type) from sales;
#How many unique payment methods does the data have?
select distinct(payment_method) from sales;

#What is the most common customer type?
select customer_type, count(customer_type)  from sales group by customer_type order by count(CUSTOMER_TYPE) DESC LIMIT 1;
#Which customer type buys the most?
SELECT CUSTOMER_type,sum(quantity) from sales group by customer_type order by sum(quantity) desc;

#What is the gender of most of the customers?
select * from sales;
select gender, count(gender) from sales group by gender;
#What is the gender distribution per branch?
select branch,gender,count(gender) from sales group by branch,gender order by branch; 
#Which time of the day do customers give most ratings?
select time_of_day, avg(rating) from sales group by time_of_day order by avg(rating) desc limit 1;
#Which time of the day do customers give most ratings per branch?
select time_of_day 
Which day fo the week has the best avg ratings?
Which day of the week has the best average ratings per branch?
 

