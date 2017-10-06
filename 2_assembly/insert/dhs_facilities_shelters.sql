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
	'dhs_facilities_shelters',
	-- hash,
    hash,
	-- geom
	(CASE
		WHEN x_coordinate IS NOT NULL THEN ST_Transform(ST_SetSRID(ST_MakePoint(x_coordinate, y_coordinate), 2236),4326)
	END),
	-- idagency
	(CASE
		WHEN Unique_ID IS NOT NULL THEN Unique_ID
	END),
	'Unique ID',
	'unique_id',
	-- facilityname
	initcap(Facility_Name),
	-- addressnumber
	address_number,
	-- streetname
	initcap(street_name),
	-- address
	CONCAT(address_number,' ',initcap(street_name)),
	-- borough
	initcap(Borough),
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	'agency',
	-- facilitytype
	initcap(facility_type),
	-- facilitysubgroup
	(CASE
		WHEN (facility_type LIKE '%DROP%' OR facility_type LIKE '%Drop%') THEN 'Non-residential Housing and Homeless Services'
		WHEN facility_type LIKE '%Supportive Housing%' THEN 'Permanent Supportive SRO Housing' 
		ELSE 'Shelters and Transitional Housing'
	END),
	-- capacity
	(CASE
		WHEN capacity <> '--' THEN ARRAY[capacity::text]
	END),
	-- utilization
	NULL,
	-- capacitytype
	(CASE
		WHEN capacity <> '--' AND capacity IS NOT NULL THEN ARRAY[capacity_type]
	END),
	-- utilizationrate
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
		(CASE
			WHEN provider_name LIKE '%NYC Dept%' THEN 'Public'
			ELSE 'Non-public'
		END),
	-- operatorname
	initcap(provider_name),
	-- operatorabbrev
		(CASE
			WHEN provider_name LIKE '%NYC Dept%' THEN 'NYCDHS'
			ELSE 'Non-public'
		END),
	-- oversightagency
	'NYC Department of Homeless Services',
	-- oversightabbrev
	'NYCDHS',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
	FALSE,
	-- youth
	FALSE,
	-- senior
	FALSE,
	-- family
	(CASE
		WHEN facility_type LIKE '%Family%' THEN TRUE
		ELSE FALSE
	END),
	-- disabilities
	FALSE,
	-- dropouts
	FALSE,
	-- unemployed
	FALSE,
	-- homeless
	TRUE,
	-- immigrants
	FALSE,
	-- groupquarters
	TRUE
FROM 
	dhs_facilities_shelters;