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
		WHEN longitude IS NOT NULL THEN ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)
		ELSE NULL
	END),
    -- geomsource
    'Agency',
	-- facilityname
	initcap(business_name),
	-- addressnumber
	address_building,
	-- streetname
	initcap(address_street_name),
	-- address
	CONCAT(address_building,' ',initcap(address_street_name)),
	-- borough -- should borough be assigned from Lat/Long to avoid using address_city?
		(CASE
			WHEN address_borough IS NULL AND upper(address_city) = 'NEW YORK' THEN 'Manhattan'
			WHEN address_borough IS NULL AND upper(address_city) = 'BRONX' THEN 'Bronx'
			WHEN address_borough IS NULL AND upper(address_city) = 'BROOKLYN' THEN 'Brooklyn'
			WHEN address_borough IS NULL AND upper(address_city) = 'STATEN ISLAND' THEN 'Staten Island'
			WHEN address_borough IS NULL AND upper(address_city) = 'QUEENS' THEN 'Queens'
			WHEN address_borough IS NULL AND upper(address_city) = 'ASTORIA' THEN 'Queens'
			WHEN address_borough IS NULL AND upper(address_city) = 'BAYSIDE' THEN 'Queens'
			WHEN address_borough IS NULL AND upper(address_city) = 'BAYSIDE HILLS' THEN 'Queens'
			WHEN address_borough IS NULL AND upper(address_city) = 'CORONA' THEN 'Queens'
			WHEN address_borough IS NULL AND upper(address_city) = 'CORONA' THEN 'Queens'
			WHEN address_borough IS NULL AND upper(address_city) = 'FLUSHING' THEN 'Queens'
			WHEN address_borough IS NULL AND upper(address_city) = 'JAMAICA' THEN 'Queens'
			WHEN address_borough IS NULL AND upper(address_city) = 'LONG ISLAND CITY' THEN 'Queens'
			WHEN address_borough IS NULL AND upper(address_city) = 'QUEENS VLG' THEN 'Queens'
			WHEN address_borough IS NULL AND upper(address_city) = 'WOODSIDE' THEN 'Queens'
			ELSE address_borough
		END),
	-- zipcode
		(CASE
			WHEN address_zip ~'^([0-9]+\.?[0-9]*|\.[0-9]+)$' THEN address_zip::integer
		END),
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
		(CASE
			WHEN license_category = 'Scrap Metal Processor' THEN 'Solid Waste Processing'
			WHEN license_category = 'Parking Lot' THEN 'Parking Lots and Garages'
			WHEN license_category = 'Garage' THEN 'Parking Lots and Garages'
	 		WHEN license_category = 'Garage and Parking Lot' THEN 'Parking Lots and Garages'
			WHEN license_category = 'Tow Truck Company' THEN 'Parking Lots and Garages'
		END),
	-- facilitytype
		(CASE 
			WHEN license_category LIKE '%Scrap Metal%' THEN 'Scrap Metal Processing'
			WHEN license_category LIKE '%Tow%' THEN 'Tow Truck Company'
			ELSE CONCAT('Commercial ', license_category)
		END),
	-- operatortype
	'Non-public',
	-- operatorname
	initcap(business_name),
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
	license_category = 'Scrap Metal Processor'
	OR license_category = 'Parking Lot'
	OR license_category = 'Garage'
	OR license_category = 'Garage and Parking Lot'
	OR license_category = 'Tow Truck Company';

-- facdb_uid_key
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

-- pgtable
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
	'NYCDCA',
	DCA_License_Number,
	'DCA License Number'
FROM dca_facilities_operatingbusinesses, facilities
WHERE facilities.hash = dca_facilities_operatingbusinesses.hash;

-- area NA

-- bbl NA

-- bin NA

-- capacity
INSERT INTO
facdb_capacity(
  uid,
  capacity,
  capacitytype
)
SELECT
	uid,
	(CASE
		WHEN detail LIKE '%Vehicle Spaces%' THEN split_part(split_part(detail,': ',2),',',1)::text
	END),
	(CASE
		WHEN detail LIKE '%Vehicle Spaces%' THEN 'Parking Spaces'
	END)
FROM dca_facilities_operatingbusinesses, facilities
WHERE facilities.hash = dca_facilities_operatingbusinesses.hash;

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
    'NYC Department of Consumer Affairs',
    'NYCDCA',
    'City'
FROM dca_facilities_operatingbusinesses, facilities
WHERE facilities.hash = dca_facilities_operatingbusinesses.hash;

-- utilization NA