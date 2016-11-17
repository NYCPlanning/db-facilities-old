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
	facility_name,
	-- addressnumber
	split_part(Location_1, ' ', 1),
	-- streetname
	split_part(split_part(Location_1, ' ', 2),'(',1),
	-- address
	split_part(Location_1, '(', 1),
	-- city
	NULL,
	-- borough
	Borough,
	-- boroughcode
		(CASE
			WHEN Borough = 'Manhattan' THEN 1
			WHEN Borough = 'Bronx' THEN 2
			WHEN Borough = 'Brooklyn' THEN 3
			WHEN Borough = 'Queens' THEN 4
			WHEN Borough = 'Staten Island' THEN 5
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
	trim(trim(split_part(split_part(Location_1,'(',2),',',1),'('),' ')::double precision,
	-- longitude
	trim(split_part(split_part(Location_1,'(',2),',',1),' ')::double precision,
	-- facilitytype
		(CASE 
			WHEN facility_type LIKE '%Diagnostic%' THEN 'Diagnostic and Treatment Center'
			ELSE facility_type
		END),
	-- domain
	'Health and Human Services',
	-- facilitygroup
	'Health Care',
	-- facilitysubgroup
		(CASE
			WHEN facility_type = 'Nursing Home' THEN 'Residential Health Care'
			ELSE 'Hospitals and Clinics'
		END),
	-- agencyclass1
	facility_type,
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
	'Public',
	-- operatorname
	'New York City Health and Hospitals Corporation',
	-- operatorabbrev
	'NYCHHC',
	-- oversightagency
	'New York State Department of Health',
	-- oversightabbrev
	'NYSDOH',
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
	ST_SetSRID(
		ST_MakePoint(
			trim(trim(split_part(split_part(Location_1,'(',2),',',2),')'),' ')::double precision,
			trim(split_part(split_part(Location_1,'(',2),',',1),' ')::double precision),
		4326),
	-- agencysource
	'NYCHHC',
	-- sourcedatasetname
	'Health and Hospitals Corporation (HHC) Facilities',
	-- linkdata
	'https://data.cityofnewyork.us/Health/Health-and-Hospitals-Corporation-HHC-Facilities/f7b6-v6v3',
	-- linkdownload
	'https://data.cityofnewyork.us/api/views/f7b6-v6v3/rows.csv?accessType=DOWNLOAD',
	-- datatype
	'CSV with Coordinates',
	-- refreshmeans
	'Pull from NYC Open Data',
	-- refreshfrequency
	'Annually',
	-- buildingid
	NULL,
	-- buildingname
	NULL,
	-- schoolorganizationlevel
	NULL,
	-- children
		(CASE
			WHEN facility_type LIKE '%Child%' THEN TRUE
			ELSE FALSE
		END),
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
		(CASE
			WHEN facility_type LIKE '%Nursing Home%' THEN TRUE
			ELSE FALSE
		END)
FROM
	hhc_facilities_hospitals