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
	Day_Care_Id,
	-- facilityname
	initcap(Legal_Name),
	-- addressnumber
	Building,
	-- streetname
	initcap(Street),
	-- address
	CONCAT(Building,' ',initcap(Street)),
	-- city
	NULL,
	-- borough
	initcap(Borough),
	-- boroughcode
		(CASE
			WHEN Borough = 'MANHATTAN' THEN 1
			WHEN Borough = 'BRONX' THEN 2
			WHEN Borough = 'BROOKLYN' THEN 3
			WHEN Borough = 'QUEENS' THEN 4
			WHEN Borough = 'STATEN ISLAND' THEN 5
		END),
	-- zipcode
	ZipCode::integer,
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
	NULL,
	-- longitude
	NULL,
	-- facilitytype
		(CASE
			WHEN (facility_type = 'CAMP' OR facility_type = 'Camp') AND (program_type = 'All Age Camp' OR program_type = 'ALL AGE CAMP')
				THEN 'Camp - All Age'
			WHEN (facility_type = 'CAMP' OR facility_type = 'Camp') AND (program_type = 'School Age Camp' OR program_type = 'SCHOOL AGE CAMP')
				THEN 'Camp - School Age'
			WHEN (program_type = 'Preschool Camp' OR program_type = 'PRESCHOOL CAMP')
				THEN 'Camp - Preschool Age'
			WHEN (facility_type = 'GDC') AND (program_type = 'Child Care - Infants/Toddlers' OR program_type = 'INFANT TODDLER')
				THEN 'Group Day Care - Infants/Toddlers'
			WHEN (facility_type = 'GDC') AND (program_type = 'Child Care - Pre School' OR program_type = 'PRESCHOOL')
				THEN 'Group Day Care - Preschool'
			WHEN (facility_type = 'SBCC') AND (program_type = 'PRESCHOOL')
				THEN 'School Based Child Care - Preschool'
			WHEN (facility_type = 'SBCC') AND (program_type = 'INFANT TODDLER')
				THEN 'School Based Child Care - Infants/Toddlers'
			ELSE CONCAT(facility_type,'-',program_type)
		END),
	-- domain
	'Education, Child Welfare, and Youth',
	-- facilitygroup
		(CASE
			WHEN (facility_type = 'CAMP' OR facility_type = 'Camp' OR program_type LIKE '%CAMP%' OR program_type LIKE '%Camp%')
				THEN 'Camps'
			ELSE 'Childcare'
		END),
	-- facilitysubgroup
		(CASE
			WHEN (facility_type = 'CAMP' OR facility_type = 'Camp' OR program_type LIKE '%CAMP%' OR program_type LIKE '%Camp%')
				THEN 'Camps'
			ELSE 'Childcare'
		END),
	-- agencyclass1
	child_care_type,
	-- agencyclass2
	program_type,
	-- colpusetype
	NULL,
	-- capacity
		(CASE
			WHEN Maximum_Capacity <> '0' THEN Maximum_Capacity::integer
			WHEN Maximum_Capacity = '0' THEN NULL
		END),
	-- utilization
	NULL,
	-- capacitytype
	'Seats',
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
	-- operator
	initcap(Legal_Name),
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	'New York City Department of Health and Mental Hygiene',
	-- oversightabbrev
	'NYCDOHMH',
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
	'2016-07-28',
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
	NULL,
	-- agencysource
	'NYCDOHMH',
	-- sourcedatasetname
	'DOHMH Childcare Center Inspections',
	-- linkdata
	'https://data.cityofnewyork.us/Health/DOHMH-Childcare-Center-Inspections/dsg6-ifza',
	-- linkdownload
	'https://data.cityofnewyork.us/api/views/dsg6-ifza/rows.csv?accessType=DOWNLOAD',
	-- datatype
	'CSV with Addresses',
	-- refreshmeans
	'Geocode - Pull from NYC Open Data',
	-- refreshfrequency
	'Weekly',
	-- buildingid
	NULL,
	-- buildingname
	NULL,
	-- schoolorganizationlevel
	NULL,
	-- children
	TRUE,
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
	dohmh_facilities_daycare
GROUP BY
	Day_Care_ID,
	Legal_Name,
	Building,
	Street,
	ZipCode,
	Borough,
	facility_type,
	child_care_type,
	program_type,
	Maximum_Capacity