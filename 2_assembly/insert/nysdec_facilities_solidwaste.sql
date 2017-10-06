INSERT INTO
facilities (
	pgtable,
	hash,
	geom,
	idagency,
	idname,
	idfield,
	facname,
	addressnum,
	streetname,
	address,
	boro,
	zipcode,
	bbl,
	bin,
	geomsource,
	factype,
	facsubgrp,
	capacity,
	util,
	capacitytype,
	utilrate,
	area,
	areatype,
	optype,
	opname,
	opabbrev,
	overagency,
	overabbrev,
	datecreated,
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
	-- pgtable
	'nysdec_facilities_solidwaste',
	-- hash,
    hash,
	-- geom
	-- ST_SetSRID(ST_MakePoint(long, lat),4326)
		(CASE
			WHEN east_coordinate > 11111 
				THEN ST_Transform(ST_SetSRID(ST_MakePoint(east_coordinate, north_coordinate),26918),4326)
		END),
	-- idagency
		(CASE
			WHEN authorization_number <> '?' THEN authorization_number
		END),
		'NYSDEC Authorization Number',
		'authorization_number',
	-- facilityname
	facility_name,
	-- addressnumber
	split_part(trim(both ' ' from location_address), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from location_address), strpos(trim(both ' ' from location_address), ' ')+1, (length(trim(both ' ' from location_address))-strpos(trim(both ' ' from location_address), ' ')))),
	-- address
	location_address,
	-- borough
		(CASE
			WHEN County = 'New York' THEN 'Manhattan'
			WHEN County = 'Bronx' THEN 'Bronx'
			WHEN County = 'Kings' THEN 'Brooklyn'
			WHEN County = 'Queens' THEN 'Queens'
			WHEN County = 'Richmond' THEN 'Staten Island'
		END),
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	'agency',
	-- facilitytype
		(CASE
			WHEN activity_desc LIKE '%C&D%' THEN 'Construction and Demolition Processing'
			WHEN activity_desc LIKE '%Composting%' THEN 'Composting'
			WHEN activity_desc LIKE '%Other%' THEN 'Other Solid Waste Processing'
			WHEN activity_desc LIKE '%RHRF%' THEN 'Recyclables Handling and Recovery'
			WHEN activity_desc LIKE '%medical%' THEN 'Regulated Medical Waste'
			WHEN activity_desc LIKE '%Transfer%' THEN 'Transfer Station'
			WHEN activity_desc LIKE '%Composting%' THEN 'Composting'
			ELSE initcap(trim(split_part(split_part(activity_desc,';',1),'-',1),' '))
		END),
	-- facilitysubgroup
	(CASE
		WHEN activity_desc LIKE '%Transfer%' THEN 'Solid Waste Transfer and Carting'
		ELSE 'Solid Waste Processing'
	END),
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
	-- operatortype
		(CASE
			WHEN owner_type = 'Municipal' THEN 'Public'
			ELSE 'Non-public'
		END),
	-- operatorname
		(CASE
			WHEN owner_type = 'Municipal' THEN 'NYC Department of Sanitation'
			WHEN owner_name IS NOT NULL THEN owner_name
			ELSE 'Unknown'
		END),
	-- operatorabbrev
		(CASE
			WHEN owner_type = 'Municipal' THEN 'NYCDSNY'
			ELSE 'Non-public'
		END),
	-- oversightagencyname
		(CASE
			WHEN owner_type = 'Municipal' THEN 'NYC Department of Sanitation'
			ELSE 'NYS Department of Environmental Conservation'
		END),
	-- oversightabbrev
		(CASE
			WHEN owner_type = 'Municipal' THEN 'NYCDSNY'
			ELSE 'NYSDEC'
		END),
	-- datecreated
	CURRENT_TIMESTAMP,
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
	nysdec_facilities_solidwaste
WHERE
	County = 'New York'
	OR County = 'Bronx'
	OR County = 'Kings'
	OR County = 'Queens'
	OR County = 'Richmond'
