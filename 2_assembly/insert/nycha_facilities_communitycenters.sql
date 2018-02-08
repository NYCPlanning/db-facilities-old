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
	'nycha_facilities_communitycenters',
	-- hash,
    hash,
	-- geom
	ST_MakePoint(longitude::double precision, latitude::double precision),
	-- idagency
	NULL,
	NULL,
	NULL,
	-- facilityname
	initcap(development_name),
	-- addressnumber
	split_part(trim(both ' ' from address), ' ', 1),
	-- streetname
	initcap(trim(both ' ' from substr(trim(both ' ' from address), strpos(trim(both ' ' from address), ' ')+1, (length(trim(both ' ' from address))-strpos(trim(both ' ' from address), ' '))))),
	-- address
	initcap(address),
	-- borough
	initcap(borough),
	-- zipcode
	ROUND(zip_code::numeric,0),
	-- bbl
	bbl,
	-- bin
	bin,
	'agency',
	-- facilitytype
	type,
	-- facilitysubgroup
	'Community Centers and Community School Programs',
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
	'New York City Housing Authority',
	-- operatorabbrev
	'NYCHA',
	-- oversightagency
	'New York City Housing Authority',
	-- oversightabbrev
	'NYCHA',
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
	nycha_facilities_communitycenters