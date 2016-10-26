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
	uniquekey,
	-- facilityname
	initcap(Parcel_Name),
	-- addressnumber
	initcap(split_part(trim(Address,' '),' ',1)),
	-- streetname
	initcap(split_part(trim(Address,' '),' ',2)),
	-- address
	initcap(trim(Address,' ')),
	-- city
	NULL,
	-- borough
		(CASE
			WHEN boro = 'MN' THEN 'Manhattan'
			WHEN boro = 'BX' THEN 'Bronx'
			WHEN boro = 'BK' THEN 'Brooklyn'
			WHEN boro = 'QN' THEN 'Queens'
			WHEN boro = 'QU' THEN 'Queens'
			WHEN boro = 'SI' THEN 'Staten Island'
		END),
	-- boroughcode
		(CASE
			WHEN boro = 'MN' THEN 1
			WHEN boro = 'BX' THEN 2
			WHEN boro = 'BK' THEN 3
			WHEN boro = 'QN' THEN 4
			WHEN boro = 'QU' THEN 4
			WHEN boro = 'SI' THEN 5
		END),
	-- zipcode
	NULL,
	-- bbl
		(CASE
			WHEN boro = 'MN' THEN ARRAY[CONCAT('1',LPAD(block,5,'0'),LPAD(lot,4,'0'))]
			WHEN boro = 'BX' THEN ARRAY[CONCAT('2',LPAD(block,5,'0'),LPAD(lot,4,'0'))]
			WHEN boro = 'BK' THEN ARRAY[CONCAT('3',LPAD(block,5,'0'),LPAD(lot,4,'0'))]
			WHEN boro = 'QN' THEN ARRAY[CONCAT('4',LPAD(block,5,'0'),LPAD(lot,4,'0'))]
			WHEN boro = 'QU' THEN ARRAY[CONCAT('4',LPAD(block,5,'0'),LPAD(lot,4,'0'))]
			WHEN boro = 'SI' THEN ARRAY[CONCAT('5',LPAD(block,5,'0'),LPAD(lot,4,'0'))]
		END),
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
	initcap(split_part(split_part(primary_use,' - ',2),'(',1)),
	-- domain
		(CASE
			WHEN primary_use LIKE '%PARKING%' OR primary_use LIKE '%PKNG%' THEN 'Administration of Government'
			WHEN primary_use LIKE '%STORAGE%' OR primary_use LIKE '%STRG%' THEN 'Administration of Government'
			WHEN primary_use LIKE '%OFFICE%' THEN 'Administration of Government'
			WHEN primary_use LIKE '%MAINTENANCE%' THEN 'Administration of Government'
			WHEN primary_use LIKE '%NO USE%' THEN 'Administration of Government'
			WHEN primary_use LIKE '%MISCELLANEOUS USE%' THEN 'Administration of Government'
			ELSE 'Public Safety, Emergency Services, and Administration of Justice'
		END),
	-- facilitygroup
		(CASE
			WHEN primary_use LIKE '%PARKING%' OR primary_use LIKE '%PKNG%' THEN 'Parking, Maintenance, and Storage'
			WHEN primary_use LIKE '%STORAGE%' OR primary_use LIKE '%STRG%' THEN 'Parking, Maintenance, and Storage'
			WHEN primary_use LIKE '%OFFICE%' THEN 'Offices'
			WHEN primary_use LIKE '%MAINTENANCE%' THEN 'Parking, Maintenance, and Storage'
			WHEN primary_use LIKE '%NO USE%' THEN 'Other Property'
			WHEN primary_use LIKE '%MISCELLANEOUS USE%' THEN 'Other Property'
			ELSE 'Public Safety'
		END),
	-- facilitysubgroup
		(CASE
			WHEN primary_use LIKE '%PARKING%' OR primary_use LIKE '%PKNG%' THEN 'Parking'
			WHEN primary_use LIKE '%STORAGE%' OR primary_use LIKE '%STRG%' THEN 'Storage'
			WHEN primary_use LIKE '%OFFICE%' THEN 'Offices'
			WHEN primary_use LIKE '%MAINTENANCE%' THEN 'Maintenance'
			WHEN primary_use LIKE '%NO USE%' THEN 'No Use'
			WHEN primary_use LIKE '%MISCELLANEOUS USE%' THEN 'Miscellaneous Use'
			ELSE 'Police Services'
		END),
	-- agencyclass1
	primary_use,
	-- agencyclass2
	detailed_use,
	-- colpusetype
	primary_use,
	-- capacity
	REPLACE(SQFT,',','')::numeric,
	-- utilization
	NULL,
	-- capacitytype
	'Square Feet',
	-- utilizationrate
	NULL,
	-- area
	REPLACE(SQFT,',','')::numeric,
	-- areatype
	'Square Feet',
	-- servicearea
	NULL,
	-- operatortype
	'Public',
	-- operatorname
	'New York City Police Department',
	-- operatorabbrev
	'NYCNYPD',
	-- oversightagency
	'New York City Police Department',
	-- oversightabbrev
	'NYCNYPD',
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
	'2016-08-20',
	-- datesourceupdated
	'2016-08-20',
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
	'NYCDCAS',
	-- sourcedatasetname
	'Gazetteer 2016',
	-- linkdata
	'NA',
	-- linkdownload
	'NA',
	-- datatype
	'CSV with Address',
	-- refreshmeans
	'Geocode - Request from Agency',
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
	dcas_facilities_nypd
WHERE
	Parcel_Name NOT LIKE '%COUNTERTERRORISM%'
	AND Parcel_Name NOT LIKE '%INTELLIGENCE%'
	AND Unit NOT LIKE '%COUNTERTERRORISM%'
	AND Unit NOT LIKE '%INTELLIGENCE%'
	AND BBL <> '3016330039'
	AND BBL <> '3006620001'
	AND BBL <> '3036980001'
	AND BBL <> '3036980003'
	AND BBL <> '3036980004'
	AND BBL <> '3036980015'
	AND BBL <> '3036980032'
	AND BBL <> '3036980103'
	AND BBL <> '1002410013'
	AND BBL <> '1019860065'
	AND BBL <> '2050640078'
	AND BBL <> '2051010012'
	AND BBL <> '3079200001'
	AND BBL <> '4040190075'
	AND BBL <> '4040310001'
	AND BBL <> '4040450001'
	AND BBL <> '5021650170'
	AND Address NOT LIKE '30 RALPH AVENUE'
	AND Address NOT LIKE '2ND AVE'
	AND Address NOT LIKE '111-13 SNEDIKER AVENUE'
	AND Address NOT LIKE '109 SNEDIKER AVENUE'
	AND Address NOT LIKE '105 SNEDIKER AVENUE'
	AND Address NOT LIKE '232 LIBERTY AVENUE'
	AND Address NOT LIKE '245 GLENMORE AVENUE'
	AND Address NOT LIKE '107 SNEDIKER AVENUE'
	AND Address NOT LIKE '3280 BROADWAY'
	AND Address NOT LIKE '550 E 241ST STREET'
	AND Address NOT LIKE '500 ABBOT ST'
	AND Address NOT LIKE '860 REMSEN AVENUE'
	AND Address NOT LIKE '11-04 111 STREET'
	AND Address NOT LIKE '109-15 14TH AVENUE'
	AND Address NOT LIKE '14-04 111TH STREET'
	AND Address NOT LIKE '2 TELEPORT DRIVE'


