-- Question 15
-- The Employee table holds all employees including their managers. 
-- Every employee has an Id, and there is also a column for the manager Id.

-- +----+-------+--------+-----------+
-- | Id | Name  | Salary | ManagerId |
-- +----+-------+--------+-----------+
-- | 1  | Joe   | 70000  | 3         |
-- | 2  | Henry | 80000  | 4         |
-- | 3  | Sam   | 60000  | NULL      |
-- | 4  | Max   | 90000  | NULL      |
-- +----+-------+--------+-----------+
-- Given the Employee table, write a SQL query that finds out employees who earn more than their managers. 
-- For the above table, Joe is the only employee who earns more than his manager.

-- +----------+
-- | Employee |
-- +----------+
-- | Joe      |
-- +----------+

-- Solution
select a.Name as Employee
from employee a, employee b
where a.salary>b.salary and a.managerid=b.id

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE employees (
      `Id` INTEGER,
      `Name` VARCHAR(5),
      `Salary` INTEGER,
      `ManagerId` VARCHAR(4)
    );
    
    INSERT INTO employees
      (`Id`, `Name`, `Salary`, `ManagerId`)
    VALUES
      ('1', 'Joe', '70000', '3'),
      ('2', 'Henry', '80000', '4'),
      ('3', 'Sam', '60000', 'NULL'),
      ('4', 'Max', '90000', 'NULL');

---

**Query #1**

    select Name 
    from employees e1
    where Salary > (select Salary from employees e2 where e1.ManagerId = e2.Id);

| Name |
| ---- |
| Joe  |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/8swYNsfsNwmy7ivEPjr4o9/1)