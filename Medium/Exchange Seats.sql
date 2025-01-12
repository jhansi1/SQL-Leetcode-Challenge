-- Question 56
-- Mary is a teacher in a middle school and she has a table seat storing students' names and their corresponding seat ids.

-- The column id is continuous increment.
 

-- Mary wants to change seats for the adjacent students.
 

-- Can you write a SQL query to output the result for Mary?
 

-- +---------+---------+
-- |    id   | student |
-- +---------+---------+
-- |    1    | Abbot   |
-- |    2    | Doris   |
-- |    3    | Emerson |
-- |    4    | Green   |
-- |    5    | Jeames  |
-- +---------+---------+
-- For the sample input, the output is:
 

-- +---------+---------+
-- |    id   | student |
-- +---------+---------+
-- |    1    | Doris   |
-- |    2    | Abbot   |
-- |    3    | Green   |
-- |    4    | Emerson |
-- |    5    | Jeames  |
-- +---------+---------+

-- Solution
select row_number() over (order by (if(id%2=1,id+1,id-1))) as id, student
from seat

----
**Schema (MySQL v8.0)**

    CREATE TABLE seat (
      `id` INTEGER,
      `student` VARCHAR(7)
    );
    
    INSERT INTO seat
      (`id`, `student`)
    VALUES
      ('1', 'Abbot'),
      ('2', 'Doris'),
      ('3', 'Emerson'),
      ('4', 'Green'),
      ('5', 'Jeames');

---

**Query #1**

    select row_number() over (order by (if(id%2=1,id+1,id-1))) as id, student
    from seat;

| id  | student |
| --- | ------- |
| 1   | Doris   |
| 2   | Abbot   |
| 3   | Green   |
| 4   | Emerson |
| 5   | Jeames  |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/dyFqqgm6vJKowW9UvnkyXs/1)