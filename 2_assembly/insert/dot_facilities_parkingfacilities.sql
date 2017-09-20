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
	(CASE
		WHEN facname IS NOT NULL THEN facname
		ELSE 'Parking Lot'
	END),
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
	(CASE
		WHEN operations = 'Public Parking Garage' THEN 'Parking Lots and Garages'
		ELSE 'City Agency Parking'
	END),
	-- facilitytype
	(CASE
		WHEN operations = 'Public Parking Garage' THEN 'Public Parking Garage'
		ELSE 'City Agency Parking'
	END),
	-- operatortype
	'Public',
	-- operatorname
	'NYC Department of Transportation',
	-- operatorabbrev
	'NYCDOT',
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
	dot_facilities_parkingfacilities;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dot_facilities_parkingfacilities
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
	'dot_facilities_parkingfacilities'
FROM dot_facilities_parkingfacilities, facilities
WHERE facilities.hash = dot_facilities_parkingfacilities.hash;

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
	'DOT',
	gid,
	'gid'
FROM dot_facilities_parkingfacilities, facilities
WHERE facilities.hash = dot_facilities_parkingfacilities.hash;

-- area NA

-- bbl
INSERT INTO
facdb_bbl(
	uid,
	bbl
)
SELECT
	uid,
	bbl
FROM dot_facilities_parkingfacilities, facilities
WHERE facilities.hash = dot_facilities_parkingfacilities.hash;

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
	'NYC Department of Transportation',
	'NYCDOT',
    'City'
FROM dot_facilities_parkingfacilities, facilities
WHERE facilities.hash = dot_facilities_parkingfacilities.hash;

-- utilization NA 