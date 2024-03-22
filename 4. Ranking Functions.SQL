Introduction
Welcome! In this part, we'll teach you how to use window functions for something very useful – creating rankings. Which x is the best? Which x is in 3rd place? Which is the worst? These are the questions we're going to answer in this part.

Today, we're going to deal with a development studio that produces games for mobile platforms. Let's take a look at it.

Exercise
Select all the information from table game.

Each game has an id and a name and is runnable on a specific platform. It is characterized by a specific genre, has an editor_rating and size in MB. The column released specifies when the game was released, whereas updated – when the game was last updated.
id	name	platform	genre	editor_rating	size	released	updated
1	Go Bunny	iOS	action	5	101	2015-05-01	2015-07-13
2	Fire Rescue	iOS	action	9	36	2015-07-30	2016-09-27
3	Eternal Stone	iOS	adventure	10	125	2015-03-20	2015-10-25
4	Froggy Adventure	iOS	adventure	7	127	2015-05-01	2015-07-02
5	Speed Race	iOS	racing	7	127	2015-03-20	2015-07-25
6	Monsters in Dungeon	Android	adventure	9	10	2015-12-01	2015-12-15
7	Shoot in Time	Android	shooting	9	123	2015-12-01	2016-03-20
8	Hit Brick	Android	action	4	54	2015-05-01	2016-01-05
9	The Square	Android	action	4	86	2015-12-01	2016-03-16
10	Duck Dash	Android	shooting	4	36	2015-07-30	2016-05-23
11	Perfect Time	Windows Phone	action	6	55	2015-12-01	2016-01-07
12	First Finish	Windows Phone	racing	7	44	2015-10-01	2016-02-20

Table purchase
Fine. Now, the second table, which we'll use much later in this part of the course.

Exercise
Select all the information from the purchase table.

Each purchase of a game is stored in this table. The purchase has its own id, the id of the game, the price paid and the date of purchase.

id	game_id	price	date
1	7	15.99	2016-03-07
2	12	13.99	2016-08-13
3	6	11.99	2016-01-21
4	11	7.99	2016-10-21
5	4	12.99	2016-05-03
6	2	1.99	2016-07-08
7	2	5.99	2016-03-29
8	10	18.99	2016-01-05
9	8	3.99	2016-07-18
10	4	7.99	2016-06-04
11	12	14.99	2016-10-16
12	10	15.99	2016-08-23
13	5	13.99	2016-09-20
14	9	14.99	2016-07-17
15	10	10.99	2016-06-07
16	2	1.99	2016-06-09
17	8	8.99	2016-04-13
18	1	6.99	2016-01-12
19	2	3.99	2016-06-18
20	6	19.99	2016-08-07
21	6	7.99	2016-04-06
22	12	5.99	2016-07-24
23	2	10.99	2016-08-05
24	12	16.99	2016-07-21
25	9	4.99	2016-10-05
26	8	11.99	2016-02-27
27	12	15.99	2016-05-26
28	3	17.99	2016-01-30
29	9	7.99	2016-01-21
30	8	19.99	2016-06-28
31	2	7.99	2016-07-09
32	9	1.99	2016-10-14
33	5	15.99	2016-07-04
34	4	19.99	2016-01-27
35	5	14.99	2016-04-06
36	4	13.99	2016-03-27
37	5	12.99	2016-07-19
38	12	7.99	2016-06-20
39	11	4.99	2016-01-02
40	1	8.99	2016-08-17
41	4	18.99	2016-06-02
42	8	7.99	2016-04-20
43	5	14.99	2016-06-05
44	2	7.99	2016-04-08
45	8	17.99	2016-06-03
46	6	16.99	2016-10-10
47	3	13.99	2016-10-04
48	1	9.99	2016-09-29
49	3	9.99	2016-03-25
50	7	13.99	2016-02-01
51	4	15.99	2016-08-29
52	3	9.99	2016-03-13
53	6	14.99	2016-04-29
54	12	6.99	2016-05-09
55	9	14.99	2016-06-07
56	8	18.99	2016-09-24
57	6	8.99	2016-10-30
58	11	4.99	2016-05-11
59	2	8.99	2016-08-22
60	9	2.99	2016-03-24

Ranking functions - introduction
Let's get down to work. So far, you've learned how to use window functions with aggregate functions that you already know – SUM(), COUNT(), AVG(), MAX() and MIN().

Now, we'll teach you different functions that go well with OVER() – ranking functions. The general syntax is as follows:

function> OVER (ORDER BY <order by columns>)
We'll introduce a few possible ranking functions in the next exercises.

