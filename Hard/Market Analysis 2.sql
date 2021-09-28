-- Question 103
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
 

-- Write an SQL query to find for each user, whether the brand of the second item (by date) they sold is their favorite brand. If a user sold less than two items, report the answer for that user as no.

-- It is guaranteed that no seller sold more than one item on a day.

-- The query result format is in the following example:

-- Users table:
-- +---------+------------+----------------+
-- | user_id | join_date  | favorite_brand |
-- +---------+------------+----------------+
-- | 1       | 2019-01-01 | Lenovo         |
-- | 2       | 2019-02-09 | Samsung        |
-- | 3       | 2019-01-19 | LG             |
-- | 4       | 2019-05-21 | HP             |
-- +---------+------------+----------------+

-- Orders table:
-- +----------+------------+---------+----------+-----------+
-- | order_id | order_date | item_id | buyer_id | seller_id |
-- +----------+------------+---------+----------+-----------+
-- | 1        | 2019-08-01 | 4       | 1        | 2         |
-- | 2        | 2019-08-02 | 2       | 1        | 3         |
-- | 3        | 2019-08-03 | 3       | 2        | 3         |
-- | 4        | 2019-08-04 | 1       | 4        | 2         |
-- | 5        | 2019-08-04 | 1       | 3        | 4         |
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
-- +-----------+--------------------+
-- | seller_id | 2nd_item_fav_brand |
-- +-----------+--------------------+
-- | 1         | no                 |
-- | 2         | yes                |
-- | 3         | yes                |
-- | 4         | no                 |
-- +-----------+--------------------+

-- The answer for the user with id 1 is no because they sold nothing.
-- The answer for the users with id 2 and 3 is yes because the brands of their second sold items are their favorite brands.
-- The answer for the user with id 4 is no because the brand of their second sold item is not their favorite brand.

-- Solution
with t1 as(
select user_id, 
case when favorite_brand = item_brand then "yes"
else "no"
end as 2nd_item_fav_brand
from users u left join
(select o.item_id, seller_id, item_brand, rank() over(partition by seller_id order by order_date) as rk
from orders o join items i
using (item_id)) a
on u.user_id = a.seller_id
where a.rk = 2)

select u.user_id as seller_id, coalesce(2nd_item_fav_brand,"no") as 2nd_item_fav_brand
from users u left join t1
using(user_id)

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Users (
      `user_id` INTEGER,
      `join_date` DATE,
      `favorite_brand` VARCHAR(7)
    );
    
    INSERT INTO Users
      (`user_id`, `join_date`, `favorite_brand`)
    VALUES
      ('1', '2019-01-01', 'Lenovo'),
      ('2', '2019-02-09', 'Samsung'),
      ('3', '2019-01-19', 'LG'),
      ('4', '2019-05-21', 'HP');
    
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
      ('2', '2019-08-02', '2', '1', '3'),
      ('3', '2019-08-03', '3', '2', '3'),
      ('4', '2019-08-04', '1', '4', '2'),
      ('5', '2019-08-04', '1', '3', '4'),
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

    with cte as 
    (select * from 
      (select item_id, seller_id, row_number() over(partition by seller_id order by order_date) as rn
    from Orders) d
     where rn = 2
    )
    
    select u.user_id as seller_id, (case when item_brand = favorite_brand then "yes" else "no" end ) as 2nd_item_fav_brand from cte c left join Items i on c.item_id = i.item_id
    right join Users u on c.seller_id = u.user_id;

| seller_id | 2nd_item_fav_brand |
| --------- | ------------------ |
| 1         | no                 |
| 2         | yes                |
| 3         | yes                |
| 4         | no                 |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/hoHRuBWjwAeow8PM2ArLcD/2)