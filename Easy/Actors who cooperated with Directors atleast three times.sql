-- Question 21
-- Table: ActorDirector

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | actor_id    | int     |
-- | director_id | int     |
-- | timestamp   | int     |
-- +-------------+---------+
-- timestamp is the primary key column for this table.
 

-- Write a SQL query for a report that provides the pairs (actor_id, director_id) where the actor have cooperated with the director at least 3 times.

-- Example:

-- ActorDirector table:
-- +-------------+-------------+-------------+
-- | actor_id    | director_id | timestamp   |
-- +-------------+-------------+-------------+
-- | 1           | 1           | 0           |
-- | 1           | 1           | 1           |
-- | 1           | 1           | 2           |
-- | 1           | 2           | 3           |
-- | 1           | 2           | 4           |
-- | 2           | 1           | 5           |
-- | 2           | 1           | 6           |
-- +-------------+-------------+-------------+

-- Result table:
-- +-------------+-------------+
-- | actor_id    | director_id |
-- +-------------+-------------+
-- | 1           | 1           |
-- +-------------+-------------+
-- The only pair is (1, 1) where they cooperated exactly 3 times.


-- Solution 
Select actor_id, director_id
from actordirector
group by actor_id, director_id
having count(*)>=3




--My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE ActorDirector (
      `actor_id` INTEGER,
      `director_id` INTEGER,
      `timestamp` INTEGER
    );
    
    INSERT INTO ActorDirector
      (`actor_id`, `director_id`, `timestamp`)
    VALUES
      ('1', '1', '0'),
      ('1', '1', '1'),
      ('1', '1', '2'),
      ('1', '2', '3'),
      ('1', '2', '4'),
      ('2', '1', '5'),
      ('2', '1', '6');

---

**Query #1**

    SELECT actor_id, director_id, count(1) FROM ActorDirector
    group by actor_id, director_id
    having count(1) >= 3;

| actor_id | director_id | count(1) |
| -------- | ----------- | -------- |
| 1        | 1           | 3        |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/oMDnFch8BXL45r3dUVF17V/17)