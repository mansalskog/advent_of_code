create table input(cmd TEXT, x INT);
.separator " "
.import input.txt input

with
	ht as (select sum(x) as h from input where cmd = "forward"),
	dt as (select sum(case when cmd = "up" then -x else x end) as d
		from input where cmd <> "forward")
select h * d from ht, dt;

with
	ht as (select sum(x) as h from input where cmd = "forward"),
	at as (select
		rowid, sum(case when cmd = "up" then -x when cmd = "down" then x else 0 end)
		over (order by rowid rows unbounded preceding) as a from input),
	dt as (select
		sum(a * (case when cmd = "forward" then x else 0 end)) as d
		from input join at on input.rowid = at.rowid)
select h * d from ht, dt;
