-- Question 61
-- Table: Stocks

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | stock_name    | varchar |
-- | operation     | enum    |
-- | operation_day | int     |
-- | price         | int     |
-- +---------------+---------+
-- (stock_name, day) is the primary key for this table.
-- The operation column is an ENUM of type ('Sell', 'Buy')
-- Each row of this table indicates that the stock which has stock_name had an operation on the day operation_day with the price.
-- It is guaranteed that each 'Sell' operation for a stock has a corresponding 'Buy' operation in a previous day.
 

-- Write an SQL query to report the Capital gain/loss for each stock.

-- The capital gain/loss of a stock is total gain or loss after buying and selling the stock one or many times.

-- Return the result table in any order.

-- The query result format is in the following example:

-- Stocks table:
-- +---------------+-----------+---------------+--------+
-- | stock_name    | operation | operation_day | price  |
-- +---------------+-----------+---------------+--------+
-- | Leetcode      | Buy       | 1             | 1000   |
-- | Corona Masks  | Buy       | 2             | 10     |
-- | Leetcode      | Sell      | 5             | 9000   |
-- | Handbags      | Buy       | 17            | 30000  |
-- | Corona Masks  | Sell      | 3             | 1010   |
-- | Corona Masks  | Buy       | 4             | 1000   |
-- | Corona Masks  | Sell      | 5             | 500    |
-- | Corona Masks  | Buy       | 6             | 1000   |
-- | Handbags      | Sell      | 29            | 7000   |
-- | Corona Masks  | Sell      | 10            | 10000  |
-- +---------------+-----------+---------------+--------+

-- Result table:
-- +---------------+-------------------+
-- | stock_name    | capital_gain_loss |
-- +---------------+-------------------+
-- | Corona Masks  | 9500              |
-- | Leetcode      | 8000              |
-- | Handbags      | -23000            |
-- +---------------+-------------------+
-- Leetcode stock was bought at day 1 for 1000$ and was sold at day 5 for 9000$. Capital gain = 9000 - 1000 = 8000$.
-- Handbags stock was bought at day 17 for 30000$ and was sold at day 29 for 7000$. Capital loss = 7000 - 30000 = -23000$.
-- Corona Masks stock was bought at day 1 for 10$ and was sold at day 3 for 1010$. It was bought again at day 4 for 1000$ and was sold at day 5 for 500$. At last, it was bought at day 6 for 1000$ and was sold at day 10 for 10000$. Capital gain/loss is the sum of capital gains/losses for each ('Buy' --> 'Sell') 
-- operation = (1010 - 10) + (500 - 1000) + (10000 - 1000) = 1000 - 500 + 9000 = 9500$.

-- Solution
select stock_name, (one-two) as capital_gain_loss
from(
(select stock_name, sum(price) as one
from stocks
where operation = 'Sell'
group by stock_name) b
left join
(select stock_name as name, sum(price) as two
from stocks
where operation = 'Buy'
group by stock_name) c
on b.stock_name = c.name)
order by capital_gain_loss desc

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Stocks (
      `stock_name` VARCHAR(12),
      `operation` VARCHAR(4),
      `operation_day` INTEGER,
      `price` INTEGER
    );
    
    INSERT INTO Stocks
      (`stock_name`, `operation`, `operation_day`, `price`)
    VALUES
      ('Leetcode', 'Buy', '1', '1000'),
      ('Corona Masks', 'Buy', '2', '10'),
      ('Leetcode', 'Sell', '5', '9000'),
      ('Handbags', 'Buy', '17', '30000'),
      ('Corona Masks', 'Sell', '3', '1010'),
      ('Corona Masks', 'Buy', '4', '1000'),
      ('Corona Masks', 'Sell', '5', '500'),
      ('Corona Masks', 'Buy', '6', '1000'),
      ('Handbags', 'Sell', '29', '7000'),
      ('Corona Masks', 'Sell', '10', '10000');

---

**Query #1**

    with cte as (
    select stock_name, operation, sum(price) as price
    from Stocks
    group by stock_name, operation)
    
    select * from (
    select stock_name, (lead(price) over(partition by stock_name order by operation) - price) as capital_gain_loss 
    from cte ) s
    where s.capital_gain_loss is not null ;

| stock_name   | capital_gain_loss |
| ------------ | ----------------- |
| Corona Masks | 9500              |
| Handbags     | -23000            |
| Leetcode     | 8000              |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/8vsQB8YRMidRWMRBAJLXQz/1)