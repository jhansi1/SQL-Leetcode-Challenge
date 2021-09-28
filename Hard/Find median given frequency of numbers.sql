-- Question 107
-- The Numbers table keeps the value of number and its frequency.

-- +----------+-------------+
-- |  Number  |  Frequency  |
-- +----------+-------------|
-- |  0       |  7          |
-- |  1       |  1          |
-- |  2       |  3          |
-- |  3       |  1          |
-- +----------+-------------+
-- In this table, the numbers are 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, so the median is (0 + 0) / 2 = 0.

-- +--------+
-- | median |
-- +--------|
-- | 0.0000 |
-- +--------+
-- Write a query to find the median of all numbers and name the result as median.

-- Solution
with t1 as(
select *,
sum(frequency) over(order by number) as cum_sum, (sum(frequency) over())/2 as middle
from numbers)

select avg(number) as median
from t1
where middle between (cum_sum - frequency) and cum_sum

-- Code:
**Schema (MySQL v8.0)**

    CREATE TABLE numbers (
      `Number` INTEGER,
      `Frequency` INTEGER
    );
    
    INSERT INTO numbers
      (`Number`, `Frequency`)
    VALUES
      ('0', '7'),
      ('1', '1'),
      ('2', '3'),
      ('3', '1');

---

**Query #1**

    with t1 as(
    select *,
    sum(frequency) over(order by number) as cumm_sum, round((sum(frequency) over())/2) as mid_pos
    from numbers)
    
    select avg(number) as median
    from t1
    where mid_pos between (cumm_sum - frequency) and cumm_sum;

| median |
| ------ |
| 0.0000 |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/xeMGJdTqiPwxqkqenveZXC/1)