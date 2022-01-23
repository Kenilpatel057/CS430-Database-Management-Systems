DECLARE    
    result int;
BEGIN
    result := getSTDeviation('1234');
    DBMS_OUTPUT.PUT_LINE(result);
END;
/
