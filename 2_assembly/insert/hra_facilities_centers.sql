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
	split_part(trim(both ' ' from Address), ' ', 1),
	-- streetname
	initcap(split_part(trim(both ' ' from Address), ' ', 2)),
	-- address
	initcap(Address),
	-- borough
	initcap(Borough),
	-- zipcode
	zipcode::integer,
	-- domain
	'Health and Human Services',
	-- facilitygroup
	'Human Services',
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
--FROM hra_facilities_centers, facilities
--WHERE facilities.hash = hra_facilities_centers.hash;
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
--FROM hra_facilities_centers, facilities
--WHERE facilities.hash = hra_facilities_centers.hash;
--
--INSERT INTO
--facdb_bbl(
--	uid,
--	bbl
--)
--SELECT
--	uid,
--
--FROM hra_facilities_centers, facilities
--WHERE facilities.hash = hra_facilities_centers.hash;
--
--INSERT INTO
--facdb_bin(
--	uid,
--	bin
--)
--SELECT
--	uid,
--
--FROM hra_facilities_centers, facilities
--WHERE facilities.hash = hra_facilities_centers.hash;
--
--INSERT INTO
--facdb_capacity(
--   uid,
--   capacity,
--   capacitytype
--)
--SELECT
--	uid,
--
--FROM hra_facilities_centers, facilities
--WHERE facilities.hash = hra_facilities_centers.hash;


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


--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid,
--
--FROM hra_facilities_centers, facilities
--WHERE facilities.hash = hra_facilities_centers.hash;