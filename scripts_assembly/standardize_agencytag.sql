UPDATE facilities AS f
    SET 
		idagency = 
			(CASE
				WHEN idagency IS NOT NULL THEN ARRAY[CONCAT(array_to_string(agencysource,','),': ', array_to_string(idagency,','))]
			END),
		sourcedatasetname = ARRAY[CONCAT(array_to_string(agencysource,','),': ', array_to_string(sourcedatasetname,','))],
		linkdata = ARRAY[CONCAT(array_to_string(agencysource,','),': ', array_to_string(linkdata,','))],
		-- datesourceupdated = ARRAY[CONCAT(array_to_string(agencysource,','),': ', array_to_string(datesourceupdated,','))],
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
			END)
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