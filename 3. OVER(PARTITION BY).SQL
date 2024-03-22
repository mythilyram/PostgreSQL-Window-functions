New tables

Introduction
Hello again. Previously, we taught you the simplest window function type – an aggregate with OVER(). In that case, the window consisted of all the rows in the query result. Today, we'll show you how you can change that window.

But before we do, we're going to take a short trip... by train. Let's get to know today's system for managing trains, routes, relations and tickets of a railway company in the UK.

Exercise
Select all the information from the table train.

Each train has an id, model, maximum speed expressed in km/h, production year, the number of first class seats and second class seats. Pretty intuitive, right?

select * from train

id	model	max_speed	production_year	first_class_places	second_class_places
1	InterCity 100	160	2000	30	230
2	InterCity 100	160	2000	40	210
3	InterCity 125	200	2001	40	180
4	Pendolino 390	240	2012	45	150
5	Pendolino ETR310	240	2010	50	250
6	Pendolino 390	240	2010	60	250

Select all the information from the table route.

A route in our system is, in other words, a railroad connection between point A and B.

Each route has its own id, its friendly name, the from_city and the to_city, as well as the distance between these two cities in kilometers.

For simplicity, we assume that we only have intercity trains, i.e. there are no stations between from_city and to_city where the train could stop.

id	name	from_city	to_city	distance
1	Manchester Express	Sheffield	Manchester	60
2	GoToLeads	Manchester	Leeds	70
3	StudentRoute	London	Oxford	90
4	MiddleEnglandWay	London	Leicester	160
5	BeatlesRoute	Liverpool	York	160
6	NewcastleDaily	York	Newcastle	135
7	ScotlandSpeed	Newcastle	Edinburgh	200

Select all the information from the table journey.

Journey in our database is what passengers can buy tickets for. Each journey has its own id, is operated by a certain train, goes via a certain route on a certain day.

Take a look at the first row: if you had wanted to go from Sheffield to Manchester with train 1 on 3 Jan 2016, you would have bought a ticket for journey with id 1.


id	train_id	route_id	date
1	1	1	2016-01-03
2	1	2	2016-01-04
3	1	3	2016-01-05
4	1	4	2016-01-06
5	2	2	2016-01-03
6	2	3	2016-01-04
7	2	4	2016-01-05
8	2	5	2016-01-06
9	3	3	2016-01-03
10	3	5	2016-01-04
11	3	5	2016-01-05
12	3	6	2016-01-06
13	4	4	2016-01-04
14	4	5	2016-01-04
15	4	6	2016-01-05
16	4	7	2016-01-06
17	5	2	2016-01-03
18	5	1	2016-01-05
19	5	3	2016-01-05
20	5	1	2016-03-06
21	6	3	2016-01-03
22	6	3	2016-01-04
23	6	1	2016-01-05
24	6	4	2016-01-06
25	1	5	2016-01-03
26	6	1	2016-01-04
27	3	3	2016-01-05
28	4	6	2016-01-06
29	3	4	2016-01-03
30	5	6	2016-01-04

Exercise
Finally, there are tickets. Each ticket has its own id, price, seat class (1st or 2nd class) and the journey id for which it was bought. Show all these columns.

