UPDATE facilities 
    SET 
        BIN = NULL
    WHERE
        BIN = '1000000'
        OR BIN = '2000000'
        OR BIN = '3000000'
        OR BIN = '4000000'
        OR BIN = '5000000'
    ;

UPDATE facilities 
    SET 
        BBL = 
        	(CASE 
        		WHEN BBL = '' OR BBL = '0' OR BBL = '0000000000' THEN NULL 
        		ELSE BBL
        	END),
        BIN = 
        	(CASE 
        		WHEN BIN = '' THEN NULL 
        		ELSE BIN 
        	END)
    ;