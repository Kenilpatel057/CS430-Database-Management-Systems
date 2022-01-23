CREATE OR REPLACE FUNCTION determineNearest(cap IN INT)
	RETURN Activities.aid%type
	
IS
	activity_instance Activities%ROWTYPE;
	nearest_activity Activities%ROWTYPE;
	difference number(3);
	num number(2);
	nearest_aid Activities.aid%type;
	
	
	CURSOR curs_act IS
		SELECT *
		FROM Activities;
BEGIN
	num := cap/2;
	difference := 100;
	
	OPEN curs_act;
	LOOP
		FETCH curs_act INTO activity_instance;
		EXIT WHEN curs_act%notfound;
		IF ABS(num-activity_instance.capacity) < difference THEN
			difference := ABS(num-activity_instance.capacity);
			nearest_activity := activity_instance;
		ELSIF ABS(num-activity_instance.capacity) = difference THEN
			IF activity_instance.price < nearest_activity.price THEN
			nearest_activity := activity_instance;
			ELSIF activity_instance.price = nearest_activity.price THEN
				IF activity_instance.aid > nearest_activity.aid THEN
				nearest_activity := activity_instance;
				END IF;
			END IF;
		END IF;
		nearest_aid := nearest_activity.aid;
	END LOOP;
	CLOSE curs_act;	
	RETURN nearest_aid;
END;
/