id	price	class	journey_id
1	200	2	24
2	76	1	12
3	102	2	6
4	126	2	11
5	80	1	17
6	74	1	5
7	200	2	5
8	66	1	17
9	59	1	22
10	134	2	11
11	60	1	6
12	89	1	14
13	71	1	3
14	99	1	7
15	166	2	3
16	154	2	6
17	76	1	23
18	106	2	23
19	97	1	7
20	124	2	19
21	146	2	10
22	50	1	8
23	62	1	1
24	90	1	23
25	88	1	4
26	128	2	8
27	75	1	15
28	140	2	4
29	67	1	9
30	68	1	20
31	192	2	15
32	83	1	9
33	200	2	8
34	200	2	21
35	52	1	19
36	144	2	24
37	99	1	2
38	98	1	24
39	178	2	17
40	164	2	23
41	190	2	11
42	76	1	22
43	100	2	12
44	65	1	13
45	130	2	5
46	67	1	14
47	160	2	19
48	166	2	3
49	172	2	13
50	150	2	1
51	188	2	22
52	126	2	23
53	70	1	8
54	52	1	23
55	198	2	22
56	172	2	12
57	81	1	6
58	126	2	12
59	116	2	15
60	99	1	14
61	62	1	8
62	168	2	5
63	66	1	23
64	70	1	16
65	196	2	2
66	180	2	18
67	93	1	16
68	83	1	3
69	128	2	17
70	71	1	8
71	69	1	1
72	56	1	3
73	69	1	6
74	162	2	13
75	198	2	16
76	51	1	10
77	192	2	2
78	51	1	10
79	51	1	13
80	126	2	15
81	67	1	10
82	91	1	10
83	55	1	14
84	71	1	18
85	116	2	8
86	164	2	11
87	200	2	5
88	78	1	14
89	58	1	23
90	98	1	20
91	178	2	4
92	132	2	7
93	83	1	24
94	192	2	2
95	90	1	22
96	84	1	2
97	61	1	19
98	66	1	14
99	196	2	4
100	87	1	12

PARTITION BY – Introduction
In this part, we'll learn one construction which can be put in OVER(), namely PARTITION BY. The basic syntax looks like this:

 OVER (PARTITION BY column1, column2 ... column_n)
PARTITION BY works in a similar way as GROUP BY: it partitions the rows into groups, based on the columns in PARTITION BY clause. Unlike GROUP BY, PARTITION BY does not collapse rows.

Let's see the example. For each train, the query returns its id, model, first_class_places and the sum of first class places from the same models of trains.

Part3_diagram
With PARTITION BY, you can easily compute the statistics for the whole group but keep details about individual rows.

What functions can you use with PARTITION BY? You can use an aggregate function that you already know (COUNT(), SUM(), AVG(), etc.), or another function, such as a ranking or an analytical function that you'll get to know in this course. Within parentheses, in turn, we've now put PARTITION BY, followed by the columns by which we want to partition (group).

Exercise
Run the template and see how it works.


Show me the answer
SELECT
  id,
  model,
  first_class_places,
  SUM(first_class_places) OVER (PARTITION BY model)
FROM train;

PARTITION BY – first exercise
As you can see, the query works fine. Imagine writing the same query using regular GROUP BY: you'd have to use a correlated subquery and a JOIN. The query would neither be readable nor efficient.

We no longer want to pay that price and PARTITION BY is the solution. Thanks to PARTITION BY, we can easily get the information about individual rows AND the information about the groups these rows belong to. 

Exercise
Show the id of each journey, its date and the number of journeys that took place on that date.

select id,
		date,
        count(id) over(partition by date)
from journey

id	date	count
21	2016-01-03	7
9	2016-01-03	7
29	2016-01-03	7
17	2016-01-03	7
5	2016-01-03	7
1	2016-01-03	7
25	2016-01-03	7
30	2016-01-04	8
2	2016-01-04	8
6	2016-01-04	8
10	2016-01-04	8
13	2016-01-04	8
14	2016-01-04	8
22	2016-01-04	8
26	2016-01-04	8
15	2016-01-05	8
11	2016-01-05	8
18	2016-01-05	8
19	2016-01-05	8
23	2016-01-05	8
7	2016-01-05	8
3	2016-01-05	8
27	2016-01-05	8
12	2016-01-06	6
16	2016-01-06	6
28	2016-01-06	6
24	2016-01-06	6
8	2016-01-06	6
4	2016-01-06	6
20	2016-03-06	1

Range of OVER(PARTITION BY)
That's right! Remember: window functions only work for those rows which are indeed returned by the query. Take a look at this query:

SELECT
  id,
  model,
  max_speed,
  COUNT(id) OVER (PARTITION BY max_speed)
FROM train
WHERE production_year != 2012;
We cut out the trains with production_year = 2012 and the query would not show them – that's pretty obvious. But the window function would not even count them – we could find out that there are only 2 trains with max_speed = 240, even though there is a third one which was produced in 2012. Note that a GROUP BY clause with a WHERE clause will behave in the same way – GROUP BY will only take into account rows which match the condition(s).

Exercise
Show id, model,first_class_places, second_class_places, and the number of trains of each model with more than 30 first class places and more than 180 second class places.

