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
		(CASE
			WHEN authorization_number <> '?' THEN authorization_number
		END),
	-- facilityname
	facility_name,
	-- addressnumber
	split_part(trim(both ' ' from location_address), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from location_address), strpos(trim(both ' ' from location_address), ' ')+1, (length(trim(both ' ' from location_address))-strpos(trim(both ' ' from location_address), ' ')))),
	-- address
	location_address,
	-- city
	NULL,
	-- borough
		(CASE
			WHEN County = 'New York' THEN 'Manhattan'
			WHEN County = 'Bronx' THEN 'Bronx'
			WHEN County = 'Kings' THEN 'Brooklyn'
			WHEN County = 'Queens' THEN 'Queens'
			WHEN County = 'Richmond' THEN 'Staten Island'
		END),
	-- boroughcode
		(CASE
			WHEN County = 'New York' THEN 1
			WHEN County = 'Bronx' THEN 2
			WHEN County = 'Kings' THEN 3
			WHEN County = 'Queens' THEN 4
			WHEN County = 'Richmond' THEN 5
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
		(CASE
			WHEN east_coordinate > 11111 
				THEN east_coordinate
		END),
	-- ycoord
		(CASE
			WHEN north_coordinate > 11111 
				THEN north_coordinate
		END),
	-- latitude
		(CASE
			WHEN east_coordinate > 11111 
				THEN ST_Y(ST_Transform(ST_SetSRID(ST_MakePoint(east_coordinate, north_coordinate),26918),4326))
		END),
	-- longitude
		(CASE
			WHEN north_coordinate > 11111 
				THEN ST_X(ST_Transform(ST_SetSRID(ST_MakePoint(east_coordinate, north_coordinate),26918),4326))
		END),
	-- facilitytype
		(CASE
			WHEN activity_desc LIKE '%C&D%' THEN 'Construction and Demolition Processing'
			WHEN activity_desc LIKE '%Composting%' THEN 'Composting'
			WHEN activity_desc LIKE '%Other%' THEN 'Other Solid Waste Processing'
			WHEN activity_desc LIKE '%RHRF%' THEN 'Recyclables Handling and Recovery'
			WHEN activity_desc LIKE '%medical%' THEN 'Regulated Medical Waste'
			WHEN activity_desc LIKE '%Transfer%' THEN 'Transfer Station'
			WHEN activity_desc LIKE '%Composting%' THEN 'Composting'
			ELSE initcap(trim(split_part(split_part(activity_desc,';',1),'-',1),' '))
		END),
	-- domain
	'Core Infrastructure and Transportation',
	-- facilitygroup
	'Wastewater and Waste Management',
	-- facilitysubgroup
	(CASE
		WHEN activity_desc LIKE '%Transfer%' THEN 'Solid Waste Transfer and Carting'
		ELSE 'Solid Waste Processing'
	END),
	-- agencyclass1
	activity_desc,
	-- agencyclass2
		(CASE
			WHEN waste_types IS NOT NULL THEN waste_types
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
	NULL,
	-- areatype
	NULL,
	-- servicearea
	NULL,
	-- operatortype
		(CASE
			WHEN owner_type = 'Municipal' THEN 'Public'
			ELSE 'Non-public'
		END),
	-- operatorname
		(CASE
			WHEN owner_type = 'Municipal' THEN 'New York City Department of Sanitation'
			WHEN owner_name IS NOT NULL THEN owner_name
			ELSE 'Unknown'
		END),
	-- operatorabbrev
		(CASE
			WHEN owner_type = 'Municipal' THEN 'NYCDSNY'
			ELSE 'Non-public'
		END),
	-- oversightagencyname
		(CASE
			WHEN owner_type = 'Municipal' THEN 'New York City Department of Sanitation'
			ELSE 'New York Department of Environmental Conservation'
		END),
	-- oversightabbrev
		(CASE
			WHEN owner_type = 'Municipal' THEN 'NYCDSNY'
			ELSE 'NYSDEC'
		END),
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
		(CASE
			WHEN east_coordinate > 11111 
				THEN ST_Transform(ST_SetSRID(ST_MakePoint(east_coordinate, north_coordinate),26918),4326)
		END),
	-- agencysource
	'NYSDEC',
	-- sourcedatasetname
	'Solid Waste Management Facilities',
	-- linkdata
	'https://data.ny.gov/Energy-Environment/Solid-Waste-Management-Facilities/2fni-raj8',
	-- linkdownload
	'https://data.ny.gov/api/views/2fni-raj8/rows.csv?accessType=DOWNLOAD',
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
	nysdec_facilities_solidwaste
WHERE
	County = 'New York'
	OR County = 'Bronx'
	OR County = 'Kings'
	OR County = 'Queens'
	OR County = 'Richmond'
