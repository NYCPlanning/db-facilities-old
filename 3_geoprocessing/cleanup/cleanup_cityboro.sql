UPDATE facilities 
    SET 
        City = 
            (CASE 
                WHEN Borough = 'Manhattan' THEN 'New York'
                ELSE Borough
            END)
    WHERE
        Borough <> 'Queens'
    ;

UPDATE facilities 
    SET 
        Borough = 
        (CASE 
            WHEN City = 'New York' THEN 'Manhattan'
            WHEN City = 'Bronx' THEN 'Bronx'
            WHEN City = 'Brooklyn' THEN 'Brooklyn'
            WHEN City = 'Staten Island' THEN 'Staten Island'
            ELSE 'Queens'
        END)
    WHERE
        Borough IS NULL
        AND City IS NOT NULL
    ;