-- Question 84
-- Table: Friendship

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user1_id      | int     |
-- | user2_id      | int     |
-- +---------------+---------+
-- (user1_id, user2_id) is the primary key for this table.
-- Each row of this table indicates that there is a friendship relation between user1_id and user2_id.
 

-- Table: Likes

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | user_id     | int     |
-- | page_id     | int     |
-- +-------------+---------+
-- (user_id, page_id) is the primary key for this table.
-- Each row of this table indicates that user_id likes page_id.
 

-- Write an SQL query to recommend pages to the user with user_id = 1 using the pages that your friends liked. It should not recommend pages you already liked.

-- Return result table in any order without duplicates.

-- The query result format is in the following example:

-- Friendship table:
-- +----------+----------+
-- | user1_id | user2_id |
-- +----------+----------+
-- | 1        | 2        |
-- | 1        | 3        |
-- | 1        | 4        |
-- | 2        | 3        |
-- | 2        | 4        |
-- | 2        | 5        |
-- | 6        | 1        |
-- +----------+----------+
 
-- Likes table:
-- +---------+---------+
-- | user_id | page_id |
-- +---------+---------+
-- | 1       | 88      |
-- | 2       | 23      |
-- | 3       | 24      |
-- | 4       | 56      |
-- | 5       | 11      |
-- | 6       | 33      |
-- | 2       | 77      |
-- | 3       | 77      |
-- | 6       | 88      |
-- +---------+---------+

-- Result table:
-- +------------------+
-- | recommended_page |
-- +------------------+
-- | 23               |
-- | 24               |
-- | 56               |
-- | 33               |
-- | 77               |
-- +------------------+
-- User one is friend with users 2, 3, 4 and 6.
-- Suggested pages are 23 from user 2, 24 from user 3, 56 from user 3 and 33 from user 6.
-- Page 77 is suggested from both user 2 and user 3.
-- Page 88 is not suggested because user 1 already likes it.

-- Solution
select distinct page_id as recommended_page
from likes
where user_id = 
any(select user2_id as id
from friendship
where user1_id = 1 or user2_id = 1 and user2_id !=1
union all
select user1_id
from friendship
where user2_id = 1) 
and page_id != all(select page_id from likes where user_id = 1)


-- My Solution
**Schema (MySQL v8.0)**

    CREATE TABLE Friendship (
      `user1_id` INTEGER,
      `user2_id` INTEGER
    );
    
    INSERT INTO Friendship
      (`user1_id`, `user2_id`)
    VALUES
      ('1', '2'),
      ('1', '3'),
      ('1', '4'),
      ('2', '3'),
      ('2', '4'),
      ('2', '5'),
      ('6', '1');
    
    CREATE TABLE Likes (
      `user_id` INTEGER,
      `page_id` INTEGER
    );
    
    INSERT INTO Likes
      (`user_id`, `page_id`)
    VALUES
      ('1', '88'),
      ('2', '23'),
      ('3', '24'),
      ('4', '56'),
      ('5', '11'),
      ('6', '33'),
      ('2', '77'),
      ('3', '77'),
      ('6', '88');

---

**Query #1**

    with cte as 
    (select user1_id, user2_id
    from Friendship
    where user1_id = 1
    union
    select user2_id, user1_id
    from Friendship
    where user2_id = 1)
    
    select distinct page_id from Likes 
    where user_id in (select user2_id from cte)
    and page_id != all(select distinct page_id from Likes
    where user_id = 1);

| page_id |
| ------- |
| 23      |
| 24      |
| 56      |
| 33      |
| 77      |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/gK1qkqYas19EUY54vvWSY6/2)