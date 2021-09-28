-- Question 95
-- Table: Transactions

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | id             | int     |
-- | country        | varchar |
-- | state          | enum    |
-- | amount         | int     |
-- | trans_date     | date    |
-- +----------------+---------+
-- id is the primary key of this table.
-- The table has information about incoming transactions.
-- The state column is an enum of type ["approved", "declined"].
-- Table: Chargebacks

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | trans_id       | int     |
-- | charge_date    | date    |
-- +----------------+---------+
-- Chargebacks contains basic information regarding incoming chargebacks from some transactions placed in Transactions table.
-- trans_id is a foreign key to the id column of Transactions table.
-- Each chargeback corresponds to a transaction made previously even if they were not approved.
 

-- Write an SQL query to find for each month and country, the number of approved transactions and their total amount, the number of chargebacks and their total amount.

-- Note: In your query, given the month and country, ignore rows with all zeros.

-- The query result format is in the following example:

-- Transactions table:
-- +------+---------+----------+--------+------------+
-- | id   | country | state    | amount | trans_date |
-- +------+---------+----------+--------+------------+
-- | 101  | US      | approved | 1000   | 2019-05-18 |
-- | 102  | US      | declined | 2000   | 2019-05-19 |
-- | 103  | US      | approved | 3000   | 2019-06-10 |
-- | 104  | US      | approved | 4000   | 2019-06-13 |
-- | 105  | US      | approved | 5000   | 2019-06-15 |
-- +------+---------+----------+--------+------------+

-- Chargebacks table:
-- +------------+------------+
-- | trans_id   | trans_date |
-- +------------+------------+
-- | 102        | 2019-05-29 |
-- | 101        | 2019-06-30 |
-- | 105        | 2019-09-18 |
-- +------------+------------+

-- Result table:
-- +----------+---------+----------------+-----------------+-------------------+--------------------+
-- | month    | country | approved_count | approved_amount | chargeback_count  | chargeback_amount  |
-- +----------+---------+----------------+-----------------+-------------------+--------------------+
-- | 2019-05  | US      | 1              | 1000            | 1                 | 2000               |
-- | 2019-06  | US      | 3              | 12000           | 1                 | 1000               |
-- | 2019-09  | US      | 0              | 0               | 1                 | 5000               |
-- +----------+---------+----------------+-----------------+-------------------+--------------------+

-- Solution
with t1 as
(select country, extract('month' from trans_date), state, count(*) as approved_count, sum(amount) as approved_amount
from transactions
where state = 'approved'
group by 1, 2, 3),
t2 as(
select t.country, extract('month' from c.trans_date), sum(amount) as chargeback_amount, count(*) as chargeback_count
from chargebacks c left join transactions t 
on trans_id = id
group by t.country, extract('month' from c.trans_date)),

t3 as(
select t2.date_part, t2.country, coalesce(approved_count,0) as approved_count, coalesce(approved_amount,0) as approved_amount, coalesce(chargeback_count,0) as chargeback_count, coalesce(chargeback_amount,0) as chargeback_amount
from t2 left join t1 
on t2.date_part = t1.date_part and t2.country = t1.country),

t4 as(
select t1.date_part, t1.country, coalesce(approved_count,0) as approved_count, coalesce(approved_amount,0) as approved_amount, coalesce(chargeback_count,0) as chargeback_count, coalesce(chargeback_amount,0) as chargeback_amount
from t2 right join t1 
on t2.date_part = t1.date_part and t2.country = t1.country)

select *
from t3
union
select *
from t4

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Transactions (
      `id` INTEGER,
      `country` VARCHAR(2),
      `state` VARCHAR(8),
      `amount` INTEGER,
      `trans_date` DATE
    );
    
    INSERT INTO Transactions
      (`id`, `country`, `state`, `amount`, `trans_date`)
    VALUES
      ('101', 'US', 'approved', '1000', '2019-05-18'),
      ('102', 'US', 'declined', '2000', '2019-05-19'),
      ('103', 'US', 'approved', '3000', '2019-06-10'),
      ('104', 'US', 'approved', '4000', '2019-06-13'),
      ('105', 'US', 'approved', '5000', '2019-06-15');
    
    CREATE TABLE Chargebacks (
      `trans_id` INTEGER,
      `trans_date` DATE
    );
    
    INSERT INTO Chargebacks
      (`trans_id`, `trans_date`)
    VALUES
      ('102', '2019-05-29'),
      ('101', '2019-06-30'),
      ('105', '2019-09-18');

---

**Query #1**

    With cte1 as (
    select DATE_FORMAT(t.trans_date,'%Y-%m') as month, t.country, count(t.state) as approved_count, sum(t.amount) as approved_amount 
    from Transactions t
    where state = 'approved'
    group by 1, 2), 
    cte2 as
    (select DATE_FORMAT(c.trans_date,'%Y-%m') as month, t.country, count(c.trans_id) as chargeback_count, sum(t.amount) as chargeback_amount from Chargebacks c left join Transactions t
    on c.trans_id = t.id
    group by 1, 2)
    
    
    select cte2.month, cte2.country, coalesce(approved_count, 0) as approved_count, coalesce(approved_amount, 0) as approved_amount, coalesce(chargeback_count, 0) as chargeback_count, coalesce(chargeback_amount, 0) as chargeback_amount
    from cte2 left join cte1 on cte2.month = cte1.month;

| month   | country | approved_count | approved_amount | chargeback_count | chargeback_amount |
| ------- | ------- | -------------- | --------------- | ---------------- | ----------------- |
| 2019-05 | US      | 1              | 1000            | 1                | 2000              |
| 2019-06 | US      | 3              | 12000           | 1                | 1000              |
| 2019-09 | US      | 0              | 0               | 1                | 5000              |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/9SrmtNvgXNK45KgJ3sdFEN/1)