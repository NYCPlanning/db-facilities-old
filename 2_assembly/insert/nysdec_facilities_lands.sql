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
	'nysdec_facilities_lands',
	-- hash,
    hash,
	-- geom
	ST_Centroid(geom),
	-- idagency
	gid,
	'NYSDEC Global ID',
	'gid',
	-- facilityname
	initcap(facility),
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- borough
		(CASE
			WHEN County = 'NEW YORK' THEN 'Manhattan'
			WHEN County = 'BRONX' THEN 'Bronx'
			WHEN County = 'KINGS' THEN 'Brooklyn'
			WHEN County = 'QUEENS' THEN 'Queens'
			WHEN County = 'RICHMOND' THEN 'Staten Island'
		END),
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	'agency',
	-- facilitytype
		(CASE
			WHEN category = 'NRA' THEN 'Natural Resource Area'
			ELSE initcap(category)
		END),
	-- facilitysubgroup
	'Preserves and Conservation Areas',
	-- capacity
	NULL,
	-- utilization
	NULL,
	-- capacitytype
	NULL,
	-- utilizationrate
	NULL,
	-- area
	acres,
	-- areatype
	'Acres',
	-- operatortype
	'Public',
	-- operatorname
	'NYS Department of Environmental Conservation',
	-- operatorabbrev
	'NYSDEC',
	-- oversightagency
	'NYS Department of Environmental Conservation',
	-- oversightabbrev
	'NYSDEC',
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
	nysdec_facilities_lands
WHERE
	County = 'NEW YORK'
	OR County = 'BRONX'
	OR County = 'KINGS'
	OR County = 'QUEENS'
	OR County = 'RICHMOND'