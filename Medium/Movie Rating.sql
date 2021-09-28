-- Question 59
-- Table: Movies

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | movie_id      | int     |
-- | title         | varchar |
-- +---------------+---------+
-- movie_id is the primary key for this table.
-- title is the name of the movie.
-- Table: Users

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | name          | varchar |
-- +---------------+---------+
-- user_id is the primary key for this table.
-- Table: Movie_Rating

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | movie_id      | int     |
-- | user_id       | int     |
-- | rating        | int     |
-- | created_at    | date    |
-- +---------------+---------+
-- (movie_id, user_id) is the primary key for this table.
-- This table contains the rating of a movie by a user in their review.
-- created_at is the user's review date. 
 

-- Write the following SQL query:

-- Find the name of the user who has rated the greatest number of the movies.
-- In case of a tie, return lexicographically smaller user name.

-- Find the movie name with the highest average rating in February 2020.
-- In case of a tie, return lexicographically smaller movie name.

-- Query is returned in 2 rows, the query result format is in the folowing example:

-- Movies table:
-- +-------------+--------------+
-- | movie_id    |  title       |
-- +-------------+--------------+
-- | 1           | Avengers     |
-- | 2           | Frozen 2     |
-- | 3           | Joker        |
-- +-------------+--------------+

-- Users table:
-- +-------------+--------------+
-- | user_id     |  name        |
-- +-------------+--------------+
-- | 1           | Daniel       |
-- | 2           | Monica       |
-- | 3           | Maria        |
-- | 4           | James        |
-- +-------------+--------------+

-- Movie_Rating table:
-- +-------------+--------------+--------------+-------------+
-- | movie_id    | user_id      | rating       | created_at  |
-- +-------------+--------------+--------------+-------------+
-- | 1           | 1            | 3            | 2020-01-12  |
-- | 1           | 2            | 4            | 2020-02-11  |
-- | 1           | 3            | 2            | 2020-02-12  |
-- | 1           | 4            | 1            | 2020-01-01  |
-- | 2           | 1            | 5            | 2020-02-17  | 
-- | 2           | 2            | 2            | 2020-02-01  | 
-- | 2           | 3            | 2            | 2020-03-01  |
-- | 3           | 1            | 3            | 2020-02-22  | 
-- | 3           | 2            | 4            | 2020-02-25  | 
-- +-------------+--------------+--------------+-------------+

-- Result table:
-- +--------------+
-- | results      |
-- +--------------+
-- | Daniel       |
-- | Frozen 2     |
-- +--------------+

-- Daniel and Maria have rated 3 movies ("Avengers", "Frozen 2" and "Joker") but Daniel is smaller lexicographically.
-- Frozen 2 and Joker have a rating average of 3.5 in February but Frozen 2 is smaller lexicographically.

-- Solution
select name as results
from(
(select a.name
from(
select name, count(*),
rank() over(order by count(*) desc) as rk
from movie_rating m
join users u 
on m.user_id = u.user_id
group by name, m.user_id
order by rk, name) a
limit 1)
union
(select title
from(
select title, round(avg(rating),1) as rnd
from movie_rating m
join movies u
on m.movie_id = u.movie_id
where month(created_at) = 2
group by title
order by rnd desc, title) b
limit 1)) as d

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Movies (
      `movie_id` INTEGER,
      `title` VARCHAR(8)
    );
    
    INSERT INTO Movies
      (`movie_id`, `title`)
    VALUES
      ('1', 'Avengers'),
      ('2', 'Frozen 2'),
      ('3', 'Joker');
    
    CREATE TABLE Users (
      `user_id` INTEGER,
      `name` VARCHAR(6)
    );
    
    INSERT INTO Users
      (`user_id`, `name`)
    VALUES
      ('1', 'Daniel'),
      ('2', 'Monica'),
      ('3', 'Maria'),
      ('4', 'James');
    
    CREATE TABLE Movie_Rating (
      `movie_id` INTEGER,
      `user_id` INTEGER,
      `rating` INTEGER,
      `created_at` DATE
    );
    
    INSERT INTO Movie_Rating
      (`movie_id`, `user_id`, `rating`, `created_at`)
    VALUES
      ('1', '1', '3', '2020-01-12'),
      ('1', '2', '4', '2020-02-11'),
      ('1', '3', '2', '2020-02-12'),
      ('1', '4', '1', '2020-01-01'),
      ('2', '1', '5', '2020-02-17'),
      ('2', '2', '2', '2020-02-01'),
      ('2', '3', '2', '2020-03-01'),
      ('3', '1', '3', '2020-02-22'),
      ('3', '2', '4', '2020-02-25');

---

**Query #1**

    select * from (
    select name as results from 
    (select user_id, count(rating) as num
    from Movie_Rating 
    group by user_id) m
    left join Users u on m.user_id = u.user_id
    order by num desc, name 
    limit 1) d1
    
    union
    
    select * from (
    select title from 
    (select movie_id, avg(rating) as average_rating
    from Movie_Rating
    where month(created_at) = 2
    group by movie_id) mr
    left join Movies m on mr.movie_id = m.movie_id
    order by average_rating desc, title 
    limit 1) d2;

| results  |
| -------- |
| Daniel   |
| Frozen 2 |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/cEEEYfzKoBbXxdt483Gsba/1)