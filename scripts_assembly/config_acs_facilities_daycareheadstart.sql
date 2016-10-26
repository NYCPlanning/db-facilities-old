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
	EL_Program_Number,
	-- facilityname
	Site_Name,
	-- addressnumber
	split_part(trim(both ' ' from Site_Address), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from Site_Address), strpos(trim(both ' ' from Site_Address), ' ')+1, (length(trim(both ' ' from Site_Address))-strpos(trim(both ' ' from Site_Address), ' ')))),
	-- address
	Site_Address,
	-- city
	NULL,
	-- borough
		(CASE
			WHEN Boro = 'MN' THEN 'Manhattan'
			WHEN Boro = 'BX' THEN 'Bronx'
			WHEN Boro = 'BK' THEN 'Brooklyn'
			WHEN Boro = 'QN' THEN 'Queens'
			WHEN Boro = 'SI' THEN 'Staten Island'
		END),
	-- boroughcode
		(CASE
			WHEN Boro = 'MN' THEN 1
			WHEN Boro = 'BX' THEN 2
			WHEN Boro = 'BK' THEN 3
			WHEN Boro = 'QN' THEN 4
			WHEN Boro = 'SI' THEN 5
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
		(CASE
			WHEN ProgXcoord <> '#N/A' THEN ProgXcoord::double precision
		END),
	-- ycoord
		(CASE
			WHEN ProgYcoord <> '#N/A' THEN ProgYcoord::double precision
		END),
	-- latitude
		(CASE
			WHEN ProgYcoord <> '#N/A' THEN
				ST_Y(ST_Transform(ST_SetSRID(ST_MakePoint(ProgXcoord::double precision, ProgYcoord::double precision),2263),4326))
		END),
	-- longitude
		(CASE
			WHEN ProgYcoord <> '#N/A' THEN
				ST_X(ST_Transform(ST_SetSRID(ST_MakePoint(ProgXcoord::double precision, ProgYcoord::double precision),2263),4326))
		END),
	-- facilitytype
		(CASE
			WHEN Model_Type = 'DE' OR Model_Type = 'DU' THEN 'Dual Enrollment Child Care/Head Start'
			WHEN Model_Type = 'CC' THEN 'Childcare - Unspecified'
			WHEN Model_Type = 'HS' THEN 'Head Start'
		END),
	-- domain
	'Youth, Education, and Child Welfare',
	-- facilitygroup
		(CASE
			WHEN Model_Type = 'DE' OR Model_Type = 'DU' THEN 'Schools'
			WHEN Model_Type = 'CC' THEN 'Childcare'
			WHEN Model_Type = 'HS' THEN 'Schools'
		END),
	-- facilitysubgroup
		(CASE
			WHEN Model_Type = 'DE' OR Model_Type = 'DU' THEN 'Preschools'
			WHEN Model_Type = 'CC' THEN 'Childcare'
			WHEN Model_Type = 'HS' THEN 'Preschools'
		END),
	-- agencyclass1
	Model_Type,
	-- agencyclass2
	'NA',
	-- colpusetype
	NULL,
	-- capacity
	Total_capacity_contracts,
	-- utilization
	Total_Enroll,
	-- capacitytype
	'Seats',
	-- utilizationrate
	Utilization,
	-- area
	NULL,
	-- areatype
	NULL,
	-- servicearea
	NULL,
	-- operatortype
	'Non-public',
	-- operatorname
	Contractor_Program_Name,
	-- operator abbrev
	'Non-public',
	-- oversightagency
	'New York City Administration for Childrens Services',
	-- oversightabbrev
	'NYCACS',
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
	'2016-07-20',
	-- datesourceupdated
	'2016-07-20',
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
		(CASE
			WHEN ProgXcoord <> '#N/A' THEN ST_Transform(ST_SetSRID(ST_MakePoint(ProgXcoord::double precision, ProgYcoord::double precision),2263),4326)
		END),
	-- agencysource
	'NYCACS',
	-- sourcedatasetname
	'Contractor Data',
	-- linkdata
	'NA',
	-- linkdownload
	'NA',
	-- datatype
	'CSV with Coordinates',
	-- refreshmeans
	'Request file from agency',
	-- refreshfrequency
	'Annually',
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
	acs_facilities_daycareheadstart