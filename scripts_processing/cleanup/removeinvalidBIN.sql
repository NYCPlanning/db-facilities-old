UPDATE facilities 
    SET 
        BIN = NULL
    WHERE
        BIN = ARRAY['1000000']
        OR BIN = ARRAY['2000000']
        OR BIN = ARRAY['3000000']
        OR BIN = ARRAY['4000000']
        OR BIN = ARRAY['5000000']
    ;

UPDATE facilities 
    SET 
        BIN = 
        	(CASE 
        		WHEN BBL = ARRAY[''] THEN NULL 
        		ELSE BIN 
        	END),
        BIN = 
        	(CASE 
        		WHEN BIN = ARRAY[''] THEN NULL 
        		ELSE BIN 
        	END)
    ;