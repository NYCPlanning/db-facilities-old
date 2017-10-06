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
	'nysoasas_facilities_programs',
	-- hash,
    hash,
	-- geom
	NULL,
	-- idagency
	program_number,
	'NYS OASAS Program Number',
	'program_number',
	-- facilityname
	program_name,
	-- address number
	split_part(trim(both ' ' from street), ' ', 1),
	-- street name
	initcap(trim(both ' ' from substr(trim(both ' ' from street), strpos(trim(both ' ' from street), ' ')+1, (length(trim(both ' ' from street))-strpos(trim(both ' ' from street), ' '))))),
	-- address
	street,
	-- borough
		(CASE
			WHEN program_county = 'New York' THEN 'Manhattan'
			WHEN program_county = 'Bronx' THEN 'Bronx'
			WHEN program_county = 'Kings' THEN 'Brooklyn'
			WHEN program_county = 'Queens' THEN 'Queens'
			WHEN program_county = 'Richmond' THEN 'Staten Island'
		END),
	-- zipcode
	LEFT(zip_code,5)::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	NULL,
	-- facilitytype
	program_category,
	-- facilitysubgroup
	'Chemical Dependency',
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
	'Non-public',
	-- operatorname
	provider_name,
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	'NYS Office of Alcoholism and Substance Abuse Services',
	-- oversightabbrev
	'NYSOASAS',
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
			WHEN program_category LIKE '%Residential%' THEN TRUE
			ELSE FALSE
		END)
FROM
	nysoasas_facilities_programs
WHERE
	program_county = 'New York'
	OR program_county = 'Bronx'
	OR program_county = 'Kings'
	OR program_county = 'Queens'
	OR program_county = 'Richmond'
