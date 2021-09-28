-- Question 52
-- Write a SQL query to find all numbers that appear at least three times consecutively.

-- +----+-----+
-- | Id | Num |
-- +----+-----+
-- | 1  |  1  |
-- | 2  |  1  |
-- | 3  |  1  |
-- | 4  |  2  |
-- | 5  |  1  |
-- | 6  |  2  |
-- | 7  |  2  |
-- +----+-----+
-- For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.

-- +-----------------+
-- | ConsecutiveNums |
-- +-----------------+
-- | 1               |
-- +-----------------+

-- Solution
select distinct a.num as ConsecutiveNums
from(
select *,
lag(num) over() as prev,
lead(num) over() as next
from logs) a
where a.num = a.prev and a.num=a.next

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE logs (
      `Id` INTEGER,
      `Num` INTEGER
    );
    
    INSERT INTO logs
      (`Id`, `Num`)
    VALUES
      ('1', '1'),
      ('2', '1'),
      ('3', '1'),
      ('4', '2'),
      ('5', '1'),
      ('6', '2'),
      ('7', '2');

---

**Query #1**

    select s.num as ConsecutiveNums from 
    (select num, 
    lead(num) over() as next, 
    lag(num) over() as prev
    from logs) s
    where s.num = s.next and s.num = s.prev;

| ConsecutiveNums |
| --------------- |
| 1               |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/4kVo9wJuf6vQEZKsAjKcfd/1)