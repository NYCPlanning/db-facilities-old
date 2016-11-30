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
	abbrev,
	-- facilityname
	name,
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- city
	NULL,
	-- borough
	NULL,
	-- boroughcode
	NULL,
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- parkid
	NULL,
	-- xcoord
	NULL,
	-- ycoord
	NULL,
	-- latitude
	latitude,
	-- longitude
	longitude,
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
	-- colpusetype
	NULL,
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
	-- servicearea
	NULL,
	-- operatortype
	'Public',
	-- operatorname
	'New York City Department of Transportation',
	-- operatorabbrev
	'NYCDOT',
	-- oversightagency
	'New York City Department of Transportation',
	-- oversightabbrev
	'NYCDOT',
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
	'2016-07-01',
	-- datesourceupdated
	'2016-07-01',
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
	ST_SetSRID(ST_MakePoint(longitude, latitude),4326),
	-- agencysource
	'NYCDOT',
	-- sourcedatasetname
	'Municipal Parking Facilities',
	-- linkdata
	'http://www.nyc.gov/html/dot/html/motorist/parkinglist.shtml',
	-- linkdownload
	'NA',
	-- datatype
	'Addresses and Details Copied from Website',
	-- refreshmeans
	'Manual copy and paste',
	-- refreshfrequency
	'Annually',
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