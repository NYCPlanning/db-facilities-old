UPDATE facilities
	SET
		idagency = 
			(CASE
				WHEN array_to_string(idagency,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(idagency,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(idagency,';'),';FAKE!',''),'FAKE!;',''),';')
			END),
		bin =
			(CASE
				WHEN array_to_string(bin,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(bin,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(bin,';'),';FAKE!',''),'FAKE!;',''),';')
			END),
		bbl =
			(CASE
				WHEN array_to_string(bbl,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(bbl,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(bbl,';'),';FAKE!',''),'FAKE!;',''),';')
			END),
		capacity =
			(CASE
				WHEN array_to_string(capacity,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(capacity,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(capacity,';'),';FAKE!',''),'FAKE!;',''),';')
			END),
		captype =
			(CASE
				WHEN array_to_string(captype,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(captype,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(captype,';'),';FAKE!',''),'FAKE!;',''),';')
			END),
		util =
			(CASE
				WHEN array_to_string(util,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(util,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(util,';'),';FAKE!',''),'FAKE!;',''),';')
			END),
		area =
			(CASE
				WHEN array_to_string(area,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(area,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(area,';'),';FAKE!',''),'FAKE!;',''),';')
			END),
		areatype =
			(CASE
				WHEN array_to_string(areatype,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(areatype,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(areatype,';'),';FAKE!',''),'FAKE!;',''),';')
			END),
		dataname =
			(CASE
				WHEN array_to_string(dataname,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(dataname,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(dataname,';'),';FAKE!',''),'FAKE!;',''),';')
			END),
		dataurl =
			(CASE
				WHEN array_to_string(dataurl,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(dataurl,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(dataurl,';'),';FAKE!',''),'FAKE!;',''),';')
			END)