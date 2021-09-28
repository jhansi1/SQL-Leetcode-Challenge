-- Question 92
-- Table: Traffic

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | activity      | enum    |
-- | activity_date | date    |
-- +---------------+---------+
-- There is no primary key for this table, it may have duplicate rows.
-- The activity column is an ENUM type of ('login', 'logout', 'jobs', 'groups', 'homepage').
 

-- Write an SQL query that reports for every date within at most 90 days from today, 
-- the number of users that logged in for the first time on that date. Assume today is 2019-06-30.

-- The query result format is in the following example:

-- Traffic table:
-- +---------+----------+---------------+
-- | user_id | activity | activity_date |
-- +---------+----------+---------------+
-- | 1       | login    | 2019-05-01    |
-- | 1       | homepage | 2019-05-01    |
-- | 1       | logout   | 2019-05-01    |
-- | 2       | login    | 2019-06-21    |
-- | 2       | logout   | 2019-06-21    |
-- | 3       | login    | 2019-01-01    |
-- | 3       | jobs     | 2019-01-01    |
-- | 3       | logout   | 2019-01-01    |
-- | 4       | login    | 2019-06-21    |
-- | 4       | groups   | 2019-06-21    |
-- | 4       | logout   | 2019-06-21    |
-- | 5       | login    | 2019-03-01    |
-- | 5       | logout   | 2019-03-01    |
-- | 5       | login    | 2019-06-21    |
-- | 5       | logout   | 2019-06-21    |
-- +---------+----------+---------------+

-- Result table:
-- +------------+-------------+
-- | login_date | user_count  |
-- +------------+-------------+
-- | 2019-05-01 | 1           |
-- | 2019-06-21 | 2           |
-- +------------+-------------+
-- Note that we only care about dates with non zero user count.
-- The user with id 5 first logged in on 2019-03-01 so he's not counted on 2019-06-21.

-- Solution
with t1 as
(
    select user_id, min(activity_date) as login_date
    from Traffic
    where activity = 'login'
    group by user_id
)

select login_date, count(distinct user_id) as user_count
from t1
where login_date between '2019-04-01' and '2019-06-30'
group by login_date

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Traffic (
      `user_id` INTEGER,
      `activity` VARCHAR(8),
      `activity_date` DATE
    );
    
    INSERT INTO Traffic
      (`user_id`, `activity`, `activity_date`)
    VALUES
      ('1', 'login', '2019-05-01'),
      ('1', 'homepage', '2019-05-01'),
      ('1', 'logout', '2019-05-01'),
      ('2', 'login', '2019-06-21'),
      ('2', 'logout', '2019-06-21'),
      ('3', 'login', '2019-01-01'),
      ('3', 'jobs', '2019-01-01'),
      ('3', 'logout', '2019-01-01'),
      ('4', 'login', '2019-06-21'),
      ('4', 'groups', '2019-06-21'),
      ('4', 'logout', '2019-06-21'),
      ('5', 'login', '2019-03-01'),
      ('5', 'logout', '2019-03-01'),
      ('5', 'login', '2019-06-21'),
      ('5', 'logout', '2019-06-21');

---

**Query #1**

    with cte as 
    (select 
    user_id, min(activity_date) as start_date
    from Traffic
    where activity = 'login'
    group by user_id)
    
    select start_date as login_date, count(distinct user_id) as user_count from cte
    where DATEDIFF('2019-06-30', start_date) <= 90
    group by start_date;

| login_date | user_count |
| ---------- | ---------- |
| 2019-05-01 | 1          |
| 2019-06-21 | 2          |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/nfQcXXfg45PL7u53oEygnn/1)