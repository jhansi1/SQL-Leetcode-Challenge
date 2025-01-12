-- Question 77
-- Table: Friends

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | name          | varchar |
-- | activity      | varchar |
-- +---------------+---------+
-- id is the id of the friend and primary key for this table.
-- name is the name of the friend.
-- activity is the name of the activity which the friend takes part in.
-- Table: Activities

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | name          | varchar |
-- +---------------+---------+
-- id is the primary key for this table.
-- name is the name of the activity.
 

-- Write an SQL query to find the names of all the activities with neither maximum, nor minimum number of participants.

-- Return the result table in any order. Each activity in table Activities is performed by any person in the table Friends.

-- The query result format is in the following example:

-- Friends table:
-- +------+--------------+---------------+
-- | id   | name         | activity      |
-- +------+--------------+---------------+
-- | 1    | Jonathan D.  | Eating        |
-- | 2    | Jade W.      | Singing       |
-- | 3    | Victor J.    | Singing       |
-- | 4    | Elvis Q.     | Eating        |
-- | 5    | Daniel A.    | Eating        |
-- | 6    | Bob B.       | Horse Riding  |
-- +------+--------------+---------------+

-- Activities table:
-- +------+--------------+
-- | id   | name         |
-- +------+--------------+
-- | 1    | Eating       |
-- | 2    | Singing      |
-- | 3    | Horse Riding |
-- +------+--------------+

-- Result table:
-- +--------------+
-- | activity     |
-- +--------------+
-- | Singing      |
-- +--------------+

-- Eating activity is performed by 3 friends, maximum number of participants, (Jonathan D. , Elvis Q. and Daniel A.)
-- Horse Riding activity is performed by 1 friend, minimum number of participants, (Bob B.)
-- Singing is performed by 2 friends (Victor J. and Jade W.)

-- Solution
with t1 as(
select max(a.total) as total
from(
    select activity, count(*) as total
    from friends
    group by activity) a
	union all
	select min(b.total) as low
    from(
    select activity, count(*) as total
    from friends
    group by activity) b), 
t2 as
(
    select activity, count(*) as total
    from friends
    group by activity
)

select activity
from t1 right join t2
on t1.total = t2.total
where t1.total is null
	
	
-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Friends (
      `id` INTEGER,
      `name` VARCHAR(11),
      `activity` VARCHAR(12)
    );
    
    INSERT INTO Friends
      (`id`, `name`, `activity`)
    VALUES
      ('1', 'Jonathan D.', 'Eating'),
      ('2', 'Jade W.', 'Singing'),
      ('3', 'Victor J.', 'Singing'),
      ('4', 'Elvis Q.', 'Eating'),
      ('5', 'Daniel A.', 'Eating'),
      ('6', 'Bob B.', 'Horse Riding');
    
    CREATE TABLE Activities (
      `id` INTEGER,
      `name` VARCHAR(12)
    );
    
    INSERT INTO Activities
      (`id`, `name`)
    VALUES
      ('1', 'Eating'),
      ('2', 'Singing'),
      ('3', 'Horse Riding');

---

**Query #1**

    with cte as ( select f.activity, cnt 
    from Friends f left join
    (select activity, count(1) as cnt  from Friends
    group by activity) s
    on f.activity = s.activity )
    
    select distinct activity from cte
    where cnt != (select min(cnt) from cte)
    and cnt != (select max(cnt) from cte);

| activity |
| -------- |
| Singing  |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/6aH4JYJuAYagoD9VghhH84/1)