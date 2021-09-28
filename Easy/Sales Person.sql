-- Question 12
-- Description

-- Given three tables: salesperson, company, orders.
-- Output all the names in the table salesperson, who didn’t have sales to company 'RED'.

-- Example
-- Input

-- Table: salesperson

-- +----------+------+--------+-----------------+-----------+
-- | sales_id | name | salary | commission_rate | hire_date |
-- +----------+------+--------+-----------------+-----------+
-- |   1      | John | 100000 |     6           | 4/1/2006  |
-- |   2      | Amy  | 120000 |     5           | 5/1/2010  |
-- |   3      | Mark | 65000  |     12          | 12/25/2008|
-- |   4      | Pam  | 25000  |     25          | 1/1/2005  |
-- |   5      | Alex | 50000  |     10          | 2/3/2007  |
-- +----------+------+--------+-----------------+-----------+
-- The table salesperson holds the salesperson information. Every salesperson has a sales_id and a name.
-- Table: company

-- +---------+--------+------------+
-- | com_id  |  name  |    city    |
-- +---------+--------+------------+
-- |   1     |  RED   |   Boston   |
-- |   2     | ORANGE |   New York |
-- |   3     | YELLOW |   Boston   |
-- |   4     | GREEN  |   Austin   |
-- +---------+--------+------------+
-- The table company holds the company information. Every company has a com_id and a name.
-- Table: orders

-- +----------+------------+---------+----------+--------+
-- | order_id | order_date | com_id  | sales_id | amount |
-- +----------+------------+---------+----------+--------+
-- | 1        |   1/1/2014 |    3    |    4     | 100000 |
-- | 2        |   2/1/2014 |    4    |    5     | 5000   |
-- | 3        |   3/1/2014 |    1    |    1     | 50000  |
-- | 4        |   4/1/2014 |    1    |    4     | 25000  |
-- +----------+----------+---------+----------+--------+
-- The table orders holds the sales record information, salesperson and customer company are represented by sales_id and com_id.
-- output

-- +------+
-- | name | 
-- +------+
-- | Amy  | 
-- | Mark | 
-- | Alex |
-- +------+
-- Explanation

-- According to order '3' and '4' in table orders, it is easy to tell only salesperson 'John' and 'Pam' have sales to company 'RED',
-- so we need to output all the other names in the table salesperson.

-- Solution
# Takes higher time
# Select distinct a.name  
# from(
# select s.sales_id as sales, name
# from salesperson s left join orders o
# on s.sales_id = o.sales_id) a
# where a.sales != all(select distinct sales_id from orders o join company c on o.com_id = c.com_id where o.com_id = any (select com_id from company where name = 'RED'))

# Faster solution
SELECT name
FROM salesperson
WHERE sales_id NOT IN (SELECT DISTINCT sales_id
FROM orders
WHERE com_id = (SELECT com_id
FROM company
WHERE name = 'RED')) ;

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE salesperson (
      `sales_id` INTEGER,
      `name` VARCHAR(4),
      `salary` INTEGER,
      `commission_rate` INTEGER,
      `hire_date` DATETIME
    );
    
    INSERT INTO salesperson
      (`sales_id`, `name`, `salary`, `commission_rate`, `hire_date`)
    VALUES
      ('1', 'John', '100000', '6', '2006-01-04'),
      ('2', 'Amy', '120000', '5', '2019-01-21'),
      ('3', 'Mark', '65000', '12', '2019-01-21'),
      ('4', 'Pam', '25000', '25', '2019-01-21'),
      ('5', 'Alex', '50000', '10', '2019-01-21');
    
    CREATE TABLE company (
      `com_id` INTEGER,
      `name` VARCHAR(6),
      `city` VARCHAR(8)
    );
    
    INSERT INTO company
      (`com_id`, `name`, `city`)
    VALUES
      ('1', 'RED', 'Boston'),
      ('2', 'ORANGE', 'New York'),
      ('3', 'YELLOW', 'Boston'),
      ('4', 'GREEN', 'Austin');
    
    CREATE TABLE orders (
      `order_id` INTEGER,
      `order_date` DATETIME,
      `com_id` INTEGER,
      `sales_id` INTEGER,
      `amount` INTEGER
    );
    
    INSERT INTO orders
      (`order_id`, `order_date`, `com_id`, `sales_id`, `amount`)
    VALUES
      ('1', '2019-01-21', '3', '4', '100000'),
      ('2', '2019-01-21', '4', '5', '5000'),
      ('3', '2019-01-21', '1', '1', '50000'),
      ('4', '2019-01-21', '1', '4', '25000');

---

**Query #1**

    select name from salesperson where sales_id not in (select distinct s.sales_id
    from (salesperson s left join orders o on s.sales_id = o.sales_id)
    left join company c on o.com_id = c.com_id
    where c.name ='RED');

| name |
| ---- |
| Amy  |
| Mark |
| Alex |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/izhdseY1UfqKzDpk4gN4pK/2)