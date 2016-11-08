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
	Facility_Code,
	-- facilityname
	Facility_Name,
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
			WHEN Program_County = 'New York' THEN 'Manhattan'
			WHEN Program_County = 'Bronx' THEN 'Bronx'
			WHEN Program_County = 'Kings' THEN 'Brooklyn'
			WHEN Program_County = 'Queens' THEN 'Queens'
			WHEN Program_County = 'Richmond' THEN 'Staten Island'
		END),
	-- boroughcode
		(CASE
			WHEN Program_County = 'New York' THEN 1
			WHEN Program_County = 'Bronx' THEN 2
			WHEN Program_County = 'Kings' THEN 3
			WHEN Program_County = 'Queens' THEN 4
			WHEN Program_County = 'Richmond' THEN 5
		END),
	-- zipcode
	LEFT(Program_Zip,5)::integer,
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
		WHEN (Location IS NOT NULL) AND (Location LIKE '%(%')
			THEN trim(trim(split_part(split_part(Location,'(',2),',',1),'('),' ')::double precision
	END),
	-- longitude
	(CASE
		WHEN (Location IS NOT NULL) AND (Location LIKE '%(%')
			THEN trim(trim(split_part(split_part(Location,'(',2),',',2),')'),' ')::double precision
	END),
	-- facilitytype
	Program_Category_Description,
	-- domain
	'Health and Human Services',
	-- facilitygroup
	'Health Care',
	-- facilitysubgroup
	'Mental Health',
	-- agencyclass1
	Program_Type_Description,
	-- agencyclass2
	Program_Subcategory_Description,
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
		(CASE
			WHEN program_type_description LIKE '%State%' THEN 'Public'
			WHEN sponsor_name LIKE '%Health and Hospitals Corporation%' THEN 'Public'
			ELSE 'Non-public'
		END),
	-- operatorname
		(CASE
			WHEN program_type_description LIKE '%State%' THEN 'New York State Office of Mental Health'
			WHEN sponsor_name LIKE '%Health and Hospitals Corporation%' THEN 'New York City Health and Hospitals Corporation'
			ELSE Agency_Name
		END),
	-- operatorabbrev
		(CASE
			WHEN program_type_description LIKE '%State%' THEN 'NYSOMH'
			WHEN sponsor_name LIKE '%Health and Hospitals Corporation%' THEN 'NYCHHC'
			ELSE 'Non-public'
		END),
	-- oversightagency
	'New York State Office of Mental Health',
	-- oversightabbrev
	'NYSOMH',
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
	'2016-07-16',
	-- datesourceupdated
	'2016-07-16',
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
		WHEN (Location IS NOT NULL) AND (Location LIKE '%(%') THEN
			ST_SetSRID(
				ST_MakePoint(
					trim(trim(split_part(split_part(Location,'(',2),',',2),')'),' ')::double precision,
					trim(split_part(split_part(Location,'(',2),',',1),' ')::double precision),
				4326)
			-- before had 3857, not sure where this SRID came from
	END),
	-- NULL,
	-- agencysource
	'NYSOMH',
	-- sourcedatasetname
	'Local Mental Health Programs',
	-- linkdata
	'https://data.ny.gov/Human-Services/Local-Mental-Health-Programs/6nvr-tbv8',
	-- linkdownload
	'https://data.ny.gov/api/views/6nvr-tbv8/rows.csv?accessType=DOWNLOAD',
	-- datatype
	'CSV with Coordinates',
	-- refreshmeans
	'Pull from NYState Open Data',
	-- refreshfrequency
	'Weekly pull',
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
	nysomh_facilities_mentalhealth
WHERE
	Program_County = 'New York'
	OR Program_County = 'Bronx'
	OR Program_County = 'Kings'
	OR Program_County = 'Queens'
	OR Program_County = 'Richmond'
