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
	'dfta_facilities_contracts',
	-- hash,
    hash,
	-- geom
	NULL,
	-- idagency
	Provider_ID,
	'Provider ID',
	'Provider_ID',
	-- facilityname
	initcap(Sponsor_Name),
	-- addressnumber
	split_part(trim(both ' ' from initcap(Program_Address)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(Program_Address)), strpos(trim(both ' ' from initcap(Program_Address)), ' ')+1, (length(trim(both ' ' from initcap(Program_Address)))-strpos(trim(both ' ' from initcap(Program_Address)), ' ')))),
	-- address
	initcap(Program_Address),
	-- borough
	NULL,
	-- zipcode
	Program_Zipcode::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	NULL,
	-- facilitytype
		(CASE
			WHEN Contract_Type LIKE '%INNOVATIVE%' AND RIGHT(Provider_ID,2) <> '01' THEN 'Satellite Senior Centers'
			WHEN Contract_Type LIKE '%NEIGHBORHOOD%' AND RIGHT(Provider_ID,2) <> '01' THEN 'Satellite Senior Centers'
			WHEN Contract_Type LIKE '%INNOVATIVE%' THEN 'Innovative Senior Centers'
			WHEN Contract_Type LIKE '%NEIGHBORHOOD%' THEN 'Neighborhood Senior Centers'
			WHEN Contract_Type LIKE '%MEALS%' THEN  initcap(Contract_Type)
			ELSE 'Senior Services'
		END),
	-- facilitysubgroup
	'Senior Services',
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
	initcap(Sponsor_Name),
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	'NYC Department for the Aging',
	-- oversightabbrev
	'NYCDFTA',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
	FALSE,
	-- youth
	FALSE,
	-- senior
	TRUE,
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
	dfta_facilities_contracts