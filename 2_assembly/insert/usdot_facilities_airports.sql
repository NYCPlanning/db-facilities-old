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
	geom,
    -- geomsource
    'Agency',
	-- facilityname
	fullname,
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- borough
	(CASE
		WHEN (stateabbv = 'NY') AND (county = 'New York') THEN 'Manhattan'
		WHEN (stateabbv = 'NY') AND (county = 'Kings') THEN 'Brooklyn'
		WHEN (stateabbv = 'NY') AND (county = 'Richmond') THEN 'Staten Island'
		ELSE county
	END),
	-- zipcode
	NULL,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	'Airports and Heliports',
	-- facilitytype
	facilityty,
	-- operatortype
		(CASE
			WHEN ownertype = 'Pr' THEN 'Non-public'
			ELSE 'Public'
		END),
	-- operatorname
		(CASE
			WHEN ownertype = 'Pr' THEN fullname
			ELSE 'Public'
		END),
	-- operator abbrev
		(CASE
			WHEN ownertype = 'Pr' THEN 'Non-public'
			ELSE 'Public'
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
	usdot_facilities_airports
WHERE
	stateabbv = 'NY' 
	AND (county = 'New York'
	OR county = 'Bronx'
	OR county = 'Kings'
	OR county = 'Queens'
	OR county = 'Richmond');

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM usdot_facilities_airports
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key)
AND stateabbv = 'NY' 
	AND (county = 'New York'
	OR county = 'Bronx'
	OR county = 'Kings'
	OR county = 'Queens'
	OR county = 'Richmond');
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
	'usdot_facilities_airports'
FROM usdot_facilities_airports, facilities
WHERE facilities.hash = usdot_facilities_airports.hash;

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
	locationid,
	'locationid'
FROM usdot_facilities_airports, facilities
WHERE facilities.hash = usdot_facilities_airports.hash;

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
FROM usdot_facilities_airports, facilities
WHERE facilities.hash = usdot_facilities_airports.hash;

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
    'US Department of Transportation',
    'USDOT',
    'Federal'
FROM usdot_facilities_airports, facilities
WHERE facilities.hash = usdot_facilities_airports.hash;

-- utilization NA