UPDATE facdb_capacity AS f
    SET 
		capacity = NULL
	WHERE
		capacity LIKE '% 0%'
		;

UPDATE facdb_utilization AS f
    SET 
		util = NULL
	WHERE
		util,',' LIKE '% 0%'
		AND capacity IS NULL
		;

UPDATE facdb_capacity AS f
    SET 
		captype = NULL
	WHERE
		capacity IS NULL
		;

UPDATE facdb_utilization AS f
    SET 
		utilrate = NULL
	WHERE
		util IS NULL
		;

UPDATE facdb_area AS f
    SET 
		area =
			(CASE
				WHEN area[1]::numeric <> 0 THEN ROUND(area[1]::numeric,3)
				ELSE NULL
			END),
		areatype =
			(CASE
				WHEN area[1]::numeric <> 0 THEN areatype
				ELSE NULL
			END)
	WHERE
		area IS NOT NULL
		AND area NOT LIKE CONCAT('%', datasource, '%')
		;