-- Question 78
-- Table Variables:

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | name          | varchar |
-- | value         | int     |
-- +---------------+---------+
-- name is the primary key for this table.
-- This table contains the stored variables and their values.
 

-- Table Expressions:

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | left_operand  | varchar |
-- | operator      | enum    |
-- | right_operand | varchar |
-- +---------------+---------+
-- (left_operand, operator, right_operand) is the primary key for this table.
-- This table contains a boolean expression that should be evaluated.
-- operator is an enum that takes one of the values ('<', '>', '=')
-- The values of left_operand and right_operand are guaranteed to be in the Variables table.
 

-- Write an SQL query to evaluate the boolean expressions in Expressions table.

-- Return the result table in any order.

-- The query result format is in the following example.

-- Variables table:
-- +------+-------+
-- | name | value |
-- +------+-------+
-- | x    | 66    |
-- | y    | 77    |
-- +------+-------+

-- Expressions table:
-- +--------------+----------+---------------+
-- | left_operand | operator | right_operand |
-- +--------------+----------+---------------+
-- | x            | >        | y             |
-- | x            | <        | y             |
-- | x            | =        | y             |
-- | y            | >        | x             |
-- | y            | <        | x             |
-- | x            | =        | x             |
-- +--------------+----------+---------------+

-- Result table:
-- +--------------+----------+---------------+-------+
-- | left_operand | operator | right_operand | value |
-- +--------------+----------+---------------+-------+
-- | x            | >        | y             | false |
-- | x            | <        | y             | true  |
-- | x            | =        | y             | false |
-- | y            | >        | x             | true  |
-- | y            | <        | x             | false |
-- | x            | =        | x             | true  |
-- +--------------+----------+---------------+-------+
-- As shown, you need find the value of each boolean exprssion in the table using the variables table.

-- Solution
with t1 as(
select e.left_operand, e.operator, e.right_operand, v.value as left_val, v_1.value as right_val
from expressions e
join variables v
on v.name = e.left_operand 
join variables v_1
on v_1.name = e.right_operand)

select t1.left_operand, t1.operator, t1.right_operand,
case when t1.operator = '<' then (select t1.left_val< t1.right_val)
when t1.operator = '>' then (select t1.left_val > t1.right_val)
when t1.operator = '=' then (select t1.left_val = t1.right_val)
else FALSE
END AS VALUE
from t1

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Variables (
      `name` VARCHAR(1),
      `value` INTEGER
    );
    
    INSERT INTO Variables
      (`name`, `value`)
    VALUES
      ('x', '66'),
      ('y', '77');
    
    
    
    CREATE TABLE Expressions (
      `left_operand` VARCHAR(1),
      `operator` VARCHAR(1),
      `right_operand` VARCHAR(1)
    );
    
    INSERT INTO Expressions
      (`left_operand`, `operator`, `right_operand`)
    VALUES
      ('x', '>', 'y'),
      ('x', '<', 'y'),
      ('x', '=', 'y'),
      ('y', '>', 'x'),
      ('y', '<', 'x'),
      ('x', '=', 'x');

---

**Query #1**

    with cte as 
    (select v1.value as left_op_value, e.operator, v2.value as right_op_value 
    from (Expressions e
    left join Variables v1 on v1.name = e.left_operand) 
    left join Variables v2 on v2.name = e.right_operand )
    
    select *, (case when operator = '=' then if(left_op_value = right_op_value, 'true', 'false')
               when operator = '>' then if(left_op_value > right_op_value, 'true', 'false')
               when operator = '<' then if(left_op_value < right_op_value, 'true', 'false')
               else 0 end ) as value  from cte;

| left_op_value | operator | right_op_value | value |
| ------------- | -------- | -------------- | ----- |
| 66            | =        | 66             | true  |
| 77            | >        | 66             | true  |
| 77            | <        | 66             | false |
| 66            | >        | 77             | false |
| 66            | <        | 77             | true  |
| 66            | =        | 77             | false |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/a9uUVPdTwbEH5NFDhJkft9/2)