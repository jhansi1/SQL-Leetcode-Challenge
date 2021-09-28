-- Question 13
-- Table: Ads

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | ad_id         | int     |
-- | user_id       | int     |
-- | action        | enum    |
-- +---------------+---------+
-- (ad_id, user_id) is the primary key for this table.
-- Each row of this table contains the ID of an Ad, the ID of a user and the action taken by this user regarding this Ad.
-- The action column is an ENUM type of ('Clicked', 'Viewed', 'Ignored').
 

-- A company is running Ads and wants to calculate the performance of each Ad.

-- Performance of the Ad is measured using Click-Through Rate (CTR) where:



-- Write an SQL query to find the ctr of each Ad.

-- Round ctr to 2 decimal points. Order the result table by ctr in descending order and by ad_id in ascending order in case of a tie.

-- The query result format is in the following example:

-- Ads table:
-- +-------+---------+---------+
-- | ad_id | user_id | action  |
-- +-------+---------+---------+
-- | 1     | 1       | Clicked |
-- | 2     | 2       | Clicked |
-- | 3     | 3       | Viewed  |
-- | 5     | 5       | Ignored |
-- | 1     | 7       | Ignored |
-- | 2     | 7       | Viewed  |
-- | 3     | 5       | Clicked |
-- | 1     | 4       | Viewed  |
-- | 2     | 11      | Viewed  |
-- | 1     | 2       | Clicked |
-- +-------+---------+---------+
-- Result table:
-- +-------+-------+
-- | ad_id | ctr   |
-- +-------+-------+
-- | 1     | 66.67 |
-- | 3     | 50.00 |
-- | 2     | 33.33 |
-- | 5     | 0.00  |
-- +-------+-------+
-- for ad_id = 1, ctr = (2/(2+1)) * 100 = 66.67
-- for ad_id = 2, ctr = (1/(1+2)) * 100 = 33.33
-- for ad_id = 3, ctr = (1/(1+1)) * 100 = 50.00
-- for ad_id = 5, ctr = 0.00, Note that ad_id = 5 has no clicks or views.
-- Note that we don't care about Ignored Ads.
-- Result table is ordered by the ctr. in case of a tie we order them by ad_id

-- Solution
with t1 as(
select ad_id, sum(case when action in ('Clicked') then 1 else 0 end) as clicked
from ads
group by ad_id
)

, t2 as
(
Select ad_id as ad, sum(case when action in ('Clicked','Viewed') then 1 else 0 end) as total
from ads
group by ad_id
)

Select a.ad_id, coalesce(round((clicked +0.0)/nullif((total +0.0),0)*100,2),0) as ctr
from
(
select *
from t1 join t2
on t1.ad_id = t2.ad) a
order by ctr desc, ad_id


-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Ads (
      `ad_id` INTEGER,
      `user_id` INTEGER,
      `action` VARCHAR(7)
    );
    
    INSERT INTO Ads
      (`ad_id`, `user_id`, `action`)
    VALUES
      ('1', '1', 'Clicked'),
      ('2', '2', 'Clicked'),
      ('3', '3', 'Viewed'),
      ('5', '5', 'Ignored'),
      ('1', '7', 'Ignored'),
      ('2', '7', 'Viewed'),
      ('3', '5', 'Clicked'),
      ('1', '4', 'Viewed'),
      ('2', '11', 'Viewed'),
      ('1', '2', 'Clicked');

---

**Query #1**

    select t1.ad_id, round(ifnull((clicked / (clicked + viewed) * 100), 0), 2) as ctr from 
    
    (select ad_id, sum(case when action='Clicked' then 1 else 0 end) as clicked
    from Ads 
    group by ad_id) t1
    join
    (select ad_id, sum(case when action='Viewed' then 1 else 0 end) as viewed
    from Ads 
    group by ad_id) t2
    on t1.ad_id = t2.ad_id
    order by  ctr desc, ad_id;

| ad_id | ctr   |
| ----- | ----- |
| 1     | 66.67 |
| 3     | 50.00 |
| 2     | 33.33 |
| 5     | 0.00  |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/oMDnFch8BXL45r3dUVF17V/18)




--Reference: WITH RECURSIVE example:
WITH RECURSIVE   
odd_num_cte (id, n) AS  
(  
SELECT 1, 1   
union all  
SELECT id+1, n+2 from odd_num_cte where id < 5   
)  
SELECT * FROM odd_num_cte;  


-- Benefits of using CTE
It provides better readability of the query.
It increases the performance of the query.
The CTE allows us to use it as an alternative to the VIEW concept
It can also be used as chaining of CTE for simplifying the query.
It can also be used to implement recursive queries easily.