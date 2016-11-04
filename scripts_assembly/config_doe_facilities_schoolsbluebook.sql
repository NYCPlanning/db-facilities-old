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
	Org_ID,
	-- facilityname
	initcap(Organization_Name),
	-- addressnumber
		(CASE
			WHEN Address <> '#N/A' THEN split_part(Address,' ',1)
		END),
	-- streetname
		(CASE
			WHEN Address <> '#N/A' THEN initcap(split_part(Address,' ',2))
		END),
	-- address
		(CASE
			WHEN Address <> '#N/A' THEN initcap(Address)
		END),
	-- city
	NULL,
	-- borough
		(CASE
			WHEN LEFT(Org_ID,1) = 'M' THEN 'Manhattan'
			WHEN LEFT(Org_ID,1) = 'X' THEN 'Bronx'
			WHEN LEFT(Org_ID,1) = 'K' THEN 'Brooklyn'
			WHEN LEFT(Org_ID,1) = 'Q' THEN 'Queens'
			WHEN LEFT(Org_ID,1) = 'R' THEN 'Staten Island'
		END),
	-- boroughcode
		(CASE
			WHEN LEFT(Org_ID,1) = 'M' THEN 1
			WHEN LEFT(Org_ID,1) = 'X' THEN 2
			WHEN LEFT(Org_ID,1) = 'K' THEN 3
			WHEN LEFT(Org_ID,1) = 'Q' THEN 4
			WHEN LEFT(Org_ID,1) = 'R' THEN 5
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
	x::double precision,
	-- ycoord
	y::double precision,
	-- latitude
		(CASE
			WHEN X <> '#N/A' THEN ST_Y(ST_Transform(ST_SetSRID(ST_MakePoint(X::double precision, Y::double precision),2263),4326))
		END),
	-- longitude
		(CASE
			WHEN X <> '#N/A' THEN ST_X(ST_Transform(ST_SetSRID(ST_MakePoint(X::double precision, Y::double precision),2263),4326))
		END),
	-- facilitytype
		(CASE
			WHEN Charter IS NULL AND Org_Level = 'PS' THEN 'Elementary School - Public'
			WHEN Charter IS NULL AND Org_Level = 'PSIS' THEN 'Elementary and Middle School - Public'
			WHEN Charter IS NULL AND Org_Level = 'IS' THEN 'Middle School - Public'
			WHEN Charter IS NULL AND Org_Level = 'ISHS' THEN 'Middle and High School - Public'
			WHEN Charter IS NULL AND Org_Level = 'IS/JHS' THEN 'High School - Public'
			WHEN Charter IS NULL AND Org_Level = 'HS' THEN 'High School - Public'
			WHEN Charter IS NULL AND Org_Level = 'SPED' THEN 'Special Ed School - Public'
			WHEN Charter IS NULL AND Org_Level = 'OTHER' THEN 'Other School - Public'
			WHEN Charter IS NOT NULL AND Org_Level = 'PS' THEN 'Elementary School - Charter'
			WHEN Charter IS NOT NULL AND Org_Level = 'PSIS' THEN 'Elementary and Middle School - Charter'
			WHEN Charter IS NOT NULL AND Org_Level = 'IS' THEN 'Middle School - Charter'
			WHEN Charter IS NOT NULL AND Org_Level = 'ISHS' THEN 'Middle and High School - Charter'
			WHEN Charter IS NOT NULL AND Org_Level = 'IS/JHS' THEN 'High School - Charter'
			WHEN Charter IS NOT NULL AND Org_Level = 'HS' THEN 'High School - Charter'
			WHEN Charter IS NOT NULL AND Org_Level = 'SPED' THEN 'Special Ed School - Charter'
			WHEN Charter IS NOT NULL AND Org_Level = 'OTHER' THEN 'Other School - Charter'
			ELSE 'Other School - Unspecified'
		END),
	-- domain
	'Youth, Education, and Child Welfare',
	-- facilitygroup
	'Schools',
	-- facilitysubgroup
	'Public Schools',
	-- agencyclass1
	Charter,
	-- agencyclass2
	Org_Level,
	-- colpusetype
	NULL,
	-- capacity
	PS_Capacity::numeric + MS_Capacity::numeric + HS_Capacity::numeric,
	-- utilization
	Org_Enroll::numeric,
	-- capacitytype
	'Seats',
	-- utilizationrate
		(CASE
			WHEN (PS_Capacity::numeric + MS_Capacity::numeric + HS_Capacity::numeric) <> 0 THEN Org_Enroll::numeric/(PS_Capacity::numeric + MS_Capacity::numeric + HS_Capacity::numeric)
		END),
	-- area
	NULL,
	-- areatype
	NULL,
	-- servicearea
	NULL,
	-- operatortype
		(CASE
			WHEN Charter IS NOT NULL THEN 'Non-public'
			ELSE 'Public'
		END),
	-- operatorname
		(CASE
			WHEN Charter IS NOT NULL THEN 'Organization_Name'
			ELSE 'New York City Department of Education'
		END),
	-- operator abbrev
		(CASE
			WHEN Charter IS NOT NULL THEN 'Non-public'
			ELSE 'NYCDOE'
		END),
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
	'2016-07-20',
	-- datesourceupdated
	'2016-07-20',
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
			WHEN X <> '#N/A' THEN ST_Transform(ST_SetSRID(ST_MakePoint(X::double precision, Y::double precision),2263),4326)
		END),
	-- agencysource
	'NYCDOE',
	-- sourcedatasetname
	'2014-2015 Blue Book',
	-- linkdata
	'NA',
	-- linkdownload
	'NA',
	-- datatype
	'CSV with Coordinates',
	-- refreshmeans
	'Request file from agency',
	-- refreshfrequency
	'Annually',
	-- buildingid
	Bldg_ID,
	-- buildingname
	Bldg_Name,
	-- schoolorganizationlevel
	NULL,
	-- children
		(CASE
			WHEN Org_Level = 'PS' THEN TRUE
			WHEN Org_Level = 'PSIS' THEN TRUE
			WHEN Org_Level = 'IS' THEN TRUE
			WHEN Org_Level = 'ISHS' THEN TRUE
			WHEN Org_Level = 'IS/JHS' THEN TRUE
			WHEN Org_Level = 'HS' THEN FALSE
			WHEN Org_Level = 'SPED' THEN FALSE
			WHEN Org_Level = 'OTHER' THEN FALSE
		END),
	-- youth
		(CASE
			WHEN Org_Level = 'PS' THEN FALSE
			WHEN Org_Level = 'PSIS' THEN FALSE
			WHEN Org_Level = 'IS' THEN FALSE
			WHEN Org_Level = 'ISHS' THEN TRUE
			WHEN Org_Level = 'IS/JHS' THEN TRUE
			WHEN Org_Level = 'HS' THEN TRUE
			WHEN Org_Level = 'SPED' THEN FALSE
			WHEN Org_Level = 'OTHER' THEN FALSE
		END),
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
	doe_facilities_schoolsbluebook