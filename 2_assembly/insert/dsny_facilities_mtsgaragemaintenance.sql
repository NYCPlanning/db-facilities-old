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
			WHEN facility_t = 'GARAGE' THEN CONCAT(facility_n,' ',facility_t)
			WHEN facility_t <> 'GARAGE' THEN CONCAT(facility_n)
		END),
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- borough
	initcap(geo_boro),
	-- zipcode
	NULL,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	'Solid Waste Transfer and Carting',
	-- facilitytype
		(CASE
			WHEN facility_t = 'MTS' THEN 'DSNY Marine Transfer Station'
			WHEN facility_t = 'GARAGE' THEN 'DSNY Garage'
			WHEN facility_t = 'REPAIR' THEN 'DSNY Repair Facility'
		END),
	-- operatortype
	'Public',
	-- operatorname
	'NYC Department of Sanitation',
	-- operatorabbrev
	'NYCDSNY',
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
	dsny_facilities_mtsgaragemaintenance;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dsny_facilities_mtsgaragemaintenance
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
	'dsny_facilities_mtsgaragemaintenance'
FROM dsny_facilities_mtsgaragemaintenance, facilities
WHERE facilities.hash = dsny_facilities_mtsgaragemaintenance.hash;

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
	'NA',
	gid,
	'gid'
FROM dsny_facilities_mtsgaragemaintenance, facilities
WHERE facilities.hash = dsny_facilities_mtsgaragemaintenance.hash;

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
    'NYC Department of Sanitation',
    'NYCDSNY',
    'City'
FROM dsny_facilities_mtsgaragemaintenance, facilities
WHERE facilities.hash = dsny_facilities_mtsgaragemaintenance.hash;

-- utilization NA