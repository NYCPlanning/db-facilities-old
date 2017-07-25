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
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- borough
	NULL,
	-- zipcode
	NULL,
	-- domain
	'Core Infrastructure and Transportation',
	-- facilitygroup
	'Transportation',
	-- facilitysubgroup
	'Ports and Ferry Landings',
	-- facilitytype
	'Ferry Terminal or Landing',
	-- operatortype
	'Public',
	-- operatorname
	(CASE
		WHEN owners = 'FTA' THEN 'Federal Transit Administration'
		WHEN owners = 'EDC' THEN 'NYC Economic Development Corporation'
		ELSE 'NYC Department of Transportation'
	END),
	-- operatorabbrev
	(CASE
		WHEN owners = 'FTA' THEN 'FTA'
		WHEN owners = 'EDC' THEN 'NYCEDC'
		ELSE 'NYCDOT'
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
	FALSE
FROM
	dot_facilities_ferryterminalslandings;

-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dot_facilities_ferryterminalslandings
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
	'dot_facilities_ferryterminalslandings'
FROM dot_facilities_ferryterminalslandings, facilities
WHERE facilities.hash = dot_facilities_ferryterminalslandings.hash;

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
--FROM dot_facilities_ferryterminalslandings, facilities
--WHERE facilities.hash = dot_facilities_ferryterminalslandings.hash;
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
--FROM dot_facilities_ferryterminalslandings, facilities
--WHERE facilities.hash = dot_facilities_ferryterminalslandings.hash;

-- INSERT INTO
-- facdb_bbl(
-- 	uid,
-- 	bbl
-- )
-- SELECT
-- 	uid,

-- FROM dot_facilities_ferryterminalslandings, facilities
-- WHERE facilities.hash = dot_facilities_ferryterminalslandings.hash;

-- INSERT INTO
-- facdb_bin(
-- 	uid,
-- 	bin
-- )
-- SELECT
-- 	uid,

-- FROM dot_facilities_ferryterminalslandings, facilities
-- WHERE facilities.hash = dot_facilities_ferryterminalslandings.hash;

-- INSERT INTO
-- facdb_capacity(
--   uid,
--   capacity,
--   capacitytype
-- )
-- SELECT
-- 	uid,

-- FROM dot_facilities_ferryterminalslandings, facilities
-- WHERE facilities.hash = dot_facilities_ferryterminalslandings.hash;

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
	'NYC Department of Transportation',
	-- oversightabbrev
	'NYCDOT',
    'City'
FROM dot_facilities_ferryterminalslandings, facilities
WHERE facilities.hash = dot_facilities_ferryterminalslandings.hash;

--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid,
--
--FROM dot_facilities_ferryterminalslandings, facilities
--WHERE facilities.hash = dot_facilities_ferryterminalslandings.hash;
--