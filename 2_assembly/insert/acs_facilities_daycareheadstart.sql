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
	NULL,
    -- geomsource
    'None',
	-- facilityname
	program_name,
	-- addressnumber
	split_part(trim(both ' ' from initcap(program_address)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(program_address)), strpos(trim(both ' ' from initcap(program_address)), ' ')+1, (length(trim(both ' ' from initcap(program_address)))-strpos(trim(both ' ' from initcap(program_address)), ' ')))),
	-- address
	initcap(program_address),
	-- borough
		(CASE
			WHEN Boro = 'MN' THEN 'Manhattan'
			WHEN Boro = 'BX' THEN 'Bronx'
			WHEN Boro = 'BK' THEN 'Brooklyn'
			WHEN Boro = 'QN' THEN 'Queens'
			WHEN Boro = 'SI' THEN 'Staten Island'
		END),
	-- zipcode
	zip,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	'Child Care',
	-- facilitytype
		(CASE
			WHEN Model_Type = 'DE' OR Model_Type = 'DU' THEN 'Dual Enrollment Child Care/Head Start'
			WHEN Model_Type = 'CC' THEN 'Child Care'
			WHEN Model_Type = 'HS' THEN 'Head Start'
			ELSE 'Child Care'
		END),
	-- operatortype
	'Non-public',
	-- operatorname
	contractor_name,
	-- operator abbrev
	'Non-public',
	-- datecreated
	CURRENT_TIMESTAMP,
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
	acs_facilities_daycareheadstart;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM acs_facilities_daycareheadstart
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
);
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
	'acs_facilities_daycareheadstart'
FROM acs_facilities_daycareheadstart, facilities
WHERE facilities.hash = acs_facilities_daycareheadstart.hash;

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
	el_program_number,
	'Early Learn Program Number',
	'el_program_number',
	'acs_facilities_daycareheadstart'
FROM acs_facilities_daycareheadstart, facilities
WHERE facilities.hash = acs_facilities_daycareheadstart.hash;

-- area NA

-- bbl NA

-- bin NA

-- capacity
INSERT INTO
facdb_capacity(
  uid,
  capacity,
  capacitytype
)
SELECT
	uid,
	ROUND(total::numeric,0)::text,
	'Seats in ACS Contract'
FROM acs_facilities_daycareheadstart, facilities
WHERE facilities.hash = acs_facilities_daycareheadstart.hash;

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
    'NYC Administration for Childrens Services',
    'NYCACS',
    'City'
FROM acs_facilities_daycareheadstart, facilities
WHERE facilities.hash = acs_facilities_daycareheadstart.hash;

-- utilization NA

