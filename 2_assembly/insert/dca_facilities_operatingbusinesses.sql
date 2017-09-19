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
		WHEN longitude IS NOT NULL THEN ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)
		ELSE NULL
	END),
    -- geomsource
    'Agency',
		-- facilityname
	initcap(Business_Name),
	-- addressnumber
	Address_Building,
	-- streetname
	initcap(Address_Street_Name),
	-- address
	CONCAT(Address_Building,' ',initcap(Address_Street_Name)),
	-- borough
		(CASE
			WHEN (Address_Borough IS NULL) AND (Address_City = 'NEW YORK') THEN 'Manhattan'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'BRONX') THEN 'Bronx'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'BROOKLYN') THEN 'Brooklyn'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'QUEENS') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'ASTORIA') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'LONG ISLAND CITY') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'QUEENS VLG') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'JAMAICA') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'WOODSIDE') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'FLUSHING') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'CORONA') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'STATEN ISLAND') THEN 'Staten Island'
			ELSE Address_Borough
		END),
	-- zipcode
		(CASE
			WHEN Address_Zip ~'^([0-9]+\.?[0-9]*|\.[0-9]+)$' THEN Address_Zip::integer
		END),
	-- domain
	'Core Infrastructure and Transportation',
	-- facilitygroup
	NULL,
	-- facilitysubgroup
		(CASE
			WHEN License_Category = 'Scrap Metal Processor' THEN 'Solid Waste Processing'
			WHEN License_Category = 'Parking Lot' THEN 'Parking Lots and Garages'
			WHEN License_Category = 'Garage' THEN 'Parking Lots and Garages'
	 		WHEN License_Category = 'Garage and Parking Lot' THEN 'Parking Lots and Garages'
			WHEN License_Category = 'Tow Truck Company' THEN 'Parking Lots and Garages'
		END),
	-- facilitytype
		(CASE 
			WHEN License_Category LIKE '%Scrap Metal%' THEN 'Scrap Metal Processing'
			WHEN License_Category LIKE '%Tow%' THEN 'Tow Truck Company'
			ELSE CONCAT('Commercial ', License_Category)
		END),
	-- operatortype
	'Non-public',
	-- operatorname
	initcap(Business_Name),
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
	dca_facilities_operatingbusinesses
WHERE
	License_Category = 'Scrap Metal Processor'
	OR License_Category = 'Parking Lot'
	OR License_Category = 'Garage'
	OR License_Category = 'Garage and Parking Lot'
	OR License_Category = 'Tow Truck Company';

-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dca_facilities_operatingbusinesses
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
) AND (License_Category = 'Scrap Metal Processor'
	OR License_Category = 'Parking Lot'
	OR License_Category = 'Garage'
	OR License_Category = 'Garage and Parking Lot'
	OR License_Category = 'Tow Truck Company');
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
	'dca_facilities_operatingbusinesses'
FROM dca_facilities_operatingbusinesses, facilities
WHERE facilities.hash = dca_facilities_operatingbusinesses.hash;

INSERT INTO
facdb_agencyid(
	uid,
	overabbrev,
	idagency,
	idname
)
SELECT
	uid,
	'NYCDCA',
	DCA_License_Number,
	'DCA License Number'
FROM dca_facilities_operatingbusinesses, facilities
WHERE facilities.hash = dca_facilities_operatingbusinesses.hash;

--INSERT INTO
--facdb_area(
--	uid,
--	area,
--	areatype
--)
--SELECT
--	uid,
--
--FROM dca_facilities_operatingbusinesses, facilities
--WHERE facilities.hash = dca_facilities_operatingbusinesses.hash;
--
--INSERT INTO
--facdb_bbl(
--	uid,
--	bbl
--)
--SELECT
--	uid,
--
--FROM dca_facilities_operatingbusinesses, facilities
--WHERE facilities.hash = dca_facilities_operatingbusinesses.hash;
--
--INSERT INTO
--facdb_bin(
--	uid,
--	bin
--)
--SELECT
--	uid,
--
--FROM dca_facilities_operatingbusinesses, facilities
--WHERE facilities.hash = dca_facilities_operatingbusinesses.hash;
--
INSERT INTO
facdb_capacity(
  uid,
  capacity,
  capacitytype
)
SELECT
	uid,
	(CASE
		WHEN Detail LIKE '%Vehicle Spaces%' THEN split_part(split_part(Detail,': ',2),',',1)::text
	END),
	(CASE
		WHEN Detail LIKE '%Vehicle Spaces%' THEN 'Parking Spaces'
	END)
FROM dca_facilities_operatingbusinesses, facilities
WHERE facilities.hash = dca_facilities_operatingbusinesses.hash;

INSERT INTO
facdb_oversight(
	uid,
	overagency,
	overabbrev,
	overlevel
)
SELECT
	uid,
    'NYC Department of Consumer Affairs',
    'NYCDCA',
    'City'
FROM dca_facilities_operatingbusinesses, facilities
WHERE facilities.hash = dca_facilities_operatingbusinesses.hash;

--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid,
--
--FROM dca_facilities_operatingbusinesses, facilities
--WHERE facilities.hash = dca_facilities_operatingbusinesses.hash;
--