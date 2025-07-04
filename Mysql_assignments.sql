use classicmodels; 

-- Q1 (a)
select * from employees;
select employeenumber,firstname,lastname 
from employees 
where jobtitle = "sales rep" and reportsTo = 1102;
-- Q1 (b)
select distinct(productline) 
from products 
where productLine like "%cars";

-- Q2
select * from customers;
select customernumber,customername,
 case when country = "usa" or country = "canada" then "north america"
 when country = "uk" or country = "france" or country = "germany" then "europe"
 else "others"
 end as "customersegment" from customers;

-- Q3 (a)
select * from orderdetails;
select productcode,sum(quantityordered) as total_ordered 
from orderdetails 
group by productcode 
order by total_ordered desc limit 10;
-- Q3 (b)
select * from payments;
select monthname(paymentdate) as payment_month,count(amount) as num_payments 
from payments 
group by payment_month having num_payments > 20 
order by num_payments desc;

-- Q4
create database customers_orders ;
use customers_orders;
create table customers (customer_id int primary key auto_increment,fisrt_name varchar(50) not null,last_name varchar(50) not null,email varchar(255) unique,phone_number varchar(20));
create table orders (order_id int primary key auto_increment,customer_id int , order_date date,total_amount decimal(10,2),foreign key(customer_id) references customers(customer_id));
desc orders;
drop table orders;

-- Q5
select * from customers;
select * from orders;
select customers.country,count(orders.ordernumber) as order_count from customers inner join orders on customers.customernumber = orders.customernumber
group by customers.country order by order_count desc limit 5;

-- Q6
create table project (employeeid int auto_increment primary key,fullname varchar(50) not null,gender char(6),managerid int,check(gender in ("male","female")));
insert into project (fullname,gender,managerid)
values ("pranaya","male",3),("priyanka","female",1),("preety","female",null),("anurag","male",1),("sambit","male",1),("rajesh","male",3),("hina","female",3);
select * from project;
select m.fullname as manegername,e.fullname as employeename from project as m join project as e on m.employeeid = e.managerid order by manegername;

-- Q7
create table facility (facility_id int not null, name varchar(100),state varchar(100),country varchar(100));
select * from facility;
alter table facility modify facility_id int auto_increment,add primary key(facility_id);
alter table facility add city varchar(100) not null after name;

-- Q8
select * from orderdetails;
select * from products;
select * from orders;
select * from productlines;
create view product_category_sales1 as select productlines.productline,
sum(orderdetails.quantityordered * orderdetails.priceeach) as total_sales ,count(orderdetails.quantityOrdered ) number_of_orders 
from orderdetails inner join products on orderdetails.productCode = products.productcode inner join productlines on productlines.productLine = products.productLine 
inner join orders on orders.orderNumber = orderdetails.orderNumber group by productlines.productLine order by productlines.productline;
drop view product_category_sales1;
select * from product_category_sales1;

-- Q9
select * from customers;
select * from payments;
Delimiter //
create procedure country_year_amount(in _country varchar(50),in _year int) 
 begin 
  select year(paymentDate) as year,country,concat(floor(sum(amount)/1000) , "k") as total_amount  from customers inner join payments on customers.customerNumber = payments.customerNumber
  where country = _country and year(paymentdate) = _year group by country,year;
 end //
delimiter ;
call country_year_amount("france",2003);
drop procedure country_year_amount;

-- Q10 (a)
select * from customers;
select * from orders;
select customers.customername,count(orders.customerNumber) as order_count ,dense_rank() over(order by count(orders.customerNumber) desc)as order_frequency_rnk 
from customers inner join orders on customers.customerNumber = orders.customerNumber
group by customers.customerName order by order_count desc;-- ,dense_rank() over(partition by order_count) as order_frequency_rnk from customers,orders; 
-- Q10 (b)
select * from orders;
select year(orderDate) as year, monthname(orderdate) as month,count(customerNumber) as total_orders,
concat(floor(100 * (count(customernumber) - lag(count(customerNumber)) over(order by year(orderdate))) / lag(count(customerNumber)) over(order by year(orderdate))) , "%")as yoy_growth 
from orders group by year(orderDate),monthname(orderdate);

-- Q11
select productLine,count(buyprice) as total 
from products 
where buyprice > (select avg(buyPrice) from products) 
group by productLine 
order by total desc;

-- Q12
create table emp_eh ( empid int primary key , empname varchar(40) not null , emailaddress varchar(30) unique );
select * from emp_eh;
drop table emp_eh;
delimiter //
create procedure emp_eh_proce ( in emp_id int, in emp_name varchar(40), in email varchar(30))
begin
declare exit handler for 1048
begin
select "error occurred < null value >" as message;
end;
declare exit handler for 1062
begin
select "error occurred < duplicate value >" as message;
end;
insert into emp_eh values(emp_id,emp_name,email);
end //
delimiter ;
call emp_eh_proce(1,"vishal kumar yadav","vvkkyy654321@gmail.com");

-- Q13
create table emp_bit(name varchar(40) not null,occupation varchar(30) not null,working_date date,working_hour smallint);
insert into emp_bit values('robin','scientist','2020-10-04',12),('warner','engineer','2020-10-04',10),('peter','actor','2020-10-04',13),('marco','doctor','2020-10-04',14),
('brayden','teacher','2020-10-04',12),('antonio','business','2020-10-04',11),('rohit','cricketer','2020-10-04',-9);
select * from emp_bit;
drop table emp_bit;
delimiter //
create trigger working_hour_check before insert on emp_bit for each row
begin
 if 
 new.working_hour < 0 then set new.working_hour = abs(new.working_hour);
 end if;
 end //
 drop trigger working_hour_check;




