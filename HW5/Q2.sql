CREATE OR REPLACE FUNCTION enrollCamper(camid IN INT,actid IN INT)
	/*RETURN registration%ROWTYPE*/
	RETURN INT
	
IS
	cam Campers%ROWTYPE;
      cur_cam Campers%ROWTYPE;
	last_act Activities%ROWTYPE;
      flag BOOLEAN;
	result registration%ROWTYPE;


	c number(2);
	avgage Campers.age%TYPE;

	
	
	CURSOR curs_cam IS
		SELECT *FROM campers c where c.cid in(Select r.cid from registration r where r.aid = actid);
	
	
BEGIN

	flag := true;
	SELECT avg(age) INTO avgage FROM campers c, registration r where c.cid= r.cid and r.aid = actid;
	SELECT * INTO cam FROM campers where cid = camid;
	SELECT * INTO last_act FROM Activities a where a.aid=(select max(a1.aid) from activities a1);

	
	IF avgage= 0 THEN
	INSERT INTO REGISTRATION VALUES(camid,actid);
	/*select * INTO result from registration r where r.cid=camid;*/
	RETURN camid;

	IF (cam.age >= avgage/2) THEN
	OPEN curs_cam;
		LOOP
			FETCH curs_cam INTO cur_cam;
			EXIT WHEN curs_cam%notfound;
			IF (cam.zipcode = cur_cam.zipcode) THEN
			flag := false;
			END IF;
		END LOOP;
		CLOSE curs_cam;
      END IF;
	ELSIF (cam.age < avgage/2) THEN
	OPEN curs_cam;
		LOOP
			FETCH curs_cam INTO cur_cam;
			EXIT WHEN curs_cam%notfound;
			IF (cam.zipcode = cur_cam.zipcode) THEN
			INSERT INTO ACTIVITIES VALUES(last_act.aid + 1, 	last_act.name, (last_act.price)/2, (last_act.capacity)*2);	
		      END IF;
		END LOOP;
		CLOSE curs_cam;
	END IF;
	IF (flag = true) THEN
			INSERT INTO REGISTRATION VALUES(camid,actid);
			return camid;
		END IF;
END;
/

