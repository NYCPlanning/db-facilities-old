UPDATE facilities AS f
    SET 
		idagency = ARRAY[CONCAT(agencysource,': ', array_to_string(idagency,','))],
		sourcedatasetname = ARRAY[CONCAT(agencysource,': ', array_to_string(sourcedatasetname,','))],
		capacity = ARRAY[CONCAT(agencysource,': ', array_to_string(capacity,','))],
		utilization = ARRAY[CONCAT(agencysource,': ', array_to_string(utilization,','))]
		;