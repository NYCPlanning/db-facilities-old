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
	initcap(BUS_NAME),
	-- addressnumber
	initcap(split_part(REPLACE(REPLACE(Mailing_Office,' - ','-'),' -','-'), ' ', 1)),
	-- streetname
	initcap(split_part(split_part(REPLACE(REPLACE(Mailing_Office,' - ','-'),' -','-'), ' ', 2),'(',1)),
	-- address
	initcap(split_part(REPLACE(REPLACE(Mailing_Office,' - ','-'),' -','-'), '(', 1)),
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
	(CASE
		WHEN (Location_1 IS NOT NULL) AND (Location_1 LIKE '%(%')
			THEN trim(trim(split_part(split_part(Location_1,'(',2),',',1),'('),' ')::double precision
	END),
	-- longitude
	(CASE
		WHEN (Location_1 IS NOT NULL) AND (Location_1 LIKE '%(%')
			THEN trim(trim(split_part(split_part(Location_1,'(',2),',',2),' '),')')::double precision
	END),
	-- facilitytype
	'Trade Waste Carter Site',
	-- domain
	'Core Infrastructure and Transportation',
	-- facilitygroup
	'Solid Waste',
	-- facilitysubgroup
	'Solid Waste Transfer and Carting',
	-- agencyclass1
	type,
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
	initcap(BUS_NAME),
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	'New York City Business Integrity Commission',
	-- oversightabbrev
	'NYCBIC',
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
	'2014-09-05',
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
	(CASE
		WHEN (Location_1 IS NOT NULL) AND (Location_1 LIKE '%(%') THEN 
			ST_SetSRID(
				ST_MakePoint(
					trim(trim(split_part(split_part(Location_1,'(',2),',',2),' '),')')::double precision,
					trim(trim(split_part(split_part(Location_1,'(',2),',',1),'('),' ')::double precision),
				4326)
	END),
	-- NULL,
	-- agencysource
	'NYCBIC',
	-- sourcedatasetname
	'Approved licensees and registrants for trade waste',
	-- linkdata
	'https://data.cityofnewyork.us/Business/Approved-licensees/7atx-5a3s',
	-- linkdownload
	'https://data.cityofnewyork.us/api/views/7atx-5a3s/rows.csv?accessType=DOWNLOAD',
	-- datatype
	'CSV with Coordinates',
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
	bic_facilities_tradewaste