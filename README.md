# PostgreSQL-Window-functions
PostgreSQL-Window-functions

##Over()

##Introducing window functions

It is a function that performs calculations across a set of table rows. The rows are somehow related to the current row.

For example, with window functions you can compute sum of values in the current row, one before and one after, as in the picture:

![image](https://github.com/mythilyram/PostgreSQL-Window-functions/assets/123518126/a737ffd3-6644-4731-bc6e-2f7ad8102da7)

We call it window functions precisely because the set of rows is called a window or a window frame. Take a look at the syntax:

 OVER (...)
can be an aggregate function that you already know (COUNT(), SUM(), AVG() etc.), or another function, such as a ranking or an analytical function that you'll get to know in this course.

The window frame is defined in the OVER(...) clause.

Let's focus on OVER (...), which defines the window. **The most basic example is OVER() and means that the window consists of all rows in the query.** Take a look:

SELECT
  first_name,
  last_name,
  salary,  
  AVG(salary) OVER()
FROM employee;

That's not a very complicated query, but take a look at the last column:

**AVG(salary) OVER()
AVG(salary) means we're looking for the average salary. Where exactly? Everywhere we can, because OVER() means 'for all rows in the query result'. In others words, we're looking for the average salary in the entire company.**

**Note that we did NOT group rows. OVER() makes it possible to show the details of single rows and the result of an aggregating function together.** That wouldn't be so easy with GROUP BY — we would have to write a subquery, which is more complicated and less effective. OVER() makes our work simple and efficient at the same time.

Exercise
Now it's your turn to write a window function. For each employee, find their first name, last name, salary and the sum of all salaries in the company.

Note that the last column is an aggregated column, even though you're not using a GROUP BY.
select  first_name, 
		last_name, 
        salary,
        sum(salary) over()
from employee        

first_name	last_name	salary	sum
Diane	Turner	5330	94219
Clarence	Robinson	3617	94219
Eugene	Phillips	4877	94219
Philip	Mitchell	5259	94219

1. **Typically, OVER() is used to compare the current row with an aggregate. For example, we can compute the difference between employee's salary and the average salary.**

2. Now, take a look at another interesting example:

SELECT
  id,
  item,
  price,
  price::numeric / SUM(price) OVER()
FROM purchase
WHERE department_id = 2;
In the above query, we show all purchases from the department with id = 2. Note that we divide the price of the item purchased by the total price of all items purchased by that department. In this way, we can check what part of all expenditures each purchase constitutes.

**Range of OVER()**
Alright. Of course, you can add a WHERE clause just as you do in any other query:

SELECT
  first_name,
  last_name,
  salary,
  AVG(salary) OVER(),
  salary - AVG(salary) OVER()
FROM employee
WHERE department_id = 1;
Now, we only calculate the salaries in the department with id = 1. **Two exercises ago, we said that OVER() means 'for all rows in the query result'. This 'in the query result' part is very important – window functions work only on the rows returned by the query**.

Here, this means we'll get the salary of each IT department employee and the average salary in that department, and not in the entire company.That's a very important rule which you need to remember. **Window functions are always executed AFTER the WHERE clause, so they work on whatever they find as the result.**

OVER and WHERE
Very good!

Now, it might be tempting to use window functions in a WHERE clause, as in the example:

SELECT
  first_name,
  last_name,
  salary,
  AVG(salary) OVER()
FROM employee
WHERE salary > AVG(salary) OVER();
However, when you run this query, you'll get an error message.**You cannot put window functions in WHERE. Why? The window functions is applied after the rows are selected. If the window functions were in a WHERE clause, you'd get a circular dependency: in order to compute the window function, you have to filter the rows with WHERE, which requires to compute the window function.**

**Summary**

**Use OVER() to compute an aggregate for all rows in the query result.
The window functions is applied after the rows are filtered by WHERE.
The window functions are used to compute aggregates but keep details of individual rows at the same time.
You can't use window functions in WHERE clauses.**

## 3. OVER(PARTITION BY)

 OVER (PARTITION BY column1, column2 ... column_n)
 
**PARTITION BY works similarly to GROUP BY: it partitions the rows into groups, based on the columns in PARTITION BY clause. Unlike GROUP BY, PARTITION BY does not collapse rows.**

![image](https://github.com/mythilyram/PostgreSQL-Window-functions/assets/123518126/19e1b182-d009-4a14-ac97-d5cc26caacf2)

**With PARTITION BY, you can easily compute the statistics for the whole group but keep details about individual rows.**

What functions can you use with PARTITION BY? You can use an aggregate function that you already know (COUNT(), SUM(), AVG(), etc.), or another function, such as a ranking or an analytical function that you'll get to know in this course. Within parentheses, in turn, we've now put PARTITION BY, followed by the columns by which we want to partition (group).

**Summary
OVER(PARTITION BY x) works in a similar way to GROUP BY, defining the window as all the rows in the query result that have the same value in x.
x can be a single column or multiple columns separated by commas.**

## 4.Ranking Functions

So far, you've learned how to use window functions with aggregate functions that you already know – SUM(), COUNT(), AVG(), MAX() and MIN().

Now, we'll teach you different functions that go well with OVER() – ranking functions. The general syntax is as follows:

**function> OVER (ORDER BY <order by columns>)**
We'll introduce a few possible ranking functions in the next exercises.

As to OVER (ORDER BY col1, col2...), this is the part where you specify the order in which rows should be sorted and therefore ranked.

**Function RANK()**
The most widely used ranking function: RANK(). 

**RANK() OVER (ORDER BY ...)**
What does RANK() do? **It returns the rank (a number) of each row with respect to the sorting specified within parentheses.**

ORDER BY sorts rows and shows them in a specific order to you. **RANK() OVER(ORDER BY ...) is a function that shows the rank(place, position) of each row in a separate column.**
Let's look at an example from our database:


  RANK() OVER(ORDER BY editor_rating)

name	platform	editor_rating	rank
Duck Dash	Android	4	1
The Square	Android	4	1
Hit Brick	Android	4	1
Go Bunny	iOS	5	4
Perfect Time	Windows Phone	6	5
First Finish	Windows Phone	7	6
Froggy Adventure	iOS	7	6
Speed Race	iOS	7	6
Shoot in Time	Android	9	9
Monsters in Dungeon	Android	9	9
Fire Rescue	iOS	9	9
Eternal Stone	iOS	10	12


**As you can see, we get the rank of each game in the last column. There are 3 games with the lowest score – 4. All of them got rank 1.**
The next game, with score 5, got rank 4, not 2. That's how RANK() works. There were three games before the game with score 5, so, being the 4th game, it got rank 4 – regardless of the fact that the other three all got rank 1. RANK() will always leave gaps in numbering when more than 1 row share the same value.

**DENSE_RANK()**
As we said, **RANK() will always leave gaps in numbering when more than 1 row share the same value. You can change that behavior by using another function: DENSE_RANK():**
SELECT
  name,
  platform,
  editor_rating,
  DENSE_RANK() OVER(ORDER BY editor_rating)
FROM game;
**DENSE_RANK gives a 'dense' rank indeed, i.e. there are no gaps in numbering.**


**We've now got three rows with rank 1, followed by a fourth row with rank 2. That's the difference between RANK() and DENSE_RANK() – the latter never leaves gaps.**
name	platform	editor_rating	dense_rank
Duck Dash	Android	4	1
The Square	Android	4	1
Hit Brick	Android	4	1
Go Bunny	iOS	5	2
Perfect Time	Windows Phone	6	3
First Finish	Windows Phone	7	4
Froggy Adventure	iOS	7	4
Speed Race	iOS	7	4
Shoot in Time	Android	9	5
Monsters in Dungeon	Android	9	5
Fire Rescue	iOS	9	5
Eternal Stone	iOS	10	6


**ROW_NUMBER()**
  ROW_NUMBER() OVER(ORDER BY editor_rating)
name	platform	editor_rating	row_number
Duck Dash	Android	4	1
The Square	Android	4	2
Hit Brick	Android	4	3
Go Bunny	iOS	5	4
Perfect Time	Windows Phone	6	5
First Finish	Windows Phone	7	6
Froggy Adventure	iOS	7	7
Speed Race	iOS	7	8
Shoot in Time	Android	9	9
Monsters in Dungeon	Android	9	10
Fire Rescue	iOS	9	11
Eternal Stone	iOS	10	12

**Now, each row gets its own, unique rank number, so even rows with the same value get consecutive numbers.**

**ROW_NUMBER() gives a unique rank number to each row. Even those rows which share the same editor_rating value got different ranks that are expressed as consecutive numbers.
    The only problem is with the order of these consecutive numbers. You could ask yourself – how does my database determine which of the games with editor_rating = 4 gets 1, 2 or 3 as the rank? The answer is – it doesn't, really. The order is nondeterministic. When you execute ROW_NUMBER(), you never really know what the output will be.**


##**RANK(), DENSE_RANK(), ROW_NUMBER()**
Perfect! It's now time to do an exercise where you will use all of the functions together and notice the subtle differences between them.

Exercise
For each game, show its name, genre and date of release. In the next three columns, show RANK(), DENSE_RANK() and ROW_NUMBER() sorted by the date of release.

select
	name,
    genre,
    released,
    **rank() over(order by released),
    dense_rank() over(order by released),
    row_number() over(order by released)**
    from game

    name	genre	released	rank	dense_rank	row_number
Eternal Stone	adventure	2015-03-20	1	1	1
Speed Race	racing	2015-03-20	1	1	2
Froggy Adventure	adventure	2015-05-01	3	2	3
Hit Brick	action	2015-05-01	3	2	4
Go Bunny	action	2015-05-01	3	2	5
Duck Dash	shooting	2015-07-30	6	3	6
Fire Rescue	action	2015-07-30	6	3	7
First Finish	racing	2015-10-01	8	4	8
The Square	action	2015-12-01	9	5	9
Shoot in Time	shooting	2015-12-01	9	5	10
Perfect Time	action	2015-12-01	9	5	11
Monsters in Dungeon	adventure	2015-12-01	9	5	12

**Ranking and ORDER BY
You may wonder if you can use regular ORDER BY with the ranking functions. Of course, you can. The ranking function and the external ORDER BY are independent. The ranking function returns the rank with the respect to the order provided within OVER.** Let's look at the example:

SELECT
  name,
  RANK() OVER (ORDER BY editor_rating)
FROM game
ORDER BY size DESC;
**The query returns the name of the game and the rank of the game with respect to editor ranking. The returned rows are ordered by size of the game in descending way.**

name	rank
Froggy Adventure	6
Speed Race	6
Eternal Stone	12
Shoot in Time	9
Go Bunny	4
The Square	1
Perfect Time	5
Hit Brick	1
First Finish	6
Fire Rescue	9
Duck Dash	1
Monsters in Dungeon	9

NTILE(X)
**It distributes the rows into a specific number of groups, provided as X.** For instance:

SELECT
  name,
  genre,
  editor_rating,
  **NTILE(3) OVER (ORDER BY editor_rating DESC)**
FROM game;

**In the above example, we create three groups with NTILE(3) that are divided based on the values in the column editor_rating. The "best" games will be put in group 1, "average" games in group 2, "worst" games in group 3.** See the picture below:

![image](https://github.com/mythilyram/PostgreSQL-Window-functions/assets/123518126/b2212965-c11f-4a13-9396-3c937c3a1bb4)

**Note that if the number of rows is not divisible by the number of groups, some groups will have one more element than other groups, with larger groups coming first**.

Exercise
We want to divide games into 4 groups with regard to their size, with biggest games coming first. For each game, show its name, genre, size and the group it belongs to.

select
	name, 
    genre, 
    size,
    ntile(4) over(order by size desc)
   from game 
    -- and the group it belongs to.
    
    name	genre	size	ntile
Speed Race	racing	127	1
Froggy Adventure	adventure	127	1
Eternal Stone	adventure	125	1
Shoot in Time	shooting	123	2
Go Bunny	action	101	2
The Square	action	86	2
Perfect Time	action	55	3
Hit Brick	action	54	3
First Finish	racing	44	3
Fire Rescue	action	36	4
Duck Dash	shooting	36	4
Monsters in Dungeon	adventure	10	4

## Selecting n-th row
Explanation
Alright. In the previous section, we've introduced ranking functions whose result was shown as an additional column in our query results. Our game table is pretty small, so it's easy to identify the first, second, or third place manually. In real life, however, we deal with huge tables and looking for one particular rank can be troublesome.

**In this section, we will learn how to create queries that, for instance, return only the row with rank 1, 5, 10, etc.** This cannot be accomplished with a simple query – we will need to create a complex one. For this purpose, we'll use Common Table Expressions. An example may look like this:

**WITH ranking AS (
  SELECT
    name,
    RANK() OVER(ORDER BY editor_rating DESC) AS rank
  FROM game
)
SELECT name
FROM ranking
WHERE rank = 2;
The query returns the name of the game which gets rank number 2 with respect to editor rating.** Don't worry if the query looks complicated. We'll explain it in a second.

#### Create the ranking
Ok, we want to answer the following question: **what is the name of the game with rank 2 in terms of best editor_rating? We create the SQL query to answer this problem in two steps.**

In step 1, we create a ranking, just as we did in the previous section:

SELECT name,
  RANK() OVER(ORDER BY editor_rating DESC) AS rank
FROM game;
This step should be quite obvious now. Let's run it to confirm that it works.
name	rank
Eternal Stone	1
Monsters in Dungeon	2
Shoot in Time	2
Fire Rescue	2
First Finish	5
Froggy Adventure	5
Speed Race	5
Perfect Time	8
Go Bunny	9
Hit Brick	10
The Square	10
Duck Dash	10

The full query
Alright, the query worked the way we wanted.

Now, the second step is to treat our previous example as a subquery and put it in the FROM clause. As you can remember, we previously wrote:

SELECT
  name,
  RANK() OVER(ORDER BY editor_rating DESC) AS rank
FROM game;
and now we'll write this:

WITH ranking AS (
  SELECT
    name,
    RANK() OVER(ORDER BY editor_rating DESC) AS rank
  FROM game
)

SELECT name
FROM ranking
WHERE rank = 2;

name
Monsters in Dungeon
Shoot in Time
Fire Rescue

The first line (WITH ranking AS) tells that what follows is called ranking. Inside the parentheses, we provide the query which we created in the previous step. In the end, all we do is select the row(s) with rank = 2 from the query we named ranking.

**Summary
The most basic usage of ranking functions is: RANK() OVER(ORDER BY column1, column2...).
The ranking functions we have learned:
RANK() – returns the rank (a number) of each row with respect to the sorting specified within parentheses.
DENSE_RANK() – returns a 'dense' rank, i.e. there are no gaps in numbering.
ROW_NUMBER() – returns a unique rank number, so even rows with the same value get consecutive numbers.
NTILE(x) – distributes the rows into a specific number of groups, provided as x.
To get col1 of the row with rank place1 in a ranking sorted by col2, write:
WITH ranking AS
  (SELECT
    RANK() OVER (ORDER BY col2) AS RANK,
    col1
  FROM table_name)
SELECT col1
FROM ranking
WHERE RANK = place1;**

## 5. Window Frame
**Window frames define precisely which rows should be taken into account when computing the results and are always relative to the current row. In this way, we can create new kinds of queries.**

For instance, **you may say that for each row, 3 rows before and 3 rows after it are taken into account; or rows from the beginning of the partition until the current row**. In a moment, you'll discover how such queries can come in handy. Take a look at the example window frame, where two rows before and two rows after the current row are selected:

![image](https://github.com/mythilyram/PostgreSQL-Window-functions/assets/123518126/53f84a56-1ebe-42d8-9103-bfa4131116d1)

**The are two kinds of window frames: those with the keyword ROWS and those with RANGE instead**. The general syntax is as follows:

<window function> OVER (...
  ORDER BY 
  [ROWS|RANGE] <window frame extent>
)
Of course, other elements might be added above (for instance, a PARTITION BY clause), which is why we put dots (...) in the brackets. For now, we'll focus on the meaning of ROWS and RANGE. We'll talk about PARTITION BY later in the course.

Let's take a look at the example:

SELECT
  id,
  total_price,
  SUM(total_price) OVER(
    ORDER BY placed
    ROWS UNBOUNDED PRECEDING)
FROM single_order
In the above query,**we sum the column total_price. For each row, we add the current row AND all the previously introduced rows (UNBOUNDED PRECEDING) to the sum. As a result, the sum will increase with each new order.**


id	total_price	sum
5	602.03	602.03
6	3599.83	4201.86
4	2659.63	6861.49
7	4402.04	11263.53
1	3876.76	15140.29
2	3949.21	19089.50
3	2199.46	21288.96
10	4973.43	26262.39
11	3252.83	29515.22
12	3796.42	33311.64
8	4553.89	37865.53
9	3575.55	41441.08

**Window frame definition**
Okay. Let's jump into the brackets of OVER(...) and discuss the details. We'll start with ROWS, because they are a bit easier to explain than RANGE. The general syntax is as follows:

**ROWS BETWEEN lower_bound AND upper_bound**
You know BETWEEN already – it's used to define a range. So far, you've used it to define a range of values – this time, we're going to use it to define a range of rows instead. What are the two bounds?**The bounds can be any of the five options**:

**UNBOUNDED PRECEDING – the first possible row.
PRECEDING – the n-th row before the current row (instead of n, write the number of your choice).
CURRENT ROW – simply current row.
FOLLOWING – the n-th row after the current row.
UNBOUNDED FOLLOWING – the last possible row.**

**The lower bound must come BEFORE the upper bound. In other words, a construction like: ...ROWS BETWEEN CURRENT ROW AND UNBOUNDED PRECEDING doesn't make sense and you'll get an error if you run it.**

Exercise
Take a look at the example on the right. The query computes:

the total price of all orders placed so far (this kind of sum is called a running total).
the total price of the current order, 3 preceding orders and 3 following orders.

SELECT
  id,
  total_price,
  SUM(total_price) OVER(ORDER BY placed ROWS UNBOUNDED PRECEDING) AS running_total,
  SUM(total_price) OVER(ORDER BY placed ROWS between 3 PRECEDING and 3 FOLLOWING) AS sum_3_before_after
FROM single_order
ORDER BY placed;
id	total_price	running_total	sum_3_before_after
5	602.03	602.03	11263.53
6	3599.83	4201.86	15140.29
4	2659.63	6861.49	19089.50
7	4402.04	11263.53	21288.96
1	3876.76	15140.29	25660.36
2	3949.21	19089.50	25313.36
3	2199.46	21288.96	26450.15
10	4973.43	26262.39	26602.00
11	3252.83	29515.22	26300.79
12	3796.42	33311.64	22351.58
8	4553.89	37865.53	20152.12
9	3575.55	41441.08	15178.69

