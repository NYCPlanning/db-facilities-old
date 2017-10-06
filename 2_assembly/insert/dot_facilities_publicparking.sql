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
	'dot_facilities_publicparking',
	-- hash,
    hash,
	-- geom
	ST_SetSRID(ST_MakePoint(longitude, latitude),4326),
	-- idagency
	abbrev,
	'DOT abbreviation'
	'abbrev',
	-- facilityname
	name,
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- borough
	NULL,
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	'agency',
	-- facilitytype
	'Public Parking',
	-- facilitysubgroup
	'Parking Lots and Garages',
	-- capacity
	capacity::text,
	-- utilization
	NULL,
	-- capacitytype
	'Parking Spaces',
	-- operatortype
	'Public',
	-- operatorname
	'NYC Department of Transportation',
	-- operatorabbrev
	'NYCDOT',
	-- oversightagency
	'NYC Department of Transportation',
	-- oversightabbrev
	'NYCDOT',
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
	dot_facilities_publicparking