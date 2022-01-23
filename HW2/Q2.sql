 CS630 HW2
Q2

a)	Select p.age from passengers p, tickets t, flights f where t.pid = p.pid and f.fid = t.fid and f.aircraft= ‘B787’ and p.age not in (select p1.age from passengers p1, tickets t1, flights f1 where t1.pid=p1.pid and f1.fid=t1.fid and f1.aircraft<> ‘B787’);

b)	Select p.pname from passengers p where not exists(select f.fid from flights f where not exists(select * from tickets t where t.pid=p.pid and t.fid=f.fid);

c)	Select f.fid, avg(t.price) from flights f, tickets t, passengers p where  p.pid=t.pid and f.fid=t.fid and p.age>30 group by f.fid having count(*)>=100;

d)	Select temp.price*temp.counts from(select t.price, count(*) as counts from flights f, tickets t where t.fid=f.fid and f.miles>= all(select f1.miles from flights f1) group by t.price, t.fid)temp;

e)	Select sum(temp.sums), temp.counts, temp.average from(Select t.price*count(p.pid) as sums, count(p.pid), avg(f.miles), f.from from passengers p, flights f, tickets t where f.fid=t.fid and t.pid=p.pid group by f.from,t.price) temp, flights group by temp.from;

f)	Select p.age from passengers p, flights f, tickets t where t.pid = p.pid and f.fid = t.fid and f.miles >= all (select f1.miles from flights f1 );

Shreyansh Dhandhukia HW

