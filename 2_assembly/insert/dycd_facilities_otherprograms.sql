INSERT INTO
facilities (
	pgtable,
	hash,
	geom,
	idagency,
	idname,
	idfield,
	facname,
	addressnum,
	streetname,
	address,
	boro,
	zipcode,
	bbl,
	bin,
	geomsource,
	factype,
	facsubgrp,
	capacity,
	util,
	capacitytype,
	utilrate,
	area,
	areatype,
	optype,
	opname,
	opabbrev,
	overagency,
	overabbrev,
	datecreated,
	children,
	youth,
	senior,
	family,
	disabilities,
	dropouts,
	unemployed,
	homeless,
	immigrants,
	groupquarters
)
SELECT
	-- pgtable
	'dycd_facilities_otherprograms',
	-- hash,
    hash,
	-- geom
	NULL,
	-- idagency
	Unique_ID,
	'DYCH Unique ID',
	'Unique_ID',
	-- facilityname
	initcap(Facility_Name),
	-- addressnumber
	split_part(trim(both ' ' from address_number), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from address_number), strpos(trim(both ' ' from address_number), ' ')+1, (length(trim(both ' ' from address_number))-strpos(trim(both ' ' from address_number), ' ')))),
	-- address
	address_number,
	-- borough
	initcap(Borough),
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	NULL,
	-- facilitytype
	(CASE
		WHEN facility_type LIKE '%Literacy%' THEN 'Literacy Program'
		WHEN facility_type LIKE '%Beacon%' THEN 'Beacon Community Center Program'
		WHEN facility_type LIKE '%COMPASS%' THEN 'COMPASS Program'
		WHEN facility_type LIKE '%Cornerstone%' THEN 'Cornerstone Community Center Program'
		WHEN facility_type LIKE '%NDA%' OR facility_type LIKE '%Neighborhood Development%' THEN 'Neighborhood Development Area Program'
		ELSE 'Other Youth Program'
	END),
	-- facilitysubgroup
		(CASE
			WHEN facility_type LIKE '%COMPASS%' THEN 'Comprehensive After School System (COMPASS) Sites'
			WHEN facility_type LIKE '%Summer%' THEN 'Summer Youth Employment Site'
			ELSE 'Youth Centers, Literacy Programs, Job Training, and Immigrant Services'
		END),
	-- capacity
	NULL,
	-- utilization
	NULL,
	-- capacitytype
	NULL,
	-- utilizationrate
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
	'Non-public',
	-- operatorname
	provider_name,
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	'NYC Department of Youth and Community Development',
	-- oversightabbrev
	'NYCDYCD',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
	FALSE,
	-- youth
	TRUE,
	-- senior
	FALSE,
	-- family
	FALSE,
	-- disabilities
	FALSE,
	-- dropouts
	FALSE,
	-- unemployed
	FALSE,
	-- homeless
	FALSE,
	-- immigrants
	FALSE,
	-- groupquarters
	FALSE
FROM 
	dycd_facilities_otherprograms
WHERE
	facility_type NOT LIKE '%Summer%'
	AND facility_type NOT LIKE '%Work, Learn & Grow Employment Program%'