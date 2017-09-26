DROP VIEW nysparks_facilities_parks_facdbview;
CREATE VIEW nysparks_facilities_parks_facdbview AS
SELECT * FROM nysparks_facilities_parks
WHERE
	county = 'New York'
	OR county = 'Bronx'
	OR county = 'Kings'
	OR county = 'Queens'
	OR county = 'Richmond';

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
	ST_SetSRID(ST_MakePoint(longitude, latitude),4326),
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
	(CASE
		WHEN county = 'New York' THEN 'Manhattan'
		WHEN county = 'Kings' THEN 'Brooklyn'
		WHEN county = 'Richmond' THEN 'Staten Island'
		ELSE county
	END),
	-- zipcode
	NULL,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	(CASE
		WHEN category LIKE '%Preserve%' THEN 'Preserves and Conservation Areas'
		ELSE 'Parks'
	END),
	-- facilitytype
	category,
	-- operatortype
	'Public',
	-- operatorname
	'NYS Office of Parks, Recreation and Historic Preservation',
	-- operatorabbrev
	'NYSOPRHP',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
	TRUE,
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
FROM nysparks_facilities_parks_facdbview;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM nysparks_facilities_parks_facdbview
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
	'nysparks_facilities_parks'
FROM nysparks_facilities_parks_facdbview, facilities
WHERE facilities.hash = nysparks_facilities_parks_facdbview.hash;

-- agency id NA

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
    'NYS Office of Parks, Recreation and Historic Preservation',
    'NYSOPRHP',
    'State'
FROM nysparks_facilities_parks, facilities
WHERE facilities.hash = nysparks_facilities_parks.hash;

-- utilization NA