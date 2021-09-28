-- Question 111
-- Table: Activity

-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | player_id    | int     |
-- | device_id    | int     |
-- | event_date   | date    |
-- | games_played | int     |
-- +--------------+---------+
-- (player_id, event_date) is the primary key of this table.
-- This table shows the activity of players of some game.
-- Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.
 

-- We define the install date of a player to be the first login day of that player.

-- We also define day 1 retention of some date X to be the number of players whose install date is X and they logged back in on the day right after X, divided by the number of players whose install date is X, rounded to 2 decimal places.

-- Write an SQL query that reports for each install date, the number of players that installed the game on that day and the day 1 retention.

-- The query result format is in the following example:

-- Activity table:
-- +-----------+-----------+------------+--------------+
-- | player_id | device_id | event_date | games_played |
-- +-----------+-----------+------------+--------------+
-- | 1         | 2         | 2016-03-01 | 5            |
-- | 1         | 2         | 2016-03-02 | 6            |
-- | 2         | 3         | 2017-06-25 | 1            |
-- | 3         | 1         | 2016-03-01 | 0            |
-- | 3         | 4         | 2016-07-03 | 5            |
-- +-----------+-----------+------------+--------------+

-- Result table:
-- +------------+----------+----------------+
-- | install_dt | installs | Day1_retention |
-- +------------+----------+----------------+
-- | 2016-03-01 | 2        | 0.50           |
-- | 2017-06-25 | 1        | 0.00           |
-- +------------+----------+----------------+
-- Player 1 and 3 installed the game on 2016-03-01 but only player 1 logged back in on 2016-03-02 so the
-- day 1 retention of 2016-03-01 is 1 / 2 = 0.50
-- Player 2 installed the game on 2017-06-25 but didn't log back in on 2017-06-26 so the day 1 retention of 2017-06-25 is 0 / 1 = 0.00

-- Solution
with t1 as(
select *,
row_number() over(partition by player_id order by event_date) as rnk,
min(event_date) over(partition by player_id) as install_dt,
lead(event_date,1) over(partition by player_id order by event_date) as nxt
from Activity)

select distinct install_dt,
count(distinct player_id) as installs,
round(sum(case when nxt=event_date+1 then 1 else 0 end)/count(distinct player_id),2) as Day1_retention
from t1
where rnk = 1
group by 1
order by 1

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Activity (
      `player_id` INTEGER,
      `device_id` INTEGER,
      `event_date` DATE,
      `games_played` INTEGER
    );
    
    INSERT INTO Activity
      (`player_id`, `device_id`, `event_date`, `games_played`)
    VALUES
      ('1', '2', '2016-03-01', '5'),
      ('1', '2', '2016-03-02', '6'),
      ('2', '3', '2017-06-25', '1'),
      ('3', '1', '2016-03-01', '0'),
      ('3', '4', '2016-07-03', '5');

---

**Query #1**

    with cte as 
    (select *, count(device_id) over(partition by event_date) as installs, 
				min(event_date) over(partition by player_id) as install_dt , 
				(case when min(event_date) over(partition by player_id) + 1 = event_date then 1 else NULL end) as log_day_after
    from Activity)
    
    select distinct c1.install_dt, installs, round((cnt/installs), 2) as Day1_retention from
    (select install_dt, count(log_day_after) as cnt
    from cte 
    group by install_dt)  c1 left join cte c2 on c1.install_dt = c2.event_date;

| install_dt | installs | Day1_retention |
| ---------- | -------- | -------------- |
| 2016-03-01 | 2        | 0.50           |
| 2017-06-25 | 1        | 0.00           |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/8v17kcfkxnyQdSwF4DhVvu/1)