-- Question 99
-- X city built a new stadium, each day many people visit it and the stats are saved as these columns: id, visit_date, people

-- Please write a query to display the records which have 3 or more consecutive rows and the amount of people more than 100(inclusive).

-- For example, the table stadium:
-- +------+------------+-----------+
-- | id   | visit_date | people    |
-- +------+------------+-----------+
-- | 1    | 2017-01-01 | 10        |
-- | 2    | 2017-01-02 | 109       |
-- | 3    | 2017-01-03 | 150       |
-- | 4    | 2017-01-04 | 99        |
-- | 5    | 2017-01-05 | 145       |
-- | 6    | 2017-01-06 | 1455      |
-- | 7    | 2017-01-07 | 199       |
-- | 8    | 2017-01-08 | 188       |
-- +------+------------+-----------+
-- For the sample data above, the output is:

-- +------+------------+-----------+
-- | id   | visit_date | people    |
-- +------+------------+-----------+
-- | 5    | 2017-01-05 | 145       |
-- | 6    | 2017-01-06 | 1455      |
-- | 7    | 2017-01-07 | 199       |
-- | 8    | 2017-01-08 | 188       |
-- +------+------------+-----------+
-- Note:
-- Each day only have one row record, and the dates are increasing with id increasing.

-- Solution
WITH t1 AS (
            SELECT id, 
                   visit_date,
                   people,
                   id - ROW_NUMBER() OVER(ORDER BY visit_date) AS dates
              FROM stadium
            WHERE people >= 100) 
            
SELECT t1.id, 
       t1.visit_date,
       t1people
FROM t1
LEFT JOIN (
            SELECT dates, 
                   COUNT(*) as total
              FROM t1
            GROUP BY dates) AS b
USING (dates)
WHERE b.total > 2

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE stadium (
      `id` INTEGER,
      `visit_date` DATE,
      `people` INTEGER
    );
    
    INSERT INTO stadium
      (`id`, `visit_date`, `people`)
    VALUES
      ('1', '2017-01-01', '10'),
      ('2', '2017-01-02', '109'),
      ('3', '2017-01-03', '150'),
      ('4', '2017-01-04', '99'),
      ('5', '2017-01-05', '145'),
      ('6', '2017-01-06', '1455'),
      ('7', '2017-01-07', '199'),
      ('8', '2017-01-08', '188');

---

**Query #1**

    with cte as (
    select *, (case when lag(people) over() >= 100 and people >= 100 and lead(people) over() >= 100 then 1 else 0 end) as check_traffic from stadium )
    
    select id, visit_date, people from
    (select *, (case when lead(check_traffic) over() = 1 or lag(check_traffic) over() = 1 then 1 else 0 end) human_traffic_gt_100 from cte ) d
    where human_traffic_gt_100 = 1;

| id  | visit_date | people |
| --- | ---------- | ------ |
| 5   | 2017-01-05 | 145    |
| 6   | 2017-01-06 | 1455   |
| 7   | 2017-01-07 | 199    |
| 8   | 2017-01-08 | 188    |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/vkETmzShbjso6PQUpH1T6A/1)