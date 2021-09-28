-- Question 4
-- Select all employee's name and bonus whose bonus is < 1000.

-- Table:Employee

-- +-------+--------+-----------+--------+
-- | empId |  name  | supervisor| salary |
-- +-------+--------+-----------+--------+
-- |   1   | John   |  3        | 1000   |
-- |   2   | Dan    |  3        | 2000   |
-- |   3   | Brad   |  null     | 4000   |
-- |   4   | Thomas |  3        | 4000   |
-- +-------+--------+-----------+--------+
-- empId is the primary key column for this table.
-- Table: Bonus

-- +-------+-------+
-- | empId | bonus |
-- +-------+-------+
-- | 2     | 500   |
-- | 4     | 2000  |
-- +-------+-------+
-- empId is the primary key column for this table.
-- Example ouput:

-- +-------+-------+
-- | name  | bonus |
-- +-------+-------+
-- | John  | null  |
-- | Dan   | 500   |
-- | Brad  | null  |
-- +-------+-------+


-- Solution
Select E.name, B.bonus
From Employee E left join Bonus B
on E.empId = B.empId
where B.bonus< 1000 or B.Bonus IS NULL

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Employee (
      `empId` INTEGER,
      `name` VARCHAR(6),
      `supervisor` VARCHAR(4),
      `salary` INTEGER
    );
    
    INSERT INTO Employee
      (`empId`, `name`, `supervisor`, `salary`)
    VALUES
      ('1', 'John', '3', '1000'),
      ('2', 'Dan', '3', '2000'),
      ('3', 'Brad', 'null', '4000'),
      ('4', 'Thomas', '3', '4000');
    
    CREATE TABLE Bonus (
      `empId` INTEGER,
      `bonus` INTEGER
    );
    
    INSERT INTO Bonus
      (`empId`, `bonus`)
    VALUES
      ('2', '500'),
      ('4', '2000');

---

**Query #1**

    select e.name, b.bonus
    from Employee e left join Bonus b on e.empId = b.empId
    where b.bonus < 1000 or b.bonus is null
    order by e.empId;

| name | bonus |
| ---- | ----- |
| John |       |
| Dan  | 500   |
| Brad |       |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/jyaCcoCrtxE4Pp8EX1fkVf/2)