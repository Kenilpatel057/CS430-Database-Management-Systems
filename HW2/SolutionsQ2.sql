--Q2
--a.)
SELECT p.age
FROM passengers p, tickets t
WHERE p.pid=t.pid and p.pid not in (
    SELECT t1.pid
    FROM tickets t1, flights f
    WHERE f.aircraft <> 'B787' AND f.fid = t1.fid
    );
--Solution: 16, 17, 18, 19

--b.)
SELECT p.pname
FROM passengers p
WHERE NOT EXISTS(
    SELECT f.AIRCRAFT
    FROM flights f
    MINUS
    SELECT f2.AIRCRAFT
        FROM tickets t, flights f2
        WHERE f2.fid = t.fid AND t.pid=p.pid
    );
--Solution: pids 1-2, 7-10

--c.)
SELECT t.fid, AVG(t.price)
FROM passengers p, tickets t
WHERE p.age > 30 AND p.pid = t.pid
GROUP BY t.fid
HAVING  100<= (SELECT COUNT(*) 
		FROM TICKETS T1
		WHERE T1.FID=T.FID);
--Solution: empty set

--d.)
SELECT SUM(t.price) as revenue
FROM tickets t, flights f
WHERE t.fid=f.fid and f.miles = 
	( SELECT MAX(f1.miles)
          FROM flights f1
        );
--Solution: 3|1800

--e.)
SELECT f."from" as origin,
       SUM(tmp.passenger_count),
       SUM(tmp.revenue) as total_revenue,
       AVG(f.miles)
FROM (
     SELECT t2.fid as fid, COUNT(*) as passenger_count, sum(t2.PRICE) as revenue
     FROM flights f1, tickets t2
     WHERE t2.fid = f1.fid
     GROUP BY t2.fid
         ) tmp,
     flights f
WHERE f.fid = tmp.fid
GROUP BY f."from";
--Solution: 'origin2'|4|1200|300, 'origin3'|3|1800|500, 'origin1'|7|700|200, 'origin9'|5|600|200

--f.)
SELECT tmp.age
FROM (  SELECT p.age, sum(f.miles) as total_miles 		
	FROM passengers p, tickets t, flights f
	WHERE f.fid = t.fid AND p.pid = t.pid
	GROUP BY p.pid, p.age
     ) tmp
where tmp.total_miles = ( select max(total_miles)
	FROM 
	(  SELECT sum(f.miles) as total_miles
        FROM passengers p, tickets t, flights f
        WHERE f.fid = t.fid AND p.pid = t.pid
        GROUP BY p.pid
     ) tmp);
	
--Solution: 14
