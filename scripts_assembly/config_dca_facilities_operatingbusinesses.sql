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
	DCA_License_Number,
	-- facilityname
	initcap(Business_Name),
	-- addressnumber
	Address_Building,
	-- streetname
	initcap(Address_Street_Name),
	-- address
	CONCAT(Address_Building,' ',initcap(Address_Street_Name)),
	-- city
	Address_City,
	-- borough
		(CASE
			WHEN (Address_Borough IS NULL) AND (Address_City = 'NEW YORK') THEN 'Manhattan'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'BRONX') THEN 'Bronx'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'BROOKLYN') THEN 'Brooklyn'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'QUEENS') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'ASTORIA') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'LONG ISLAND CITY') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'QUEENS VLG') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'JAMAICA') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'WOODSIDE') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'FLUSHING') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'CORONA') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'STATEN ISLAND') THEN 'Staten Island'
			ELSE Address_Borough
		END),
	-- boroughcode
		(CASE
			WHEN Address_Borough = 'Manhattan' THEN 1
			WHEN Address_Borough = 'Bronx' THEN 2
			WHEN Address_Borough = 'Brooklyn' THEN 3
			WHEN Address_Borough = 'Queens' THEN 4
			WHEN Address_Borough = 'Staten Island' THEN 5
			WHEN (Address_Borough IS NULL) AND (Address_City = 'NEW YORK') THEN 1
			WHEN (Address_Borough IS NULL) AND (Address_City = 'BRONX') THEN 2
			WHEN (Address_Borough IS NULL) AND (Address_City = 'BROOKLYN') THEN 3
			WHEN (Address_Borough IS NULL) AND (Address_City = 'QUEENS') THEN 4
			WHEN (Address_Borough IS NULL) AND (Address_City = 'ASTORIA') THEN 4
			WHEN (Address_Borough IS NULL) AND (Address_City = 'LONG ISLAND CITY') THEN 4
			WHEN (Address_Borough IS NULL) AND (Address_City = 'QUEENS VLG') THEN 4
			WHEN (Address_Borough IS NULL) AND (Address_City = 'JAMAICA') THEN 4
			WHEN (Address_Borough IS NULL) AND (Address_City = 'WOODSIDE') THEN 4
			WHEN (Address_Borough IS NULL) AND (Address_City = 'FLUSHING') THEN 4
			WHEN (Address_Borough IS NULL) AND (Address_City = 'CORONA') THEN 4
			WHEN (Address_Borough IS NULL) AND (Address_City = 'STATEN ISLAND') THEN 5
		END),
	-- zipcode
		(CASE
			WHEN Address_Zip ~'^([0-9]+\.?[0-9]*|\.[0-9]+)$' THEN Address_Zip::integer
		END),
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
			WHEN License_Category LIKE '%Scrap Metal%' THEN 'Scrap Metal Processing'
			WHEN License_Category LIKE '%Tow%' THEN 'Tow Truck Company'
			ELSE CONCAT('Commercial ', License_Category)
		END),
	-- domain
	'Core Infrastructure and Transportation',
	-- facilitygroup
		(CASE
			WHEN License_Category = 'Scrap Metal Processor' THEN 'Wastewater and Waste Management'
			WHEN License_Category = 'Parking Lot' THEN 'Transportation'
			WHEN License_Category = 'Garage' THEN 'Transportation'
	 		WHEN License_Category = 'Garage and Parking Lot' THEN 'Transportation'
			WHEN License_Category = 'Tow Truck Company' THEN 'Transportation'
		END),
	-- facilitysubgroup
		(CASE
			WHEN License_Category = 'Scrap Metal Processor' THEN 'Solid Waste Processing'
			WHEN License_Category = 'Parking Lot' THEN 'Parking Lots and Garages'
			WHEN License_Category = 'Garage' THEN 'Parking Lots and Garages'
	 		WHEN License_Category = 'Garage and Parking Lot' THEN 'Parking Lots and Garages'
			WHEN License_Category = 'Tow Truck Company' THEN 'Parking Lots and Garages'
		END),
	-- agencyclass1
	License_Category,
	-- agencyclass2
	License_Type,
	-- colpusetype
	NULL,
	-- capacity
		(CASE
			WHEN Detail LIKE '%Vehicle Spaces%' THEN split_part(split_part(Detail,': ',2),',',1)::double precision
			ELSE NULL
		END),
	-- utilization
	NULL,
	-- capacitytype
		(CASE
			WHEN Detail LIKE '%Vehicle Spaces%' THEN 'Parking Spaces'
			ELSE NULL
		END),
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
	initcap(Business_Name),
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	'New York City Department of Consumer Affairs',
	-- oversightabbrev
	'NYCDCA',
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
	'2016-06-24',
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
	'NYCDCA',
	-- sourcedatasetname
	'Legally Operating Businesses',
	-- linkdata
	'https://data.cityofnewyork.us/Business/Legally-Operating-Businesses/w7w3-xahh',
	-- linkdownload
	'https://data.cityofnewyork.us/api/views/w7w3-xahh/rows.csv?accessType=DOWNLOAD',
	-- datatype
	'CSV with Address',
	-- refreshmeans
	'Geocode - Pull from NYC Open Data',
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
	dca_facilities_operatingbusinesses
WHERE
	License_Category = 'Scrap Metal Processor'
	OR License_Category = 'Parking Lot'
	OR License_Category = 'Garage'
	OR License_Category = 'Garage and Parking Lot'
	OR License_Category = 'Tow Truck Company'