-- Restaurant Owners
-- 5 Tables
-- 1x Fact, 4x Dimension
-- search google, how to add foreign key
-- write SQL 3-5 queries analyze data
-- 1x subquery/ with

CREATE TABLE orders (
    order_id INT UNIQUE,
    days_id  INT,
    order_date date,
    customer_id INT,
    food_id int,
    employee_id INT,
    PRIMARY KEY (order_id),
    FOREIGN KEY (days_id) references days(days_id),
    FOREIGN KEY (food_id) references foods_set(food_id),
    FOREIGN KEY (employee_id) references employee(employee_id),
    FOREIGN KEY (customer_id) references customer(customer_id)
    
);

INSERT INTO orders VALUES 
(1, 1, '2022-08-29',2,1,1),
(2, 1, '2022-08-29',5,2,1),
(3, 1, '2022-08-29',6,3,4),
(4, 1, '2022-08-29',7,4,3),
(5, 1, '2022-08-29',1,5,2),  
(6, 2, '2022-08-30',3,6,4),
(7, 2, '2022-08-30',6,7,1),
(8, 3, '2022-08-31',2,1,3),
(9, 6, '2022-09-03',4,3,2),
(10,6, '2022-09-04',1,2,3) 
  
  ;

create table foods_set (
    food_id INT UNIQUE,
    food TEXT,
    price real,
    PRIMARY KEY (food_id)
    
);

INSERT INTO foods_set VALUES  
  (1, "Tom Yum Source Fried Rice",1210),
  (2, "Basil Chicken",1210),
  (3,	"Chicken Coconut Curry",1100),
  (4, "Pork Noodle",1100),
  (5,	"Soft-Shell Crab with Yellow Curry",1100),
  (6,	"Prawns Curry",	1430),
  (7,	"Green Curry",1100);

create table days(
  days_id int UNIQUE,
  days TEXT,
  PRIMARY KEY (days_id)
  
);
INSERT INTO days VALUES
  (1,"Monday"),
  (2,"Tuesday"),
  (3,"Wednesday"),
  (4,"Thursday"),
  (5,"Friday"),
  (6,"Holiday");

create table employee(
  employee_id INT UNIQUE,
  employee_name TEXT,
  position TEXT,
  
  PRIMARY KEY (employee_id)
  
);
INSERT INTO employee VALUES
  (1,"Jame","Manager"),
  (2,"Nut","Staff"),
  (3,"Koi","Staff"),
  (4,"Bee","Cashier");

create table cus_member(
  level_member INT,
  cat_member TEXT,
  
  PRIMARY KEY (level_member)
  
);
INSERT INTO cus_member VALUES 
  (1,"Gold Member"),
  (2,"Silver Member"),
  (3,"No Member");

create table customer (
  customer_id INT,
  customer_name TEXT,
  level_member INT,
  PRIMARY KEY (customer_id),
  FOREIGN KEY (level_member) references cus_member(level_member)
  
);
  INSERT INTO customer VALUES 
  (1,"Khun KK",1),
  (2,"Khun Jann",1),
  (3,"Khun Pimmy",2),
  (4,"Khun Kaiwarn",3),
  (5,"Khun Joo",3),
  (6,"Khun Num",2),
  (7,"Khun Jennis",1)  ;
  
    



-- sqlite command
.mode markdown
.header on 
  
SELECT * FROM orders;



  
SELECT 
  employee_name AS staff_Name,
  customer_name AS cus_Name
  
FROM orders,employee,customer
WHERE orders.employee_id = employee.employee_id 
and
orders.customer_id = customer.customer_id;







SELECT 
  customer.customer_name AS cus_Name,
  cus_member.cat_member AS class_cus,
  foods_set.food AS cus_menu,
  foods_set.price AS price,
    
   CASE 
     WHEN cus_member.level_member = 1 THEN (price*.80)
     WHEN cus_member.level_member = 2 THEN (price*.90)
     ELSE (price*1)
   END AS Discount_for_member
  
FROM customer,cus_member,orders,foods_set
WHERE customer.level_member = cus_member.level_member
AND orders.customer_id = customer.customer_id
AND orders.food_id = foods_set.food_id;



SELECT 
  cus_Name,
  SUM(revenue) AS revenue_by_cus
  FROM(
SELECT
  customer.customer_name AS cus_Name,
  foods_set.food AS menu,
  foods_set.price AS revenue,
  employee_name AS staff_name
  
FROM orders,foods_set,customer,employee
WHERE orders.food_id = foods_set.food_id
and
customer.customer_id = orders.customer_id
and
orders.employee_id = employee.employee_id

)
GROUP BY cus_Name
ORDER BY revenue DESC;
