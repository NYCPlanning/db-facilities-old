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
	ST_Centroid(geom),
    -- geomsource
    'Agency',
-- facilityname
	initcap(facility),
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- borough
		(CASE
			WHEN County = 'NEW YORK' THEN 'Manhattan'
			WHEN County = 'BRONX' THEN 'Bronx'
			WHEN County = 'KINGS' THEN 'Brooklyn'
			WHEN County = 'QUEENS' THEN 'Queens'
			WHEN County = 'RICHMOND' THEN 'Staten Island'
		END),
	-- zipcode
	NULL,
	-- domain
	'Parks, Gardens, and Historical Sites',
	-- facilitygroup
	'Parks and Plazas',
	-- facilitysubgroup
	'Preserves and Conservation Areas',
	-- facilitytype
		(CASE
			WHEN category = 'NRA' THEN 'Natural Resource Area'
			ELSE initcap(category)
		END),
	-- operatortype
	'Public',
	-- operatorname
	'NYS Department of Environmental Conservation',
	-- operatorabbrev
	'NYSDEC',
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
	nysdec_facilities_lands;

-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM nysdec_facilities_lands
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
	'nysdec_facilities_lands'
FROM nysdec_facilities_lands, facilities
WHERE facilities.hash = nysdec_facilities_lands.hash;

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
--FROM nysdec_facilities_lands, facilities
--WHERE facilities.hash = nysdec_facilities_lands.hash;

INSERT INTO
facdb_area(
	uid,
	area,
	areatype
)
SELECT
	uid,
	acres,
	'Acres'
FROM nysdec_facilities_lands, facilities
WHERE facilities.hash = nysdec_facilities_lands.hash;

--INSERT INTO
--facdb_bbl(
--	uid,
--	bbl
--)
--SELECT
--	uid,
--
--FROM nysdec_facilities_lands, facilities
--WHERE facilities.hash = nysdec_facilities_lands.hash;
--
--INSERT INTO
--facdb_bin(
--	uid,
--	bin
--)
--SELECT
--	uid,
--
--FROM nysdec_facilities_lands, facilities
--WHERE facilities.hash = nysdec_facilities_lands.hash;
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
--FROM nysdec_facilities_lands, facilities
--WHERE facilities.hash = nysdec_facilities_lands.hash;


INSERT INTO
facdb_oversight(
	uid,
	overagency,
	overabbrev,
	overlevel
)
SELECT
	uid,
    'NYC Business Integrity Commission',
    'NYCBIC',
    'City'
FROM nysdec_facilities_lands, facilities
WHERE facilities.hash = nysdec_facilities_lands.hash;

--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid,
--
--FROM nysdec_facilities_lands, facilities
--WHERE facilities.hash = nysdec_facilities_lands.hash;