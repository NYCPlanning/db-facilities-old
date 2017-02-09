UPDATE facilities 
    SET 
    	borough =
    		(CASE
	    		WHEN trim(borough, ' ') = 'New York' THEN 'Manhattan'
                WHEN trim(borough, ' ') = 'NEW YORK' THEN 'Manhattan'
                WHEN trim(borough, ' ') = 'MANHATTAN' THEN 'Manhattan'
                WHEN trim(borough, ' ') = 'Manhattan' THEN 'Manhattan'

                WHEN trim(borough, ' ') = 'BRONX' THEN 'Bronx'
                WHEN trim(borough, ' ') = 'Bronx' THEN 'Bronx'

                WHEN trim(borough, ' ') = 'Kings' THEN 'Brooklyn'
                WHEN trim(borough, ' ') = 'KINGS' THEN 'Brooklyn'
                WHEN trim(borough, ' ') = 'BROOKLYN' THEN 'Brooklyn'
                WHEN trim(borough, ' ') = 'Brooklyn' THEN 'Brooklyn'

                WHEN trim(borough, ' ') = 'QUEENS' THEN 'Queens'
                WHEN trim(borough, ' ') = 'Queens' THEN 'Queens'

                WHEN trim(borough, ' ') = 'Richmond' THEN 'Staten Island'
                WHEN trim(borough, ' ') = 'RICHMOND' THEN 'Staten Island'
                WHEN trim(borough, ' ') = 'STATEN ISLAND' THEN 'Staten Island'
                WHEN trim(borough, ' ') = 'Staten Island' THEN 'Staten Island'
                WHEN trim(borough, ' ') = 'Staten Is' THEN 'Staten Island'
	    	END),
        boroughcode =
            (CASE
                WHEN trim(borough, ' ') = 'New York' THEN 1
                WHEN trim(borough, ' ') = 'NEW YORK' THEN 1
                WHEN trim(borough, ' ') = 'MANHATTAN' THEN 1
                WHEN trim(borough, ' ') = 'Manhattan' THEN 1

                WHEN trim(borough, ' ') = 'BRONX' THEN 2
                WHEN trim(borough, ' ') = 'Bronx' THEN 2

                WHEN trim(borough, ' ') = 'Kings' THEN 3
                WHEN trim(borough, ' ') = 'KINGS' THEN 3
                WHEN trim(borough, ' ') = 'BROOKLYN' THEN 3
                WHEN trim(borough, ' ') = 'Brooklyn' THEN 3

                WHEN trim(borough, ' ') = 'QUEENS' THEN 4
                WHEN trim(borough, ' ') = 'Queens' THEN 4
                
                WHEN trim(borough, ' ') = 'Richmond' THEN 5
                WHEN trim(borough, ' ') = 'RICHMOND' THEN 5
                WHEN trim(borough, ' ') = 'STATEN ISLAND' THEN 5
                WHEN trim(borough, ' ') = 'Staten Island' THEN 5
                WHEN trim(borough, ' ') = 'Staten Is' THEN 5
            END)
