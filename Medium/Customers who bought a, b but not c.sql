-- Question 72
-- Table: Customers

-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | customer_id         | int     |
-- | customer_name       | varchar |
-- +---------------------+---------+
-- customer_id is the primary key for this table.
-- customer_name is the name of the customer.
 

-- Table: Orders

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | order_id      | int     |
-- | customer_id   | int     |
-- | product_name  | varchar |
-- +---------------+---------+
-- order_id is the primary key for this table.
-- customer_id is the id of the customer who bought the product "product_name".
 

-- Write an SQL query to report the customer_id and customer_name of customers who bought products "A", "B" but did not buy the product "C" since we want to recommend them buy this product.

-- Return the result table ordered by customer_id.

-- The query result format is in the following example.

 

-- Customers table:
-- +-------------+---------------+
-- | customer_id | customer_name |
-- +-------------+---------------+
-- | 1           | Daniel        |
-- | 2           | Diana         |
-- | 3           | Elizabeth     |
-- | 4           | Jhon          |
-- +-------------+---------------+

-- Orders table:
-- +------------+--------------+---------------+
-- | order_id   | customer_id  | product_name  |
-- +------------+--------------+---------------+
-- | 10         |     1        |     A         |
-- | 20         |     1        |     B         |
-- | 30         |     1        |     D         |
-- | 40         |     1        |     C         |
-- | 50         |     2        |     A         |
-- | 60         |     3        |     A         |
-- | 70         |     3        |     B         |
-- | 80         |     3        |     D         |
-- | 90         |     4        |     C         |
-- +------------+--------------+---------------+

-- Result table:
-- +-------------+---------------+
-- | customer_id | customer_name |
-- +-------------+---------------+
-- | 3           | Elizabeth     |
-- +-------------+---------------+
-- Only the customer_id with id 3 bought the product A and B but not the product C.

-- Solution
with t1 as
(
select customer_id
from orders
where product_name = 'B' and
customer_id in (select customer_id
from orders
where product_name = 'A'))

Select t1.customer_id, c.customer_name
from t1 join customers c
on t1.customer_id = c.customer_id
where t1.customer_id != all(select customer_id
from orders
where product_name = 'C')

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Customers (
      `customer_id` INTEGER,
      `customer_name` VARCHAR(9)
    );
    
    INSERT INTO Customers
      (`customer_id`, `customer_name`)
    VALUES
      ('1', 'Daniel'),
      ('2', 'Diana'),
      ('3', 'Elizabeth'),
      ('4', 'Jhon');
    
    CREATE TABLE Orders (
      `order_id` INTEGER,
      `customer_id` INTEGER,
      `product_name` VARCHAR(1)
    );
    
    INSERT INTO Orders
      (`order_id`, `customer_id`, `product_name`)
    VALUES
      ('10', '1', 'A'),
      ('11', '3', 'A'),
      ('20', '1', 'B'),
      ('30', '1', 'D'),
      ('40', '1', 'C'),
      ('50', '2', 'A'),
      ('60', '3', 'A'),
      ('70', '3', 'B'),
      ('80', '3', 'D'),
      ('90', '4', 'C');

---

**Query #1**

    with cte as
    (select c.customer_id, 
			sum(case when o.product_name = 'A' then 1 end) as A, 
			sum(case when o.product_name = 'B' then 1 end) as B, 
			sum(case when o.product_name = 'C' then 1 end) as C 
    from Customers c left join Orders o on c.customer_id = o.customer_id
    group by c.customer_id)
    
    select cte.customer_id, c.customer_name  from cte left join Customers c on cte.customer_id = c.customer_id 
    where A is not null
    and B is not null 
    and C is null;

| customer_id | customer_name |
| ----------- | ------------- |
| 3           | Elizabeth     |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/9wZkbMMfUH4vVe59GUsXwG/1)