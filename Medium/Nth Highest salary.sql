-- Question 50
-- Write a SQL query to get the nth highest salary from the Employee table.

-- +----+--------+
-- | Id | Salary |
-- +----+--------+
-- | 1  | 100    |
-- | 2  | 200    |
-- | 3  | 300    |
-- +----+--------+
-- For example, given the above Employee table, the nth highest salary where n = 2 is 200. If there is no nth highest salary, then the query should return null.

-- +------------------------+
-- | getNthHighestSalary(2) |
-- +------------------------+
-- | 200                    |
-- +------------------------+

-- Solution 
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      # Write your MySQL query statement below.
      select distinct a.salary
      from
      (select salary, 
      dense_rank() over(order by salary desc) as rk
      from Employee) a
      where a.rk = N
  );
END

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE employee (
      `Id` INTEGER,
      `Salary` INTEGER
    );
    
    INSERT INTO employee
      (`Id`, `Salary`)
    VALUES
      ('1', '100'),
      ('2', '200'),
      ('3', '300');
      
    delimiter //
    create function getNthHighestSalary(n int) returns int DETERMINISTIC
    begin
      return (
          select distinct Salary from (
          select Salary, dense_rank() over(order by Salary desc) as r
          from employee ) d
          where r = n 
        );
    end //
    delimiter ;

---

**Query #1**

    select getNthHighestSalary(1) from dual;

| getNthHighestSalary(1) |
| ---------------------- |
| 300                    |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/wEXdfA4WydqAoZjfZf5BzG/2)