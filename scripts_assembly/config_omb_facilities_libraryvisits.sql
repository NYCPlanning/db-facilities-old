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
	split_part(name,' - ',1),
	-- addressnumber
	housenum,
	-- streetname
	initcap(streetname),
	-- address
	CONCAT(housenum,' ',initcap(streetname)),
	-- city
	NULL,
	-- borough
	boroname,
	-- boroughcode
	ROUND(borocode::numeric,0),
	-- zipcode
	ROUND(zip::numeric,0),
	-- bbl
	ARRAY[ROUND(bbl::numeric,0)],
	-- bin
	ARRAY[ROUND(bin::numeric,0)],
	-- parkid
	NULL,
	-- xcoord
	ST_X(ST_Transform(ST_SetSRID(ST_MakePoint(lon, lat),4326),2263)),
	-- ycoord
	ST_Y(ST_Transform(ST_SetSRID(ST_MakePoint(lon, lat),4326),2263)),
	-- latitude
	lat,
	-- longitude
	lon,
	-- facilitytype
	'Public Libraries',
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
	visits,
	-- capacitytype
	'Visits',
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
	'2016-06-30',
	-- datesourceupdated
	'2016-06-30',
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
	ST_SetSRID(ST_MakePoint(lon, lat),4326),
	-- agencysource
	'NYCOMB',
	-- sourcedatasetname
	'District Resource Statement',
	-- linkdata
	'NA',
	-- linkdownload
	'NA',
	-- datatype
	'CSV with Coordinates',
	-- refreshmeans
	'Request from Agency',
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
	omb_facilities_libraryvisits