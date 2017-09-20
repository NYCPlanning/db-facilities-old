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
	ST_SetSRID(ST_MakePoint(longitude_x, latitude_y),4326),
    -- geomsource
    'Agency',
	-- facilityname
	name,
	-- address number
	split_part(trim(both ' ' from address), ' ', 1),
	-- street name
	initcap(trim(both ' ' from substr(trim(both ' ' from address), strpos(trim(both ' ' from address), ' ')+1, (length(trim(both ' ' from address))-strpos(trim(both ' ' from address), ' '))))),
	-- address
	address,
	-- borough
	NULL,
	-- zipcode
	LEFT(zip_code,5)::integer,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	'Soup Kitchens and Food Pantries',
	-- facilitytype
		(CASE
			WHEN fbc_agency_category_code = 'PANTRY' THEN 'Food Pantry'
			WHEN fbc_agency_category_code = 'SOUP KITCH' THEN 'Soup Kitchen'
		END),
	-- operatortype
	'Non-public',
	-- operatorname
	name,
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
	foodbankny_facilities_foodbanks;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM foodbankny_facilities_foodbanks
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
	'foodbankny_facilities_foodbanks'
FROM foodbankny_facilities_foodbanks, facilities
WHERE facilities.hash = foodbankny_facilities_foodbanks.hash;

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
    'Non-public',
    'Non-public',
    'Non-public'
FROM foodbankny_facilities_foodbanks, facilities
WHERE facilities.hash = foodbankny_facilities_foodbanks.hash;

-- utilization NA