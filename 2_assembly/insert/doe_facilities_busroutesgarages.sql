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
	'doe_facilities_busroutesgarages',
	-- hash,
    hash,
	-- geom
	ST_Transform(ST_SetSRID(ST_MakePoint(XCoordinates, YCoordinates),2263),4326),
	-- idagency
	NULL,
	NULL,
	NULL,
	-- facilityname
	initcap(Vendor_Name),
	-- addressnumber
	split_part(trim(both ' ' from Garage_Street_Address), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from Garage_Street_Address), strpos(trim(both ' ' from Garage_Street_Address), ' ')+1, (length(trim(both ' ' from Garage_Street_Address))-strpos(trim(both ' ' from Garage_Street_Address), ' ')))),
	-- address
	Garage_Street_Address,
	-- borough
	NULL,
	-- zipcode
	Garage_Zip::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	'agency',
	-- facilitytype
	'School Bus Depot',
	-- facilitysubgroup
	'Bus Depots and Terminals',
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
	initcap(Vendor_Name),
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	'NYC Department of Education',
	-- oversightabbrev
	'NYCDOE',
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
	doe_facilities_busroutesgarages
WHERE
	School_Year = '2015-2016'
GROUP BY
	hash,
	Vendor_Name,
	Garage_Street_Address,
	Garage_City,
	Garage_Zip,
	XCoordinates,
	YCoordinates