SELECT
  id,
  model,
  first_class_places,
  second_class_places,
  COUNT(id) OVER (PARTITION BY model)
FROM train
WHERE first_class_places >30 AND 
  second_class_places > 180

id	model	first_class_places	second_class_places	count
2	InterCity 100	40	210	1
6	Pendolino 390	60	250	1
5	Pendolino ETR310	50	250	1

PARTITION BY MULTIPLE COLUMNS
Great! Of course, you can partition rows by multiple columns. Take a look:

SELECT
  route_id,
  ticket.id,
  ticket.price,
  SUM(price) OVER (PARTITION BY route_id, date)
FROM ticket
JOIN journey
ON ticket.journey_id = journey.id;
We wanted to show each ticket with the sum of all tickets on the particular route on the particular date. Neither of the tables would suffice on its own, so we had to join them together to get all the columns.

Exercise
Show the id of each journey, the date on which it took place, the model of the train that was used, the max_speed of that train and the highest max_speed from all the trains that ever went on the same route on the same day.

SELECT
	j.id,
    j.date,
    t.model,
    t.max_speed,
    max(t.max_speed) over(partition by j.route_id, date) 
FROM journey j
JOIN train t
ON t.id = j.train_id;

id	date	model	max_speed	max
1	2016-01-03	InterCity 100	160	160
26	2016-01-04	Pendolino 390	240	240
18	2016-01-05	Pendolino ETR310	240	240
23	2016-01-05	Pendolino 390	240	240
20	2016-03-06	Pendolino ETR310	240	240
17	2016-01-03	Pendolino ETR310	240	240
5	2016-01-03	InterCity 100	160	240
2	2016-01-04	InterCity 100	160	160
21	2016-01-03	Pendolino 390	240	240
9	2016-01-03	InterCity 125	200	240
6	2016-01-04	InterCity 100	160	240
22	2016-01-04	Pendolino 390	240	240
19	2016-01-05	Pendolino ETR310	240	240
27	2016-01-05	InterCity 125	200	240
3	2016-01-05	InterCity 100	160	240
29	2016-01-03	InterCity 125	200	200
13	2016-01-04	Pendolino 390	240	240
7	2016-01-05	InterCity 100	160	160
24	2016-01-06	Pendolino 390	240	240
4	2016-01-06	InterCity 100	160	240
25	2016-01-03	InterCity 100	160	160
10	2016-01-04	InterCity 125	200	240
14	2016-01-04	Pendolino 390	240	240
11	2016-01-05	InterCity 125	200	200
8	2016-01-06	InterCity 100	160	160
30	2016-01-04	Pendolino ETR310	240	240
15	2016-01-05	Pendolino 390	240	240
12	2016-01-06	InterCity 125	200	240
28	2016-01-06	Pendolino 390	240	240
16	2016-01-06	Pendolino 390	240	240

OVER(PARTITION BY) – practice 1
Fantastic. Let's do a couple of exercises to practice.

Exercise
For each journey, show its id, the production_year of the train on that journey, the number of journeys the train took as journeys_by_train and the number of journeys on the same route as journeys_by_route.
SELECT
	j.id,
    t.	production_year,
    count(j.id) over(partition by j.train_id) as journeys_by_train,
    count(j.id) over(partition by j.route_id) as journeys_by_route
FROM journey  j
join train t
on j.train_id = t.id
id	production_year	journeys_by_train	journeys_by_route
3	2000	5	7
4	2000	5	5
2	2000	5	3
1	2000	5	5
25	2000	5	5
7	2000	4	5
8	2000	4	5
5	2000	4	3
6	2000	4	7
11	2001	6	5
29	2001	6	5
27	2001	6	7
9	2001	6	7
12	2001	6	4
10	2001	6	5
16	2012	5	1
13	2012	5	5
14	2012	5	5
15	2012	5	4
28	2012	5	4
19	2010	5	7
17	2010	5	3
18	2010	5	5
20	2010	5	5
30	2010	5	4
21	2010	5	7
22	2010	5	7
23	2010	5	5
26	2010	5	5
24	2010	5	5

