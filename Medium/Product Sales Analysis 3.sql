-- Question 90
-- Table: Sales

-- +-------------+-------+
-- | Column Name | Type  |
-- +-------------+-------+
-- | sale_id     | int   |
-- | product_id  | int   |
-- | year        | int   |
-- | quantity    | int   |
-- | price       | int   |
-- +-------------+-------+
-- sale_id is the primary key of this table.
-- product_id is a foreign key to Product table.
-- Note that the price is per unit.
-- Table: Product

-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | product_id   | int     |
-- | product_name | varchar |
-- +--------------+---------+
-- product_id is the primary key of this table.
 

-- Write an SQL query that selects the product id, year, quantity, and price for the first year of every product sold.

-- The query result format is in the following example:

-- Sales table:
-- +---------+------------+------+----------+-------+
-- | sale_id | product_id | year | quantity | price |
-- +---------+------------+------+----------+-------+ 
-- | 1       | 100        | 2008 | 10       | 5000  |
-- | 2       | 100        | 2009 | 12       | 5000  |
-- | 7       | 200        | 2011 | 15       | 9000  |
-- +---------+------------+------+----------+-------+

-- Product table:
-- +------------+--------------+
-- | product_id | product_name |
-- +------------+--------------+
-- | 100        | Nokia        |
-- | 200        | Apple        |
-- | 300        | Samsung      |
-- +------------+--------------+

-- Result table:
-- +------------+------------+----------+-------+
-- | product_id | first_year | quantity | price |
-- +------------+------------+----------+-------+ 
-- | 100        | 2008       | 10       | 5000  |
-- | 200        | 2011       | 15       | 9000  |
-- +------------+------------+----------+-------+

-- Solution
select a.product_id, a.year as first_year, a.quantity, a.price
from
( select product_id, quantity, price, year,
  rank() over(partition by product_id order by year) as rk
  from sales
) a
where a.rk = 1

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Sales (
      `sale_id` INTEGER,
      `product_id` INTEGER,
      `year` INTEGER,
      `quantity` INTEGER,
      `price` INTEGER
    );
    
    INSERT INTO Sales
      (`sale_id`, `product_id`, `year`, `quantity`, `price`)
    VALUES
      ('1', '100', '2008', '10', '5000'),
      ('2', '100', '2009', '12', '5000'),
      ('7', '200', '2011', '15', '9000');
    
    CREATE TABLE Product (
      `product_id` INTEGER,
      `product_name` VARCHAR(7)
    );
    
    INSERT INTO Product
      (`product_id`, `product_name`)
    VALUES
      ('100', 'Nokia'),
      ('200', 'Apple'),
      ('300', 'Samsung');

---

**Query #1**

    select product_id, year as first_year, quantity, price from 
    (select product_id, year, quantity, price, rank() over(partition by product_id order by year) r
    from Sales) d
    where r = 1;

| product_id | first_year | quantity | price |
| ---------- | ---------- | -------- | ----- |
| 100        | 2008       | 10       | 5000  |
| 200        | 2011       | 15       | 9000  |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/bRv8Ciyk6TiSStzcK35SoJ/1)