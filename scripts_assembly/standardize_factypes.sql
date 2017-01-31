UPDATE facilities AS f
    SET 
		facilitytype = REPLACE(facilitytype, 'Other ', '');
	WHERE
		facilitytype NOT LIKE '% Other%';