-- Question 87
-- A university uses 2 data tables, student and department, to store data about its students
-- and the departments associated with each major.

-- Write a query to print the respective department name and number of students majoring in each
-- department for all departments in the department table (even ones with no current students).

-- Sort your results by descending number of students; if two or more departments have the same number of students, 
-- then sort those departments alphabetically by department name.

-- The student is described as follow:

-- | Column Name  | Type      |
-- |--------------|-----------|
-- | student_id   | Integer   |
-- | student_name | String    |
-- | gender       | Character |
-- | dept_id      | Integer   |
-- where student_id is the student's ID number, student_name is the student's name, gender is their gender, and dept_id is the department ID associated with their declared major.

-- And the department table is described as below:

-- | Column Name | Type    |
-- |-------------|---------|
-- | dept_id     | Integer |
-- | dept_name   | String  |
-- where dept_id is the department's ID number and dept_name is the department name.

-- Here is an example input:
-- student table:

-- | student_id | student_name | gender | dept_id |
-- |------------|--------------|--------|---------|
-- | 1          | Jack         | M      | 1       |
-- | 2          | Jane         | F      | 1       |
-- | 3          | Mark         | M      | 2       |
-- department table:

-- | dept_id | dept_name   |
-- |---------|-------------|
-- | 1       | Engineering |
-- | 2       | Science     |
-- | 3       | Law         |
-- The Output should be:

-- | dept_name   | student_number |
-- |-------------|----------------|
-- | Engineering | 2              |
-- | Science     | 1              |
-- | Law         | 0              |

-- Solution
select dept_name, count(s.dept_id) as student_number
from department d
left join student s
on d.dept_id = s.dept_id
group by d.dept_id
order by count(s.dept_id) desc, dept_name

-- My Solution:
**Schema (MySQL v8.0)**

    CREATE TABLE student (
      `student_id` INTEGER,
      `student_name` VARCHAR(4),
      `gender` VARCHAR(1),
      `dept_id` INTEGER
    );
    
    INSERT INTO student
      (`student_id`, `student_name`, `gender`, `dept_id`)
    VALUES
      ('1', 'Jack', 'M', '1'),
      ('2', 'Jane', 'F', '1'),
      ('3', 'Mark', 'M', '2');
    
    CREATE TABLE department (
      `dept_id` INTEGER,
      `dept_name` VARCHAR(11)
    );
    
    INSERT INTO department
      (`dept_id`, `dept_name`)
    VALUES
      ('1', 'Engineering'),
      ('2', 'Science'),
      ('3', 'Law');

---

**Query #1**

    select d.dept_name, sum(case when s.dept_id is not null then 1 else 0 end) as num_of_students 
	from department d left join student s
    on d.dept_id = s.dept_id
    group by d.dept_name
    order by 2 desc, 1;

| dept_name   | num_of_students |
| ----------- | --------------- |
| Engineering | 2               |
| Science     | 1               |
| Law         | 0               |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/7BHhHvqmK3ZZMPzbumoCvv/2)