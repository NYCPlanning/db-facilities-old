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
	'foodbankny_facilities_foodbanks',
	-- hash,
    hash,
	-- geom
	ST_SetSRID(ST_MakePoint(longitude_x, latitude_y),4326),	
	-- idagency
	NULL,
	NULL,
	NULL,
	-- facilityname
	name,
	-- address number
	split_part(trim(both ' ' from address), ' ', 1),
	-- street name
	initcap(trim(both ' ' from substr(trim(both ' ' from address), strpos(trim(both ' ' from address), ' ')+1, (length(trim(both ' ' from address))-strpos(trim(both ' ' from address), ' '))))),
	-- address
	address,
	-- borough
	NULL,
	-- zipcode
	LEFT(zip_code,5)::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	'agency',
	-- facilitytype
		(CASE
			WHEN fbc_agency_category_code = 'PANTRY' THEN 'Food Pantry'
			WHEN fbc_agency_category_code = 'SOUP KITCH' THEN 'Soup Kitchen'
		END),
	-- facilitysubgroup
	'Soup Kitchens and Food Pantries',
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
	name,
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	'Non-public',
	-- oversightabbrev
	'Non-public',
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
	foodbankny_facilities_foodbanks
