-- Question 26
-- Table: Project

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | project_id  | int     |
-- | employee_id | int     |
-- +-------------+---------+
-- (project_id, employee_id) is the primary key of this table.
-- employee_id is a foreign key to Employee table.
-- Table: Employee

-- +------------------+---------+
-- | Column Name      | Type    |
-- +------------------+---------+
-- | employee_id      | int     |
-- | name             | varchar |
-- | experience_years | int     |
-- +------------------+---------+
-- employee_id is the primary key of this table.
 

-- Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.

-- The query result format is in the following example:

-- Project table:
-- +-------------+-------------+
-- | project_id  | employee_id |
-- +-------------+-------------+
-- | 1           | 1           |
-- | 1           | 2           |
-- | 1           | 3           |
-- | 2           | 1           |
-- | 2           | 4           |
-- +-------------+-------------+

-- Employee table:
-- +-------------+--------+------------------+
-- | employee_id | name   | experience_years |
-- +-------------+--------+------------------+
-- | 1           | Khaled | 3                |
-- | 2           | Ali    | 2                |
-- | 3           | John   | 1                |
-- | 4           | Doe    | 2                |
-- +-------------+--------+------------------+

-- Result table:
-- +-------------+---------------+
-- | project_id  | average_years |
-- +-------------+---------------+
-- | 1           | 2.00          |
-- | 2           | 2.50          |
-- +-------------+---------------+
-- The average experience years for the first project is (3 + 2 + 1) / 3 = 2.00 and for the second project is (3 + 2) / 2 = 2.50

-- Solution
Select a.project_id, round(sum(b.experience_years)/count(b.employee_id),2) as average_years
from project as a
join
employee as b
on a.employee_id=b.employee_id
group by a.project_id

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Project (
      `project_id` INTEGER,
      `employee_id` INTEGER
    );
    
    INSERT INTO Project
      (`project_id`, `employee_id`)
    VALUES
      ('1', '1'),
      ('1', '2'),
      ('1', '3'),
      ('2', '1'),
      ('2', '4');
    
    CREATE TABLE Employee (
      `employee_id` INTEGER,
      `name` VARCHAR(6),
      `experience_years` INTEGER
    );
    
    INSERT INTO Employee
      (`employee_id`, `name`, `experience_years`)
    VALUES
      ('1', 'Khaled', '3'),
      ('2', 'Ali', '2'),
      ('3', 'John', '1'),
      ('4', 'Doe', '2');

---

**Query #1**

    select p.project_id, round(avg(e.experience_years), 2) as average_years
    from Project p left join Employee e on p.employee_id = e.employee_id
    group by p.project_id;

| project_id | average_years |
| ---------- | ------------- |
| 1          | 2.00          |
| 2          | 2.50          |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/eqarsWMnqAMVa2ofEFNLfe/2)