UPDATE facilities AS f
    SET 
		idagency = 
			(CASE
				WHEN idagency IS NOT NULL THEN ARRAY[CONCAT(array_to_string(agencysource,','),': ', array_to_string(idagency,','))]
			END),
		sourcedatasetname = ARRAY[CONCAT(array_to_string(agencysource,','),': ', array_to_string(sourcedatasetname,','))],
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