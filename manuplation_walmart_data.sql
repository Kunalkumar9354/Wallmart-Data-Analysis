create schema wallmart_db;
use wallmart_db;
create table wallmart_sales(
	invoice_id varchar(30) not null primary key,
	branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(30) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    vat float(6,4) not null,
    total decimal(10,2) not null,
    date date not null,
    time timestamp not null,
    payment_method decimal(10,2) not null,
    cogs decimal(10,2) not null,
    gross_margin_percentage float(11,9) not null,
    gross_income decimal(10,2) not null,
    rating float(2,1) not null 
    );
desc walmart_data;
##########################################
alter table walmart_data
change vat vat float(6,4);

alter table walmart_data
change invoice_id invoice_id varchar(30);

alter table walmart_data
change branch branch varchar(5);

alter table walmart_data
change city city varchar(30);

alter table walmart_data
change customer_type customer_type varchar(30);


alter table walmart_data
change branch branch varchar(5);

alter table walmart_data
change gender gender varchar(10);
alter table walmart_data
change product_line product_line varchar(100);
alter table walmart_data
change unit_price unit_price decimal(10,2);
alter table walmart_data
change total total decimal(10,2);
set sql_safe_updates = 0;

-- Handling date values
update walmart_data
set Date = date_format(str_to_date( Date , "%m/%d/%Y"),"%y-%m-%d");
alter table walmart_data
change Date Date date;

-- Handling Time values
update walmart_data
set time = str_to_date(time,"%H:%i:%s");
alter table walmart_data
change time time time;

alter table walmart_data
change cogs cogs decimal(10,2);
alter table walmart_data
change payment payment varchar(30);
alter table walmart_data
change gross_income gross_income decimal(10,2);
alter table walmart_data
change ratings ratings float;
alter table walmart_data
change gross_margin_percentage gross_margin_percentage decimal(10,2);

-- Feature Engineering
-- add column day_name,time_of_day,month_name 
alter table walmart_data
add column  month_name varchar(20);

alter table walmart_data
add column day_name varchar(30);

alter table walmart_data
add column time_of_day varchar(30);

select * from walmart_data;

update walmart_data
set month_name = monthname(date);

update walmart_data
set day_name = dayname(date);

update walmart_data 
set time_of_day = case when time between "00:00:00" and "12:00:00" then "morning"
				when time between "12:01:00" and "16:00:00" then "afternoon"
                else "evening"
                end ;