OVER(PARTITION BY) – practice 2
Another correct answer. Let's do the third exercise now.

Exercise
For each ticket, show its id, price, date of its journey, the average price of tickets sold on that day and the number of tickets sold on that day. Exclude journeys with train_id = 5.

SELECT
	tk.id,
    tk.	price,
    j.date,
    avg(price) over(partition by j.date),
    count(tk.id) over(partition by j.date) 
FROM journey  j
join ticket tk
on j.id = tk.journey_id
where train_id <> 5

id	price	date	avg	count
6	74	2016-01-03	119.3333333333333333	21
7	200	2016-01-03	119.3333333333333333	21
102	168	2016-01-03	119.3333333333333333	21
136	126	2016-01-03	119.3333333333333333	21
149	100	2016-01-03	119.3333333333333333	21
101	80	2016-01-03	119.3333333333333333	21
34	200	2016-01-03	119.3333333333333333	21
23	62	2016-01-03	119.3333333333333333	21
87	200	2016-01-03	119.3333333333333333	21
45	130	2016-01-03	119.3333333333333333	21
142	102	2016-01-03	119.3333333333333333	21
120	108	2016-01-03	119.3333333333333333	21
32	83	2016-01-03	119.3333333333333333	21
29	67	2016-01-03	119.3333333333333333	21
112	53	2016-01-03	119.3333333333333333	21
135	150	2016-01-03	119.3333333333333333	21
50	150	2016-01-03	119.3333333333333333	21
110	124	2016-01-03	119.3333333333333333	21
145	92	2016-01-03	119.3333333333333333	21
71	69	2016-01-03	119.3333333333333333	21
62	168	2016-01-03	119.3333333333333333	21
3	102	2016-01-04	105.6829268292682927	41
57	81	2016-01-04	105.6829268292682927	41
106	72	2016-01-04	105.6829268292682927	41
11	60	2016-01-04	105.6829268292682927	41
148	126	2016-01-04	105.6829268292682927	41
129	95	2016-01-04	105.6829268292682927	41
77	192	2016-01-04	105.6829268292682927	41
96	84	2016-01-04	105.6829268292682927	41
94	192	2016-01-04	105.6829268292682927	41
65	196	2016-01-04	105.6829268292682927	41
103	57	2016-01-04	105.6829268292682927	41
83	55	2016-01-04	105.6829268292682927	41
88	78	2016-01-04	105.6829268292682927	41
76	51	2016-01-04	105.6829268292682927	41
21	146	2016-01-04	105.6829268292682927	41
78	51	2016-01-04	105.6829268292682927	41
81	67	2016-01-04	105.6829268292682927	41
82	91	2016-01-04	105.6829268292682927	41
111	194	2016-01-04	105.6829268292682927	41
117	81	2016-01-04	105.6829268292682927	41
16	154	2016-01-04	105.6829268292682927	41
37	99	2016-01-04	105.6829268292682927	41
60	99	2016-01-04	105.6829268292682927	41
46	67	2016-01-04	105.6829268292682927	41
12	89	2016-01-04	105.6829268292682927	41
98	66	2016-01-04	105.6829268292682927	41
141	168	2016-01-04	105.6829268292682927	41
74	162	2016-01-04	105.6829268292682927	41
138	196	2016-01-04	105.6829268292682927	41
44	65	2016-01-04	105.6829268292682927	41
79	51	2016-01-04	105.6829268292682927	41
49	172	2016-01-04	105.6829268292682927	41
126	70	2016-01-04	105.6829268292682927	41
137	72	2016-01-04	105.6829268292682927	41
42	76	2016-01-04	105.6829268292682927	41
146	52	2016-01-04	105.6829268292682927	41
55	198	2016-01-04	105.6829268292682927	41
95	90	2016-01-04	105.6829268292682927	41
9	59	2016-01-04	105.6829268292682927	41
51	188	2016-01-04	105.6829268292682927	41
73	69	2016-01-04	105.6829268292682927	41
109	114	2016-01-05	112.8857142857142857	35
48	166	2016-01-05	112.8857142857142857	35
104	100	2016-01-05	112.8857142857142857	35
68	83	2016-01-05	112.8857142857142857	35
140	124	2016-01-05	112.8857142857142857	35
13	71	2016-01-05	112.8857142857142857	35
15	166	2016-01-05	112.8857142857142857	35
72	56	2016-01-05	112.8857142857142857	35
128	83	2016-01-05	112.8857142857142857	35
14	99	2016-01-05	112.8857142857142857	35
134	182	2016-01-05	112.8857142857142857	35
19	97	2016-01-05	112.8857142857142857	35
92	132	2016-01-05	112.8857142857142857	35
4	126	2016-01-05	112.8857142857142857	35
113	69	2016-01-05	112.8857142857142857	35
10	134	2016-01-05	112.8857142857142857	35
86	164	2016-01-05	112.8857142857142857	35
122	97	2016-01-05	112.8857142857142857	35
41	190	2016-01-05	112.8857142857142857	35
27	75	2016-01-05	112.8857142857142857	35
123	132	2016-01-05	112.8857142857142857	35
59	116	2016-01-05	112.8857142857142857	35
80	126	2016-01-05	112.8857142857142857	35
31	192	2016-01-05	112.8857142857142857	35
24	90	2016-01-05	112.8857142857142857	35
118	136	2016-01-05	112.8857142857142857	35
18	106	2016-01-05	112.8857142857142857	35
17	76	2016-01-05	112.8857142857142857	35
132	90	2016-01-05	112.8857142857142857	35
40	164	2016-01-05	112.8857142857142857	35
89	58	2016-01-05	112.8857142857142857	35
144	93	2016-01-05	112.8857142857142857	35
52	126	2016-01-05	112.8857142857142857	35
54	52	2016-01-05	112.8857142857142857	35
63	66	2016-01-05	112.8857142857142857	35
139	200	2016-01-06	117.0312500000000000	32
75	198	2016-01-06	117.0312500000000000	32
67	93	2016-01-06	117.0312500000000000	32

