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
	lands_uid,
	-- facilityname
	initcap(facility),
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
			WHEN County = 'NEW YORK' THEN 'Manhattan'
			WHEN County = 'BRONX' THEN 'Bronx'
			WHEN County = 'KINGS' THEN 'Brooklyn'
			WHEN County = 'QUEENS' THEN 'Queens'
			WHEN County = 'RICHMOND' THEN 'Staten Island'
		END),
	-- boroughcode
		(CASE
			WHEN County = 'NEW YORK' THEN 1
			WHEN County = 'BRONX' THEN 2
			WHEN County = 'KINGS' THEN 3
			WHEN County = 'QUEENS' THEN 4
			WHEN County = 'RICHMOND' THEN 5
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
	ST_Y(ST_Centroid(geom)),
	-- longitude
	ST_X(ST_Centroid(geom)),
	-- facilitytype
		(CASE
			WHEN category = 'NRA' THEN 'Natural Resource Area'
			ELSE initcap(category)
		END),
	-- domain
	'Parks, Cultural, and Other Community Facilities',
	-- facilitygroup
	'Parks and Plazas',
	-- facilitysubgroup
	'Preserves and Conservation Areas',
	-- agencyclass1
	category,
	-- agencyclass2
		(CASE
			WHEN class IS NOT NULL THEN class
			ELSE 'NA'
		END),
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
	'Public',
	-- operatorname
	'New York State Department of Conservation',
	-- operatorabbrev
	'NYSDEC',
	-- oversightagency
	'New York State Department of Conservation',
	-- oversightabbrev
	'NYSDEC',
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
	'2016-03-01',
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
	ST_Centroid(geom),
	-- agencysource
	'NYSDEC',
	-- sourcedatasetname
	'Lands - Under the Care, Custody, and Control of DEC',
	-- linkdata
	'http://gis.ny.gov/gisdata/inventories/details.cfm?DSID=1114',
	-- linkdownload
	'http://gis.ny.gov/gisdata/data/ds_1114/DEC_lands.zip',
	-- datatype
	'Shapefile',
	-- refreshmeans
	'Pull from NYState GIS Clearinghouse',
	-- refreshfrequency
	'Nightly pull',
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
	nysdec_facilities_lands
WHERE
	County = 'NEW YORK'
	OR County = 'BRONX'
	OR County = 'KINGS'
	OR County = 'QUEENS'
	OR County = 'RICHMOND'