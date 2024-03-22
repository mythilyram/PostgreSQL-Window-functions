Introduction
Hello and welcome! Today, we're finally going to define the windows of window functions in detail.

Let's start by introducing today's tables. We're going to work for a company called ColdLikeHell which deals with... well, everything that is somehow connected to ice. Let's check the products.

Exercise
Select all the information from the product table.

Just take a look at all those wonderful products! Each of them has an id, a name, and a third column which informs when it was introduced to the market.
id	name	introduced
1	Frozen Yoghurt	2016-01-26
2	Ice cubes	2016-04-10
3	Ice cream	2016-01-05
4	Skis	2016-04-09
5	Snowboard	2016-02-01
6	Sledge	2016-02-20
7	Freezer	2016-01-16

Table stock_change
Alright, another table.

Exercise
Select all the information from stock_change table.

A single row in stock_change means that either a given number of products left the warehouse, or were delivered to the warehouse.

You can find:

the id of the change.
the product_id.
the quantity (positive values mean delivery, negative values mean the products left the warehouse).
the changed when it happened.

id	product_id	quantity	changed
1	5	-90	2016-09-11
2	2	-91	2016-08-16
3	5	-15	2016-06-08
4	2	51	2016-06-10
5	1	-58	2016-08-09
6	1	-84	2016-09-28
7	4	56	2016-06-09
8	5	73	2016-09-22
9	1	-43	2016-06-07
10	2	-79	2016-07-27
11	4	93	2016-09-22
12	4	74	2016-06-13
13	2	-37	2016-08-02
14	7	19	2016-07-14
15	7	-72	2016-09-13
16	7	-13	2016-08-28
17	3	23	2016-07-24
18	1	24	2016-08-17
19	3	77	2016-08-11
20	1	24	2016-08-28

Table single_order
Let's check the third table.

Exercise
Select all the information from the single_order table.

A pretty simple table, each order has an id, was placed on a specific day and has a given total_price
id	placed	total_price
1	2016-07-10	3876.76
2	2016-07-10	3949.21
3	2016-07-18	2199.46
4	2016-06-13	2659.63
5	2016-06-13	602.03
6	2016-06-13	3599.83
7	2016-06-29	4402.04
8	2016-08-21	4553.89
9	2016-08-30	3575.55
10	2016-08-01	4973.43
11	2016-08-05	3252.83
12	2016-08-05	3796.42

Table order_position
One more table and you're good to go!

Exercise
Select all the information from the order_position table.

Each order_position is a single position in an order (you may think of it as a position in an invoice). It has its own id, the id of the product, id of the order, and the quantity of the product.

id	product_id	order_id	quantity
1	1	9	7
2	1	6	15
3	7	2	1
4	1	4	24
5	1	5	16
6	3	8	7
7	5	12	5
8	2	12	1
9	5	10	20
10	2	8	14
11	4	6	28
12	6	3	15
13	6	6	16
14	4	1	8
15	2	8	13
16	5	4	27
17	2	8	30
18	7	6	29
19	1	10	6
20	6	5	21
21	1	11	9
22	6	7	4
23	5	8	27
24	7	1	25
25	4	3	16
26	5	5	4
27	4	6	1
28	2	6	5
29	5	4	29
30	4	11	21
31	4	10	18
32	6	1	5
33	4	5	5
34	3	12	19
35	6	5	29
36	5	9	21
37	6	7	25
38	4	4	3
39	6	9	21
40	3	4	15
41	6	12	17
42	2	3	18
43	2	7	30
44	5	5	2
45	6	3	26
46	3	3	13
47	2	8	29
48	7	11	26
49	3	8	12
50	3	6	4

General syntax
Alright. Let's get down to work. In this part, we're finally going to learn about window frames.

Window frames define precisely which rows should be taken into account when computing the results and are always relative to the current row. In this way, we can create new kinds of queries.

For instance, you may say that for each row, 3 rows before and 3 rows after it are taken into account; or rows from the beginning of the partition until the current row. In a moment, you'll discover how such queries can come in handy. Take a look at the example window frame, where two rows before and two rows after the current row are selected:


The are two kinds of window frames: those with the keyword ROWS and those with RANGE instead. The general syntax is as follows:

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
In the above query, we sum the column total_price. For each row, we add the current row AND all the previously introduced rows (UNBOUNDED PRECEDING) to the sum. As a result, the sum will increase with each new order.



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

First exercise
Okay! It's your turn to write a query!

Here is a syntax reminder:

SELECT
  id,
  quantity,
  changed,
  SUM(quantity) OVER(
    ORDER BY changed
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM stock_change
Exercise
For each order, show its id, the placed date, and the third column which will count the number of orders up to the current order when sorted by the placed date.

SELECT
  id,
  placed,
  count(id) OVER(
    ORDER BY placed
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM single_order
id	placed	count
5	2016-06-13	1
6	2016-06-13	2
4	2016-06-13	3
7	2016-06-29	4
1	2016-07-10	5
2	2016-07-10	6
3	2016-07-18	7
10	2016-08-01	8
11	2016-08-05	9
12	2016-08-05	10
8	2016-08-21	11
9	2016-08-30	12

Rows – exercise 1
Perfect. Let's do a couple of exercises to practice.

Exercise
Warehouse workers always need to pick the products for orders by hand and one by one. For positions with order_id = 5, calculate the remaining sum of all the products to pick. For each position from that order, show its id, the id of the product, the quantity and the quantity of the remaining items (including the current row) when sorted by the id in the ascending order.
select
	op.id,
    op.product_id,
    op.quantity,
    sum(op.quantity) over(order by op.id rows BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
from order_position op
where order_id = 5
id	product_id	quantity	sum
5	1	16	77
20	6	21	61
26	5	4	40
33	4	5	36
35	6	29	31
44	5	2	2
