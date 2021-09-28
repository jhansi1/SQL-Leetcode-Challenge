-- Question 69
-- Table: Users

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | user_id        | int     |
-- | join_date      | date    |
-- | favorite_brand | varchar |
-- +----------------+---------+
-- user_id is the primary key of this table.
-- This table has the info of the users of an online shopping website where users can sell and buy items.
-- Table: Orders

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | order_id      | int     |
-- | order_date    | date    |
-- | item_id       | int     |
-- | buyer_id      | int     |
-- | seller_id     | int     |
-- +---------------+---------+
-- order_id is the primary key of this table.
-- item_id is a foreign key to the Items table.
-- buyer_id and seller_id are foreign keys to the Users table.
-- Table: Items

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | item_id       | int     |
-- | item_brand    | varchar |
-- +---------------+---------+
-- item_id is the primary key of this table.
 

-- Write an SQL query to find for each user, the join date and the number of orders they made as a buyer in 2019.

-- The query result format is in the following example:

-- Users table:
-- +---------+------------+----------------+
-- | user_id | join_date  | favorite_brand |
-- +---------+------------+----------------+
-- | 1       | 2018-01-01 | Lenovo         |
-- | 2       | 2018-02-09 | Samsung        |
-- | 3       | 2018-01-19 | LG             |
-- | 4       | 2018-05-21 | HP             |
-- +---------+------------+----------------+

-- Orders table:
-- +----------+------------+---------+----------+-----------+
-- | order_id | order_date | item_id | buyer_id | seller_id |
-- +----------+------------+---------+----------+-----------+
-- | 1        | 2019-08-01 | 4       | 1        | 2         |
-- | 2        | 2018-08-02 | 2       | 1        | 3         |
-- | 3        | 2019-08-03 | 3       | 2        | 3         |
-- | 4        | 2018-08-04 | 1       | 4        | 2         |
-- | 5        | 2018-08-04 | 1       | 3        | 4         |
-- | 6        | 2019-08-05 | 2       | 2        | 4         |
-- +----------+------------+---------+----------+-----------+

-- Items table:
-- +---------+------------+
-- | item_id | item_brand |
-- +---------+------------+
-- | 1       | Samsung    |
-- | 2       | Lenovo     |
-- | 3       | LG         |
-- | 4       | HP         |
-- +---------+------------+

-- Result table:
-- +-----------+------------+----------------+
-- | buyer_id  | join_date  | orders_in_2019 |
-- +-----------+------------+----------------+
-- | 1         | 2018-01-01 | 1              |
-- | 2         | 2018-02-09 | 2              |
-- | 3         | 2018-01-19 | 0              |
-- | 4         | 2018-05-21 | 0              |
-- +-----------+------------+----------------+

-- Solution
select user_id as buyer_id, join_date, coalesce(a.orders_in_2019,0)
from users
left join
(
select buyer_id, coalesce(count(*), 0) as orders_in_2019
from orders o
join users u
on u.user_id = o.buyer_id
where extract('year'from order_date) = 2019
group by buyer_id) a
on users.user_id = a.buyer_id

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Users (
      `user_id` INTEGER,
      `join_date` DATETIME,
      `favorite_brand` VARCHAR(7)
    );
    
    INSERT INTO Users
      (`user_id`, `join_date`, `favorite_brand`)
    VALUES
      ('1', '2018-01-01', 'Lenovo'),
      ('2', '2018-02-09', 'Samsung'),
      ('3', '2018-01-19', 'LG'),
      ('4', '2018-05-21', 'HP');
    
    CREATE TABLE Orders (
      `order_id` INTEGER,
      `order_date` DATE,
      `item_id` INTEGER,
      `buyer_id` INTEGER,
      `seller_id` INTEGER
    );
    
    INSERT INTO Orders
      (`order_id`, `order_date`, `item_id`, `buyer_id`, `seller_id`)
    VALUES
      ('1', '2019-08-01', '4', '1', '2'),
      ('2', '2018-08-02', '2', '1', '3'),
      ('3', '2019-08-03', '3', '2', '3'),
      ('4', '2018-08-04', '1', '4', '2'),
      ('5', '2018-08-04', '1', '3', '4'),
      ('6', '2019-08-05', '2', '2', '4');
    
    CREATE TABLE Items (
      `item_id` INTEGER,
      `item_brand` VARCHAR(7)
    );
    
    INSERT INTO Items
      (`item_id`, `item_brand`)
    VALUES
      ('1', 'Samsung'),
      ('2', 'Lenovo'),
      ('3', 'LG'),
      ('4', 'HP');

---

**Query #1**

    select u.user_id as buyer_id, u.join_date, coalesce(orders_in_2019, 0) as orders_in_2019 from 
    (select buyer_id, count(order_id) as orders_in_2019 from Orders
    where year(order_date) = 2019
    group by buyer_id
    order by 1) o
    right join 
    Users u on  o.buyer_id = u.user_id;

| buyer_id | join_date           | orders_in_2019 |
| -------- | ------------------- | -------------- |
| 1        | 2018-01-01 00:00:00 | 1              |
| 2        | 2018-02-09 00:00:00 | 2              |
| 3        | 2018-01-19 00:00:00 | 0              |
| 4        | 2018-05-21 00:00:00 | 0              |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/2ZmRriVzb8ePaQbGg5c8Nt/1)