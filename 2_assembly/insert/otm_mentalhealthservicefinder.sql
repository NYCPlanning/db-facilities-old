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
	'otm_mentalhealthservicefinder',
	-- hash,
    hash,
	-- geom
	ST_SetSRID(ST_MakePoint(longitude::double precision, latitude::double precision),4326),
	-- idagency
	NULL,
	NULL,
	NULL,
	-- facilityname
	name_2,
	-- addressnumber
	split_part(trim(both ' ' from initcap(street_1)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(street_1)), strpos(trim(both ' ' from initcap(street_1)), ' ')+1, (length(trim(both ' ' from initcap(street_1)))-strpos(trim(both ' ' from initcap(street_1)), ' ')))),
	-- address
	initcap(street_1),
	-- borough
	(CASE
		WHEN upper(city) = 'NEW YORK' THEN 'Manhattan'
		WHEN upper(city) = 'BRONX' THEN 'Bronx'
		WHEN upper(city) = 'BROOKLYN' THEN 'Brooklyn'
		WHEN upper(city) = 'STATEN ISLAND' THEN 'Staten Island'
		ELSE 'Queens'
	END),
	-- zipcode
	zip,
	-- bbl
	NULL,
	-- bin
	NULL,
	'agency',
	-- facilitytype
	'Other Mental Health',
	-- facilitysubgroup
	'Mental Health',
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
	name_1,
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	'NYC Department of Health and Mental Hygiene',
	-- oversightabbrev
	'NYCDOHMH',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
	FALSE,
	-- youth
	FALSE,
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
	otm_mentalhealthservicefinder