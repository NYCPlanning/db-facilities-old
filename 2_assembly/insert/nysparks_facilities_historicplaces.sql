DROP VIEW nysparks_facilities_historicplaces_facdbview;
CREATE VIEW nysparks_facilities_historicplaces_facdbview AS 
SELECT DISTINCT 
	hash,
	Resource_Name,
	County,
	National_Register_Date,
	National_Register_Number,
	Longitude,
	Latitude,
	Location
FROM nysparks_facilities_historicplaces
WHERE
	Resource_Name NOT LIKE '%Historic District%'
	AND (County = 'New York'
	OR County = 'Bronx'
	OR County = 'Kings'
	OR County = 'Queens'
	OR County = 'Richmond');

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
	resource_name,
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
	'Historical Sites',
	-- facilitytype
	'State Historic Place',
	-- operatortype
	'Non-public',
	-- operatorname
	'Not Available',
	-- operatorabbrev
	'Non-public',
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
FROM nysparks_facilities_historicplaces_facdbview;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM nysparks_facilities_historicplaces_facdbview
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
	'nysparks_facilities_historicplaces'
FROM nysparks_facilities_historicplaces_facdbview, facilities
WHERE facilities.hash = nysparks_facilities_historicplaces_facdbview.hash;

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
	National_Register_Number,
	'National Register Number',
	'National_Register_Number',
	'nysparks_facilities_historicplaces'
FROM nysparks_facilities_historicplaces, facilities
WHERE facilities.hash = nysparks_facilities_historicplaces.hash;

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
FROM nysparks_facilities_historicplaces, facilities
WHERE facilities.hash = nysparks_facilities_historicplaces.hash;

-- utilization NA