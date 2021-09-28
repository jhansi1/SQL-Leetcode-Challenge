-- Question 39
-- Table: Prices

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | start_date    | date    |
-- | end_date      | date    |
-- | price         | int     |
-- +---------------+---------+
-- (product_id, start_date, end_date) is the primary key for this table.
-- Each row of this table indicates the price of the product_id in the period from start_date to end_date.
-- For each product_id there will be no two overlapping periods. That means there will be no two intersecting periods for the same product_id.
 

-- Table: UnitsSold

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | purchase_date | date    |
-- | units         | int     |
-- +---------------+---------+
-- There is no primary key for this table, it may contain duplicates.
-- Each row of this table indicates the date, units and product_id of each product sold. 
 

-- Write an SQL query to find the average selling price for each product.

-- average_price should be rounded to 2 decimal places.

-- The query result format is in the following example:

-- Prices table:
-- +------------+------------+------------+--------+
-- | product_id | start_date | end_date   | price  |
-- +------------+------------+------------+--------+
-- | 1          | 2019-02-17 | 2019-02-28 | 5      |
-- | 1          | 2019-03-01 | 2019-03-22 | 20     |
-- | 2          | 2019-02-01 | 2019-02-20 | 15     |
-- | 2          | 2019-02-21 | 2019-03-31 | 30     |
-- +------------+------------+------------+--------+
 
-- UnitsSold table:
-- +------------+---------------+-------+
-- | product_id | purchase_date | units |
-- +------------+---------------+-------+
-- | 1          | 2019-02-25    | 100   |
-- | 1          | 2019-03-01    | 15    |
-- | 2          | 2019-02-10    | 200   |
-- | 2          | 2019-03-22    | 30    |
-- +------------+---------------+-------+

-- Result table:
-- +------------+---------------+
-- | product_id | average_price |
-- +------------+---------------+
-- | 1          | 6.96          |
-- | 2          | 16.96         |
-- +------------+---------------+
-- Average selling price = Total Price of Product / Number of products sold.
-- Average selling price for product 1 = ((100 * 5) + (15 * 20)) / 115 = 6.96
-- Average selling price for product 2 = ((200 * 15) + (30 * 30)) / 230 = 16.96

-- Solution
Select d.product_id, round((sum(price*units)+0.00)/(sum(units)+0.00),2) as average_price
from(
Select *
from prices p
natural join 
unitssold u
where u.purchase_date between p.start_date and p.end_date) d
group by d.product_id 


-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Prices (
      `product_id` INTEGER,
      `start_date` DATETIME,
      `end_date` DATETIME,
      `price` INTEGER
    );
    
    INSERT INTO Prices
      (`product_id`, `start_date`, `end_date`, `price`)
    VALUES
      ('1', '2019-02-17', '2019-02-28', '5'),
      ('1', '2019-03-01', '2019-03-22', '20'),
      ('2', '2019-02-01', '2019-02-20', '15'),
      ('2', '2019-02-21', '2019-03-31', '30');
    
    CREATE TABLE UnitsSold (
      `product_id` INTEGER,
      `purchase_date` DATETIME,
      `units` INTEGER
    );
    
    INSERT INTO UnitsSold
      (`product_id`, `purchase_date`, `units`)
    VALUES
      ('1', '2019-02-25', '100'),
      ('1', '2019-03-01', '15'),
      ('2', '2019-02-10', '200'),
      ('2', '2019-03-22', '30');

---

**Query #1**

select s.product_id,
	round(sum(s.price_of_products)/ sum(s.number_of_products_sold), 2) as average_price
from (
select p.product_id as product_id, (p.price * u.units) as price_of_products, u.units as number_of_products_sold
      from Prices p inner join UnitsSold u on p.product_id = u.product_id
where u.purchase_date between p.start_date and p.end_date
) s
 group by s.product_id;   

| product_id | average_price |
| ---------- | ------------- |
| 1          | 6.96          |
| 2          | 16.96         |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/un1LYJche6VFe3dEUTGyXi/1)