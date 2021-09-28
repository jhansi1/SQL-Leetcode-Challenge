-- Question 32
-- Write a SQL query to delete all duplicate email entries in a table named Person, keeping only unique emails based on its smallest Id.

-- +----+------------------+
-- | Id | Email            |
-- +----+------------------+
-- | 1  | john@example.com |
-- | 2  | bob@example.com  |
-- | 3  | john@example.com |
-- +----+------------------+
-- Id is the primary key column for this table.
-- For example, after running your query, the above Person table should have the following rows:

-- +----+------------------+
-- | Id | Email            |
-- +----+------------------+
-- | 1  | john@example.com |
-- | 2  | bob@example.com  |
-- +----+------------------+

-- Solution
With t1 as
(
 Select *,
    row_number() over(partition by email order by id) as rk
    from person
)
Delete from person
where id in (Select t1.id from t1 where t1.rk>1)


-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Person (
      `Id` INTEGER,
      `Email` VARCHAR(16)
    );
    
    INSERT INTO Person
      (`Id`, `Email`)
    VALUES
      ('1', 'john@example.com'),
      ('2', 'bob@example.com'),
      ('3', 'john@example.com');

---

**Query #1**

    With cte as (
    select Id, Email, row_number() over(partition by Email) as r
    from Person )
    
    Delete from Person where Id in (
    select Id
    from cte where r > 1 );

There are no results to be displayed.

---
**Query #2**

    select * from Person;

| Id  | Email            |
| --- | ---------------- |
| 1   | john@example.com |
| 2   | bob@example.com  |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/45RKGF7TQmRoqAcG6sXELS/1)