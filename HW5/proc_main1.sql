DECLARE    
    nearest_aid Activities.aid%type;
BEGIN
    nearest_aid := determineNearest('90');
    DBMS_OUTPUT.PUT_LINE('nearest aid = ' || nearest_aid);
END;
/

