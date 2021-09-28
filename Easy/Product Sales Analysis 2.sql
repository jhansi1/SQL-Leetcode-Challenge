-- Question 29
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
 

-- Write an SQL query that reports the total quantity sold for every product id.

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
-- +--------------+----------------+
-- | product_id   | total_quantity |
-- +--------------+----------------+
-- | 100          | 22             |
-- | 200          | 15             |
-- +--------------+----------------+

-- Solution
Select a.product_id, sum(a.quantity) as total_quantity
from sales a
join
product b
on a.product_id = b.product_id
group by a.product_id

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

    select s.product_id, sum(s.quantity) as total_quantity
    from Sales s left join Product p on s.product_id = p.product_id
    group by s.product_id;

| product_id | total_quantity |
| ---------- | -------------- |
| 100        | 22             |
| 200        | 15             |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/fzYV4RHAdHB1AhhLFcSFht/1)