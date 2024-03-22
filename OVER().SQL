We'll start with introducing today's tables. We're going to deal with employees, their departments and purchases in each department.

select * from employee

id	first_name	last_name	department_id	salary	years_worked
1	Diane	Turner	1	5330	4
2	Clarence	Robinson	1	3617	2
3	Eugene	Phillips	1	4877	2
4	Philip	Mitchell	1	5259	3
5	Ann	Wright	2	2094	5
6	Charles	Wilson	2	5167	5
7	Russell	Johnson	2	3762	4
8	Jacqueline	Cook	2	6923	3
9	Larry	Lee	3	2796	4
10	Willie	Patterson	3	4771	5
11	Janet	Ramirez	3	3782	2
12	Doris	Bryant	3	6419	1
13	Amy	Williams	3	6261	1
14	Keith	Scott	3	4928	8
15	Karen	Morris	4	6347	6
16	Kathy	Sanders	4	6286	1
17	Joe	Thompson	5	5639	3
18	Barbara	Clark	5	3232	1
19	Todd	Bell	5	4653	1
20	Ronald	Butler	5	2076	5

select * from department

id	name
1	IT
2	Management
3	Human Resources
4	Accounting
5	Help Desk

select * from purchase


id	department_id	item	price
1	4	monitor	531
2	1	printer	315
3	3	whiteboard	170
4	5	training	117
5	3	computer	2190
6	1	monitor	418
7	3	whiteboard	120
8	3	monitor	388
9	5	paper	37
10	1	paper	695
11	3	projector	407
12	4	garden party	986
13	5	projector	481
14	2	chair	180
15	2	desk	854
16	2	post-it	15
17	3	paper	60
18	2	tv	943
19	2	desk	478
20	5	keyboard	214

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

Exercise
For each item in the purchase table, select its name (column item), price and the average price of all items.

select
		item, 
        price,
        avg(price) over()
from purchase;        

item	price	avg
monitor	531	479.9500000000000000
printer	315	479.9500000000000000
whiteboard	170	479.9500000000000000

Computations with OVER()
Typically, OVER() is used to compare the current row with an aggregate. For example, we can compute the difference between employee's salary and the average salary. Actually, why don't we calculate the difference between these two values? Take a look:

SELECT
  first_name,
  last_name,
  salary,
  AVG(salary) OVER(),
  salary - AVG(salary) OVER() as difference
FROM employee;
The last column shows the difference between the employee's salary and the average salary. That's the typical usage of window functions: compare the current row with an aggregate for a group of rows. With window functions you can do such comparisons with one simple query.

Exercise
For each employee in table employee, select first and last name, years_worked, average of years spent in the company by all employees, and the difference between the years_worked and the average as difference.

select 
		first_name,
        last_name,
        years_worked,
        avg(years_worked) over(),
        years_worked - avg(years_worked) over() as difference
        
        from employee

Computations with OVER() - exercise 2
That's right. Now, take a look at another interesting example:

SELECT
  id,
  item,
  price,
  price::numeric / SUM(price) OVER()
FROM purchase
WHERE department_id = 2;
In the above query, we show all purchases from the department with id = 2. Note that we divide the price of the item purchased by the total price of all items purchased by that department. In this way, we can check what part of all expenditures each purchase constitutes.

Exercise
For all employees from department with department_id = 3, show their:

first_name.
last_name.
salary.
the difference of their salary to the average of all salaries in that department as difference.

OVER() and COUNT()
Good job! You can use all aggregate functions with OVER(). Let's try an example with COUNT:

SELECT 
  id, 
  name, 
  COUNT(id) OVER()
FROM department
ORDER BY name ASC;
Here, we show the id and name of each department, plus the number of all departments. At the end, we sort the rows by name.

Exercise
For each employee that earns more than 4000, show their first_name, last_name, salary and the number of all employees who earn more than 4000.

Select 
	first_name, 
    last_name, 
    salary,
    count(id) over()
 from employee
 where salary > 4000

first_name	last_name	salary	count
Diane	Turner	5330	13
Eugene	Phillips	4877	13
Philip	Mitchell	5259	13

Exercise
For each purchase with department_id = 3, show its:

id.
department_id.
item.
price.
maximum price from all purchases in this department.
the difference between the maximum price and the price.

select id, department_id, item, price,
	max(price) over(),
	(max(price) over()  - price) as difference 
from purchase
WHERE department_id = 3;

id	department_id	item	price	max	difference
3	3	whiteboard	170	2190	2020
5	3	computer	2190	2190	0
7	3	whiteboard	120	2190	2070

Exercise
For each purchase from any department, show its id, item, price, average price and the sum of all prices in that table.

select id, item, price, 
	avg(price) over(),
    sum(price) over()
from purchase    

id	item	price	avg	sum
1	monitor	531	479.9500000000000000	9599
2	printer	315	479.9500000000000000	9599
3	whiteboard	170	479.9500000000000000	9599

Range of OVER()
Alright. Of course, you can add a WHERE clause just as you do in any other query:

SELECT
  first_name,
  last_name,
  salary,
  AVG(salary) OVER(),
  salary - AVG(salary) OVER()
FROM employee
WHERE department_id = 1;
Now, we only calculate the salaries in the department with id = 1. Two exercises ago, we said that OVER() means 'for all rows in the query result'. This 'in the query result' part is very important – window functions work only on the rows returned by the query.

Here, this means we'll get the salary of each IT department employee and the average salary in that department, and not in the entire company.That's a very important rule which you need to remember. Window functions are always executed AFTER the WHERE clause, so they work on whatever they find as the result.

Exercise
Show the first_name, last_name and salary of every person who works in departments with id 1, 2 or 3, along with the average salary calculated in those three departments.

select first_name, last_name, salary,
	avg(salary) over()
from employee
where department_id	 in (1,2,3)

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
However, when you run this query, you'll get an error message. You cannot put window functions in WHERE. Why? The window functions is applied after the rows are selected. If the window functions were in a WHERE clause, you'd get a circular dependency: in order to compute the window function, you have to filter the rows with WHERE, which requires to compute the window function.

Summary
Great! Let's review what we've learned so far.

Use OVER() to compute an aggregate for all rows in the query result.
The window functions is applied after the rows are filtered by WHERE.
The window functions are used to compute aggregates but keep details of individual rows at the same time.
You can't use window functions in WHERE clauses.

