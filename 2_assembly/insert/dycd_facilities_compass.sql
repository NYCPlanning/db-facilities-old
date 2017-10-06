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
	'dycd_facilities_compass',
	-- hash,
    hash,
	-- geom
	NULL,
	-- idagency
	NULL,
	NULL,
	NULL,
	-- facilityname
	provider_name,
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
	NULL,
	-- facilitytype
	'COMPASS Program',
	-- facilitysubgroup
	'Comprehensive After School System (COMPASS) Sites',
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
	provider_name,
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	'NYC Department of Youth and Community Development',
	-- oversightabbrev
	'NYCDYCD',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
	FALSE,
	-- youth
	TRUE,
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
	dycd_facilities_compass
GROUP BY
	hash,
	Address_Number,
	Street_Name,
	Borough,
	BBLs,
	BIN,
	X_Coordinate,
	Y_Coordinate,
	Provider_Name,
	Date_Source_Data_Updated