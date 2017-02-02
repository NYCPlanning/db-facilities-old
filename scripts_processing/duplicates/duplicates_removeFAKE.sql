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