-- Question 65
-- Table: Events

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | business_id   | int     |
-- | event_type    | varchar |
-- | occurences    | int     | 
-- +---------------+---------+
-- (business_id, event_type) is the primary key of this table.
-- Each row in the table logs the info that an event of some type occured at some business for a number of times.
 

-- Write an SQL query to find all active businesses.

-- An active business is a business that has more than one event type with occurences greater than the average occurences of that event type among all businesses.

-- The query result format is in the following example:

-- Events table:
-- +-------------+------------+------------+
-- | business_id | event_type | occurences |
-- +-------------+------------+------------+
-- | 1           | reviews    | 7          |
-- | 3           | reviews    | 3          |
-- | 1           | ads        | 11         |
-- | 2           | ads        | 7          |
-- | 3           | ads        | 6          |
-- | 1           | page views | 3          |
-- | 2           | page views | 12         |
-- +-------------+------------+------------+

-- Result table:
-- +-------------+
-- | business_id |
-- +-------------+
-- | 1           |
-- +-------------+ 
-- Average for 'reviews', 'ads' and 'page views' are (7+3)/2=5, (11+7+6)/3=8, (3+12)/2=7.5 respectively.
-- Business with id 1 has 7 'reviews' events (more than 5) and 11 'ads' events (more than 8) so it is an active business.

-- Solution
select c.business_id
from(
select *
from events e
join
(select event_type as event, round(avg(occurences),2) as average from events group by event_type) b
on e.event_type = b.event) c
where c.occurences>c.average
group by c.business_id
having count(*) > 1


-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Events (
      `business_id` INTEGER,
      `event_type` VARCHAR(10),
      `occurences` INTEGER
    );
    
    INSERT INTO Events
      (`business_id`, `event_type`, `occurences`)
    VALUES
      ('1', 'reviews', '7'),
      ('3', 'reviews', '3'),
      ('1', 'ads', '11'),
      ('2', 'ads', '7'),
      ('3', 'ads', '6'),
      ('1', 'page views', '3'),
      ('2', 'page views', '12');

---

**Query #1**

    select business_id from (
    select business_id, event_type, (case when occurences > (select avg(s.occurences) as avg_occurence from Events s
    where event_type = e.event_type) then 1 else 0 end ) as num_occurence 
    from Events e ) s1
    group by business_id
    having sum(num_occurence) > 1 ;

| business_id |
| ----------- |
| 1           |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/szNMC8LUuNaZhta4mKSaqQ/1)