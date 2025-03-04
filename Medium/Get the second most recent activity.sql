-- Question 109
-- Table: UserActivity

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | username      | varchar |
-- | activity      | varchar |
-- | startDate     | Date    |
-- | endDate       | Date    |
-- +---------------+---------+
-- This table does not contain primary key.
-- This table contain information about the activity performed of each user in a period of time.
-- A person with username performed a activity from startDate to endDate.

-- Write an SQL query to show the second most recent activity of each user.

-- If the user only has one activity, return that one. 

-- A user can't perform more than one activity at the same time. Return the result table in any order.

-- The query result format is in the following example:

-- UserActivity table:
-- +------------+--------------+-------------+-------------+
-- | username   | activity     | startDate   | endDate     |
-- +------------+--------------+-------------+-------------+
-- | Alice      | Travel       | 2020-02-12  | 2020-02-20  |
-- | Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
-- | Alice      | Travel       | 2020-02-24  | 2020-02-28  |
-- | Bob        | Travel       | 2020-02-11  | 2020-02-18  |
-- +------------+--------------+-------------+-------------+

-- Result table:
-- +------------+--------------+-------------+-------------+
-- | username   | activity     | startDate   | endDate     |
-- +------------+--------------+-------------+-------------+
-- | Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
-- | Bob        | Travel       | 2020-02-11  | 2020-02-18  |
-- +------------+--------------+-------------+-------------+

-- The most recent activity of Alice is Travel from 2020-02-24 to 2020-02-28, before that she was dancing from 2020-02-21 to 2020-02-23.
-- Bob only has one record, we just take that one.

-- Solution
select username, activity, startdate, enddate
from
(select *,
rank() over(partition by username order by startdate desc) as rk,
count(username) over(partition by username) as cnt
from useractivity) a
where a.rk = 2 or cnt = 1

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE UserActivity (
      `username` VARCHAR(5),
      `activity` VARCHAR(7),
      `startDate` DATE,
      `endDate` DATE
    );
    
    INSERT INTO UserActivity
      (`username`, `activity`, `startDate`, `endDate`)
    VALUES
      ('Alice', 'Travel', '2020-02-12', '2020-02-20'),
      ('Alice', 'Dancing', '2020-02-21', '2020-02-23'),
      ('Alice', 'Travel', '2020-02-24', '2020-02-28'),
      ('Bob', 'Travel', '2020-02-11', '2020-02-18');

---

**Query #1**

    with cte as
    (select *, row_number() over(partition by username order by startDate desc) as r
    from UserActivity)
    
    
    select username, activity, startDate, endDate  from cte where r = 2
    union
    select username, activity, startDate, endDate from cte
    where username in (select username from cte group by username
    having count(r) = 1);

| username | activity | startDate  | endDate    |
| -------- | -------- | ---------- | ---------- |
| Alice    | Dancing  | 2020-02-21 | 2020-02-23 |
| Bob      | Travel   | 2020-02-11 | 2020-02-18 |

---
**Query #2**

    select username, activity, startDate, endDate from 
    (select *, 
			row_number() over(partition by username order by startDate desc) as r, 
			count(username) over(partition by username) as cnt
    from UserActivity ) d
    where r = 2 or cnt = 1;

| username | activity | startDate  | endDate    |
| -------- | -------- | ---------- | ---------- |
| Alice    | Dancing  | 2020-02-21 | 2020-02-23 |
| Bob      | Travel   | 2020-02-11 | 2020-02-18 |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/pEGASnL2AVJVJPnTk8XjSb/2)