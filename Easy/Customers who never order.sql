-- Question 13
-- Suppose that a website contains two tables, 
-- the Customers table and the Orders table. Write a SQL query to find all customers who never order anything.

-- Table: Customers.

-- +----+-------+
-- | Id | Name  |
-- +----+-------+
-- | 1  | Joe   |
-- | 2  | Henry |
-- | 3  | Sam   |
-- | 4  | Max   |
-- +----+-------+
-- Table: Orders.

-- +----+------------+
-- | Id | CustomerId |
-- +----+------------+
-- | 1  | 3          |
-- | 2  | 1          |
-- +----+------------+
-- Using the above tables as example, return the following:

-- +-----------+
-- | Customers |
-- +-----------+
-- | Henry     |
-- | Max       |
-- +-----------+


-- Solution
Select Name as Customers
from Customers
where id != All(select c.id
                from Customers c, Orders o
                where c.id = o.Customerid) 
				
-- My solution:
**Schema (MySQL v8.0)**

    CREATE TABLE Customers (
      `Id` INTEGER,
      `Name` VARCHAR(5)
    );
    
    INSERT INTO Customers
      (`Id`, `Name`)
    VALUES
      ('1', 'Joe'),
      ('2', 'Henry'),
      ('3', 'Sam'),
      ('4', 'Max');
    
    CREATE TABLE Orders (
      `Id` INTEGER,
      `CustomerId` INTEGER
    );
    
    INSERT INTO Orders
      (`Id`, `CustomerId`)
    VALUES
      ('1', '3'),
      ('2', '1');

---

**Query #1**

    select Name 
    from Customers c left join Orders o
    on c.Id = o.CustomerId
    where o.Id is null;

| Name  |
| ----- |
| Henry |
| Max   |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/6CNm5FccNtYiG6dWx6uwK2/1)				