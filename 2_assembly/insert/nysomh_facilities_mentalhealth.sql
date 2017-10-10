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
	'nysomh_facilities_mentalhealth',
	-- hash,
    hash,
	-- geom
	(CASE
		WHEN (Location IS NOT NULL) AND (Location LIKE '%(%') THEN
			ST_SetSRID(
				ST_MakePoint(
					trim(trim(split_part(split_part(Location,'(',2),',',2),')'),' ')::double precision,
					trim(split_part(split_part(Location,'(',2),',',1),' ')::double precision),
				4326)
			-- before had 3857, not sure where this SRID came from
	END),
	-- idagency
	CONCAT(sponsor_code,'-',facility_code,'-', program_code),
	'NYS Unique ID',
	'sponsor_code-facility_code-program_code',
	-- facilityname
	Program_Name,
	-- addressnumber
	split_part(trim(both ' ' from initcap(Program_Address_1)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(Program_Address_1)), strpos(trim(both ' ' from initcap(Program_Address_1)), ' ')+1, (length(trim(both ' ' from initcap(Program_Address_1)))-strpos(trim(both ' ' from initcap(Program_Address_1)), ' ')))),
	-- address
	initcap(Program_Address_1),
	-- borough
		(CASE
			WHEN Program_County = 'New York' THEN 'Manhattan'
			WHEN Program_County = 'Bronx' THEN 'Bronx'
			WHEN Program_County = 'Kings' THEN 'Brooklyn'
			WHEN Program_County = 'Queens' THEN 'Queens'
			WHEN Program_County = 'Richmond' THEN 'Staten Island'
		END),
	-- zipcode
	LEFT(Program_Zip,5)::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	'agency',
	-- facilitytype
	Program_Category_Description,
	-- facilitysubgroup
	'Mental Health',
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
			WHEN program_type_description LIKE '%State%' THEN 'Public'
			WHEN sponsor_name LIKE '%Health and Hospitals Corporation%' THEN 'Public'
			ELSE 'Non-public'
		END),
	-- operatorname
		(CASE
			WHEN program_type_description LIKE '%State%' THEN 'NYS Office of Mental Health'
			WHEN sponsor_name LIKE '%Health and Hospitals Corporation%' THEN 'NYC Health and Hospitals Corporation'
			ELSE Agency_Name
		END),
	-- operatorabbrev
		(CASE
			WHEN program_type_description LIKE '%State%' THEN 'NYSOMH'
			WHEN sponsor_name LIKE '%Health and Hospitals Corporation%' THEN 'NYCHHC'
			ELSE 'Non-public'
		END),
	-- oversightagency
	'NYS Office of Mental Health',
	-- oversightabbrev
	'NYSOMH',
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
		(CASE
			WHEN Program_Category_Description LIKE '%Residential%' THEN TRUE
			ELSE FALSE
		END)
FROM
	nysomh_facilities_mentalhealth
WHERE
	Program_County = 'New York'
	OR Program_County = 'Bronx'
	OR Program_County = 'Kings'
	OR Program_County = 'Queens'
	OR Program_County = 'Richmond'
