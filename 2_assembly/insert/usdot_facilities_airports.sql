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
	'usdot_facilities_airports',
	-- hash,
    hash,
	-- geom
	geom,
	-- idagency
	locationid,
	'USDOT Location ID',
	'locationid',
	-- facilityname
	fullname,
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- borough
		(CASE
			WHEN (stateabbv = 'NY') AND (County = 'New York') THEN 'Manhattan'
			WHEN (stateabbv = 'NY') AND (County = 'Bronx') THEN 'Bronx'
			WHEN (stateabbv = 'NY') AND (County = 'Kings') THEN 'Brooklyn'
			WHEN (stateabbv = 'NY') AND (County = 'Queens') THEN 'Queens'
			WHEN (stateabbv = 'NY') AND (County = 'Richmond') THEN 'Staten Island'
		END),
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	'agency',
	-- facilitytype
	facilityty,
	-- facilitysubgroup
	'Airports and Heliports',
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
		(CASE
			WHEN ownertype = 'Pr' THEN 'Non-public'
			ELSE 'Public'
		END),
	-- operatorname
		(CASE
			WHEN ownertype = 'Pr' THEN fullname
			ELSE 'Public'
		END),
	-- operatorabbrev
		(CASE
			WHEN ownertype = 'Pr' THEN 'Non-public'
			ELSE 'Public'
		END),
	-- oversightagency
	'US Department of Transportation',
	-- oversightabbrev
	'USDOT',
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
	usdot_facilities_airports
WHERE
	stateabbv = 'NY' 
	AND (County = 'New York'
	OR County = 'Bronx'
	OR County = 'Kings'
	OR County = 'Queens'
	OR County = 'Richmond')