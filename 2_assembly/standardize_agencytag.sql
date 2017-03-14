UPDATE facilities AS f
    SET 
		idagency = 
			(CASE
				WHEN idagency IS NOT NULL THEN ARRAY[CONCAT(array_to_string(agencysource,','),': ', array_to_string(idagency,','))]
			END),
		oversightlevel = 
			(CASE
				WHEN oversightlevel @> ARRAY['Non-public Oversight'] THEN oversightlevel
				ELSE ARRAY[CONCAT(array_to_string(oversightabbrev,','),': ', array_to_string(oversightlevel,','))]
			END),
		capacity = 
			(CASE
				WHEN capacity IS NOT NULL THEN ARRAY[CONCAT(array_to_string(agencysource,','),': ', array_to_string(capacity,','))]
			END),
		capacitytype = 
			(CASE
				WHEN capacitytype IS NOT NULL THEN ARRAY[CONCAT(array_to_string(agencysource,','),': ', array_to_string(capacitytype,','))]
			END),
		utilization = 
			(CASE
				WHEN utilization IS NOT NULL THEN ARRAY[CONCAT(array_to_string(agencysource,','),': ', array_to_string(utilization,','))]
			END),
		utilizationrate = 
			(CASE
				WHEN utilizationrate IS NOT NULL THEN ARRAY[CONCAT(array_to_string(agencysource,','),': ', array_to_string(utilizationrate,','))]
			END),
		area = 
			(CASE
				WHEN area IS NOT NULL THEN ARRAY[CONCAT(array_to_string(agencysource,','),': ', array_to_string(area,','))]
			END),
		areatype = 
			(CASE
				WHEN areatype IS NOT NULL THEN ARRAY[CONCAT(array_to_string(agencysource,','),': ', array_to_string(areatype,','))]
			END)
	WHERE array_to_string(oversightlevel,',') NOT LIKE CONCAT(array_to_string(oversightabbrev,','),': %') AND oversightlevel <> ARRAY['Non-public Oversight']
		;

UPDATE facilities
	SET idagency = NULL
	WHERE idagency IS NOT NULL 
	AND split_part(array_to_string(idagency,','),': ',2) = '';

UPDATE facilities
	SET capacity = NULL
	WHERE capacity IS NOT NULL 
	AND split_part(array_to_string(capacity,','),': ',2) = '';

UPDATE facilities
	SET capacitytype = NULL
	WHERE capacitytype IS NOT NULL 
	AND split_part(array_to_string(capacitytype,','),': ',2) = '';

UPDATE facilities
	SET utilization = NULL
	WHERE utilization IS NOT NULL 
	AND split_part(array_to_string(utilization,','),': ',2) = '';

UPDATE facilities
	SET utilizationrate = NULL
	WHERE utilizationrate IS NOT NULL 
	AND split_part(array_to_string(utilizationrate,','),': ',2) = '';

UPDATE facilities
	SET area = NULL
	WHERE area IS NOT NULL 
	AND split_part(array_to_string(area,','),': ',2) = '';

UPDATE facilities
	SET areatype = NULL
	WHERE areatype IS NOT NULL 
	AND split_part(array_to_string(areatype,','),': ',2) = '';

UPDATE facilities
	SET linkdata = NULL
	WHERE linkdata IS NOT NULL 
	AND split_part(array_to_string(linkdata,','),': ',2) = '';

UPDATE facilities
	SET linkdownload = NULL
	WHERE linkdownload IS NOT NULL 
	AND split_part(array_to_string(linkdownload,','),': ',2) = '';