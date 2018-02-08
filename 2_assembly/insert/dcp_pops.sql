DROP FROM dcp_pops
WHERE popsnumber IS NULL;

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
	'dcp_pops',
	-- hash,
    hash,
	-- geom
	ST_SetSRID(ST_MakePoint(longitude::double precision, latitude::double precision),4326),
	-- idagency
	popsnumber,
	'POPS Number',
	'popsnumber',
	-- facilityname
	(CASE
		WHEN alternative IS NOT NULL AND alternative <> '' THEN alternative
		ELSE buildingaddress
	END),
	-- addressnumber
	split_part(trim(both ' ' from initcap(buildingaddress)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(buildingaddress)), strpos(trim(both ' ' from initcap(buildingaddress)), ' ')+1, (length(trim(both ' ' from initcap(buildingaddress)))-strpos(trim(both ' ' from initcap(buildingaddress)), ' ')))),
	-- address
	initcap(buildingaddress),
	-- borough
		(CASE
			WHEN LEFT(popsnumber,1) = 'B' THEN 'Bronx'
			WHEN LEFT(popsnumber,1) = 'K' THEN 'Brooklyn'
			WHEN LEFT(popsnumber,1) = 'Q' THEN 'Queens'
			WHEN LEFT(popsnumber,1) = 'M' THEN 'Manhattan'
			ELSE 'Manhattan'
		END),
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	NULL,
	-- facilitytype
	'Privately Owned Public Space',
	-- facilitysubgroup
	'Privately Owned Public Space',
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
	'Not Available',
	-- operator abbrev
	'Non-public',
	-- oversightagency
	'NYC Department of Buildings',
	-- oversightabbrev
	'NYCDOB',
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
	dcp_pops