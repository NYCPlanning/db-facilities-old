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
	Facility_ID,
	-- facilityname
	Facility_Name,
	-- addressnumber
	split_part(trim(both ' ' from Facility_Address_1), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from Facility_Address_1), strpos(trim(both ' ' from Facility_Address_1), ' ')+1, (length(trim(both ' ' from Facility_Address_1))-strpos(trim(both ' ' from Facility_Address_1), ' ')))),
	-- address
	Facility_Address_1,
	-- city
	NULL,
	-- borough
		(CASE
			WHEN Facility_County = 'New York' THEN 'Manhattan'
			WHEN Facility_County = 'Bronx' THEN 'Bronx'
			WHEN Facility_County = 'Kings' THEN 'Brooklyn'
			WHEN Facility_County = 'Queens' THEN 'Queens'
			WHEN Facility_County = 'Richmond' THEN 'Staten Island'
		END),
	-- boroughcode
		(CASE
			WHEN Facility_County = 'New York' THEN 1
			WHEN Facility_County = 'Bronx' THEN 2
			WHEN Facility_County = 'Kings' THEN 3
			WHEN Facility_County = 'Queens' THEN 4
			WHEN Facility_County = 'Richmond' THEN 5
		END),
	-- zipcode
	LEFT(Facility_Zip_Code,5)::integer,
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
	Facility_Latitude,
	-- longitude
	Facility_Longitude,
	-- facilitytype
		(CASE
			WHEN Description LIKE '%Residential%'
				THEN 'Residential Health Care'
			ELSE Description
		END),
	-- domain
	'Health and Human Services',
	-- facilitygroup
	'Health Care',
	-- facilitysubgroup
		(CASE
			WHEN Description LIKE '%Residential%'
				OR Description LIKE '%Hospice%'
				THEN 'Residential Health Care'
			WHEN Description LIKE '%Adult Day Health%'
				THEN 'Other Health Care'
			WHEN Description LIKE '%Home%'
				THEN 'Other Health Care'
			ELSE 'Hospitals and Clinics'
		END),
	-- agencyclass1
	Description,
	-- agencyclass2
	ownership_type,
	-- colpusetype
	NULL,
	-- capacity
	capacity,
	-- utilization
	utilization,
	-- capacitytype
		(CASE
			WHEN capacity IS NOT NULL THEN 'Beds'
			ELSE NULL
		END),
	-- utilizationrate
		(CASE
			WHEN capacity IS NOT NULL THEN ROUND((utilization::numeric/capacity::numeric),3)
			ELSE NULL
		END),
	-- area
	NULL,
	-- areatype
	NULL,
	-- servicearea
	NULL,
	-- operatortype
		(CASE
			WHEN operator_name = 'City of New York' THEN 'Public'
			WHEN operator_name = 'New York City Health and Hospital Corporation' THEN 'Public'
			WHEN ownership_type = 'State' THEN 'Public'
			ELSE 'Non-public'
		END),	
	-- operatorname
		(CASE
			WHEN operator_name = 'City of New York' THEN 'New York City Department of Health and Mental Hygiene'
			WHEN operator_name = 'New York City Health and Hospital Corporation' THEN 'New York City Health and Hospital Corporation'
			WHEN ownership_type = 'State' THEN 'New York State Department of Health'
			ELSE operator_name
		END),
	-- operatorabbrev
		(CASE
			WHEN operator_name = 'City of New York' THEN 'NYCDOHMH'
			WHEN operator_name = 'New York City Health and Hospital Corporation' THEN 'NYCHHC'
			WHEN ownership_type = 'State' THEN 'NYSDOH'
			ELSE 'Non-public'
		END),
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
	'2016-11-14',
	-- datesourceupdated
	'2016-11-14',
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
	ST_SetSRID(ST_MakePoint(Facility_Longitude, Facility_Latitude),4326),
	-- agencysource
	'NYSDOH',
	-- sourcedatasetname
	'Health Facility General Information',
	-- linkdata
	'https://health.data.ny.gov/Health/Health-Facility-General-Information/vn5v-hh5r',
	-- linkdownload
	'https://health.data.ny.gov/api/views/vn5v-hh5r/rows.csv?accessType=DOWNLOAD',
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
		(CASE
			WHEN description LIKE '%Hospice%' THEN TRUE
			WHEN description LIKE '%Residential%' THEN TRUE
			ELSE FALSE
		END)
FROM
	(SELECT DISTINCT ON (facility_id)
		f.*,
		c.total_capacity AS capacity,
		(c.total_capacity-c.total_available) AS utilization,
		c.bed_census_date
		FROM nysdoh_facilities_healthfacilities AS f
		JOIN nysdoh_nursinghomebedcensus AS c
		ON f.facility_id::numeric=c.facility_id::numeric
		ORDER BY f.facility_id, c.bed_census_date DESC) AS nysdoh_facilities_healthfacilities
WHERE
	Facility_County = 'New York'
	OR Facility_County = 'Bronx'
	OR Facility_County = 'Kings'
	OR Facility_County = 'Queens'
	OR Facility_County = 'Richmond'
