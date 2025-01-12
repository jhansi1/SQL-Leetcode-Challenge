-- Question 31
-- Table: Submissions

-- +---------------+----------+
-- | Column Name   | Type     |
-- +---------------+----------+
-- | sub_id        | int      |
-- | parent_id     | int      |
-- +---------------+----------+
-- There is no primary key for this table, it may have duplicate rows.
-- Each row can be a post or comment on the post.
-- parent_id is null for posts.
-- parent_id for comments is sub_id for another post in the table.
 

-- Write an SQL query to find number of comments per each post.

-- Result table should contain post_id and its corresponding number_of_comments, 
-- and must be sorted by post_id in ascending order.

-- Submissions may contain duplicate comments. You should count the number of unique comments per post.

-- Submissions may contain duplicate posts. You should treat them as one post.

-- The query result format is in the following example:

-- Submissions table:
-- +---------+------------+
-- | sub_id  | parent_id  |
-- +---------+------------+
-- | 1       | Null       |
-- | 2       | Null       |
-- | 1       | Null       |
-- | 12      | Null       |
-- | 3       | 1          |
-- | 5       | 2          |
-- | 3       | 1          |
-- | 4       | 1          |
-- | 9       | 1          |
-- | 10      | 2          |
-- | 6       | 7          |
-- +---------+------------+

-- Result table:
-- +---------+--------------------+
-- | post_id | number_of_comments |
-- +---------+--------------------+
-- | 1       | 3                  |
-- | 2       | 2                  |
-- | 12      | 0                  |
-- +---------+--------------------+

-- The post with id 1 has three comments in the table with id 3, 4 and 9. The comment with id 3 is 
-- repeated in the table, we counted it only once.
-- The post with id 2 has two comments in the table with id 5 and 10.
-- The post with id 12 has no comments in the table.
-- The comment with id 6 is a comment on a deleted post with id 7 so we ignored it.

-- Solution
Select a.sub_id as post_id, coalesce(b.number_of_comments,0) as number_of_comments
from(
select distinct sub_id from submissions where parent_id is null) a
left join(
select parent_id, count(distinct(sub_id)) as number_of_comments
from submissions
group by parent_id
having parent_id = any(select sub_id from submissions where parent_id is null)) b
on a.sub_id = b.parent_id
order by post_id


-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Submissions (
      `sub_id` INTEGER,
      `parent_id` INTEGER
    );
    
    INSERT INTO Submissions
      (`sub_id`, `parent_id`)
    VALUES
      ('1', Null),
      ('2', Null),
      ('1', Null),
      ('12', Null),
      ('3', '1'),
      ('5', '2'),
      ('3', '1'),
      ('4', '1'),
      ('9', '1'),
      ('10', '2'),
      ('6', '7');

---

**Query #1**

    With t1 as 
    (select distinct sub_id as post_id from Submissions where parent_id is null),
    t2 as
    (select distinct sub_id, parent_id from Submissions where parent_id is not null)
    
    select post_id, sum(case when parent_id is not null then 1 else 0 end) as number_of_comments 
	from t1 left join  t2 on t1.post_id = t2.parent_id
    group by post_id
    order by post_id;

| post_id | number_of_comments |
| ------- | ------------------ |
| 1       | 3                  |
| 2       | 2                  |
| 12      | 0                  |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/cuvCtZ8nQE4NveBYKPFqmF/2)