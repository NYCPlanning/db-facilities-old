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
	'nysdoh_cacfp',
	-- hash,
    hash,
	-- geom
	ST_SetSRID(ST_MakePoint(substring(location from '\, (.+)\)')::double precision, substring(location from '\((.+)\,')::double precision),4326),
	-- idagency
	NULL,
	NULL,
	NULL,
	-- facilityname
	sitename,
	-- addressnumber
	split_part(trim(both ' ' from street1), ' ', 1),
	-- streetname
	initcap(trim(both ' ' from substr(trim(both ' ' from street1), strpos(trim(both ' ' from street1), ' ')+1, (length(trim(both ' ' from street1))-strpos(trim(both ' ' from street1), ' '))))),
	-- address
	street1,
	-- borough
		(CASE
			WHEN county = 'New York' THEN 'Manhattan'
			WHEN county = 'Bronx' THEN 'Bronx'
			WHEN county = 'Kings' THEN 'Brooklyn'
			WHEN county = 'Queens' THEN 'Queens'
			WHEN county = 'Richmond' THEN 'Staten Island'
		END),
	-- zipcode
	zipcode,
	-- bbl
	NULL,
	-- bin
	NULL,
	'agency',
	-- facilitytype
	'NYC Child and Adult Care Food Program ('||initcap(sitetype)||')',
	-- facilitysubgroup
	'Financial Assistance and Social Services',
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
	sitename,
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	(CASE 
		WHEN licensetype = 'NYC DEPARTMENT OF HEALTH AND MENTAL HYGIENE' THEN 'NYC Department of Health and Mental Hygiene'
		WHEN licensetype = 'OFFICE FOR PEOPLE WITH DEVELOPMENTAL DISABILITIES' THEN 'NYS Office for People With Developmental Disabilities'
		WHEN licensetype = 'OFFICE FOR THE AGING' THEN 'NYS Office for the Aging'
		WHEN licensetype = 'OFFICE OF CHILDREN AND FAMILY SERVICES' THEN 'New York State Office of Children and Family Services'
		WHEN licensetype = 'OFFICE OF MENTAL HEALTH' THEN 'NYS Office of Mental Health'
		ELSE 'Non-public'
	END),
	-- oversightabbrev
	(CASE 
		WHEN licensetype = 'NYC DEPARTMENT OF HEALTH AND MENTAL HYGIENE' THEN 'NYCDOHMH'
		WHEN licensetype = 'OFFICE FOR PEOPLE WITH DEVELOPMENTAL DISABILITIES' THEN 'NYSOPWDD'
		WHEN licensetype = 'OFFICE FOR THE AGING' THEN 'NYSOFA'
		WHEN licensetype = 'OFFICE OF CHILDREN AND FAMILY SERVICES' THEN 'NYSOCFS'
		WHEN licensetype = 'OFFICE OF MENTAL HEALTH' THEN 'NYSOMH'
		ELSE 'Non-public'
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
FROM nysdoh_cacfp
WHERE
	county = 'New York'
	OR county = 'Bronx'
	OR county = 'Kings'
	OR county = 'Queens'
	OR county = 'Richmond'
