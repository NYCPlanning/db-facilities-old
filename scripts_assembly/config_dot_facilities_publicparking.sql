INSERT INTO
facilities (
	pgtable,
	hash,
	geom,
	idagency,
	facilityname,
	addressnumber,
	streetname,
	address,
	borough,
	zipcode,
	bbl,
	bin,
	facilitytype,
	domain,
	facilitygroup,
	facilitysubgroup,
	agencyclass1,
	agencyclass2,
	capacity,
	utilization,
	capacitytype,
	utilizationrate,
	area,
	areatype,
	operatortype,
	operatorname,
	operatorabbrev,
	oversightagency,
	oversightabbrev,
	datecreated,
	buildingid,
	buildingname,
	schoolorganizationlevel,
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
	ARRAY['dot_facilities_publicparking'],
	-- hash,
	md5(CAST((dot_facilities_publicparking.*) AS text)),
	-- geom
	ST_SetSRID(ST_MakePoint(longitude, latitude),4326),
	-- idagency
	ARRAY[abbrev],
	-- facilityname
	name,
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- borough
	NULL,
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
	'Public Parking Facility',
	-- domain
	'Core Infrastructure and Transportation',
	-- facilitygroup
	'Transportation',
	-- facilitysubgroup
	'Parking Lots and Garages',
	-- agencyclass1
	'NA',
	-- agencyclass2
	'NA',
	-- capacity
	capacity,
	-- utilization
	NULL,
	-- capacitytype
	'Parking Spaces',
	-- utilizationrate
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
	'Public',
	-- operatorname
	'New York City Department of Transportation',
	-- operatorabbrev
	'NYCDOT',
	-- oversightagency
	ARRAY['New York City Department of Transportation'],
	-- oversightabbrev
	ARRAY['NYCDOT'],
	-- datecreated
	CURRENT_TIMESTAMP,
	-- buildingid
	NULL,
	-- buildingname
	NULL,
	-- schoolorganizationlevel
	NULL,
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
	dot_facilities_publicparking