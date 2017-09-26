DROP VIEW nysoasas_facilities_programs_facdbview;
CREATE VIEW nysoasas_facilities_programs_facdbview AS
SELECT * FROM nysoasas_facilities_programs
WHERE
	program_county = 'New York'
	OR program_county = 'Bronx'
	OR program_county = 'Kings'
	OR program_county = 'Queens'
	OR program_county = 'Richmond';

-- facilities
INSERT INTO
facilities(
	hash,
	uid,
    geom,
    geomsource,
	facname,
	addressnum,
	streetname,
	address,
	boro,
	zipcode,
	facdomain,
	facgroup,
	facsubgrp,
	factype,
	optype,
	opname,
	opabbrev,
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
	-- hash
	hash,
    -- uid
    NULL,
	-- geom
	NULL,
    -- geomsource
    'None',
	-- facilityname
	program_name,
	-- addressnumber
	split_part(trim(both ' ' from street), ' ', 1),
	-- streetname
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
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	'Chemical Dependency',
	-- facilitytype
	program_category,
	-- operatortype
	'Non-public',
	-- operatorname
	provider_name,
	-- operator abbrev
	'Non-public',
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
FROM nysoasas_facilities_programs_facdbview;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM nysoasas_facilities_programs_facdbview
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key);
-- JOIN uid FROM KEY ONTO DATABASE
UPDATE facilities AS f
SET uid = k.uid
FROM facdb_uid_key AS k
WHERE k.hash = f.hash AND
      f.uid IS NULL;

-- pgtable
INSERT INTO
facdb_pgtable(
   uid,
   pgtable
)
SELECT
	uid,
	'nysoasas_facilities_programs'
FROM nysoasas_facilities_programs_facdbview, facilities
WHERE facilities.hash = nysoasas_facilities_programs_facdbview.hash;

-- agency id
INSERT INTO
facdb_agencyid(
	uid,
	idagency,
	idname,
	idfield,
	idtable
)
SELECT
	uid,
	program_number,
	'Program Number',
	'program_number',
	'nysoasas_facilities_programs'
FROM nysoasas_facilities_programs, facilities
WHERE facilities.hash = nysoasas_facilities_programs.hash;

-- area NA

-- bbl NA

-- bin NA

-- capacity NA

-- oversight
INSERT INTO
facdb_oversight(
	uid,
	overagency,
	overabbrev,
	overlevel
)
SELECT
	uid,
    'NYS Office of Alcoholism and Substance Abuse Services',
    'NYSOASAS',
    'NA'
FROM nysoasas_facilities_programs, facilities
WHERE facilities.hash = nysoasas_facilities_programs.hash;

-- utilization NA