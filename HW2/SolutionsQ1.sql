--Q1
--a.)
SELECT DISTINCT b.author
FROM books b, orders o, customers c
WHERE o.quantity >= 50 AND c.zipcode = '02125' AND b.bid = o.bid AND c.cid = o.cid;
--Solution: 'Edgar Codd', 'author3'

--b.)
SELECT c.cname
FROM orders o, customers c
where o.cid=c.cid and c.cid not in 
(SELECT o1.cid
      FROM orders o1, books b
      WHERE b.price >= 100 AND  b.bid = o1.bid);
--Solution: 'cust1', 'cust3'

--c.)
SELECT c.cid, AVG(b.price) as average_price
FROM customers c, books b, orders o
WHERE o.cid = c.cid AND b.bid = o.bid
GROUP BY c.cid
HAVING 20 <= (SELECT COUNT(distinct b2.bname)
              FROM books b2, orders o2
              WHERE b2.price >= 20 AND o2.cid = c.cid AND o2.bid = b2.bid);
--Solution: 'cust4'|68.5

--d.)
SELECT c.cname
FROM customers c
WHERE NOT EXISTS(
    SELECT *
    FROM books b
    WHERE b.author = 'Edgar Codd' AND NOT EXISTS(
        SELECT *
        FROM orders o
        WHERE o.cid = c.cid AND b.bid = o.bid
    )
);
--Solution: 'cust1', 'cust2', 'cust4'

--e.)
SELECT tmp.author, tmp.copies_sold
FROM 	(	
	SELECT b.author, sum(o.quantity) as copies_sold
	FROM books b, orders o
	WHERE b.bid = o.bid
	group by b.bid, b.author
	) tmp
where tmp.copies_sold = (select max(tmp.copies_sold) 
	from
	(
	SELECT sum(o1.quantity) as copies_sold
        FROM books b1, orders o1
        WHERE b1.bid = o1.bid
        group by b1.bid
	)tmp);

--Solution: 'author2', 'author3'

--f.)
SELECT tmp.cname, tmp.spent
FROM    (
        SELECT c.cname, sum(o.quantity * b.price) as spent
        FROM books b, orders o, customers c
        WHERE b.bid = o.bid and c.cid=o.cid
        group by c.cid, c.cname
        ) tmp
where tmp.spent = (select max(tmp.spent)
        from
	 (
        SELECT c.cname, sum(o.quantity * b.price) as spent
        FROM books b, orders o, customers c
        WHERE b.bid = o.bid and c.cid=o.cid
        group by c.cid, c.cname
        )tmp);


--Solution: 'cust2'
