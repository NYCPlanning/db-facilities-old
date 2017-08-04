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
		WHEN (Location_1 IS NOT NULL) AND (Location_1 LIKE '%(%') THEN 
			ST_SetSRID(
				ST_MakePoint(
					trim(trim(split_part(split_part(Location_1,'(',2),',',2),' '),')')::double precision,
					trim(trim(split_part(split_part(Location_1,'(',2),',',1),'('),' ')::double precision),
				4326)
	END),
    -- geomsource
    'Agency',
	-- facilityname
	initcap(BUS_NAME),
	-- addressnumber
	initcap(split_part(REPLACE(REPLACE(Mailing_Office,' - ','-'),' -','-'), ' ', 1)),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(split_part(REPLACE(REPLACE(Mailing_Office,' - ','-'),' -','-'), '(', 1))), strpos(trim(both ' ' from initcap(split_part(REPLACE(REPLACE(Mailing_Office,' - ','-'),' -','-'), '(', 1))), ' ')+1, (length(trim(both ' ' from initcap(split_part(REPLACE(REPLACE(Mailing_Office,' - ','-'),' -','-'), '(', 1))))-strpos(trim(both ' ' from initcap(split_part(REPLACE(REPLACE(Mailing_Office,' - ','-'),' -','-'), '(', 1))), ' ')))),
        -- address
	initcap(split_part(REPLACE(REPLACE(Mailing_Office,' - ','-'),' -','-'), '(', 1)),
	-- borough
	NULL,
	-- zipcode
	NULL,
	-- domain
	'Core Infrastructure and Transportation',
	-- facilitygroup
	'Solid Waste',
	-- facilitysubgroup
	'Solid Waste Transfer and Carting',
	-- facilitytype
	'Trade Waste Carter Site',
	-- operatortype
	'Non-public',
	-- operatorname
	initcap(BUS_NAME),
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

--INSERT INTO
--facdb_agencyid(
--	uid,
--	overabbrev,
--	idagency,
--	idname
--)
--SELECT
--	uid,
--
--FROM bic_facilities_tradewaste, facilities
--WHERE facilities.hash = bic_facilities_tradewaste.hash;
--
--INSERT INTO
--facdb_area(
--	uid,
--	area,
--	areatype
--)
--SELECT
--	uid,
--
--FROM bic_facilities_tradewaste, facilities
--WHERE facilities.hash = bic_facilities_tradewaste.hash;
--
--INSERT INTO
--facdb_bbl(
--	uid,
--	bbl
--)
--SELECT
--	uid,
--
--FROM bic_facilities_tradewaste, facilities
--WHERE facilities.hash = bic_facilities_tradewaste.hash;
--
--INSERT INTO
--facdb_bin(
--	uid,
--	bin
--)
--SELECT
--	uid,
--
--FROM bic_facilities_tradewaste, facilities
--WHERE facilities.hash = bic_facilities_tradewaste.hash;
--
--INSERT INTO
--facdb_capacity(
--   uid,
--   capacity,
--   capacitytype
--)
--SELECT
--	uid,
--
--FROM bic_facilities_tradewaste, facilities
--WHERE facilities.hash = bic_facilities_tradewaste.hash;


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

--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid,
--
--FROM bic_facilities_tradewaste, facilities
--WHERE facilities.hash = bic_facilities_tradewaste.hash;