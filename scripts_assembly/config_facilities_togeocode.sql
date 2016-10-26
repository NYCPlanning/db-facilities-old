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
	facilityname,
	-- addressnumber
	trim(addressnumber,'"'),
	-- streetname
	initcap(replace(streetname, 'STEET', 'STREET')),
	-- address
	initcap(replace(address, 'STEET', 'STREET')),
	-- city
	NULL,
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
	NULL,
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
	facilitytype,
	-- domain
	'Public Safety, Emergency Services, and Administration of Justice',
	-- facilitygroup
	'Justice and Corrections',
	-- facilitysubgroup
		(CASE
			WHEN (facilitytype LIKE '%Courthouse%') OR (operatorname LIKE '%Court%') THEN
				'Courthouses and Judicial'
			ELSE 'Detention and Correctional'
		END),
	-- agencyclass1
	'NA',
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
	operatortype,
	-- operatorname
	operatorname,
	-- operatorabbrev
	operatorabbrev,
	-- oversightagency
	oversightagency,
	-- oversightabbrev
	oversightabbrev,
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
	dateobtained::date,
	-- datesourceupdated
	dateobtained::date,
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
	datasource,
	-- sourcedatasetname
	dataset,
	-- linkdata
	datalink,
	-- linkdownload
	'NA',
	-- datatype
	'Addresses',
	-- refreshmeans
	'Manual copy and paste',
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
		(CASE
			WHEN facilitytype LIKE '%Juvenile%' THEN TRUE
			ELSE FALSE
		END),
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
			WHEN facilitytype LIKE '%Detention%' THEN TRUE
			WHEN facilitytype LIKE '%Residential%' THEN TRUE
			WHEN facilitytype LIKE '%Correctional%' THEN TRUE
			WHEN facilitytype LIKE '%Reception%' THEN TRUE
			ELSE FALSE
		END)
FROM
	togeocode