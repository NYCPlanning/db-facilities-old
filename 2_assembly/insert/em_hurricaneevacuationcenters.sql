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
	'em_hurricaneevacuationcenters',
	-- hash,
    hash,
	-- geom
	geom,
	-- idagency
	NULL,
	NULL,
	NULL,
	-- facilityname
	initcap(ec_name),
	-- addressnumber
	initcap(split_part(REPLACE(REPLACE(address,' - ','-'),' -','-'), ' ', 1)),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(split_part(REPLACE(REPLACE(address,' - ','-'),' -','-'), '(', 1))), strpos(trim(both ' ' from initcap(split_part(REPLACE(REPLACE(address,' - ','-'),' -','-'), '(', 1))), ' ')+1, (length(trim(both ' ' from initcap(split_part(REPLACE(REPLACE(address,' - ','-'),' -','-'), '(', 1))))-strpos(trim(both ' ' from initcap(split_part(REPLACE(REPLACE(address,' - ','-'),' -','-'), '(', 1))), ' ')))),
	-- address
	initcap(split_part(REPLACE(REPLACE(address,' - ','-'),' -','-'), '(', 1)),
	-- borough
	(CASE
		WHEN borocode = 1 THEN 'Manhattan'
		WHEN borocode = 2 THEN 'Bronx'
		WHEN borocode = 3 THEN 'Brooklyn'
		WHEN borocode = 4 THEN 'Queens'
		WHEN borocode = 5 THEN 'Staten Island'
	END),
	-- zipcode
	zip_code,
	-- bbl
	bbl,
	-- bin
	bin,
	'agency',
	-- facilitytype
	'EM Hurricane Evacuation Center',
	-- facilitysubgroup
	'Other Public Safety',
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
	'NYC Office of Emergency Management',
	-- operatorabbrev
	'NYCEM',
	-- oversightagency
	'NYC Office of Emergency Management',
	-- oversightabbrev
	'NYCEM',
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
	em_hurricaneevacuationcenters