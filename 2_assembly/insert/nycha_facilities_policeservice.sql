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
	initcap(development_name),
	-- addressnumber
	split_part(trim(both ' ' from address), ' ', 1),
	-- streetname
	initcap(trim(both ' ' from substr(trim(both ' ' from address), strpos(trim(both ' ' from address), ' ')+1, (length(trim(both ' ' from address))-strpos(trim(both ' ' from address), ' '))))),
	-- address
	initcap(address),
	-- borough
	initcap(borough),
	-- zipcode
	ROUND(zip_code::numeric,0),
	-- domain
	'Public Safety, Emergency Services, and Administration of Justice',
	-- facilitygroup
	'Public Safety',
	-- facilitysubgroup
	'Police Services',
	-- facilitytype
	'NYCHA Community Center',
	-- operatortype
	'Public',
	-- operatorname
	'New York City Housing Authority',
	-- operatorabbrev
	'NYCHA',
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
	nycha_facilities_communitycenters;

-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM nycha_facilities_communitycenters
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
	'nycha_facilities_communitycenters'
FROM nycha_facilities_communitycenters, facilities
WHERE facilities.hash = nycha_facilities_communitycenters.hash;

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
--FROM nycha_facilities_communitycenters, facilities
--WHERE facilities.hash = nycha_facilities_communitycenters.hash;
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
--FROM nycha_facilities_communitycenters, facilities
--WHERE facilities.hash = nycha_facilities_communitycenters.hash;
--
--INSERT INTO
--facdb_bbl(
--	uid,
--	bbl
--)
--SELECT
--	uid,
--
--FROM nycha_facilities_communitycenters, facilities
--WHERE facilities.hash = nycha_facilities_communitycenters.hash;
--
--INSERT INTO
--facdb_bin(
--	uid,
--	bin
--)
--SELECT
--	uid,
--
--FROM nycha_facilities_communitycenters, facilities
--WHERE facilities.hash = nycha_facilities_communitycenters.hash;
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
--FROM nycha_facilities_communitycenters, facilities
--WHERE facilities.hash = nycha_facilities_communitycenters.hash;


INSERT INTO
facdb_oversight(
	uid,
	overagency,
	overabbrev,
	overlevel
)
SELECT
	uid,
    'New York City Housing Authority',
    'NYCHA',
    'City'
FROM nycha_facilities_communitycenters, facilities
WHERE facilities.hash = nycha_facilities_communitycenters.hash;

--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid,
--
--FROM nycha_facilities_communitycenters, facilities
--WHERE facilities.hash = nycha_facilities_communitycenters.hash;