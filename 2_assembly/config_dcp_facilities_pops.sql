INSERT INTO
facilities (
	pgtable,
	hash,
	geom,
	idagency,
	facname,
	addressnum,
	streetname,
	address,
	boro,
	zipcode,
	bbl,
	bin,
	factype,
	facdomain,
	facgroup,
	facsubgrp,
	agencyclass1,
	agencyclass2,
	capacity,
	util,
	captype,
	utilrate,
	area,
	areatype,
	optype,
	opname,
	opabbrev,
	overagency,
	overabbrev,
	datecreated,
	buildingid,
	buildingname,
	schoolorganizationlevel,
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
	ARRAY['dcp_pops'],
	-- hash,
    hash,
	-- geom
	ST_SetSRID(ST_MakePoint(longitude::double precision, latitude::double precision),4326),
	-- idagency
	ARRAY[popsnumber],
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
	-- facilitytype
	'Privately Owned Public Space',
	-- domain
	'Parks, Gardens, and Historical Sites',
	-- facilitygroup
	'Parks and Plazas',
	-- facilitysubgroup
	'Privately Owned Public Space',
	-- agencyclass1
	NULL,
	-- agencyclass2
	NULL,
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
	ARRAY['NYC Department of City Planning', 'NYC Department of Buildings'],
	-- oversightabbrev
	ARRAY['NYCDCP', 'NYCDOB'],
	-- datecreated
	CURRENT_TIMESTAMP,
	-- buildingid
	NULL,
	-- buildingname
	NULL,
	-- schoolorganizationlevel
	NULL,
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