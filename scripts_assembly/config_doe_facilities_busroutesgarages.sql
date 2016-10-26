INSERT INTO
facilities (
	id,
	idold,
	idagency,
	facilityname,
	addressnumber,
	streetname,
	address,
	city,
	borough,
	boroughcode,
	zipcode,
	bbl,
	bin,
	parkid,
	xcoord,
	ycoord,
	latitude,
	longitude,
	facilitytype,
	domain,
	facilitygroup,
	facilitysubgroup,
	agencyclass1,
	agencyclass2,
	colpusetype,
	capacity,
	utilization,
	capacitytype,
	utilizationrate,
	area,
	areatype,
	servicearea,
	operatortype,
	operatorname,
	operatorabbrev,
	oversightagency,
	oversightabbrev,
	dateactive,
	dateinactive,
	inactivestatus,
	tags,
	notes,
	datesourcereceived,
	datesourceupdated,
	datecreated,
	dateedited,
	creator,
	editor,
	geom,
	agencysource,
	sourcedatasetname,
	linkdata,
	linkdownload,
	datatype,
	refreshmeans,
	refreshfrequency,
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
	-- id
	NULL,
	-- idold
	NULL,
	-- idagency
	NULL,
	-- facilityname
	initcap(Vendor_Name),
	-- addressnumber
	split_part(trim(both ' ' from Garage_Street_Address), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from Garage_Street_Address), strpos(trim(both ' ' from Garage_Street_Address), ' ')+1, (length(trim(both ' ' from Garage_Street_Address))-strpos(trim(both ' ' from Garage_Street_Address), ' ')))),
	-- address
	Garage_Street_Address,
	-- city
	Garage_City,
	-- borough
	NULL,
	-- boroughcode
	NULL,
	-- zipcode
	Garage_Zip::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- parkid
	NULL,
	-- xcoord
	XCoordinates,
	-- ycoord
	YCoordinates,
	-- latitude
	ST_Y(ST_Transform(ST_SetSRID(ST_MakePoint(XCoordinates, YCoordinates),2263),4326)),
	-- longitude
	ST_X(ST_Transform(ST_SetSRID(ST_MakePoint(XCoordinates, YCoordinates),2263),4326)),
	-- facilitytype
	'School Bus Depot',
	-- domain
	'Core Infrastructure and Transportation',
	-- facilitygroup
	'Transportation',
	-- facilitysubgroup
	'Bus Depots and Terminals',
	-- agencyclass1
	'NA',
	-- agencyclass2
	'NA',
	-- colpusetype
	NULL,
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
	-- servicearea
	NULL,
	-- operatortype
	'Non-public',
	-- operatorname
	initcap(Vendor_Name),
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	'New York City Department of Education',
	-- oversightabbrev
	'NYCDOE',
	-- dateactive
	NULL,
	-- dateinactive
	NULL,
	-- inactivestatus
	NULL,
	-- tags
	NULL,
	-- notes
	NULL,
	-- datesourcereceived
	'2016-08-01',
	-- datesourceupdated
	'2016-08-01',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- dateedited
	CURRENT_TIMESTAMP,
	-- creator
	'Hannah Kates',
	-- editor
	'Hannah Kates',
	-- geom
	-- ST_SetSRID(ST_MakePoint(long, lat),4326)
	ST_Transform(ST_SetSRID(ST_MakePoint(XCoordinates, YCoordinates),2263),4326),
	-- NAD 1983 StatePlane New York Long Island FIPS 3104 Feet
	-- agencysource
	'NYCDOE',
	-- sourcedatasetname
	'Routes',
	-- linkdata
	'https://data.cityofnewyork.us/Transportation/Routes/8yac-vygm',
	-- linkdownload
	'https://data.cityofnewyork.us/api/views/8yac-vygm/rows.csv?accessType=DOWNLOAD',
	-- datatype
	'CSV with Coordinates',
	-- refreshmeans
	'Pull from NYC Open Data',
	-- refreshfrequency
	'Monthly',
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
	doe_facilities_busroutesgarages
WHERE
	School_Year = '2015-2016'
GROUP BY
	Vendor_Name,
	Garage_Street_Address,
	Garage_City,
	Garage_Zip,
	XCoordinates,
	YCoordinates