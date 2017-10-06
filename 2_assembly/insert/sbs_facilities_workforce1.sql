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
	'sbs_facilities_workforce1',
	-- hash,
    hash,
	-- geom
	ST_SetSRID(ST_MakePoint(Longitude::numeric, Latitude::numeric),4326),
	-- idagency
	NULL,
	NULL,
	NULL,
	-- facilityname
	Name,
	-- addressnumber
	HouseNumber,
	-- streetname
	Street,
	-- address
 	CONCAT(HouseNumber, ' ', Street),
	-- borough
	Borough,
	-- zipcode
	Postcode::integer,
	-- bbl
	bbl,
	-- bin
	bin,
	'agency',
	-- facilitytype
	Location_Type,
	-- facilitysubgroup
	'Workforce Development',
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
	'NYC Department of Small Business Services',
	-- operatorabbrev
	'NYCSBS',
	-- oversightagency
	'NYC Department of Small Business Services',
	-- oversightabbrev
	'NYCSBS',
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
	TRUE,
	-- homeless
	FALSE,
	-- immigrants
	FALSE,
	-- groupquarters
	FALSE
FROM 
	sbs_facilities_workforce1