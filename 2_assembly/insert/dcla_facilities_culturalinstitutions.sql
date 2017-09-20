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
	organization_name,
	-- addressnumber
	split_part(trim(both ' ' from initcap(address)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(address)), strpos(trim(both ' ' from initcap(address)), ' ')+1, (length(trim(both ' ' from initcap(address)))-strpos(trim(both ' ' from initcap(address)), ' ')))),
	-- address
	initcap(address),
	-- borough
	borough,
	-- zipcode
	LEFT(zip_code,5)::integer,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
		(CASE
			WHEN discipline LIKE '%Museum%' THEN 'Museums'
			ELSE 'Other Cultural Institutions'
		END),
	-- facilitytype
		(CASE
			WHEN discipline IS NOT NULL THEN discipline
			ELSE 'Unspecified Discipline'
		END),
	-- operatortype
	'Non-public',
	-- operatorname
	organization_name,
	-- operatorabbrev
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
	FALSE
FROM
	dcla_facilities_culturalinstitutions;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dcla_facilities_culturalinstitutions
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
	'dcla_facilities_culturalinstitutions'
FROM dcla_facilities_culturalinstitutions, facilities
WHERE facilities.hash = dcla_facilities_culturalinstitutions.hash;

-- agency id NA

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
        'NYC Department of Cultural Affairs',
        'NYCDCLA',
        'City'
FROM dcla_facilities_culturalinstitutions, facilities
WHERE facilities.hash = dcla_facilities_culturalinstitutions.hash;

-- utilization NA