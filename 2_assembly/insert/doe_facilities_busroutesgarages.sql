DROP VIEW doe_facilities_busroutesgarages_facdbview;
CREATE VIEW doe_facilities_busroutesgarages_facdbview AS 
SELECT DISTINCT
	hash,
	vendor_name,
	garage_street_address,
	garage_city,
	garage_zip,
	xcoordinates,
	ycoordinates
FROM doe_facilities_busroutesgarages;

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
	ST_Transform(ST_SetSRID(ST_MakePoint(xcoordinates, ycoordinates),2263),4326),
    -- geomsource
    'Agency',
	-- facilityname
	initcap(vendor_name),
	-- addressnumber
	split_part(trim(both ' ' from garage_street_address), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from garage_street_address), strpos(trim(both ' ' from garage_street_address), ' ')+1, (length(trim(both ' ' from garage_street_address))-strpos(trim(both ' ' from garage_street_address), ' ')))),
	-- address
	garage_street_address,
	-- borough
	NULL,
	-- zipcode
	garage_zip::integer,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	'Bus Depots and Terminals',
	-- facilitytype
	'School Bus Depot',
	-- operatortype
	'Non-public',
	-- operatorname
	initcap(vendor_name),
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
FROM doe_facilities_busroutesgarages_facdbview;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM doe_facilities_busroutesgarages_facdbview
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
	'doe_facilities_busroutesgarages'
FROM doe_facilities_busroutesgarages_facdbview, facilities
WHERE facilities.hash = doe_facilities_busroutesgarages_facdbview.hash;

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
    'NYC Department of Education',
    'NYCDOE',
    'City'
FROM doe_facilities_busroutesgarages, facilities
WHERE facilities.hash = doe_facilities_busroutesgarages.hash
GROUP BY
        facilities.uid,
	doe_facilities_busroutesgarages.hash,
	vendor_name,
	garage_street_address,
	garage_city,
	garage_zip,
	xcoordinates,
	ycoordinates;

-- utilization NA

