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
	name,
	-- address number
	split_part(trim(both ' ' from address), ' ', 1),
	-- street name
	initcap(trim(both ' ' from substr(trim(both ' ' from address), strpos(trim(both ' ' from address), ' ')+1, (length(trim(both ' ' from address))-strpos(trim(both ' ' from address), ' '))))),
	-- address
	address,
	-- city
	NULL,
	-- borough
	NULL,
	-- boroughcode
	NULL,
	-- zipcode
	LEFT(zip_code,5)::integer,
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
	latitude_y,
	-- trim(trim(split_part(split_part(Location,'(',2),',',1),'('),' ')::double precision,
	-- longitude
	longitude_x,
	-- trim(split_part(split_part(Location,'(',2),',',1),' ')::double precision,
	-- facilitytype
		(CASE
			WHEN fbc_agency_category_code = 'PANTRY' THEN 'Food Pantry'
			WHEN fbc_agency_category_code = 'SOUP KITCH' THEN 'Soup Kitchen'
		END),
	-- domain
	'Health Care and Human Services',
	-- facilitygroup
	'Human Services',
	-- facilitysubgroup
	'Soup Kitchens and Food Pantries',
	-- agencyclass1
	fbc_agency_category_code,
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
	'Non-public',
	-- operatorname
	name,
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	'Non-public',
	-- oversightabbrev
	'Non-public',
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
	'2016-08-05',
	-- datesourceupdated
	'2016-08-05',
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
	ST_SetSRID(ST_MakePoint(longitude_x, latitude_y),4326),
	-- agencysource
	'FBNYC',
	-- sourcedatasetname
	'FBNYC Food Pantry Soup Kitchen List 8-5-16',
	-- linkdata
	'NA',
	-- linkdownload
	'NA',
	-- datatype
	'CSV with Coordinates',
	-- refreshmeans
	'Request file from agency',
	-- refreshfrequency
	'Quarterly',
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
	foodbankny_facilities_foodbanks
