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
	'hra_idnyc_locations',
	-- hash,
    hash,
	-- geom
	ST_MakePoint(substring(location1 from '\, (.+)\)')::double precision, substring(location1 from '\((.+)\,')::double precision)
    -- idagency
	id,
	-- idname
	'HRA IDNYC ID',
	-- idfield
	'id',
	-- facilityname
	name,
	-- addressnumber
	split_part(trim(both ' ' from initcap(address1)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(address1)), strpos(trim(both ' ' from initcap(address1)), ' ')+1, (length(trim(both ' ' from initcap(address1)))-strpos(trim(both ' ' from initcap(address1)), ' ')))),
	-- address
	initcap(address1),
	-- borough
		(CASE
			WHEN city = 'New York' THEN 'Manhattan'
			WHEN city = 'Bronx' THEN 'Bronx'
			WHEN city = 'Brooklyn' THEN 'Brooklyn'
			WHEN city = 'Staten Island' THEN 'Staten Island'
			ELSE 'Queens'
		END),
	-- zipcode
	zip,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- geomsource
	'agency',
	-- facilitytype
	'IDNYC Location ('||type||')',
	-- facilitysubgroup
	'Financial Assistance and Social Services',
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
	-- operator abbrev
	'Non-public',
	-- oversightagency
	'NYC Human Resources Administration',
	-- oversightabbrev
	'NYCHRA',
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
	hra_idnyc_locations;