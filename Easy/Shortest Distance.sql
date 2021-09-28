-- Question 25
-- Table point holds the x coordinate of some points on x-axis in a plane, which are all integers.
 

-- Write a query to find the shortest distance between two points in these points.
 

-- | x   |
-- |-----|
-- | -1  |
-- | 0   |
-- | 2   |
 

-- The shortest distance is '1' obviously, which is from point '-1' to '0'. So the output is as below:
 

-- | shortest|
-- |---------|
-- | 1       |
 

-- Note: Every point is unique, which means there is no duplicates in table point

-- Solution
select min(abs(abs(a.x)-abs(a.next_closest))) as shortest
from(
select *,
lead(x) over(order by x) as next_closest
from point) a 

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Point (
      `x` INTEGER
    );
    
    INSERT INTO Point
      (`x`)
    VALUES
      (-1),
      (0),
      (2);

---

**Query #1**

    select min(abs(abs(x) - abs(next_point))) as shortest_distance from (
    select x, lead(x) over() as next_point from Point) s;

| shortest_distance |
| ----------------- |
| 1                 |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/vPcqpc4keukMTjAjekyjhG/1)