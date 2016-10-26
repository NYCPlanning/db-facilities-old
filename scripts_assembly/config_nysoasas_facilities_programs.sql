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
	program_number,
	-- facilityname
	provider_name,
	-- address number
	split_part(trim(both ' ' from street), ' ', 1),
	-- street name
	initcap(trim(both ' ' from substr(trim(both ' ' from street), strpos(trim(both ' ' from street), ' ')+1, (length(trim(both ' ' from street))-strpos(trim(both ' ' from street), ' '))))),
	-- address
	street,
	-- city
	NULL,
	-- borough
		(CASE
			WHEN program_county = 'New York' THEN 'Manhattan'
			WHEN program_county = 'Bronx' THEN 'Bronx'
			WHEN program_county = 'Kings' THEN 'Brooklyn'
			WHEN program_county = 'Queens' THEN 'Queens'
			WHEN program_county = 'Richmond' THEN 'Staten Island'
		END),
	-- borough
		(CASE
			WHEN program_county = 'New York' THEN 1
			WHEN program_county = 'Bronx' THEN 2
			WHEN program_county = 'Kings' THEN 3
			WHEN program_county = 'Queens' THEN 4
			WHEN program_county = 'Richmond' THEN 5
		END),
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
	NULL,
	-- trim(trim(split_part(split_part(Location,'(',2),',',1),'('),' ')::double precision,
	-- longitude
	NULL,
	-- trim(split_part(split_part(Location,'(',2),',',1),' ')::double precision,
	-- facilitytype
	program_category,
	-- domain
	'Health Care and Human Services',
	-- facilitygroup
	'Health Care',
	-- facilitysubgroup
	'Chemical Dependency',
	-- agencyclass1
	program_category,
	-- agencyclass2
	service,
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
	provider_name,
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	'New York State Office of Alcoholism and Substance Abuse Services',
	-- oversightabbrev
	'NYSOASAS',
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
	'2016-10-01',
	-- datesourceupdated
	'2016-10-01',
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
	-- ST_SetSRID(
	-- 	ST_MakePoint(
	-- 		trim(trim(split_part(split_part(Location,'(',2),',',2),')'),' ')::double precision,
	-- 		trim(split_part(split_part(Location,'(',2),',',1),' ')::double precision),
	-- 	4326),
	NULL,
	-- agencysource
	'NYSOASAS',
	-- sourcedatasetname
	'List of NYC Programs',
	-- linkdata
	'NA',
	-- linkdownload
	'NA',
	-- datatype
	'CSV with Addresses',
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
	nysoasas_facilities_programs
WHERE
	program_county = 'New York'
	OR program_county = 'Bronx'
	OR program_county = 'Kings'
	OR program_county = 'Queens'
	OR program_county = 'Richmond'
