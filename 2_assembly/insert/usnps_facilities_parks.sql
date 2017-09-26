DROP VIEW usnps_facilities_parks_facdbview;
CREATE VIEW usnps_facilities_parks_facdbview AS
SELECT * FROM usnps_facilities_parks
WHERE
	state = 'NY'
	AND unit_code <> 'GATE'
	AND unit_code <> 'FIIS';

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
    NULL,
	-- geom
	ST_Centroid(geom),
    -- geomsource
    'Agency',
	-- facilityname
	unit_name,
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
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	'Historical Sites',
	-- facilitytype
	unit_type,
	-- operatortype
	'Public',
	-- operatorname
	'National Park Service',
	-- operatorabbrev
	'USNPS',
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
FROM usnps_facilities_parks_facdbview;


-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM usnps_facilities_parks_facdbview
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key);
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
	'usnps_facilities_parks'
FROM usnps_facilities_parks, facilities
WHERE facilities.hash = usnps_facilities_parks.hash;

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
	unit_code,
	'Unit Code',
	'unit_code',
	'usnps_facilities_parks'
FROM usnps_facilities_parks, facilities
WHERE facilities.hash = usnps_facilities_parks.hash;

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
    'National Park Service',
    'USNPS',
    'Federal'
FROM usnps_facilities_parks, facilities
WHERE facilities.hash = usnps_facilities_parks.hash;

-- utilization NA