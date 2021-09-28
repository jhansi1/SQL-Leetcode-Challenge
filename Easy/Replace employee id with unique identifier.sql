-- Question 48
-- Table: Employees

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | name          | varchar |
-- +---------------+---------+
-- id is the primary key for this table.
-- Each row of this table contains the id and the name of an employee in a company.
 

-- Table: EmployeeUNI

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | unique_id     | int     |
-- +---------------+---------+
-- (id, unique_id) is the primary key for this table.
-- Each row of this table contains the id and the corresponding unique id of an employee in the company.
 

-- Write an SQL query to show the unique ID of each user, If a user doesn't have a unique ID replace just show null.

-- Return the result table in any order.

-- The query result format is in the following example:

-- Employees table:
-- +----+----------+
-- | id | name     |
-- +----+----------+
-- | 1  | Alice    |
-- | 7  | Bob      |
-- | 11 | Meir     |
-- | 90 | Winston  |
-- | 3  | Jonathan |
-- +----+----------+

-- EmployeeUNI table:
-- +----+-----------+
-- | id | unique_id |
-- +----+-----------+
-- | 3  | 1         |
-- | 11 | 2         |
-- | 90 | 3         |
-- +----+-----------+

-- EmployeeUNI table:
-- +-----------+----------+
-- | unique_id | name     |
-- +-----------+----------+
-- | null      | Alice    |
-- | null      | Bob      |
-- | 2         | Meir     |
-- | 3         | Winston  |
-- | 1         | Jonathan |
-- +-----------+----------+

-- Alice and Bob don't have a unique ID, We will show null instead.
-- The unique ID of Meir is 2.
-- The unique ID of Winston is 3.
-- The unique ID of Jonathan is 1.

-- Solution
select unique_id, name
from employees e
left join
employeeuni u
on e.id = u.id
order by e.id

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Employees (
      `id` INTEGER,
      `name` VARCHAR(8)
    );
    
    INSERT INTO Employees
      (`id`, `name`)
    VALUES
      ('1', 'Alice'),
      ('7', 'Bob'),
      ('11', 'Meir'),
      ('90', 'Winston'),
      ('3', 'Jonathan');
    
    CREATE TABLE EmployeeUNI (
      `id` INTEGER,
      `unique_id` INTEGER
    );
    
    INSERT INTO EmployeeUNI
      (`id`, `unique_id`)
    VALUES
      ('3', '1'),
      ('11', '2'),
      ('90', '3');

---

**Query #1**

    select unique_id, name
    from Employees e left join EmployeeUNI u on e.id = u.id;

| unique_id | name     |
| --------- | -------- |
| 1         | Jonathan |
| 2         | Meir     |
| 3         | Winston  |
|           | Alice    |
|           | Bob      |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/iw7iUX6o6RogJ9VSR2sgJ3/1)