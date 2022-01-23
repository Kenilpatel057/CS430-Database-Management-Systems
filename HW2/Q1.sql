 CS630 HW2
Q1

a)	Select distinct b.author from books b, orders o, customers c where o.quantity>= 50 and c.zipcode = ‘02125’ and c.cid = o.cid and o.bid = b.bid;

b)	Select c.cname from customers c, books b, orders o where c.cid=o.cid and o.bid=b.bid and b.price<100 and c.cname not in(select c1.cname from customers c1, books b1, orders o1 where c1.cid=o1.cid and b1.bid=o1.bid and b1.price>=100);

c)	Select o.cid, avg(b.price) as average from orders o, books b where o.bid=b.bid and b.price>=20 group by o.cid having count(*)>=20;

d)	Select c.cid, c.cname from customers c, orders o, books b where o.cid=c.cid and b.bid=o.bid group by c.cid, c.cname having every(b.author=‘edgar codd’);

e)	Select temp.author, temp.maxquan from (select b.author, sum(o.quantity) as maxquan from books b, orders o where o.bid=b.bid group by b.author)temp where temp.maxquan >= all (select temp.maxquan from (select b1.author, sum(o1.quantity) as maxquan from books b1, orders o1 where o1.bid=b1.bid group by b1.author) temp);

f)	 Select c.cid, c.cname from customers c, orders o, books b where c.cid=o.cid and o.bid=b.bid and b.price*o.quantity = select(max(o1.quantity*b1.price) from books b1, orders o1) group by c.cname,c.cid ;


Shreyansh Dhandhukia HW