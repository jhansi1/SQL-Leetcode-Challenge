-- Question 37
-- Several friends at a cinema ticket office would like to reserve consecutive available seats.
-- Can you help to query all the consecutive available seats order by the seat_id using the following cinema table?
-- | seat_id | free |
-- |---------|------|
-- | 1       | 1    |
-- | 2       | 0    |
-- | 3       | 1    |
-- | 4       | 1    |
-- | 5       | 1    |
 

-- Your query should return the following result for the sample case above.
 

-- | seat_id |
-- |---------|
-- | 3       |
-- | 4       |
-- | 5       |
-- Note:
-- The seat_id is an auto increment int, and free is bool ('1' means free, and '0' means occupied.).
-- Consecutive available seats are more than 2(inclusive) seats consecutively available.

-- Solution
Select seat_id
from(
select seat_id, free,
lead(free,1) over() as next,
lag(free,1) over() as prev
from cinema) a
where a.free=True and (next = True or prev=True)
order by seat_id


-- My solution:
**Schema (MySQL v8.0)**

    CREATE TABLE cinema (
      `seat_id` INTEGER,
      `free` INTEGER
    );
    
    INSERT INTO cinema
      (`seat_id`, `free`)
    VALUES
      ('1', '1'),
      ('2', '0'),
      ('3', '1'),
      ('4', '1'),
      ('5', '1');

---

**Query #1**

    select s.seat_id from (
    select seat_id, free, lag(free) over() as prev, lead(free) over() as next from cinema) s
    where s.free = 1 and (s.prev = 1 or s.next = 1)
    order by seat_id;

| seat_id |
| ------- |
| 3       |
| 4       |
| 5       |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/un1LYJche6VFe3dEUTGyXi/1)

Reference: select seat_id, free, lag(free, 2) over() as prev, lead(free, 2) over() as next from cinema