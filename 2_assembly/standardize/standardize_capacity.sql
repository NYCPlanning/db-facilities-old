UPDATE facdb_capacity AS f
    SET 
		capacity = NULL
	WHERE
		array_to_string(capacity,',') LIKE '% 0%'
		;

UPDATE facdb_utilization AS f
    SET 
		util = NULL
	WHERE
		array_to_string(util,',') LIKE '% 0%'
		AND capacity IS NULL
		;

UPDATE facdb_capacity AS f
    SET 
		captype = NULL
	WHERE
		capacity IS NULL
		AND util IS NULL
		;

UPDATE facdb_utilization AS f
    SET 
		utilrate = NULL
	WHERE
		capacity IS NULL
		AND util IS NULL
		;

UPDATE facdb_area AS f
    SET 
		area =
			(CASE
				WHEN area[1]::numeric <> 0 THEN ARRAY[ROUND(area[1]::numeric,3)]
				ELSE NULL
			END),
		areatype =
			(CASE
				WHEN area[1]::numeric <> 0 THEN areatype
				ELSE NULL
			END)
	WHERE
		area IS NOT NULL
		AND array_to_string(area,',') NOT LIKE CONCAT('%',array_to_string(datasource,','),'%')
		;