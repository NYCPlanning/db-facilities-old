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
	-- hash,
	hash,
    -- uid
    NULL,
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
    -- geomsource
    'Agency',
	-- facilityname
	program_name,
	-- addressnumber
	split_part(trim(both ' ' from initcap(program_address_1)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(program_address_1)), strpos(trim(both ' ' from initcap(program_address_1)), ' ')+1, (length(trim(both ' ' from initcap(program_address_1)))-strpos(trim(both ' ' from initcap(program_address_1)), ' ')))),
	-- address
	initcap(program_address_1),
	-- borough
		(CASE
			WHEN program_county = 'New York' THEN 'Manhattan'
			WHEN program_county = 'Bronx' THEN 'Bronx'
			WHEN program_county = 'Kings' THEN 'Brooklyn'
			WHEN program_county = 'Queens' THEN 'Queens'
			WHEN program_county = 'Richmond' THEN 'Staten Island'
		END),
	-- zipcode
	LEFT(program_zip,5)::integer,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	'Mental Health',
	-- facilitytype
	program_category_description,
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
	-- operator abbrev
		(CASE
			WHEN program_type_description LIKE '%State%' THEN 'NYSOMH'
			WHEN sponsor_name LIKE '%Health and Hospitals Corporation%' THEN 'NYCHHC'
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
		(CASE
			WHEN Program_Category_Description LIKE '%Residential%' THEN TRUE
			ELSE FALSE
		END)
FROM
	nysomh_facilities_mentalhealth
WHERE
	program_county = 'New York'
	OR program_county = 'Bronx'
	OR program_county = 'Kings'
	OR program_county = 'Queens'
	OR program_county = 'Richmond';


-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM nysomh_facilities_mentalhealth
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
)
AND program_county = 'New York'
	OR program_county = 'Bronx'
	OR program_county = 'Kings'
	OR program_county = 'Queens'
	OR program_county = 'Richmond';
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
	'nysomh_facilities_mentalhealth'
FROM nysomh_facilities_mentalhealth, facilities
WHERE facilities.hash = nysomh_facilities_mentalhealth.hash;

-- agency id
INSERT INTO
facdb_agencyid(
	uid,
	overabbrev,
	idagency,
	idname
)
SELECT
	uid,
	'nysomh_facilities_mentalhealth',
	sponsor_code||'-'||facility_code||'-'||program_code,
	'sponsor_code-facility_code-program_code'
FROM nysomh_facilities_mentalhealth, facilities
WHERE facilities.hash = nysomh_facilities_mentalhealth.hash;

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
    'NYS Office of Mental Health',
    'NYSOMH',
    'State'
FROM nysomh_facilities_mentalhealth, facilities
WHERE facilities.hash = nysomh_facilities_mentalhealth.hash;

-- utilization NA 