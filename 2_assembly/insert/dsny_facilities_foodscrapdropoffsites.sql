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
	'dsny_facilities_foodscrapdropoffsites',
	-- hash,
    hash,
	-- geom
	ST_MakePoint(longitude:double precision, latitude::double precision),
	-- idagency
	NULL,
	NULL,
	NULL,
	-- facilityname
	name,
	-- addressnumber
	split_part(trim(both ' ' from initcap(location)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(location)), strpos(trim(both ' ' from initcap(location)), ' ')+1, (length(trim(both ' ' from initcap(location)))-strpos(trim(both ' ' from initcap(location)), ' ')))),
	-- address
	initcap(location),
	-- borough
	(CASE
		WHEN borough = 'MN' THEN 'Manhattan'
		WHEN borough = 'BX' THEN 'Bronx'
		WHEN borough = 'BK' THEN 'Brooklyn'
		WHEN borough = 'SI' THEN 'Staten Island'
		WHEN borough = 'QN' THEN 'Queens'
		ELSE borough
	END),
	-- zipcode
	postcode,
	-- bbl
	bbl,
	-- bin
	bin,
	'agency',
	-- facilitytype
	'DSNY Food Scrap Drop-off Site',
	-- facilitysubgroup
	'Solid Waste Transfer and Carting',
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
	organizer,
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	'NYC Department of Sanitation',
	-- oversightabbrev
	'NYCDSNY',
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
	dsny_facilities_foodscrapdropoffsites