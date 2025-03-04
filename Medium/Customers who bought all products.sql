-- Question 93
-- Table: Customer

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | customer_id | int     |
-- | product_key | int     |
-- +-------------+---------+
-- product_key is a foreign key to Product table.
-- Table: Product

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | product_key | int     |
-- +-------------+---------+
-- product_key is the primary key column for this table.
 

-- Write an SQL query for a report that provides the customer ids from the Customer table that bought all the products in the Product table.

-- For example:

-- Customer table:
-- +-------------+-------------+
-- | customer_id | product_key |
-- +-------------+-------------+
-- | 1           | 5           |
-- | 2           | 6           |
-- | 3           | 5           |
-- | 3           | 6           |
-- | 1           | 6           |
-- +-------------+-------------+

-- Product table:
-- +-------------+
-- | product_key |
-- +-------------+
-- | 5           |
-- | 6           |
-- +-------------+

-- Result table:
-- +-------------+
-- | customer_id |
-- +-------------+
-- | 1           |
-- | 3           |
-- +-------------+
-- The customers who bought all the products (5 and 6) are customers with id 1 and 3.

-- Solution
select customer_id
from customer
group by customer_id
having count(distinct product_key) = (select COUNT(distinct product_key) from product)

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Customer (
      `customer_id` INTEGER,
      `product_key` INTEGER
    );
    
    INSERT INTO Customer
      (`customer_id`, `product_key`)
    VALUES
      ('1', '5'),
      ('2', '6'),
      ('3', '5'),
      ('3', '6'),
      ('1', '6');
    
    CREATE TABLE Product (
      `product_key` INTEGER
    );
    
    INSERT INTO Product
      (`product_key`)
    VALUES
      ('5'),
      ('6');

---

**Query #1**

    select customer_id
    from Customer
    group by customer_id
    having count(distinct product_key) = (select count(distinct product_key) from Product);

| customer_id |
| ----------- |
| 1           |
| 3           |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/apHsH5WuyYVWffkWF9YCk/1)