As to OVER (ORDER BY col1, col2...), this is the part where you specify the order in which rows should be sorted and therefore ranked.

Function RANK()
Alright. We'll start with the most widely used ranking function: RANK(). The syntax is as follows:

RANK() OVER (ORDER BY ...)
What does RANK() do? It returns the rank (a number) of each row with respect to the sorting specified within parentheses.

ORDER BY sorts rows and shows them in a specific order to you. RANK() OVER(ORDER BY ...) is a function that shows the rank(place, position) of each row in a separate column.

Let's look at an example from our database:

SELECT
  name,
  platform,
  editor_rating,
  RANK() OVER(ORDER BY editor_rating)
FROM game;
The first three columns are quite obvious, but look what happens next: we want to return the rank (RANK()) of each row when we sort them by the column editor_rating (OVER(ORDER BY editor_rating).

Exercise
Look at the result of the example query on the right.

As you can see, we get the rank of each game in the last column. There are 3 games with the lowest score – 4. All of them got rank 1.

The next game, with score 5, got rank 4, not 2. That's how RANK() works. There were three games before the game with score 5, so, being the 4th game, it got rank 4 – regardless of the fact that the other three all got rank 1. RANK() will always leave gaps in numbering when more than 1 row share the same value.

So far, you've learned how to use window functions with aggregate functions that you already know – SUM(), COUNT(), AVG(), MAX() and MIN().


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

Exercise
For each game, show name, genre, date of update and its rank. The rank should be created with RANK() and take into account the date of update.
SELECT
  name,
  genre,
  updated ,
  RANK() OVER(ORDER BY updated)
FROM game;
name	genre	updated	rank
Froggy Adventure	adventure	2015-07-02	1
Go Bunny	action	2015-07-13	2
Speed Race	racing	2015-07-25	3
Eternal Stone	adventure	2015-10-25	4
Monsters in Dungeon	adventure	2015-12-15	5
Hit Brick	action	2016-01-05	6
Perfect Time	action	2016-01-07	7
First Finish	racing	2016-02-20	8
The Square	action	2016-03-16	9
Shoot in Time	shooting	2016-03-20	10
Duck Dash	shooting	2016-05-23	11
Fire Rescue	action	2016-09-27	12

DENSE_RANK()
Perfect!

As we said, RANK() will always leave gaps in numbering when more than 1 row share the same value. You can change that behavior by using another function: DENSE_RANK():

SELECT
  name,
  platform,
  editor_rating,
  DENSE_RANK() OVER(ORDER BY editor_rating)
FROM game;
DENSE_RANK gives a 'dense' rank indeed, i.e. there are no gaps in numbering.

Exercise
Click RUN AND CHECK CODE to run the modified example.

We've now got three rows with rank 1, followed by a fourth row with rank 2. That's the difference between RANK() and DENSE_RANK() – the latter never leaves gaps.

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

Exercise
Use DENSE_RANK() and for each game, show name, size and the rank in terms of its size.

SELECT
  name,
  size,
  DENSE_RANK() OVER(ORDER BY size)
FROM game;


name	size	dense_rank
Monsters in Dungeon	10	1
Fire Rescue	36	2
Duck Dash	36	2
First Finish	44	3
Hit Brick	54	4
Perfect Time	55	5
The Square	86	6
Go Bunny	101	7
Shoot in Time	123	8
Eternal Stone	125	9
Speed Race	127	10
Froggy Adventure	127	10

ROW_NUMBER()
All right, and now, let us take a look at yet another way of ranking:

SELECT
  name,
  platform,
  editor_rating,
  ROW_NUMBER() OVER(ORDER BY editor_rating)
FROM game;
Let's run the example to see what's different now.

Exercise
Run the third example and see the difference in ranking.

Now, each row gets its own, unique rank number, so even rows with the same value get consecutive numbers.

ROW_NUMBER() – practice
Great. As you can see, ROW_NUMBER() gives a unique rank number to each row. Even those rows which share the same editor_rating value got different ranks that are expressed as consecutive numbers.

The only problem is with the order of these consecutive numbers. You could ask yourself – how does my database determine which of the games with editor_rating = 4 gets 1, 2 or 3 as the rank? The answer is – it doesn't, really. The order is nondeterministic. When you execute ROW_NUMBER(), you never really know what the output will be.

Now, how about an exercise for you?

Exercise
Use ROW_NUMBER() and for each game, show their name, date of release and the rank based on the date of release.
select 
	name,
    released,
    row_number() over(order by released)
    from game

name	released	row_number
Eternal Stone	2015-03-20	1
Speed Race	2015-03-20	2
Froggy Adventure	2015-05-01	3
Hit Brick	2015-05-01	4
Go Bunny	2015-05-01	5
Duck Dash	2015-07-30	6
Fire Rescue	2015-07-30	7
First Finish	2015-10-01	8
The Square	2015-12-01	9
Shoot in Time	2015-12-01	10
Perfect Time	2015-12-01	11
Monsters in Dungeon	2015-12-01	12

RANK(), DENSE_RANK(), ROW_NUMBER()
Perfect! It's now time to do an exercise where you will use all of the functions together and notice the subtle differences between them.

Exercise
For each game, show its name, genre and date of release. In the next three columns, show RANK(), DENSE_RANK() and ROW_NUMBER() sorted by the date of release.

select
	name,
    genre,
    released,
    rank() over(order by released),
    dense_rank() over(order by released),
    row_number() over(order by released)
    from game
RANK() OVER(ORDER BY ... DESC)
Good job! You may have noticed that the rank given by the function may be counter-intuitive to some extent. When we showed the rank sorted by editor_rating, the game with the lowest score got a rank of 1. We usually want it the other way around – the first place should be occupied by the best game. Luckily, this requires a very minor change to our query:

SELECT
  name,
  platform,
  editor_rating,
  RANK() OVER(ORDER BY editor_rating DESC)
FROM game;
Voila, add DESC after the column name in OVER( ... ) and the ranking order is reversed.

Exercise
Let's use DENSE_RANK() to show the latest games from our studio. For each game, show its name, genre, date of release and DENSE_RANK() in the descending order.
select
	name,
    genre,
    released,
    dense_rank() over(order by released desc)
        from game

name	genre	released	dense_rank
Monsters in Dungeon	adventure	2015-12-01	1
Perfect Time	action	2015-12-01	1
The Square	action	2015-12-01	1
Shoot in Time	shooting	2015-12-01	1
First Finish	racing	2015-10-01	2
Fire Rescue	action	2015-07-30	3
Duck Dash	shooting	2015-07-30	3
Go Bunny	action	2015-05-01	4
Hit Brick	action	2015-05-01	4
Froggy Adventure	adventure	2015-05-01	4
Eternal Stone	adventure	2015-03-20	5
Speed Race	racing	2015-03-20	5

RANK() with ORDER BY many columns
Great. Yet another thing you can do is rank by multiple columns, each of them in the ascending or descending order of your choice. Let's pretend that a player named John has limited space on his phone, but he wants to install a relatively recent game. Take a look:

SELECT
  name,
  genre,
  editor_rating,
  RANK() OVER(ORDER BY released DESC, size ASC)
FROM game;
We first sort the rows by the release date, with the latest games coming first, and then by size, with the smallest games appearing before bigger games.

Exercise
We want to find games which were both recently released and recently updated. For each game, show name, date of release and last update date, as well as their rank: use ROW_NUMBER(), sort by release date and then by update date, both in the descending order.
select
	name,
    released,
    updated,
    row_number() over(order by released desc,updated desc)
    from game
name	released	updated	row_number
Shoot in Time	2015-12-01	2016-03-20	1
The Square	2015-12-01	2016-03-16	2
Perfect Time	2015-12-01	2016-01-07	3
Monsters in Dungeon	2015-12-01	2015-12-15	4
First Finish	2015-10-01	2016-02-20	5
Fire Rescue	2015-07-30	2016-09-27	6
Duck Dash	2015-07-30	2016-05-23	7
Hit Brick	2015-05-01	2016-01-05	8
Go Bunny	2015-05-01	2015-07-13	9
Froggy Adventure	2015-05-01	2015-07-02	10
Eternal Stone	2015-03-20	2015-10-25	11
Speed Race	2015-03-20	2015-07-25	12

Ranking and ORDER BY
Very good! You may wonder if you can use regular ORDER BY with the ranking functions. Of course, you can. The ranking function and the external ORDER BY are independent. The ranking function returns the rank with the respect to the order provided within OVER. Let's look at the example:

SELECT
  name,
  RANK() OVER (ORDER BY editor_rating)
FROM game
ORDER BY size DESC;
The query returns the name of the game and the rank of the game with respect to editor ranking. The returned rows are ordered by size of the game in descending way.

Exercise
For each game find its name, genre, its rank by size. Order the games by date of release with newest games coming first.

Exercise
For each game find its name, genre, its rank by size. Order the games by date of release with newest games coming first.

select	
	name,
    genre,
    rank() over(order by size)
    from game
    order by released desc

name	genre	rank
Monsters in Dungeon	adventure	1
Perfect Time	action	6
The Square	action	7
Shoot in Time	shooting	9
First Finish	racing	4
Duck Dash	shooting	2
Fire Rescue	action	2
Froggy Adventure	adventure	11
Go Bunny	action	8
Hit Brick	action	5
Speed Race	racing	11
Eternal Stone	adventure	10

ROW NUMBER with ORDER BY
Perfect! Let's try another one.

Exercise
For each purchase, find the name of the game, the price, and the date of the purchase. Give purchases consecutive numbers by date when the purchase happened, so that the latest purchase gets number 1. Order the result by editor's rating of the game.
select
	g.name,
    p.price,
    p.date,
    row_number() over(order by date desc)
    from purchase p
    join game g
    on p.game_id = g.id
    order by editor_rating
    name	price	date	row_number
The Square	14.99	2016-07-17	22
Hit Brick	7.99	2016-04-20	41
Hit Brick	11.99	2016-02-27	52
The Square	2.99	2016-03-24	49
The Square	4.99	2016-10-05	6
Duck Dash	18.99	2016-01-05	59
Hit Brick	3.99	2016-07-18	21
Hit Brick	8.99	2016-04-13	42
Hit Brick	19.99	2016-06-28	26
Hit Brick	18.99	2016-09-24	9
Hit Brick	17.99	2016-06-03	34
The Square	14.99	2016-06-07	30
Duck Dash	10.99	2016-06-07	31
The Square	1.99	2016-10-14	4
Duck Dash	15.99	2016-08-23	12
The Square	7.99	2016-01-21	57
Go Bunny	9.99	2016-09-29	8
Go Bunny	6.99	2016-01-12	58
Go Bunny	8.99	2016-08-17	14
Perfect Time	7.99	2016-10-21	2
Perfect Time	4.99	2016-05-11	37
Perfect Time	4.99	2016-01-02	60
First Finish	13.99	2016-08-13	15
First Finish	14.99	2016-10-16	3
Speed Race	13.99	2016-09-20	10
Froggy Adventure	15.99	2016-08-29	11
First Finish	5.99	2016-07-24	18
First Finish	16.99	2016-07-21	19
Speed Race	12.99	2016-07-19	20
Speed Race	15.99	2016-07-04	25
First Finish	7.99	2016-06-20	27
Speed Race	14.99	2016-06-05	32
Froggy Adventure	7.99	2016-06-04	33
Froggy Adventure	18.99	2016-06-02	35
First Finish	15.99	2016-05-26	36
First Finish	6.99	2016-05-09	38
Froggy Adventure	12.99	2016-05-03	39
Speed Race	14.99	2016-04-06	45
Froggy Adventure	13.99	2016-03-27	47
Froggy Adventure	19.99	2016-01-27	55
Monsters in Dungeon	14.99	2016-04-29	40
Fire Rescue	7.99	2016-07-09	23
Fire Rescue	7.99	2016-04-08	43
Monsters in Dungeon	7.99	2016-04-06	44
Fire Rescue	8.99	2016-08-22	13
Fire Rescue	5.99	2016-03-29	46
Fire Rescue	3.99	2016-06-18	28
Monsters in Dungeon	11.99	2016-01-21	56
Monsters in Dungeon	8.99	2016-10-30	1
Fire Rescue	1.99	2016-07-08	24
Fire Rescue	10.99	2016-08-05	17
Shoot in Time	15.99	2016-03-07	51
Monsters in Dungeon	19.99	2016-08-07	16
Shoot in Time	13.99	2016-02-01	53
Fire Rescue	1.99	2016-06-09	29
Monsters in Dungeon	16.99	2016-10-10	5
Eternal Stone	13.99	2016-10-04	7
Eternal Stone	9.99	2016-03-25	48
Eternal Stone	17.99	2016-01-30	54
Eternal Stone	9.99	2016-03-13	50

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

Exercise
Split the games into 5 groups based on their date of last update. The most recently updated games should come first. For each of them, show the name, genre, date of update and the group they were assigned to. In the result, notice how many items the groups have (varying value).

select
	name, 
    genre, 
    updated,
    ntile(5) over(order by updated desc)
   from game
name	genre	updated	ntile
Fire Rescue	action	2016-09-27	1
Duck Dash	shooting	2016-05-23	1
Shoot in Time	shooting	2016-03-20	1
The Square	action	2016-03-16	2
First Finish	racing	2016-02-20	2
Perfect Time	action	2016-01-07	2
Hit Brick	action	2016-01-05	3
Monsters in Dungeon	adventure	2015-12-15	3
Eternal Stone	adventure	2015-10-25	4
Speed Race	racing	2015-07-25	4
Go Bunny	action	2015-07-13	5
Froggy Adventure	adventure	2015-07-02	5

Explanation
Alright. In the previous section, we've introduced ranking functions whose result was shown as an additional column in our query results. Our game table is pretty small, so it's easy to identify the first, second, or third place manually. In real life, however, we deal with huge tables and looking for one particular rank can be troublesome.

In this section, we will learn how to create queries that, for instance, return only the row with rank 1, 5, 10, etc. This cannot be accomplished with a simple query – we will need to create a complex one. For this purpose, we'll use Common Table Expressions. An example may look like this:

WITH ranking AS (
  SELECT
    name,
    RANK() OVER(ORDER BY editor_rating DESC) AS rank
  FROM game
)

SELECT name
FROM ranking
WHERE rank = 2;
The query returns the name of the game which gets rank number 2 with respect to editor rating. Don't worry if the query looks complicated. We'll explain it in a second.

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

Practice 1
Great. It's time for some practice, let's give it a try.

Exercise
Find the name, genre and size of the smallest game in our studio.

Remember the steps:

Create the ranking query so that the smallest game gets rank 1.
Use WITH to select rows with rank 1.
with ranking as(select
	name, 
    genre,
    size,
    rank() over(order by size) as rank
 from game   )
 select 
    name, 
    genre,
    size
    from ranking
    where rank=1
name	genre	size
Monsters in Dungeon	adventure	10

Practice 2
Perfect! Another exercise is waiting for you.

Exercise
Show the name, platform and update date of the second most recently updated game.
with ranking as(select
	name, 
    platform,
    updated,
    rank() over(order by updated desc) as rank
 from game   )
 select 
   	name, 
    platform,
    updated
    from ranking
    where rank=2
name	platform	updated
Duck Dash	Android	2016-05-23

Summary
That was another correct answer! Okay, let's review what we've learned in this part:

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
WHERE RANK = place1;

Table application
You know the game and purchase table very well now, so let's change the table during our quiz. The game studio decided to start making applications as well. Let's see what information we can find in the application table.

Exercise
Select all information from the application table.

Each application has an id and a name, is intended for a specific platform and has a certain type. We also have the average_rating from users, the numbers of downloads and the overall income it generated.

id	name	platform	type	average_rating	downloads	income
1	Manage your budget	iOS	business	4.6407751550	34989	804397.11
2	Banking App	iOS	business	5.3498863368	4970	79470.30
3	CouchSurfing	iOS	travel	6.3912259350	20210	646517.90
4	Shopping List	iOS	utility	6.0639225361	33594	940296.06
5	Stock 24 News	Android	business	5.6434623087	8295	348307.05
6	Perfect Notes	Android	utility	9.9605993188	29703	742277.97
7	Amazing filters	Android	camera	8.7427015833	4120	197718.80
8	OverseasTrade	Windows Phone	business	9.5007765361	12502	74886.98
9	Scientific Calculator	Windows Phone	utility	5.7217209288	13015	572529.85
10	Corporate Chat	Windows Phone	business	6.9995402484	13712	603190.88
11	Click & Travel	Windows Phone	travel	5.5346579098	26192	602154.08
12	Cheap Apartments	Windows Phone	travel	5.7184126335	12727	432590.73

Exercise 1
Let's start easy!

Exercise
For each application, show its name, average_rating and its rank, with best rated apps coming first.

select
 	name,
    average_rating,
    rank() over(order by average_rating desc)
    from application
name	average_rating	rank
Perfect Notes	9.9605993188	1
OverseasTrade	9.5007765361	2
Amazing filters	8.7427015833	3
Corporate Chat	6.9995402484	4
CouchSurfing	6.3912259350	5
Shopping List	6.0639225361	6
Scientific Calculator	5.7217209288	7
Cheap Apartments	5.7184126335	8
Stock 24 News	5.6434623087	9
Click & Travel	5.5346579098	10
Banking App	5.3498863368	11
Manage your budget	4.6407751550	12

Exercise 2
Nice! Another exercise now.

Exercise
Find the application that ranked 3rd in terms of the greatest number of downloads. Show its name and the number of downloads.
with cte as(select
 	name,
   downloads,
    rank() over(order by downloads desc) as rank
    from application)
select
	name,
    downloads
    from cte
    where rank = 3

name	downloads
Perfect Notes	29703


