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
			WHEN county = 'NEW YORK' THEN 'Manhattan'
			WHEN county = 'BRONX' THEN 'Bronx'
			WHEN county = 'KINGS' THEN 'Brooklyn'
			WHEN county = 'QUEENS' THEN 'Queens'
			WHEN county = 'RICHMOND' THEN 'Staten Island'
		END),
	-- zipcode
	NULL,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
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

-- facdb_uid_key
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

-- pgtable
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

-- agency id
INSERT INTO
facdb_agencyid(
	uid,
	idagency,
	idname,
	idfield,
	idtable
)
SELECT
	uid,
	gid,
	'Global ID',
	'gid',
	'nysdec_facilities_lands'
FROM nysdec_facilities_lands, facilities
WHERE facilities.hash = nysdec_facilities_lands.hash;

-- area
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
    'NYC Business Integrity Commission',
    'NYCBIC',
    'City'
FROM nysdec_facilities_lands, facilities
WHERE facilities.hash = nysdec_facilities_lands.hash;

-- utilization NA 