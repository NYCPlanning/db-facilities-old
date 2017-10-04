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
		util LIKE '% 0%'
		;

UPDATE facdb_capacity AS f
    SET 
		capacitytype = NULL
	WHERE
		capacity IS NULL
		;

UPDATE facdb_utilization AS f
    SET 
		utiltype = NULL
	WHERE
		util IS NULL
		;

UPDATE facdb_area AS f
    SET 
		area =
			(CASE
				WHEN area::numeric <> 0 THEN ROUND(area::numeric,3)
				ELSE NULL
			END),
		areatype =
			(CASE
				WHEN area::numeric <> 0 THEN areatype
				ELSE NULL
			END)
	WHERE
		area IS NOT NULL
		;