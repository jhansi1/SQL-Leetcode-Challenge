-- Question 70
-- In facebook, there is a follow table with two columns: followee, follower.

-- Please write a sql query to get the amount of each follower’s follower if he/she has one.

-- For example:

-- +-------------+------------+
-- | followee    | follower   |
-- +-------------+------------+
-- |     A       |     B      |
-- |     B       |     C      |
-- |     B       |     D      |
-- |     D       |     E      |
-- +-------------+------------+
-- should output:
-- +-------------+------------+
-- | follower    | num        |
-- +-------------+------------+
-- |     B       |  2         |
-- |     D       |  1         |
-- +-------------+------------+
-- Explaination:
-- Both B and D exist in the follower list, when as a followee, B's follower is C and D, and D's follower is E. A does not exist in follower list.
 

-- Note:
-- Followee would not follow himself/herself in all cases.
-- Please display the result in follower's alphabet order.

-- Solution
select followee as follower, count(distinct(follower)) as num
from follow
where followee = any(select follower from follow)
group by followee
order by followee

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE follow (
      `followee` VARCHAR(1),
      `follower` VARCHAR(1)
    );
    
    INSERT INTO follow
      (`followee`, `follower`)
    VALUES
      ('A', 'B'),
      ('B', 'C'),
      ('B', 'D'),
      ('D', 'E');

---

**Query #1**

    select followee as follower, count(distinct follower) as num from follow 
    where followee in (select follower from follow)
    group by followee;

| followee | num |
| -------- | --- |
| B        | 2   |
| D        | 1   |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/fpVzFBpDp95DZ7xnkftips/1)