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
	Reference_Key,
	-- facilityname
	initcap(Shelter_Operator_Facility_Name),
	-- addressnumber
	split_part(trim(both ' ' from Shelter_Operating_Address), ' ', 1),
	-- streetname
	initcap(split_part(trim(both ' ' from Shelter_Operating_Address), ' ', 2)),
	-- address
	initcap(Shelter_Operating_Address),
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
	zip::integer,
	-- bbl
	NULL,
	-- bin
	ARRAY[Corrected_BIN],
	-- parkid
	ARRAY[bbl],
	-- xcoord
	ST_X(ST_Transform(geom,2263)),
	-- ycoord
	ST_Y(ST_Transform(geom,2263)),
	-- latitude
	ST_Y(geom),
	-- longitude
	ST_X(geom),
	-- facilitytype
	Shelter_Facility_Type_Cares,
	-- domain
	'Health and Human Services',
	-- facilitygroup
	'Human Services',
	-- facilitysubgroup
	'Shelters and Transitional Housing',
	-- agencyclass1
	Shelter_Facility_Type_CARES,
	-- agencyclass2
	NYC_Owned_Property,
	-- colpusetype
	NULL,
	-- capacity
	Active,
	-- utilization
	Occupied_UnitBeds,
	-- capacitytype
	(CASE
		WHEN Shelter_Facility_Type_CARES LIKE '%Family%' THEN 'Family Residential Units'
		ELSE 'Beds'
	END),
	-- utilizationrate
	Occupied_UnitBeds/Active,
	-- area
	NULL,
	-- areatype
	NULL,
	-- servicearea
	NULL,
	-- operatortype
		(CASE
			WHEN NYC_Owned_Property LIKE '%NYC Owned%' THEN 'Public'
			ELSE 'Non-public'
		END),
	-- operatorname
		(CASE
			WHEN NYC_Owned_Property LIKE '%NYC Owned%' THEN '%New York City Department of Homeless Services%'
			ELSE initcap(Service_Provider)
		END),
	-- operatorabbrev
		(CASE
			WHEN NYC_Owned_Property LIKE '%NYC Owned%' THEN 'NYCDHS'
			ELSE 'Non-public'
		END),
	-- oversightagency
	'New York City Department of Homeless Services',
	-- oversightabbrev
	'NYCDHS',
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
	'2016-07-25',
	-- datesourceupdated
	'2016-07-25',
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
	geom,
	-- agencysource
	'NYCHRA',
	-- sourcedatasetname
	'Final shelter address list 2016 07 25 for distribution corrected',
	-- linkdata
	'NA',
	-- linkdownload
	'NA',
	-- datatype
	'CSV with BINs and Addresses',
	-- refreshmeans
	'Request file from agency',
	-- refreshfrequency
	'Monthly',
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
	(CASE
		WHEN Shelter_Facility_Type_CARES LIKE '%Family%' THEN TRUE
		ELSE FALSE
	END),
	-- disabilities
	FALSE,
	-- dropouts
	FALSE,
	-- unemployed
	FALSE,
	-- homeless
	TRUE,
	-- immigrants
	FALSE,
	-- groupquarters
	TRUE
FROM 
	(SELECT 
		h.*,
		ST_Centroid(ST_Transform(b.geom,4326)) AS geom,
		b.bbl as bbl
	FROM hra_facilities_dhsshelters AS h
	LEFT JOIN doitt_buildingfootprints AS b
	ON h.Corrected_BIN::text = b.bin::text) AS hra_facilities_dhsshelters