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
	initcap(locationname),
	-- addressnumber 
	split_part(primaryaddress,' ',1),
	-- streetname
	initcap(trim(both ' ' from substr(trim(both ' ' from primaryaddress), strpos(trim(both ' ' from primaryaddress), ' ')+1, (length(trim(both ' ' from primaryaddress))-strpos(trim(both ' ' from primaryaddress), ' '))))),
	-- address
	initcap(primaryaddress),
	-- borough
		(CASE
			WHEN LEFT(locationcode,1) = 'M' THEN 'Manhattan'
			WHEN LEFT(locationcode,1) = 'X' THEN 'Bronx'
			WHEN LEFT(locationcode,1) = 'K' THEN 'Brooklyn'
			WHEN LEFT(locationcode,1) = 'Q' THEN 'Queens'
			WHEN LEFT(locationcode,1) = 'R' THEN 'Staten Island'
		END),
	-- zipcode
	zip::integer,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
		(CASE
			WHEN locationtypedescription LIKE '%Special%' THEN 'Public and Private Special Education Schools'
			WHEN locationcategorydescription LIKE '%Early%' OR locationcategorydescription LIKE '%Pre-K%' THEN 'DOE Universal Pre-Kindergarten'
			WHEN managedbyname = 'Charter' THEN 'Charter K-12 Schools'
			ELSE 'Public K-12 Schools'
		END),
	-- facilitytype
		(CASE
			WHEN managedbyname = 'Charter' AND lower(locationcategorydescription) LIKE '%school%' THEN CONCAT(locationcategorydescription, ' - Charter')
			WHEN managedbyname = 'Charter' THEN CONCAT(locationcategorydescription, ' School - Charter')
			WHEN lower(locationcategorydescription) LIKE '%school%' THEN CONCAT(locationcategorydescription, ' - Public')
			ELSE CONCAT(locationcategorydescription, ' School - Public')
		END),
	-- operatortype
		(CASE
			WHEN managedbyname = 'Charter' THEN 'Non-public'
			ELSE 'Public'
		END),
	-- operatorname
		(CASE
			WHEN managedbyname = 'Charter' THEN locationname
			ELSE 'NYC Department of Education'
		END),
	-- operator abbrev
		(CASE
			WHEN managedbyname = 'Charter' THEN 'Non-public'
			ELSE 'NYCDOE'
		END),
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
		(CASE
			WHEN locationcategorydescription LIKE '%Pre-K%' OR locationcategorydescription LIKE '%Elementary%' OR locationcategorydescription LIKE '%Early%' OR locationcategorydescription LIKE '%K-%' THEN TRUE
			ELSE FALSE
		END),
	-- youth
		(CASE
			WHEN locationcategorydescription LIKE '%High%' OR locationcategorydescription LIKE '%Secondary%' OR locationcategorydescription LIKE '%K-12%' THEN TRUE
			ELSE FALSE
		END),
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
	doe_facilities_lcgms;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM doe_facilities_lcgms
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
	'doe_facilities_lcgms'
FROM doe_facilities_lcgms, facilities
WHERE facilities.hash = doe_facilities_lcgms.hash;

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
	'NYCDOE',
	locationcode,
	'DOE Location Code'
FROM doe_facilities_lcgms, facilities
WHERE facilities.hash = doe_facilities_lcgms.hash;

INSERT INTO
facdb_agencyid(
	uid,
	overabbrev,
	idagency,
	idname
)
SELECT
	uid,
	'NYCDOE',
	buildingcode,
	'DOE Building Code'
FROM doe_facilities_lcgms, facilities
WHERE facilities.hash = doe_facilities_lcgms.hash;

-- area NA

-- bbl
INSERT INTO
facdb_bbl(
	uid,
	bbl
)
SELECT
	uid,
	(CASE
		WHEN boroughblocklot <> '0' THEN boroughblocklot
	END)
FROM doe_facilities_lcgms, facilities
WHERE facilities.hash = doe_facilities_lcgms.hash;

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
    'NYC Department of Education',
    'NYCDOE',
    'City'
FROM doe_facilities_lcgms, facilities
WHERE facilities.hash = doe_facilities_lcgms.hash;

-- utilization NA 
--