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
	National_Register_Number,
	-- facilityname
	Resource_Name,
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- city
	NULL,
	-- borough
	County,
	-- borough
		(CASE
			WHEN County = 'Manhattan' THEN 1
			WHEN County = 'Bronx' THEN 2
			WHEN County = 'Brooklyn' THEN 3
			WHEN County = 'Queens' THEN 4
			WHEN County = 'Staten Island' THEN 5
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
	latitude,
	-- longitude
	longitude,
	-- facilitytype
	'State Historic Place',
	-- domain
	'Parks, Cultural, and Other Community Facilities',
	-- facilitygroup
	'Historical Sites',
	-- facilitysubgroup
	'Historical Sites',
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
	'Mix',
	-- operatorname
	'New York State Office of Parks, Recreation and Historic Preservation',
	-- operatorabbrev
	'NYSOPRHP',
	-- oversightagency
	'New York State Office of Parks, Recreation and Historic Preservation',
	-- oversightabbrev
	'NYSOPRHP',
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
	'2015-12-18',
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
	'NYSOPRHP',
	-- sourcedatasetname
	'National Register of Historic Places',
	-- linkdata
	'http://gis.ny.gov/gisdata/inventories/details.cfm?DSID=1114',
	-- linkdownload
	'https://data.ny.gov/api/views/y36f-mkpp/rows.csv?accessType=DOWNLOAD',
	-- datatype
	'CSV with Coordinates',
	-- refreshmeans
	'Pull from NYState Open Data',
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
	nysparks_facilities_historicplaces
WHERE
	Resource_Name NOT LIKE '%Historic District%'
	AND (County = 'New York'
	OR County = 'Bronx'
	OR County = 'Kings'
	OR County = 'Queens'
	OR County = 'Richmond')