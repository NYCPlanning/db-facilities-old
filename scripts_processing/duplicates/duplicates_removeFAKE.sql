UPDATE facilities
	SET
		idagency = NULL
	WHERE array_to_string(idagency,',') = 'FAKE!';

UPDATE facilities
	SET
		idagency = string_to_array(REPLACE(array_to_string(idagency,';'),';FAKE!',''),';')
	WHERE array_to_string(idagency,',') LIKE '%FAKE!%';

UPDATE facilities
	SET
		bin = NULL
	WHERE array_to_string(bin,',') = 'FAKE!';

UPDATE facilities
	SET
		bin = string_to_array(REPLACE(array_to_string(bin,';'),';FAKE!',''),';')
	WHERE array_to_string(bin,',') LIKE '%FAKE!%';

UPDATE facilities
	SET
		bbl = NULL
	WHERE array_to_string(bbl,',') = 'FAKE!';

UPDATE facilities
	SET
		bbl = string_to_array(REPLACE(array_to_string(bbl,';'),';FAKE!',''),';')
	WHERE array_to_string(bbl,',') LIKE '%FAKE!%';

UPDATE facilities
	SET
		capacity = NULL
	WHERE array_to_string(capacity,',') = 'FAKE!';

UPDATE facilities
	SET
		capacity = string_to_array(REPLACE(array_to_string(capacity,';'),';FAKE!',''),';')
	WHERE array_to_string(capacity,',') LIKE '%FAKE!%';

UPDATE facilities
	SET
		capacitytype = NULL
	WHERE array_to_string(capacitytype,',') = 'FAKE!';

UPDATE facilities
	SET
		capacitytype = string_to_array(REPLACE(array_to_string(capacitytype,';'),';FAKE!',''),';')
	WHERE array_to_string(capacitytype,',') LIKE '%FAKE!%';

UPDATE facilities
	SET
		utilization = NULL
	WHERE array_to_string(utilization,',') = 'FAKE!';

UPDATE facilities
	SET
		utilization = string_to_array(REPLACE(array_to_string(utilization,';'),';FAKE!',''),';')
	WHERE array_to_string(utilization,',') LIKE '%FAKE!%';

UPDATE facilities
	SET
		area = NULL
	WHERE array_to_string(area,',') = 'FAKE!';

UPDATE facilities
	SET
		area = string_to_array(REPLACE(array_to_string(area,';'),';FAKE!',''),';')
	WHERE array_to_string(area,',') LIKE '%FAKE!%';

UPDATE facilities
	SET
		areatype = NULL
	WHERE array_to_string(areatype,',') = 'FAKE!';

UPDATE facilities
	SET
		areatype = string_to_array(REPLACE(array_to_string(areatype,';'),';FAKE!',''),';')
	WHERE array_to_string(areatype,',') LIKE '%FAKE!%';