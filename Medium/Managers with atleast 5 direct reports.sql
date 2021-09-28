-- Question 75
-- The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

-- +------+----------+-----------+----------+
-- |Id    |Name 	  |Department |ManagerId |
-- +------+----------+-----------+----------+
-- |101   |John 	  |A 	      |null      |
-- |102   |Dan 	  |A 	      |101       |
-- |103   |James 	  |A 	      |101       |
-- |104   |Amy 	  |A 	      |101       |
-- |105   |Anne 	  |A 	      |101       |
-- |106   |Ron 	  |B 	      |101       |
-- +------+----------+-----------+----------+
-- Given the Employee table, write a SQL query that finds out managers with at least 5 direct report. For the above table, your SQL query should return:

-- +-------+
-- | Name  |
-- +-------+
-- | John  |
-- +-------+
-- Note:
-- No one would report to himself.

-- Solution
with t1 as
(
    select managerid, count(name) as total
    from employee
    group by managerid
)

select e.name
from t1
join employee e
on t1.managerid = e.id
where t1.total>=5

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE employee (
      `Id` INTEGER,
      `Name` VARCHAR(5),
      `Department` VARCHAR(1),
      `ManagerId` VARCHAR(4)
    );
    
    INSERT INTO employee
      (`Id`, `Name`, `Department`, `ManagerId`)
    VALUES
      ('101', 'John', 'A', 'null'),
      ('102', 'Dan', 'A', '101'),
      ('103', 'James', 'A', '101'),
      ('104', 'Amy', 'A', '101'),
      ('105', 'Anne', 'A', '101'),
      ('106', 'Ron', 'B', '101');

---

**Query #1**

    select Name from employee
    where Id in (select ManagerId from employee group by ManagerId having count(Id) >= 5);

| Name |
| ---- |
| John |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/cKqv5LPgefCcXs6P8eCYDk/1)