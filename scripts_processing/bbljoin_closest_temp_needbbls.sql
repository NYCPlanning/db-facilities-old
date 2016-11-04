CREATE TABLE temp_needbbls AS (
	SELECT *
	FROM facilities
	WHERE
	    geom IS NOT NULL
	    AND BBL IS NULL
	    AND facilitygroup NOT LIKE '%Parks and Plazas%'
	)