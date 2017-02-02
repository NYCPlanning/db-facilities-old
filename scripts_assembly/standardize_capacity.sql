UPDATE facilities AS f
    SET 
		capacity = NULL
	WHERE
		array_to_string(capacity,',') LIKE '% 0%'
		;

UPDATE facilities AS f
    SET 
		utilization = NULL
	WHERE
		array_to_string(utilization,',') LIKE '% 0%'
		AND capacity IS NULL
		;

UPDATE facilities AS f
    SET 
		capacitytype = NULL,
		utilizationrate = NULL
	WHERE
		capacity IS NULL
		AND utilization IS NULL
		;