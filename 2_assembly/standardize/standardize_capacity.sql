UPDATE facilities AS f
    SET 
		capacity = NULL
	WHERE
		capacity LIKE '% 0%'
		;

UPDATE facilities AS f
    SET 
		util = NULL
	WHERE
		util LIKE '% 0%'
		AND capacity IS NULL
		;

UPDATE facilities AS f
    SET 
		capacitytype = NULL,
		utilrate = NULL
	WHERE
		capacity IS NULL
		AND util IS NULL
		;

UPDATE facilities AS f
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
		AND area NOT LIKE CONCAT('%',datasource,'%')
		;