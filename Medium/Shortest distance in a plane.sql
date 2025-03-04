-- Question 89
-- Table point_2d holds the coordinates (x,y) of some unique points (more than two) in a plane.
 

-- Write a query to find the shortest distance between these points rounded to 2 decimals.
 

-- | x  | y  |
-- |----|----|
-- | -1 | -1 |
-- | 0  | 0  |
-- | -1 | -2 |
 

-- The shortest distance is 1.00 from point (-1,-1) to (-1,2). So the output should be:
 

-- | shortest |
-- |----------|
-- | 1.00     |
 

-- Note: The longest distance among all the points are less than 10000.

-- Solution
select round(a.shortest,2) as shortest
from(
select sqrt(pow((p1.x-p2.x),2)+pow((p1.y-p2.y),2)) as shortest
from point_2d p1
cross join point_2d p2
where p1.x!=p2.x or p1.y!=p2.y
order by sqrt(pow((p1.x-p2.x),2)+pow((p1.y-p2.y),2))
limit 1) a

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE points_2d (
      `x` INTEGER,
      `y` INTEGER
    );
    
    INSERT INTO points_2d
      (`x`, `y`)
    VALUES
      ('-1', '-1'),
      ('0', '0'),
      ('-1', '-2');

---

**Query #1**

    with cte as
    (select p1.x as x1, p1.y as y1, p2.x as x2, p2.y as y2, round(sqrt(pow((p1.x - p2.x), 2) + pow((p1.y - p2.y), 2)), 2) as distance from points_2d p1 cross join points_2d p2
    where p1.x!=p2.x or p1.y!=p2.y
    order by 5)
    
    select distance as shortest_distance from cte 
    limit 1;

| shortest_distance |
| ----------------- |
| 1                 |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/dQLTDKaArAS2VoGFbzu8n9/1)