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
	initcap(sponsor_name),
	-- addressnumber
	split_part(trim(both ' ' from initcap(program_address)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(program_address)), strpos(trim(both ' ' from initcap(program_address)), ' ')+1, (length(trim(both ' ' from initcap(program_address)))-strpos(trim(both ' ' from initcap(program_address)), ' ')))),
	-- address
	initcap(program_address),
	-- borough
	NULL,
	-- zipcode
	program_zipcode::integer,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	'Senior Services',
	-- facilitytype
		(CASE
			WHEN contract_type LIKE '%INNOVATIVE%' AND RIGHT(provider_id,2) <> '01' THEN 'Satellite Senior Centers'
			WHEN contract_type LIKE '%NEIGHBORHOOD%' AND RIGHT(provider_id,2) <> '01' THEN 'Satellite Senior Centers'
			WHEN contract_type LIKE '%INNOVATIVE%' THEN 'Innovative Senior Centers'
			WHEN contract_type LIKE '%NEIGHBORHOOD%' THEN 'Neighborhood Senior Centers'
			WHEN contract_type LIKE '%MEALS%' THEN  initcap(contract_type)
			ELSE 'Senior Services'
		END),
	-- operatortype
	'Non-public',
	-- operatorname
	initcap(sponsor_name),
	-- operatorabbrev
	'Non-public',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
	FALSE,
	-- youth
	FALSE,
	-- senior
	TRUE,
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
	dfta_facilities_contracts;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dfta_facilities_contracts
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
	'dfta_facilities_contracts'
FROM dfta_facilities_contracts, facilities
WHERE facilities.hash = dfta_facilities_contracts.hash;

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
	'NYCDFTA',
	Provider_ID,
	'Provider ID'
FROM dfta_facilities_contracts, facilities
WHERE facilities.hash = dfta_facilities_contracts.hash;

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
    'NYC Department for the Aging',
    'NYCDFTA',
    'City'
FROM dfta_facilities_contracts, facilities
WHERE facilities.hash = dfta_facilities_contracts.hash;

-- utilization NA

