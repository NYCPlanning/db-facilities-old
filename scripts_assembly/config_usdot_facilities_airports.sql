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
	locationid,
	-- facilityname
	fullname,
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- city
	NULL,
	-- borough
		(CASE
			WHEN (stateabbv = 'NY') AND (County = 'New York') THEN 'Manhattan'
			WHEN (stateabbv = 'NY') AND (County = 'Bronx') THEN 'Bronx'
			WHEN (stateabbv = 'NY') AND (County = 'Kings') THEN 'Brooklyn'
			WHEN (stateabbv = 'NY') AND (County = 'Queens') THEN 'Queens'
			WHEN (stateabbv = 'NY') AND (County = 'Richmond') THEN 'Staten Island'
		END),
	-- boroughcode
		(CASE
			WHEN (stateabbv = 'NY') AND (County = 'New York') THEN 1
			WHEN (stateabbv = 'NY') AND (County = 'Bronx') THEN 2
			WHEN (stateabbv = 'NY') AND (County = 'Kings') THEN 3
			WHEN (stateabbv = 'NY') AND (County = 'Queens') THEN 4
			WHEN (stateabbv = 'NY') AND (County = 'Richmond') THEN 5
		END),
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
	ST_Y(geom),
	-- longitude
	ST_X(geom),
	-- facilitytype
	facilityty,
	-- domain
	'Core Infrastructure and Transportation',
	-- facilitygroup
	'Transportation',
	-- facilitysubgroup
	'Airports and Heliports',
	-- agencyclass1
	facilityty,
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
	acres,
	-- areatype
	'Acres',
	-- servicearea
	NULL,
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
	'United States Department of Transportation',
	-- oversightabbrev
	'USDOT',
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
	'2015-08-01',
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
	geom,
	-- agencysource
	'USDOT',
	-- sourcedatasetname
	'Airports',
	-- linkdata
	'http://www.rita.dot.gov/bts/sites/rita.dot.gov.bts/files/publications/national_transportation_atlas_database/2015/point',
	-- linkdownload
	'http://www.rita.dot.gov/bts/sites/rita.dot.gov.bts/files/AdditionalAttachmentFiles/airports.zip',
	-- datatype
	'Shapefile',
	-- refreshmeans
	'Pull from US DOT',
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
	usdot_facilities_airports
WHERE
	stateabbv = 'NY' 
	AND (County = 'New York'
	OR County = 'Bronx'
	OR County = 'Kings'
	OR County = 'Queens'
	OR County = 'Richmond')