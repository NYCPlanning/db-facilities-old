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
	'dsny_facilities_mtsgaragemaintenance',
	-- hash,
    hash,
	-- geom
	geom,
	-- idagency
	NULL,
	NULL,
	NULL,
	-- facilityname
		(CASE
			WHEN facility_t = 'GARAGE' THEN CONCAT(facility_n,' ',facility_t)
			WHEN facility_t <> 'GARAGE' THEN CONCAT(facility_n)
		END),
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- borough
	initcap(geo_boro),
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	'agency',
	-- facilitytype
		(CASE
			WHEN facility_t = 'MTS' THEN 'DSNY Marine Transfer Station'
			WHEN facility_t = 'GARAGE' THEN 'DSNY Garage'
			WHEN facility_t = 'REPAIR' THEN 'DSNY Repair Facility'
		END),
	-- facilitysubgroup
	'Solid Waste Transfer and Carting',
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
	'NYC Department of Sanitation',
	-- operatorabbrev
	'NYCDSNY',
	-- oversightagency
	'NYC Department of Sanitation',
	-- oversightabbrev
	'NYCDSNY',
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
	dsny_facilities_mtsgaragemaintenance