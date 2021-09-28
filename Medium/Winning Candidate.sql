-- Question 88
-- Table: Candidate

-- +-----+---------+
-- | id  | Name    |
-- +-----+---------+
-- | 1   | A       |
-- | 2   | B       |
-- | 3   | C       |
-- | 4   | D       |
-- | 5   | E       |
-- +-----+---------+  
-- Table: Vote

-- +-----+--------------+
-- | id  | CandidateId  |
-- +-----+--------------+
-- | 1   |     2        |
-- | 2   |     4        |
-- | 3   |     3        |
-- | 4   |     2        |
-- | 5   |     5        |
-- +-----+--------------+
-- id is the auto-increment primary key,
-- CandidateId is the id appeared in Candidate table.
-- Write a sql to find the name of the winning candidate, the above example will return the winner B.

-- +------+
-- | Name |
-- +------+
-- | B    |
-- +------+
-- Notes:

-- You may assume there is no tie, in other words there will be only one winning candidate

-- Solution
with t1 as (
select *, rank() over(order by b.votes desc) as rk
from candidate c
join 
(select candidateid, count(*) as votes
from vote
group by candidateid) b
on c.id = b.candidateid)

select t1.name
from t1
where t1.rk=1

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Candidate (
      `id` INTEGER,
      `Name` VARCHAR(1)
    );
    
    INSERT INTO Candidate
      (`id`, `Name`)
    VALUES
      ('1', 'A'),
      ('2', 'B'),
      ('3', 'C'),
      ('4', 'D'),
      ('5', 'E');
    
    CREATE TABLE Vote (
      `id` INTEGER,
      `CandidateId` INTEGER
    );
    
    INSERT INTO Vote
      (`id`, `CandidateId`)
    VALUES
      ('1', '2'),
      ('2', '4'),
      ('3', '3'),
      ('4', '2'),
      ('5', '5');

---

**Query #1**

    with cte as
    (select CandidateId, count(CandidateId) as votings from Vote group by CandidateId)
    
    select Name from (
    select *, rank() over(order by votings desc) as r from Candidate c left join cte on c.id = cte. CandidateId ) d
    where r = 1;

| Name |
| ---- |
| B    |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/chW3Vei9Jdpdm54ebngYKX/1)