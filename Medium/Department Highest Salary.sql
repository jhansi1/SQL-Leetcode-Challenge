-- Question 57
-- The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.

-- +----+-------+--------+--------------+
-- | Id | Name  | Salary | DepartmentId |
-- +----+-------+--------+--------------+
-- | 1  | Joe   | 70000  | 1            |
-- | 2  | Jim   | 90000  | 1            |
-- | 3  | Henry | 80000  | 2            |
-- | 4  | Sam   | 60000  | 2            |
-- | 5  | Max   | 90000  | 1            |
-- +----+-------+--------+--------------+
-- The Department table holds all departments of the company.

-- +----+----------+
-- | Id | Name     |
-- +----+----------+
-- | 1  | IT       |
-- | 2  | Sales    |
-- +----+----------+
-- Write a SQL query to find employees who have the highest salary in each of the departments. 
-- For the above tables, your SQL query should return the following rows (order of rows does not matter).

-- +------------+----------+--------+
-- | Department | Employee | Salary |
-- +------------+----------+--------+
-- | IT         | Max      | 90000  |
-- | IT         | Jim      | 90000  |
-- | Sales      | Henry    | 80000  |
-- +------------+----------+--------+
-- Explanation:

-- Max and Jim both have the highest salary in the IT department and Henry has the highest salary in the Sales department.

-- Solution
select a.Department, a.Employee, a.Salary
from(
select d.name as Department, e.name as Employee, Salary,
rank() over(partition by d.name order by salary desc) as rk
from employee e
join department d
on e.departmentid = d.id) a
where a.rk=1

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Employee (
      `Id` INTEGER,
      `Name` VARCHAR(5),
      `Salary` INTEGER,
      `DepartmentId` INTEGER
    );
    
    INSERT INTO Employee
      (`Id`, `Name`, `Salary`, `DepartmentId`)
    VALUES
      ('1', 'Joe', '70000', '1'),
      ('2', 'Jim', '90000', '1'),
      ('3', 'Henry', '80000', '2'),
      ('4', 'Sam', '60000', '2'),
      ('5', 'Max', '90000', '1');
    
    CREATE TABLE Department (
      `Id` INTEGER,
      `Name` VARCHAR(5)
    );
    
    INSERT INTO Department
      (`Id`, `Name`)
    VALUES
      ('1', 'IT'),
      ('2', 'Sales');

---

**Query #1**

    select d.Name as Department, e.Name as Employee, Salary
    from 
    (select DepartmentId, Name, Salary, rank() over(partition by DepartmentId order by Salary DESC) as r from Employee ) e
    left join Department d on e.DepartmentId = d.Id
    where r = 1;

| Department | Employee | Salary |
| ---------- | -------- | ------ |
| IT         | Jim      | 90000  |
| IT         | Max      | 90000  |
| Sales      | Henry    | 80000  |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/3UCtjSw1zUH2PSXuK7YTiA/1)