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
	name,
	-- addressnumber
	housenum,
	-- streetname
	streetname,
	-- address
	CONCAT(housenum,' ',streetname),
	-- city
	NULL,
	-- borough
		(CASE
			WHEN system = 'BPL' THEN 'Brooklyn'
			WHEN system = 'QPL' THEN 'Queens'
			WHEN city = 'New York' THEN 'New York'
			WHEN city = 'Bronx' THEN 'Bronx'
			WHEN city = 'Staten Island' THEN 'Staten Island'
		END),
	-- boroughcode
	ROUND(borocode,0),
	-- zipcode
	zip,
	-- bbl
	ARRAY[bbl],
	-- bin
	ARRAY[ROUND(bin,0)],
	-- parkid
	NULL,
	-- xcoord
	x,
	-- ycoord
	y,
	-- latitude
	ST_Y(geom),
	-- longitude
	ST_X(geom),
	-- facilitytype
	'Public Library',
	-- domain
	'Parks, Cultural, and Other Community Facilities',
	-- facilitygroup
	'Libraries',
	-- facilitysubgroup
	'Public Libraries',
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
		(CASE
			WHEN system = 'QPL' THEN 'Queens Public Libraries'
			WHEN system = 'BPL' THEN 'Brooklyn Public Libraries'
			WHEN system = 'NYPL' THEN 'New York Public Libraries'
		END),
	-- operatorabbrev
	system,
	-- oversightagency
		(CASE
			WHEN system = 'QPL' THEN 'Queens Public Libraries'
			WHEN system = 'BPL' THEN 'Brooklyn Public Libraries'
			WHEN system = 'NYPL' THEN 'New York Public Libraries'
		END),
	-- oversightabbrev
	system,
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
	'2016-06-22',
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
	'NYCDOITT',
	-- sourcedatasetname
	'Library',
	-- linkdata
	'https://data.cityofnewyork.us/Business/Library/p4pf-fyc4',
	-- linkdownload
	'https://data.cityofnewyork.us/api/geospatial/p4pf-fyc4?method=export&format=Shapefile',
	-- datatype
	'Shapefile',
	-- refreshmeans
	'Pull from NYC Open Data',
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
	(SELECT *
	FROM doitt_facilities_libraries AS lib
	LEFT JOIN omb_facilities_libraryvisits AS v
	ON split_part(v.name, ' - ', 1) = split_part(lib.name, ' <br>', 1)
	) AS doitt_facilities_libraries