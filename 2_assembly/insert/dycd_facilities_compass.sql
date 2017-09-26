DROP VIEW dycd_facilities_compass_facdbview;
CREATE VIEW dycd_facilities_compass_facdbview AS 
SELECT DISTINCT
	hash,
	address_number,
	street_name,
	borough,
	bbls,
	bin,
	x_coordinate,
	y_coordinate,
	provider_name,
	date_source_data_updated
FROM dycd_facilities_compass;


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
	NULL,
    -- geomsource
    'None',
	-- facilityname
	provider_name,
	-- addressnumber
	address_number,
	-- streetname
	initcap(street_name),
	-- address
	CONCAT(address_number,' ',initcap(street_name)),
	-- borough
	initcap(borough),
	-- zipcode
	NULL,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	'Comprehensive After School System (COMPASS) Sites',
	-- facilitytype
	'COMPASS Program',
	-- operatortype
	'Non-public',
	-- operatorname
	provider_name,
	-- operatorabbrev
	'Non-public',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
	FALSE,
	-- youth
	TRUE,
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
FROM dycd_facilities_compass_facdbview;


-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dycd_facilities_compass_facdbview
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
	'dycd_facilities_compass'
FROM dycd_facilities_compass_facdbview, facilities
WHERE facilities.hash = dycd_facilities_compass_facdbview.hash;

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
    'NYC Department of Youth and Community Development',
    'NYCDYCD',
    'City'
FROM dycd_facilities_compass, facilities
WHERE facilities.hash = dycd_facilities_compass.hash;

-- utilization NA
