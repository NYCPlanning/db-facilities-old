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
	geom,
    -- geomsource
    'Agency',
	-- facilityname
	name,
	-- addressnumber
	housenum,
	-- streetname
	streetname,
	-- address
	CONCAT(housenum,' ',streetname),
	-- borough
		(CASE
			WHEN system = 'BPL' THEN 'Brooklyn'
			WHEN system = 'QPL' THEN 'Queens'
			WHEN city = 'New York' THEN 'New York'
			WHEN city = 'Bronx' THEN 'Bronx'
			WHEN city = 'Staten Island' THEN 'Staten Island'
		END),
	-- zipcode
	zip,
	-- domain
	'Libraries and Cultural Programs',
	-- facilitygroup
	'Libraries',
	-- facilitysubgroup
	'Public Libraries',
	-- facilitytype
	'Public Library',
	-- operatortype
	'Non-public',
	-- operatorname
		(CASE
			WHEN system = 'QPL' THEN 'Queens Public Libraries'
			WHEN system = 'BPL' THEN 'Brooklyn Public Libraries'
			WHEN system = 'NYPL' THEN 'New York Public Libraries'
		END),
	-- operatorabbrev
	system,
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
	doitt_facilities_libraries;

-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM doitt_facilities_libraries
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
);
-- JOIN uid FROM KEY ONTO DATABASE
UPDATE facilities AS f
SET uid = k.uid
FROM facdb_uid_key AS k
WHERE k.hash = f.hash AND
      f.uid IS NULL;

INSERT INTO
facdb_pgtable(
   uid,
   pgtable
)
SELECT
	uid,
	'doitt_facilities_libraries'
FROM doitt_facilities_libraries, facilities
WHERE facilities.hash = doitt_facilities_libraries.hash;

--INSERT INTO
--facdb_agencyid(
--	uid,
--	overabbrev,
--	idagency,
--	idname
--)
--SELECT
--	uid,
--
--FROM doitt_facilities_libraries, facilities
--WHERE facilities.hash = doitt_facilities_libraries.hash;
--
--INSERT INTO
--facdb_area(
--	uid,
--	area,
--	areatype
--)
--SELECT
--	uid,
--
--FROM doitt_facilities_libraries, facilities
--WHERE facilities.hash = doitt_facilities_libraries.hash;

INSERT INTO
facdb_bbl(
	uid,
	bbl
)
SELECT
	uid,
	bbl
FROM doitt_facilities_libraries, facilities
WHERE facilities.hash = doitt_facilities_libraries.hash;

INSERT INTO
facdb_bin(
	uid,
	bin
)
SELECT
	uid,
	ROUND(bin,0)
FROM doitt_facilities_libraries, facilities
WHERE facilities.hash = doitt_facilities_libraries.hash;

-- INSERT INTO
-- facdb_capacity(
--   uid,
--   capacity,
--   capacitytype
-- )
-- SELECT
-- 	uid,

-- FROM doitt_facilities_libraries, facilities
-- WHERE facilities.hash = doitt_facilities_libraries.hash;

INSERT INTO
facdb_oversight(
	uid,
	overagency,
	overabbrev,
	overlevel
)
SELECT
	uid,
	-- oversightagency
	(CASE
		WHEN system = 'QPL' THEN 'Queens Public Libraries'
		WHEN system = 'BPL' THEN 'Brooklyn Public Libraries'
		WHEN system = 'NYPL' THEN 'New York Public Libraries'
	END),
	-- oversightabbrev
	system,
    'Non-public'
FROM doitt_facilities_libraries, facilities
WHERE facilities.hash = doitt_facilities_libraries.hash;

--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid,
--
--FROM doitt_facilities_libraries, facilities
--WHERE facilities.hash = doitt_facilities_libraries.hash;
--