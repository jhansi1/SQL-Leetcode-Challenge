-- Question 33
-- Table: Product

-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | product_id   | int     |
-- | product_name | varchar |
-- | unit_price   | int     |
-- +--------------+---------+
-- product_id is the primary key of this table.
-- Table: Sales

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | seller_id   | int     |
-- | product_id  | int     |
-- | buyer_id    | int     |
-- | sale_date   | date    |
-- | quantity    | int     |
-- | price       | int     |
-- +------ ------+---------+
-- This table has no primary key, it can have repeated rows.
-- product_id is a foreign key to Product table.
 

-- Write an SQL query that reports the buyers who have bought S8 but not iPhone. Note that S8 and iPhone are products present in the Product table.

-- The query result format is in the following example:

-- Product table:
-- +------------+--------------+------------+
-- | product_id | product_name | unit_price |
-- +------------+--------------+------------+
-- | 1          | S8           | 1000       |
-- | 2          | G4           | 800        |
-- | 3          | iPhone       | 1400       |
-- +------------+--------------+------------+

-- Sales table:
-- +-----------+------------+----------+------------+----------+-------+
-- | seller_id | product_id | buyer_id | sale_date  | quantity | price |
-- +-----------+------------+----------+------------+----------+-------+
-- | 1         | 1          | 1        | 2019-01-21 | 2        | 2000  |
-- | 1         | 2          | 2        | 2019-02-17 | 1        | 800   |
-- | 2         | 1          | 3        | 2019-06-02 | 1        | 800   |
-- | 3         | 3          | 3        | 2019-05-13 | 2        | 2800  |
-- +-----------+------------+----------+------------+----------+-------+

-- Result table:
-- +-------------+
-- | buyer_id    |
-- +-------------+
-- | 1           |
-- +-------------+
-- The buyer with id 1 bought an S8 but didn't buy an iPhone. The buyer with id 3 bought both.

-- Solution
Select distinct a.buyer_id
from sales a join
product b
on a.product_id = b.product_id
where a.buyer_id in
(Select a.buyer_id from sales a join product b on a.product_id = b.product_id where b.product_name = 'S8') 
and
a.buyer_id not in (Select a.buyer_id from sales a join product b on a.product_id = b.product_id where b.product_name = 'iPhone')

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Sales (
      `seller_id` INTEGER,
      `product_id` INTEGER,
      `buyer_id` INTEGER,
      `sale_date` DATETIME,
      `quantity` INTEGER,
      `price` INTEGER
    );
    
    INSERT INTO Sales
      (`seller_id`, `product_id`, `buyer_id`, `sale_date`, `quantity`, `price`)
    VALUES
      ('1', '1', '1', '2019-01-21', '2', '2000'),
      ('1', '2', '2', '2019-02-17', '1', '800'),
      ('2', '2', '3', '2019-06-02', '1', '800'),
      ('3', '3', '4', '2019-05-13', '2', '2800');
    
    CREATE TABLE Product (
      `product_id` INTEGER,
      `product_name` VARCHAR(6),
      `unit_price` INTEGER
    );
    
    INSERT INTO Product
      (`product_id`, `product_name`, `unit_price`)
    VALUES
      ('1', 'S8', '1000'),
      ('2', 'G4', '800'),
      ('3', 'iPhone', '1400');

---

**Query #1**

    select s.buyer_id from 
    Sales s left join Product p on s.product_id = p.product_id
    where p.product_name = 'S8' and p.product_name != 'iPhone';

| buyer_id |
| -------- |
| 1        |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/o5vRFojmFuK9DvZsJm35wC/1)