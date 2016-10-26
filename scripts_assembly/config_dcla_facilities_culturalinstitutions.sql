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
	Organization_Name,
	-- addressnumber
	split_part(trim(both ' ' from Address), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from Address), strpos(trim(both ' ' from Address), ' ')+1, (length(trim(both ' ' from Address))-strpos(trim(both ' ' from Address), ' ')))),
	-- address
	Address,
	-- city
	City,
	-- borough
	borough,
	-- boroughcode
		(CASE
			WHEN borough = 'Manhattan' THEN 1
			WHEN borough = 'Bronx' THEN 2
			WHEN borough = 'Brooklyn' THEN 3
			WHEN borough = 'Queens' THEN 4
			WHEN borough = 'Staten Island' THEN 5
		END),
	-- zipcode
	left(zip_code,5)::integer,
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
			WHEN Discipline LIKE '%Museum%'
			WHEN Discipline IS NOT NULL THEN Discipline
			ELSE 'Unspecified Discipline'
		END),
	-- domain
	'Parks, Cultural, and Other Community Facilities',
	-- facilitygroup
	'Cultural Institutions',
	-- facilitysubgroup
	'Other Cultural Institutions',
	-- agencyclass1
	Discipline,
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
	Organization_Name,
	-- operatorabbrev
	'Non-public',
	-- oversightagencyn
	'New York City Department of Cultural Affairs',
	-- oversightabbrev
	'NYCDCLA',
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
	'2016-03-22',
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
	'NYCDCLA',
	-- sourcedatasetname
	'DCLA Cultural Organizations',
	-- linkdata
	'https://data.cityofnewyork.us/Recreation/DCLA-Cultural-Organizations/u35m-9t32',
	-- linkdownload
	'https://data.cityofnewyork.us/api/views/u35m-9t32/rows.csv?accessType=DOWNLOAD',
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
	dcla_facilities_culturalinstitutions