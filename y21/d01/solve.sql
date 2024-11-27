create table input(x INT);
.import input.txt input
select sum(y) from (select x > lag(x) over (order by rowid) as y from input);
select sum(y) from (select x > lag(x,3) over (order by rowid) as y from input);
