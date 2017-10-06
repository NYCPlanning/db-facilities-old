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
	'hra_facilities_centers',
	-- hash,
    hash,
	-- geom
	NULL,	
	-- idagency
	NULL,
	NULL,
	NULL,
	-- facilityname
	name,
	-- addressnumber
	split_part(trim(both ' ' from Address), ' ', 1),
	-- streetname
	initcap(split_part(trim(both ' ' from Address), ' ', 2)),
	-- address
	initcap(Address),
	-- borough
	initcap(Borough),
	-- zipcode
	zipcode::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	NULL,
	-- facilitytype
	REPLACE(Type,'HASA','HIV/AIDS Services'),
	-- facilitysubgroup
	(CASE
		WHEN type = 'Job Centers' THEN 'Workforce Development'
		ELSE 'Financial Assistance and Social Services'
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
	'Public',
	-- operatorname
	'NYC Human Resources Administration/Department of Social Services',
	-- operatorabbrev
	'NYCHRA/DSS',
	-- oversightagency
	'NYC Human Resources Administration/Department of Social Services',
	-- oversightabbrev
	'NYCHRA/DSS',
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
	hra_facilities_centers