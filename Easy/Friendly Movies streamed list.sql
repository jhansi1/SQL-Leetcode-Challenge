-- Question 115
-- Write an SQL query to report the distinct titles of the kid-friendly movies streamed in June 2020.

-- Return the result table in any order.

-- The query result format is in the following example.

 

-- TVProgram table:
-- +--------------------+--------------+-------------+
-- | program_date       | content_id   | channel     |
-- +--------------------+--------------+-------------+
-- | 2020-06-10 08:00   | 1            | LC-Channel  |
-- | 2020-05-11 12:00   | 2            | LC-Channel  |
-- | 2020-05-12 12:00   | 3            | LC-Channel  |
-- | 2020-05-13 14:00   | 4            | Disney Ch   |
-- | 2020-06-18 14:00   | 4            | Disney Ch   |
-- | 2020-07-15 16:00   | 5            | Disney Ch   |
-- +--------------------+--------------+-------------+

-- Content table:
-- +------------+----------------+---------------+---------------+
-- | content_id | title          | Kids_content  | content_type  |
-- +------------+----------------+---------------+---------------+
-- | 1          | Leetcode Movie | N             | Movies        |
-- | 2          | Alg. for Kids  | Y             | Series        |
-- | 3          | Database Sols  | N             | Series        |
-- | 4          | Aladdin        | Y             | Movies        |
-- | 5          | Cinderella     | Y             | Movies        |
-- +------------+----------------+---------------+---------------+

-- Result table:
-- +--------------+
-- | title        |
-- +--------------+
-- | Aladdin      |
-- +--------------+
-- "Leetcode Movie" is not a content for kids.
-- "Alg. for Kids" is not a movie.
-- "Database Sols" is not a movie
-- "Alladin" is a movie, content for kids and was streamed in June 2020.
-- "Cinderella" was not streamed in June 2020.

-- Solution
select distinct title
from
(select content_id, title
from content
where kids_content = 'Y' and content_type = 'Movies') a
join
tvprogram using (content_id)
where month(program_date) = 6


-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE TVProgram (
      `program_date` DATETIME,
      `content_id` INTEGER,
      `channel` VARCHAR(10)
    );
    
    INSERT INTO TVProgram
      (`program_date`, `content_id`, `channel`)
    VALUES
      ('2020-06-10 08:00', '1', 'LC-Channel'),
      ('2020-05-11 12:00', '2', 'LC-Channel'),
      ('2020-05-12 12:00', '3', 'LC-Channel'),
      ('2020-05-13 14:00', '4', 'Disney Ch'),
      ('2020-06-18 14:00', '4', 'Disney Ch'),
      ('2020-07-15 16:00', '5', 'Disney Ch');
    
    CREATE TABLE Content (
      `content_id` INTEGER,
      `title` VARCHAR(14),
      `Kids_content` VARCHAR(1),
      `content_type` VARCHAR(6)
    );
    
    INSERT INTO Content
      (`content_id`, `title`, `Kids_content`, `content_type`)
    VALUES
      ('1', 'Leetcode Movie', 'N', 'Movies'),
      ('2', 'Alg. for Kids', 'Y', 'Series'),
      ('3', 'Database Sols', 'N', 'Series'),
      ('4', 'Aladdin', 'Y', 'Movies'),
      ('5', 'Cinderella', 'Y', 'Movies');

---

**Query #1**

    select distinct title 
    from TVProgram p inner join Content c on p.content_id= c.content_id
    where c.Kids_content = 'Y' and c.content_type = 'Movies' and month(p.program_date) = 6;

| title   |
| ------- |
| Aladdin |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/9e6VodUHkaQteuqLXQZ31P/1)