OVER(PARTITION BY) – practice 3
Fantastic! Let's do a couple of exercises to practice.

Exercise
For each ticket, show its id, price and, the column named ratio. The ratio is the ticket price to the sum of all ticket prices purchased on the same journey.

SELECT
	tk.id,
    tk.	price,
    price::numeric/sum(price) over(partition by journey_id) as ratio
FROM ticket tk

id	price	ratio
23	62	0.07730673316708229426
110	124	0.15461346633416458853
145	92	0.11471321695760598504
112	53	0.06608478802992518703
135	150	0.18703241895261845387
50	150	0.18703241895261845387
71	69	0.08603491271820448878
142	102	0.12718204488778054863
129	95	0.11072261072261072261
77	192	0.22377622377622377622
96	84	0.09790209790209790210
94	192	0.22377622377622377622
65	196	0.22843822843822843823
37	99	0.11538461538461538462
48	166	0.21671018276762402089
104	100	0.13054830287206266319
68	83	0.10835509138381201044
140	124	0.16187989556135770235
13	71	0.09268929503916449086
15	166	0.21671018276762402089
72	56	0.07310704960835509138
91	178	0.23056994818652849741
28	140	0.18134715025906735751
133	58	0.07512953367875647668
25	88	0.11398963730569948187
99	196	0.25388601036269430052
143	112	0.14507772020725388601
62	168	0.17872340425531914894
6	74	0.07872340425531914894
7	200	0.21276595744680851064
102	168	0.17872340425531914894
87	200	0.21276595744680851064
45	130	0.13829787234042553191
73	69	0.12825278810408921933
3	102	0.18959107806691449814
57	81	0.15055762081784386617
106	72	0.13382899628252788104
11	60	0.11152416356877323420
16	154	0.28624535315985130112
128	83	0.13996627318718381113
14	99	0.16694772344013490725
134	182	0.30691399662731871838
19	97	0.16357504215851602024
92	132	0.22259696458684654300
33	200	0.26178010471204188482
53	70	0.09162303664921465969
26	128	0.16753926701570680628
119	67	0.08769633507853403141
22	50	0.06544502617801047120
85	116	0.15183246073298429319
61	62	0.08115183246073298429
70	71	0.09293193717277486911
120	108	0.41860465116279069767
32	83	0.32170542635658914729
29	67	0.25968992248062015504
76	51	0.06319702602230483271
21	146	0.18091697645600991326
78	51	0.06319702602230483271
81	67	0.08302354399008674102
82	91	0.11276332094175960347
111	194	0.24039653035935563817
117	81	0.10037174721189591078
148	126	0.15613382899628252788
4	126	0.16153846153846153846
113	69	0.08846153846153846154
10	134	0.17179487179487179487
86	164	0.21025641025641025641
122	97	0.12435897435897435897
41	190	0.24358974358974358974
2	76	0.08379272326350606395
125	156	0.17199558985667034179
56	172	0.18963616317530319735
107	190	0.20948180815876515987
58	126	0.13891951488423373760
43	100	0.11025358324145534730
100	87	0.09592061742006615215
44	65	0.06799163179916317992
79	51	0.05334728033472803347
49	172	0.17991631799163179916
126	70	0.07322175732217573222
137	72	0.07531380753138075314
138	196	0.20502092050209205021
74	162	0.16945606694560669456
141	168	0.17573221757322175732
98	66	0.12915851272015655577
12	89	0.17416829745596868885
46	67	0.13111545988258317025
60	99	0.19373776908023483366
88	78	0.15264187866927592955
83	55	0.10763209393346379648
103	57	0.11154598825831702544
27	75	0.09933774834437086093
123	132	0.17483443708609271523
59	116	0.15364238410596026490
80	126	0.16688741721854304636
31	192	0.25430463576158940397
109	114	0.15099337748344370861
139	200	0.35650623885918003565
75	198	0.35294117647058823529
67	93	0.16577540106951871658

