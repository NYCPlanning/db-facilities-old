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
	ST_SetSRID(ST_MakePoint(longitude::numeric, latitude::numeric),4326),
    -- geomsource
    'Agency',
	-- facilityname
	name,
	-- addressnumber
	housenumber,
	-- streetname
	street,
	-- address
	CONCAT(housenumber, ' ', street),
	-- borough
	borough,
	-- zipcode
	postcode::integer,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	'Workforce Development',
	-- facilitytype
	location_type,
	-- operatortype
	'Public',
	-- operatorname
	'NYC Department of Small Business Services',
	-- operatorabbrev
	'NYCSBS',
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
	TRUE,
	-- homeless
	FALSE,
	-- immigrants
	FALSE,
	-- groupquarters
	FALSE
FROM 
	sbs_facilities_workforce1;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM sbs_facilities_workforce1
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
	'sbs_facilities_workforce1'
FROM sbs_facilities_workforce1, facilities
WHERE facilities.hash = sbs_facilities_workforce1.hash;

-- agency id NA

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
FROM sbs_facilities_workforce1, facilities
WHERE facilities.hash = sbs_facilities_workforce1.hash;

-- bin
INSERT INTO
facdb_bin(
	uid,
	bin
)
SELECT
	uid,
	bin
FROM sbs_facilities_workforce1, facilities
WHERE facilities.hash = sbs_facilities_workforce1.hash;

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
    'NYC Department of Small Business Services',
    'NYCSBS',
    'City'
FROM sbs_facilities_workforce1, facilities
WHERE facilities.hash = sbs_facilities_workforce1.hash;

-- utilization