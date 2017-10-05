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
	'dcp_facilities_pops',
	-- hash,
    hash,
	-- geom
	NULL,
	-- idagency
	DCP_RECORD,
	'DCP Record ID',
	'dcp_record',
	-- facilityname
	(CASE
		WHEN Building_Name IS NOT NULL AND Building_Name <> '' THEN Building_Name
		ELSE Building_Address
	END),
	-- addressnumber
	split_part(trim(both ' ' from initcap(Building_Address)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(Building_Address)), strpos(trim(both ' ' from initcap(Building_Address)), ' ')+1, (length(trim(both ' ' from initcap(Building_Address)))-strpos(trim(both ' ' from initcap(Building_Address)), ' ')))),
	-- address
	initcap(Building_Address),
	-- borough
		(CASE
			WHEN LEFT(DCP_RECORD,1) = 'B' THEN 'Brooklyn'
			WHEN LEFT(DCP_RECORD,1) = 'Q' THEN 'Queens'
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
	ARRAY['NYC Department of City Planning', 'NYC Department of Buildings'],
	-- oversightabbrev
	ARRAY['NYCDCP', 'NYCDOB'],
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
	dcp_facilities_pops