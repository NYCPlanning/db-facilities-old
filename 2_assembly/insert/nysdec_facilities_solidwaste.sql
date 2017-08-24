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
			WHEN east_coordinate > 11111 
				THEN ST_Transform(ST_SetSRID(ST_MakePoint(east_coordinate, north_coordinate),26918),4326)
		END),
    -- geomsource
    'Agency',
	-- facilityname
	facility_name,
	-- addressnumber
	split_part(trim(both ' ' from location_address), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from location_address), strpos(trim(both ' ' from location_address), ' ')+1, (length(trim(both ' ' from location_address))-strpos(trim(both ' ' from location_address), ' ')))),
	-- address
	location_address,
	-- borough
		(CASE
			WHEN County = 'New York' THEN 'Manhattan'
			WHEN County = 'Bronx' THEN 'Bronx'
			WHEN County = 'Kings' THEN 'Brooklyn'
			WHEN County = 'Queens' THEN 'Queens'
			WHEN County = 'Richmond' THEN 'Staten Island'
		END),
	-- zipcode
	NULL,
	-- domain
	'Core Infrastructure and Transportation',
	-- facilitygroup
	'Solid Waste',
	-- facilitysubgroup
		(CASE
			WHEN activity_desc LIKE '%Transfer%' THEN 'Solid Waste Transfer and Carting'
			ELSE 'Solid Waste Processing'
		END),
	-- facilitytype
		(CASE
			WHEN activity_desc LIKE '%C&D%' THEN 'Construction and Demolition Processing'
			WHEN activity_desc LIKE '%Composting%' THEN 'Composting'
			WHEN activity_desc LIKE '%Other%' THEN 'Other Solid Waste Processing'
			WHEN activity_desc LIKE '%RHRF%' THEN 'Recyclables Handling and Recovery'
			WHEN activity_desc LIKE '%medical%' THEN 'Regulated Medical Waste'
			WHEN activity_desc LIKE '%Transfer%' THEN 'Transfer Station'
			WHEN activity_desc LIKE '%Composting%' THEN 'Composting'
			ELSE initcap(trim(split_part(split_part(activity_desc,';',1),'-',1),' '))
		END),
	-- operatortype
		(CASE
			WHEN owner_type = 'Municipal' THEN 'Public'
			ELSE 'Non-public'
		END),
	-- operatorname
		(CASE
			WHEN owner_type = 'Municipal' THEN 'NYC Department of Sanitation'
			WHEN owner_name IS NOT NULL THEN owner_name
			ELSE 'Unknown'
		END),
	-- operatorabbrev
		(CASE
			WHEN owner_type = 'Municipal' THEN 'NYCDSNY'
			ELSE 'Non-public'
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
	nysdec_facilities_solidwaste
WHERE
	County = 'New York'
	OR County = 'Bronx'
	OR County = 'Kings'
	OR County = 'Queens'
	OR County = 'Richmond';

-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM nysdec_facilities_solidwaste
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
) AND (County = 'New York'
	OR County = 'Bronx'
	OR County = 'Kings'
	OR County = 'Queens'
	OR County = 'Richmond');
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
	'nysdec_facilities_solidwaste'
FROM nysdec_facilities_solidwaste, facilities
WHERE facilities.hash = nysdec_facilities_solidwaste.hash;

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
--FROM nysdec_facilities_solidwaste, facilities
--WHERE facilities.hash = nysdec_facilities_solidwaste.hash;
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
--FROM nysdec_facilities_solidwaste, facilities
--WHERE facilities.hash = nysdec_facilities_solidwaste.hash;
--
--INSERT INTO
--facdb_bbl(
--	uid,
--	bbl
--)
--SELECT
--	uid,
--
--FROM nysdec_facilities_solidwaste, facilities
--WHERE facilities.hash = nysdec_facilities_solidwaste.hash;
--
--INSERT INTO
--facdb_bin(
--	uid,
--	bin
--)
--SELECT
--	uid,
--
--FROM nysdec_facilities_solidwaste, facilities
--WHERE facilities.hash = nysdec_facilities_solidwaste.hash;
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
--FROM nysdec_facilities_solidwaste, facilities
--WHERE facilities.hash = nysdec_facilities_solidwaste.hash;


INSERT INTO
facdb_oversight(
	uid,
	overagency,
	overabbrev,
	overlevel
)
SELECT
	uid,
		(CASE
			WHEN owner_type = 'Municipal' THEN 'NYC Department of Sanitation'
			ELSE 'NYS Department of Environmental Conservation'
		END),
		(CASE
			WHEN owner_type = 'Municipal' THEN 'NYCDSNY'
			ELSE 'NYSDEC'
		END),
		(CASE
			WHEN owner_type = 'Municipal' THEN 'City'
			ELSE 'State'
		END)
FROM nysdec_facilities_solidwaste, facilities
WHERE facilities.hash = nysdec_facilities_solidwaste.hash;

--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid,
--
--FROM nysdec_facilities_solidwaste, facilities
--WHERE facilities.hash = nysdec_facilities_solidwaste.hash;