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
	name,
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
	'Ports and Ferry Landings',
	-- facilitytype
	'Ferry Terminal or Landing',
	-- operatortype
	'Public',
	-- operatorname
	(CASE
		WHEN owners = 'FTA' THEN 'Federal Transit Administration'
		WHEN owners = 'EDC' THEN 'NYC Economic Development Corporation'
		ELSE 'NYC Department of Transportation'
	END),
	-- operatorabbrev
	(CASE
		WHEN owners = 'FTA' THEN 'FTA'
		WHEN owners = 'EDC' THEN 'NYCEDC'
		ELSE 'NYCDOT'
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
	dot_facilities_ferryterminalslandings;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dot_facilities_ferryterminalslandings
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
	'dot_facilities_ferryterminalslandings'
FROM dot_facilities_ferryterminalslandings, facilities
WHERE facilities.hash = dot_facilities_ferryterminalslandings.hash;

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
	id,
	'id',
	'id',
	'dot_facilities_ferryterminalslandings'
FROM dot_facilities_ferryterminalslandings, facilities
WHERE facilities.hash = dot_facilities_ferryterminalslandings.hash;

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
	'NYC Department of Transportation',
	'NYCDOT',
    'City'
FROM dot_facilities_ferryterminalslandings, facilities
WHERE facilities.hash = dot_facilities_ferryterminalslandings.hash;

-- utilization NA 