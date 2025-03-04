-- Question 51
-- Write a SQL query to rank scores.
-- If there is a tie between two scores, both should have the same ranking. 
-- Note that after a tie, the next ranking number should be the next consecutive integer value. 
-- In other words, there should be no "holes" between ranks.

-- +----+-------+
-- | Id | Score |
-- +----+-------+
-- | 1  | 3.50  |
-- | 2  | 3.65  |
-- | 3  | 4.00  |
-- | 4  | 3.85  |
-- | 5  | 4.00  |
-- | 6  | 3.65  |
-- +----+-------+
-- For example, given the above Scores table, your query should generate the following report (order by highest score):

-- +-------+---------+
-- | score | Rank    |
-- +-------+---------+
-- | 4.00  | 1       |
-- | 4.00  | 1       |
-- | 3.85  | 2       |
-- | 3.65  | 3       |
-- | 3.65  | 3       |
-- | 3.50  | 4       |
-- +-------+---------+
-- Important Note: For MySQL solutions, to escape reserved words used as column names, 
-- you can use an apostrophe before and after the keyword. For example `Rank`.

-- Solution
select Score,
dense_rank() over(order by score desc) as "Rank"
from scores

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE scores (
      `Id` INTEGER,
      `Score` FLOAT
    );
    
    INSERT INTO scores
      (`Id`, `Score`)
    VALUES
      ('1', '3.50'),
      ('2', '3.65'),
      ('3', '4.00'),
      ('4', '3.85'),
      ('5', '4.00'),
      ('6', '3.65');

---

**Query #1**

    select Score, dense_rank() over(order by Score desc) as 'Rank' from scores;

| Score | Rank |
| ----- | ---- |
| 4     | 1    |
| 4     | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.5   | 4    |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/nXUPFgJ2tREitd2K7udbz4/1)