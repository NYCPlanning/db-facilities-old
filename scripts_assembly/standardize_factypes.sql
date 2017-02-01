UPDATE facilities AS f
    SET 
		facilitytype = REPLACE(facilitytype, 'Other ', '')
	WHERE
		facilitytype LIKE '%Other %'
		AND facilitytype NOT LIKE '% Other%';

UPDATE facilities AS f
    SET 
		facilitytype = CONCAT(facilitytype, ' Mental Health')
	WHERE
		facilitysubgroup = 'Mental Health'
		AND facilitytype NOT LIKE '%Mental Health%';

UPDATE facilities AS f
    SET 
		facilitytype = CONCAT(facilitytype, ' Chemical Dependency')
	WHERE
		facilitysubgroup = 'Chemical Dependency'
		AND facilitytype NOT LIKE '%Chemical Dependency%';