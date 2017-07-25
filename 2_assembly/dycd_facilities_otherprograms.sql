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
	initcap(Facility_Name),
	-- addressnumber
	split_part(trim(both ' ' from address_number), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from address_number), strpos(trim(both ' ' from address_number), ' ')+1, (length(trim(both ' ' from address_number))-strpos(trim(both ' ' from address_number), ' ')))),
	-- address
	address_number,
	-- borough
	initcap(Borough),
	-- zipcode
	NULL,
	-- domain
	'Education, Child Welfare, and Youth',
	-- facilitygroup
	'Youth Services',
	-- facilitysubgroup
		(CASE
			WHEN facility_type LIKE '%COMPASS%' THEN 'Comprehensive After School System (COMPASS) Sites'
			WHEN facility_type LIKE '%Summer%' THEN 'Summer Youth Employment Site'
			ELSE 'Youth Centers, Literacy Programs, Job Training, and Immigrant Services'
		END),
	-- facilitytype
	(CASE
		WHEN facility_type LIKE '%Literacy%' THEN 'Literacy Program'
		WHEN facility_type LIKE '%Beacon%' THEN 'Beacon Community Center Program'
		WHEN facility_type LIKE '%COMPASS%' THEN 'COMPASS Program'
		WHEN facility_type LIKE '%Cornerstone%' THEN 'Cornerstone Community Center Program'
		WHEN facility_type LIKE '%NDA%' OR facility_type LIKE '%Neighborhood Development%' THEN 'Neighborhood Development Area Program'
		ELSE 'Other Youth Program'
	END),
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
FROM
	dycd_facilities_compass
GROUP BY
	hash,
	Address_Number,
	Street_Name,
	Borough,
	BBLs,
	BIN,
	X_Coordinate,
	Y_Coordinate,
	Provider_Name,
	Date_Source_Data_Updated;

-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dycd_facilities_compass
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
)
GROUP BY
	hash,
	Address_Number,
	Street_Name,
	Borough,
	BBLs,
	BIN,
	X_Coordinate,
	Y_Coordinate,
	Provider_Name,
	Date_Source_Data_Updated;
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
	'dycd_facilities_compass'
FROM dycd_facilities_compass, facilities
WHERE facilities.hash = dycd_facilities_compass.hash;

INSERT INTO
facdb_agencyid(
	uid,
	overabbrev,
	idagency,
	idname
)
SELECT
	uid,
	'NYCDYCD',
	Unique_ID,
	'DYCD UniqueID'
FROM dycd_facilities_compass, facilities
WHERE facilities.hash = dycd_facilities_compass.hash;

--INSERT INTO
--facdb_area(
--	uid,
--	area,
--	areatype
--)
--SELECT
--	uid,
--
--FROM dycd_facilities_compass, facilities
--WHERE facilities.hash = dycd_facilities_compass.hash;
--
--INSERT INTO
--facdb_bbl(
--	uid,
--	bbl
--)
--SELECT
--	uid,
--
--FROM dycd_facilities_compass, facilities
--WHERE facilities.hash = dycd_facilities_compass.hash;
--
--INSERT INTO
--facdb_bin(
--	uid,
--	bin
--)
--SELECT
--	uid,
--
--FROM dycd_facilities_compass, facilities
--WHERE facilities.hash = dycd_facilities_compass.hash;
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
--FROM dycd_facilities_compass, facilities
--WHERE facilities.hash = dycd_facilities_compass.hash;


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

--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid,
--
--FROM dycd_facilities_compass, facilities
--WHERE facilities.hash = dycd_facilities_compass.hash;