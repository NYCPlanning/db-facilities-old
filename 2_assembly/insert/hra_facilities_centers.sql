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
	name,
	-- addressnumber
	split_part(trim(both ' ' from address), ' ', 1),
	-- streetname
	initcap(split_part(trim(both ' ' from address), ' ', 2)),
	-- address
	initcap(address),
	-- borough
	initcap(borough),
	-- zipcode
	zipcode::integer,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	(CASE
		WHEN type = 'Job Centers' THEN 'Workforce Development'
		ELSE 'Financial Assistance and Social Services'
	END),
	-- facilitytype
	REPLACE(Type,'HASA','HIV/AIDS Services'),
	-- operatortype
	'Public',
	-- operatorname
	'NYC Human Resources Administration/Department of Social Services',
	-- operatorabbrev
	'NYCHRA/DSS',
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
	hra_facilities_centers;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM hra_facilities_centers
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
	'hra_facilities_centers'
FROM hra_facilities_centers, facilities
WHERE facilities.hash = hra_facilities_centers.hash;

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
    'NYC Human Resources Administration/Department of Social Services',
    'NYCHRA/DSS',
    'City'
FROM hra_facilities_centers, facilities
WHERE facilities.hash = hra_facilities_centers.hash;

-- utilization NA 