-- Question 12
-- Given a Weather table, write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.

-- +---------+------------------+------------------+
-- | Id(INT) | RecordDate(DATE) | Temperature(INT) |
-- +---------+------------------+------------------+
-- |       1 |       2015-01-01 |               10 |
-- |       2 |       2015-01-02 |               25 |
-- |       3 |       2015-01-03 |               20 |
-- |       4 |       2015-01-04 |               30 |
-- +---------+------------------+------------------+
-- For example, return the following Ids for the above Weather table:

-- +----+
-- | Id |
-- +----+
-- |  2 |
-- |  4 |
-- +----+

-- Solution
select a.Id
from weather a, weather b
where a.Temperature>b.Temperature and  datediff(a.recorddate,b.recorddate)=1

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Weather (
      `Id` INTEGER,
      `RecordDate` DATETIME,
      `Temperature` INTEGER
    );
    
    INSERT INTO Weather
      (`Id`, `RecordDate`, `Temperature`)
    VALUES
      ('1', '2015-01-01', '10'),
      ('2', '2015-01-02', '25'),
      ('3', '2015-01-03', '20'),
      ('4', '2015-01-04', '30');

---
**Query #1**

    select a.Id
    from Weather a, Weather b 
    where a.Temperature > b.Temperature
    and DATEDIFF(a.RecordDate, b.RecordDate) = 1;
	
| Id  |
| --- |
| 2   |
| 4   | 

**Query #2**

    select a.Id, b.Id
    from Weather a, Weather b 
    where a.Temperature > b.Temperature
    and DATEDIFF(a.RecordDate, b.RecordDate) = 1;

| Id  | Id  |
| --- | --- |
| 2   | 1   |
| 4   | 3   |

---
**Query #3**

    select a.Id, b.Id
    from Weather a join Weather b on a.Id = b.Id;

| Id  | Id  |
| --- | --- |
| 1   | 1   |
| 2   | 2   |
| 3   | 3   |
| 4   | 4   |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/6Kt2uKHWuijnswvH2bu5bK/1)