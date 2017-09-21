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
    NULL
	-- geom
	ST_SetSRID(ST_MakePoint(lon, lat),4326),
    -- geomsource
    'Agency',
	-- facilityname
	split_part(name,' - ',1),
	-- addressnumber
	housenum,
	-- streetname
	initcap(streetname),
	-- address
	CONCAT(housenum,' ',initcap(streetname)),
	-- borough
	boroname,
	-- zipcode
	ROUND(zip::numeric,0),
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	'Public Libraries',
	-- facilitytype
	'Public Libraries',
	-- operatortype
	'Non-public',
	-- operatorname
	(CASE
		WHEN system = 'QPL' THEN 'Queens Public Library'
		WHEN system = 'BPL' THEN 'Brooklyn Public Library'
		WHEN system = 'NYPL' THEN 'New York Public Library'
	END),
	-- operatorabbrev
	system,
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
	omb_facilities_libraryvisits;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM omb_facilities_libraryvisits
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
	'omb_facilities_libraryvisits'
FROM omb_facilities_libraryvisits, facilities
WHERE facilities.hash = omb_facilities_libraryvisits.hash;

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
	(CASE
		WHEN system = 'QPL' THEN 'Queens Public Library'
		WHEN system = 'BPL' THEN 'Brooklyn Public Library'
		WHEN system = 'NYPL' THEN 'New York Public Library'
	END),
	system,
    'City'
FROM omb_facilities_libraryvisits, facilities
WHERE facilities.hash = omb_facilities_libraryvisits.hash;

-- utilization
INSERT INTO
facdb_utilization(
	uid,
	util,
	utiltype
)
SELECT
	uid,
	visits::text,
	'Visits'
FROM omb_facilities_libraryvisits, facilities
WHERE facilities.hash = omb_facilities_libraryvisits.hash;