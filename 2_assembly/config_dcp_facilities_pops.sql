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
	ARRAY['dcp_facilities_pops'],
	-- hash,
	md5(CAST((dcp_facilities_pops.*) AS text)),
	-- geom
	NULL,
	-- idagency
	ARRAY[DCP_RECORD],
	-- facilityname
	Public_Space_1,
	-- addressnumber
	split_part(trim(both ' ' from initcap(Building_Address)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(Building_Address)), strpos(trim(both ' ' from initcap(Building_Address)), ' ')+1, (length(trim(both ' ' from initcap(Building_Address)))-strpos(trim(both ' ' from initcap(Building_Address)), ' ')))),
	-- address
	initcap(Building_Address),
	-- borough
		(CASE
			WHEN City_State LIKE '%New York%' THEN 'Manhattan'
			WHEN City_State LIKE '%Brooklyn%' THEN 'Bronx'
			WHEN City_State LIKE '%Queens%' THEN 'Queens'
		END),
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
	Public_Space_1,
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
	ARRAY['NYC Department of City Planning'],
	-- oversightabbrev
	ARRAY['NYCDCP'],
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
	dcp_facilities_pops