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
	LOCCODE,
	-- facilityname
	LocName,
	-- addressnumber
	split_part(trim(both ' ' from address), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from address), strpos(trim(both ' ' from address), ' ')+1, (length(trim(both ' ' from address))-strpos(trim(both ' ' from address), ' ')))),
	-- address
	address,
	-- city
	NULL,
	-- borough
		(CASE
			WHEN Borough = 'M' THEN 'Manhattan'
			WHEN Borough = 'X' THEN 'Bronx'
			WHEN Borough = 'K' THEN 'Brooklyn'
			WHEN Borough = 'Q' THEN 'Queens'
			WHEN Borough = 'R' THEN 'Staten Island'
		END),
	-- boroughcode
		(CASE
			WHEN Borough = 'M' THEN 1
			WHEN Borough = 'X' THEN 2
			WHEN Borough = 'K' THEN 3
			WHEN Borough = 'Q' THEN 4
			WHEN Borough = 'R' THEN 5
		END),
	-- zipcode
	zip::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- parkid
	NULL,
	-- xcoord
	x,
	-- ycoord
	y,
	-- latitude
	ST_Y(ST_Transform(ST_SetSRID(ST_MakePoint(x, y),2263),4326)),
	-- longitude
	ST_X(ST_Transform(ST_SetSRID(ST_MakePoint(x, y),2263),4326)),
	-- facilitytype
		(CASE
			WHEN PreK_Type = 'DOE' THEN 'Universal Pre-K'
			WHEN PreK_Type = 'CHARTER' THEN 'Universal Pre-K - Charter '
			WHEN PreK_Type = 'NYCEEC' THEN 'NYC Early Education Center'
		END),
	-- domain
	'Education, Child Welfare, and Youth',
	-- facilitygroup
	'Schools',
	-- facilitysubgroup
	'Preschools',
	-- agencyclass1
	PreK_Type,
	-- agencyclass2
	'NA',
	-- colpusetype
	NULL,
	-- capacity
	Seats,
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
		(CASE
			WHEN PreK_Type = 'DOE' THEN 'Public'
			WHEN PreK_Type = 'CHARTER' THEN 'Charter'
			WHEN PreK_Type = 'NYCEEC' THEN 'Non-public'
			ELSE 'Unknown'
		END),
	-- operatorname
		(CASE
			WHEN PreK_Type = 'DOE' THEN 'New York City Department of Education'
			WHEN PreK_Type = 'CHARTER' THEN LocName
			WHEN PreK_Type = 'NYCEEC' THEN LocName
			ELSE 'Unknown'
		END),
	-- operatorabbrev
		(CASE
			WHEN PreK_Type = 'DOE' THEN 'NYCDOE'
			WHEN PreK_Type = 'CHARTER' THEN 'Charter'
			WHEN PreK_Type = 'NYCEEC' THEN 'Non-public'
			ELSE 'Unknown'
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
	'2016-08-01',
	-- datesourceupdated
	'2016-01-15',
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
	ST_Transform(ST_SetSRID(ST_MakePoint(x, y),2263),4326),
	-- agencysource
	'NYCDOE',
	-- sourcedatasetname
	'Universal Pre-K (UPK) School Locations',
	-- linkdata
	'https://data.cityofnewyork.us/Education/Universal-Pre-K-UPK-School-Locations/kiyv-ks3f',
	-- linkdownload
	'https://data.cityofnewyork.us/api/views/kiyv-ks3f/rows.csv?accessType=DOWNLOAD',
	-- datatype
	'CSV with Coordinates',
	-- refreshmeans
	'Pull from NYC Open Data',
	-- refreshfrequency
	'Monthly',
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
	doe_facilities_universalprek