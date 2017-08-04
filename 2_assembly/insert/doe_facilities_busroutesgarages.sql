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
	ST_Transform(ST_SetSRID(ST_MakePoint(XCoordinates, YCoordinates),2263),4326),
    -- geomsource
    'Agency',
	-- facilityname
	initcap(Vendor_Name),
	-- addressnumber
	split_part(trim(both ' ' from Garage_Street_Address), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from Garage_Street_Address), strpos(trim(both ' ' from Garage_Street_Address), ' ')+1, (length(trim(both ' ' from Garage_Street_Address))-strpos(trim(both ' ' from Garage_Street_Address), ' ')))),
	-- address
	Garage_Street_Address,
	-- borough
	NULL,
	-- zipcode
	Garage_Zip::integer,
	-- domain
	'Core Infrastructure and Transportation',
	-- facilitygroup
	'Transportation',
	-- facilitysubgroup
	'Bus Depots and Terminals',
	-- facilitytype
	'School Bus Depot',
	-- operatortype
	'Non-public',
	-- operatorname
	initcap(Vendor_Name),
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
	doe_facilities_busroutesgarages
GROUP BY
	hash,
	Vendor_Name,
	Garage_Street_Address,
	Garage_City,
	Garage_Zip,
	XCoordinates,
	YCoordinates;

-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM doe_facilities_busroutesgarages
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
)
GROUP BY
	hash,
	Vendor_Name,
	Garage_Street_Address,
	Garage_City,
	Garage_Zip,
	XCoordinates,
	YCoordinates
;
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
	'doe_facilities_busroutesgarages'
FROM doe_facilities_busroutesgarages, facilities
WHERE facilities.hash = doe_facilities_busroutesgarages.hash
GROUP BY
	facilities.uid,
        doe_facilities_busroutesgarages.hash,
	Vendor_Name,
	Garage_Street_Address,
	Garage_City,
	Garage_Zip,
	XCoordinates,
	YCoordinates;


-- INSERT INTO
-- facdb_agencyid(
-- 	uid,
-- 	overabbrev,
-- 	idagency,
-- 	idname
-- )
-- SELECT
-- 	uid,

-- FROM doe_facilities_busroutesgarages, facilities
-- WHERE facilities.hash = doe_facilities_busroutesgarages.hash;

--INSERT INTO
--facdb_area(
--	uid,
--	area,
--	areatype
--)
--SELECT
--	uid,
--
--FROM doe_facilities_busroutesgarages, facilities
--WHERE facilities.hash = doe_facilities_busroutesgarages.hash;
--
--INSERT INTO
--facdb_bbl(
--	uid,
--	bbl
--)
--SELECT
--	uid,
--
--FROM doe_facilities_busroutesgarages, facilities
--WHERE facilities.hash = doe_facilities_busroutesgarages.hash;
--
--INSERT INTO
--facdb_bin(
--	uid,
--	bin
--)
--SELECT
--	uid,
--
--FROM doe_facilities_busroutesgarages, facilities
--WHERE facilities.hash = doe_facilities_busroutesgarages.hash;
--
-- INSERT INTO
-- facdb_capacity(
--   uid,
--   capacity,
--   capacitytype
-- )
-- SELECT
-- 	uid,


-- FROM doe_facilities_busroutesgarages, facilities
-- WHERE facilities.hash = doe_facilities_busroutesgarages.hash;


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
	Vendor_Name,
	Garage_Street_Address,
	Garage_City,
	Garage_Zip,
	XCoordinates,
	YCoordinates
;

--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid,
--
--FROM doe_facilities_busroutesgarages, facilities
--WHERE facilities.hash = doe_facilities_busroutesgarages.hash;
--

