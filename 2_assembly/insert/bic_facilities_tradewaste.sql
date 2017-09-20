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
	(CASE
		WHEN (location_1 IS NOT NULL) AND (location_1 LIKE '%(%') THEN 
			ST_SetSRID(
				ST_MakePoint(
					trim(trim(split_part(split_part(location_1,'(',2),',',2),' '),')')::double precision,
					trim(trim(split_part(split_part(location_1,'(',2),',',1),'('),' ')::double precision),
				4326)
	END),
    -- geomsource
    'Agency',
	-- facilityname
	initcap(bus_name),
	-- addressnumber
	initcap(split_part(REPLACE(REPLACE(mailing_office,' - ','-'),' -','-'), ' ', 1)),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(split_part(REPLACE(REPLACE(mailing_office,' - ','-'),' -','-'), '(', 1))), strpos(trim(both ' ' from initcap(split_part(REPLACE(REPLACE(mailing_office,' - ','-'),' -','-'), '(', 1))), ' ')+1, (length(trim(both ' ' from initcap(split_part(REPLACE(REPLACE(mailing_office,' - ','-'),' -','-'), '(', 1))))-strpos(trim(both ' ' from initcap(split_part(REPLACE(REPLACE(mailing_office,' - ','-'),' -','-'), '(', 1))), ' ')))),
        -- address
	initcap(split_part(REPLACE(REPLACE(mailing_office,' - ','-'),' -','-'), '(', 1)),
	-- borough
	NULL,
	-- zipcode
	NULL,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	'Solid Waste Transfer and Carting',
	-- facilitytype
	'Trade Waste Carter Site',
	-- operatortype
	'Non-public',
	-- operatorname
	initcap(bus_name),
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
FROM
	bic_facilities_tradewaste;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM bic_facilities_tradewaste
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
	'bic_facilities_tradewaste'
FROM bic_facilities_tradewaste, facilities
WHERE facilities.hash = bic_facilities_tradewaste.hash;

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
    'NYC Business Integrity Commission',
    'NYCBIC',
    'City'
FROM bic_facilities_tradewaste, facilities
WHERE facilities.hash = bic_facilities_tradewaste.hash;

-- utilization NA