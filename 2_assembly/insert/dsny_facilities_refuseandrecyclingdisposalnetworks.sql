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
	'dsny_facilities_refuseandrecyclingdisposalnetworks',
	-- hash,
    hash,
	-- geom
	ST_MakePoint(longitude:double precision, latitude::double precision),
	-- idagency
	NULL,
	NULL,
	NULL,
	-- facilityname
	location,
	-- addressnumber
	split_part(trim(both ' ' from initcap(location)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(location)), strpos(trim(both ' ' from initcap(location)), ' ')+1, (length(trim(both ' ' from initcap(location)))-strpos(trim(both ' ' from initcap(location)), ' ')))),
	-- address
	initcap(location),
	-- borough
	initcap(borough),
	-- zipcode
	postcode,
	-- bbl
	bbl,
	-- bin
	bin,
	'agency',
	-- facilitytype
	'DSNY Refuse and Recycling Disposal Network ('||material||')',
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
	'Public',
	-- operatorname
	'NYC Department of Sanitation',
	-- operatorabbrev
	'NYCDSNY',
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
	dsny_facilities_refuseandrecyclingdisposalnetworks