UPDATE facilities 
    SET 
    	oversightagency =
    		(CASE
	    		WHEN trim(oversightagency, ' ') = 'New York' THEN 'Manhattan'
                WHEN trim(oversightagency, ' ') = 'NEW YORK' THEN 'Manhattan'
                WHEN trim(oversightagency, ' ') = 'MANHATTAN' THEN 'Manhattan'
                WHEN trim(oversightagency, ' ') = 'Manhattan' THEN 'Manhattan'

                WHEN trim(oversightagency, ' ') = 'BRONX' THEN 'Bronx'
                WHEN trim(oversightagency, ' ') = 'Bronx' THEN 'Bronx'

                WHEN trim(oversightagency, ' ') = 'Kings' THEN 'Brooklyn'
                WHEN trim(oversightagency, ' ') = 'KINGS' THEN 'Brooklyn'
                WHEN trim(oversightagency, ' ') = 'BROOKLYN' THEN 'Brooklyn'
                WHEN trim(oversightagency, ' ') = 'Brooklyn' THEN 'Brooklyn'

                WHEN trim(oversightagency, ' ') = 'QUEENS' THEN 'Queens'
                WHEN trim(oversightagency, ' ') = 'Queens' THEN 'Queens'

                WHEN trim(oversightagency, ' ') = 'Richmond' THEN 'Staten Island'
                WHEN trim(oversightagency, ' ') = 'RICHMOND' THEN 'Staten Island'
                WHEN trim(oversightagency, ' ') = 'STATEN ISLAND' THEN 'Staten Island'
                WHEN trim(oversightagency, ' ') = 'Staten Island' THEN 'Staten Island'
	    	END),
        oversightabbrev =
            (CASE
                WHEN trim(oversightabbrev, ' ') = 'New York' THEN '1'
                WHEN trim(oversightabbrev, ' ') = 'NEW YORK' THEN '1'
                WHEN trim(oversightabbrev, ' ') = 'MANHATTAN' THEN '1'
                WHEN trim(oversightabbrev, ' ') = 'Manhattan' THEN '1'

                WHEN trim(oversightabbrev, ' ') = 'BRONX' THEN '2'
                WHEN trim(oversightabbrev, ' ') = 'Bronx' THEN '2'

                WHEN trim(oversightabbrev, ' ') = 'Kings' THEN '3'
                WHEN trim(oversightabbrev, ' ') = 'KINGS' THEN '3'
                WHEN trim(oversightabbrev, ' ') = 'BROOKLYN' THEN '3'
                WHEN trim(oversightabbrev, ' ') = 'Brooklyn' THEN '3'

                WHEN trim(oversightabbrev, ' ') = 'QUEENS' THEN '4'
                WHEN trim(oversightabbrev, ' ') = 'Queens' THEN '4'

                WHEN trim(oversightabbrev, ' ') = 'Richmond' THEN '5'
                WHEN trim(oversightabbrev, ' ') = 'RICHMOND' THEN '5'
                WHEN trim(oversightabbrev, ' ') = 'STATEN ISLAND' THEN '5'
                WHEN trim(oversightabbrev, ' ') = 'Staten Island' THEN '5'
            END)
