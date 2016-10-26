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
			WHEN primary_use LIKE '%MUSEUM%' OR primary_use LIKE '%CULTURAL%' THEN 'Parks, Cultural, and Other Community Facilities'
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
			WHEN primary_use LIKE '%MUSEUM%' OR primary_use LIKE '%CULTURAL%' THEN 'Cultural Institutions'
			WHEN primary_use LIKE '%PARKING%' OR primary_use LIKE '%PKNG%' THEN 'Parking, Maintenance, and Storage'
			WHEN primary_use LIKE '%STORAGE%' OR primary_use LIKE '%STRG%' THEN 'Parking, Maintenance, and Storage'
			WHEN primary_use LIKE '%OFFICE%' THEN 'Offices'
			WHEN primary_use LIKE '%MAINTENANCE%' THEN 'Parking, Maintenance, and Storage'
			WHEN primary_use LIKE '%NO USE%' THEN 'Other Property'
			WHEN primary_use LIKE '%MISCELLANEOUS USE%' THEN 'Other Property'
			ELSE 'Emergency Services'
		END),
	-- facilitysubgroup
		(CASE
			WHEN primary_use LIKE '%MUSEUM%' THEN 'Museums'
			WHEN primary_use LIKE '%CULTURAL%' THEN 'Other Cultural Institutions'
			WHEN primary_use LIKE '%PARKING%' OR primary_use LIKE '%PKNG%' THEN 'Parking'
			WHEN primary_use LIKE '%STORAGE%' OR primary_use LIKE '%STRG%' THEN 'Storage'
			WHEN primary_use LIKE '%OFFICE%' THEN 'Offices'
			WHEN primary_use LIKE '%MAINTENANCE%' THEN 'Maintenance'
			WHEN primary_use LIKE '%NO USE%' THEN 'No Use'
			WHEN primary_use LIKE '%MISCELLANEOUS USE%' THEN 'Miscellaneous Use'
			ELSE 'Emergency Services'
		END),
	-- agencyclass1
	primary_use,
	-- agencyclass2
	detailed_use,
	-- colpusetype
	primary_use,
	-- capacity
		(CASE
			WHEN sqft NOT LIKE '%-%' AND sqft NOT LIKE '%D/N/A%' THEN (REPLACE(REPLACE(SQFT,',',''),' ',''))::numeric
			ELSE NULL
		END),
	-- utilization
	NULL,
	-- capacitytype
	'Square Feet',
	-- utilizationrate
	NULL,
	-- area
		(CASE
			WHEN sqft NOT LIKE '%-%' AND sqft NOT LIKE '%D/N/A%' THEN (REPLACE(REPLACE(SQFT,',',''),' ',''))::numeric
			ELSE NULL
		END),
	-- areatype
	'Square Feet',
	-- servicearea
	NULL,
	-- operatortype
	'Public',
	-- operatorname
	'New York City Fire Department',
	-- operatorabbrev
	'NYCFDNY',
	-- oversightagency
	'New York City Fire Department',
	-- oversightabbrev
	'NYCFDNY',
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
	'2016-10-20',
	-- datesourceupdated
	'2016-10-20',
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
	'City Owned and Leased Properties',
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
	dcas_facilities_fdny