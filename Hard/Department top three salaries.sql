-- Question 14
-- The Employee table holds all employees. Every employee has an Id, and there is also a column for the department Id.

-- +----+-------+--------+--------------+
-- | Id | Name  | Salary | DepartmentId |
-- +----+-------+--------+--------------+
-- | 1  | Joe   | 85000  | 1            |
-- | 2  | Henry | 80000  | 2            |
-- | 3  | Sam   | 60000  | 2            |
-- | 4  | Max   | 90000  | 1            |
-- | 5  | Janet | 69000  | 1            |
-- | 6  | Randy | 85000  | 1            |
-- | 7  | Will  | 70000  | 1            |
-- +----+-------+--------+--------------+
-- The Department table holds all departments of the company.

-- +----+----------+
-- | Id | Name     |
-- +----+----------+
-- | 1  | IT       |
-- | 2  | Sales    |
-- +----+----------+
-- Write a SQL query to find employees who earn the top three salaries in each of the department. For the above tables, your SQL query should return the following rows (order of rows does not matter).

-- +------------+----------+--------+
-- | Department | Employee | Salary |
-- +------------+----------+--------+
-- | IT         | Max      | 90000  |
-- | IT         | Randy    | 85000  |
-- | IT         | Joe      | 85000  |
-- | IT         | Will     | 70000  |
-- | Sales      | Henry    | 80000  |
-- | Sales      | Sam      | 60000  |
-- +------------+----------+--------+
-- Explanation:

-- In IT department, Max earns the highest salary, both Randy and Joe earn the second highest salary, 
-- and Will earns the third highest salary. 
-- There are only two employees in the Sales department, 
-- Henry earns the highest salary while Sam earns the second highest salary.

-- Solution
select a.department, a.employee, a.salary
from (
select d.name as department, e.name as employee, salary, 
    dense_rank() over(Partition by d.name order by salary desc) as rk
from Employee e join Department d
on e.departmentid = d.id) a
where a.rk<4

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE employee (
      `Id` INTEGER,
      `Name` VARCHAR(5),
      `Salary` INTEGER,
      `DepartmentId` INTEGER
    );
    
    INSERT INTO employee
      (`Id`, `Name`, `Salary`, `DepartmentId`)
    VALUES
      ('1', 'Joe', '85000', '1'),
      ('2', 'Henry', '80000', '2'),
      ('3', 'Sam', '60000', '2'),
      ('4', 'Max', '90000', '1'),
      ('5', 'Janet', '69000', '1'),
      ('6', 'Randy', '85000', '1'),
      ('7', 'Will', '70000', '1');
    
    CREATE TABLE department (
      `Id` INTEGER,
      `Name` VARCHAR(5)
    );
    
    INSERT INTO department
      (`Id`, `Name`)
    VALUES
      ('1', 'IT'),
      ('2', 'Sales');

---

**Query #1**

    select Department, Employee, Salary from
    (select e.Name as Employee, d.Name as Department, Salary, dense_rank() over(partition by e.DepartmentId order by Salary desc) as rank_num from employee e left join department d on e.DepartmentId = d.Id) d
    where rank_num <= 3;

| Department | Employee | Salary |
| ---------- | -------- | ------ |
| IT         | Max      | 90000  |
| IT         | Joe      | 85000  |
| IT         | Randy    | 85000  |
| IT         | Will     | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/DuEjaF8VcXHrcu8uBo9pU/1)