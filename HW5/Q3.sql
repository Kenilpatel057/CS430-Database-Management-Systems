CREATE OR REPLACE FUNCTION getSTDeviation(zipc IN INT)
	RETURN INT

IS
	avg_age Campers.age%type;
	age_cam number(4,2);
	std number(4,2);


	CURSOR curs_camp IS
		SELECT *
		FROM Campers;
	
BEGIN
	
	SELECT AVG(AGE),STDDEV(AGE) INTO avg_age, std FROM campers c, registration r where c.cid= r.cid and r.aid = a.aid;
	
	if(std<avg_age) then
		age_cam= floor(std)+avg_age;
	Elseif(std>avg_age) then
		age_cam= ceil(std)+avg_age;
	ENDIF;
	return age_cam; 
END;
/