Summary
Excellent! Let's review what we've learned in this part:

OVER(PARTITION BY x) works in a similar way to GROUP BY, defining the window as all the rows in the query result that have the same value in x.
x can be a single column or multiple columns separated by commas.

Exercise
Select all the information from the table employee.

Each employee has a first and last name, a department where they work and a salary.

Select * from employee

first_name	last_name	department	salary
Harriet	Mckinney	development	7891
Wendy	Mann	development	4680
David	Love	development	2685
Thomas	Wise	development	2901
Viola	Griffin	sales	6106
Hannah	Rose	sales	5643
Kenny	Vasquez	sales	5146
Patricia	Ortiz	HR	4797
Julia	Fernandez	HR	4778
Warren	Schwartz	HR	5240

Exercise
For each employee, show their first_name, last_name, department, salary, as well as the minimal and maximal salary in that department.

SElect
	first_name, 
    last_name, 
    department, 
    salary,
    min(salary) over(partition by department) ,
    max(salary) over(partition by department)
    from employee
first_name	last_name	department	salary	min	max
Harriet	Mckinney	development	7891	2685	7891
Wendy	Mann	development	4680	2685	7891
David	Love	development	2685	2685	7891
Thomas	Wise	development	2901	2685	7891
Warren	Schwartz	HR	5240	4778	5240
Patricia	Ortiz	HR	4797	4778	5240
Julia	Fernandez	HR	4778	4778	5240
Viola	Griffin	sales	6106	5146	6106
Hannah	Rose	sales	5643	5146	6106
Kenny	Vasquez	sales	5146	5146	6106

2. For each employee, show their first_name, last_name, department, salary and the proportion of their salary to the sum of all salaries in that department. To avoid the integer division remember to cast the dividend to numeric.
SElect
	first_name, 
    last_name, 
    department, 
    salary,
    salary::numeric/sum(salary) over(partition by department)
    from employee
first_name	last_name	department	salary	?column?
Harriet	Mckinney	development	7891	0.43459822657928071818
Wendy	Mann	development	4680	0.25775183124965578014
David	Love	development	2685	0.14787685190284738668
Thomas	Wise	development	2901	0.15977309026821611500
Warren	Schwartz	HR	5240	0.35369557880526493419
Patricia	Ortiz	HR	4797	0.32379345258184272697
Julia	Fernandez	HR	4778	0.32251096861289233885
Viola	Griffin	sales	6106	0.36140870079905297425
Hannah	Rose	sales	5643	0.33400414323764427345
Kenny	Vasquez	sales	5146	0.30458715596330275229


