UPDATE facilities
    SET addressnumber = REPLACE(addressnumber,'One','1');

CREATE OR REPLACE FUNCTION isnumeric(text) RETURNS BOOLEAN AS $$
DECLARE x NUMERIC;
BEGIN
    x = $1::NUMERIC;
    RETURN TRUE;
EXCEPTION WHEN others THEN
    RETURN FALSE;
END;
$$
STRICT
LANGUAGE plpgsql IMMUTABLE;

UPDATE facilities
    SET
    addressnumber = 
    	(CASE WHEN isnumeric(REPLACE(addressnumber,'-','')) THEN addressnumber
    		ELSE NULL
    	END),
    streetname =
        (CASE WHEN isnumeric(REPLACE(addressnumber,'-','')) THEN streetname
    		ELSE NULL
    	END)
    ;