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
	'omb_facilities_libraryvisits',
	-- hash,
    hash,
	-- geom
	ST_SetSRID(ST_MakePoint(lon, lat),4326),
	-- idagency
	NULL,
	NULL,
	NULL,
	-- facilityname
	split_part(name,' - ',1),
	-- addressnumber
	housenum,
	-- streetname
	initcap(streetname),
	-- address
	CONCAT(housenum,' ',initcap(streetname)),
	-- borough
	boroname,
	-- zipcode
	ROUND(zip::numeric,0),
	-- bbl
	ROUND(bbl::numeric,0),
	-- bin
	ROUND(bin::numeric,0),
	'agency',
	-- facilitytype
	'Public Libraries',
	-- facilitysubgroup
	'Public Libraries',
	-- capacity
	NULL,
	-- utilization
	visits::text,
	-- capacitytype
	'Visits',
	-- utilizationrate
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
	'Non-public',
	-- operatorname
		(CASE
			WHEN system = 'QPL' THEN 'Queens Public Library'
			WHEN system = 'BPL' THEN 'Brooklyn Public Library'
			WHEN system = 'NYPL' THEN 'New York Public Library'
		END),
	-- operatorabbrev
	system,
	-- oversightagency
		(CASE
			WHEN system = 'QPL' THEN 'Queens Public Library'
			WHEN system = 'BPL' THEN 'Brooklyn Public Library'
			WHEN system = 'NYPL' THEN 'New York Public Library'
		END),
	-- oversightabbrev
	system,
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
	omb_facilities_libraryvisits