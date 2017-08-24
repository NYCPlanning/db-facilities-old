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
	ST_SetSRID(ST_MakePoint(Facility_Longitude, Facility_Latitude),4326),
    -- geomsource
    'Agency',
	-- facilityname
	Facility_Name,
	-- addressnumber
	split_part(trim(both ' ' from Facility_Address_1), ' ', 1),
	-- streetname
	initcap(trim(both ' ' from substr(trim(both ' ' from Facility_Address_1), strpos(trim(both ' ' from Facility_Address_1), ' ')+1, (length(trim(both ' ' from Facility_Address_1))-strpos(trim(both ' ' from Facility_Address_1), ' '))))),
	-- address
	Facility_Address_1,
	-- borough
		(CASE
			WHEN Facility_County = 'New York' THEN 'Manhattan'
			WHEN Facility_County = 'Bronx' THEN 'Bronx'
			WHEN Facility_County = 'Kings' THEN 'Brooklyn'
			WHEN Facility_County = 'Queens' THEN 'Queens'
			WHEN Facility_County = 'Richmond' THEN 'Staten Island'
		END),
	-- zipcode
	LEFT(Facility_Zip_Code,5)::integer,
	-- domain
	'Health and Human Services',
	-- facilitygroup
	'Health Care',
	-- facilitysubgroup
		(CASE
			WHEN Description LIKE '%Residential%'
				OR Description LIKE '%Hospice%'
				THEN 'Residential Health Care'
			WHEN Description LIKE '%Adult Day Health%'
				THEN 'Other Health Care'
			WHEN Description LIKE '%Home%'
				THEN 'Other Health Care'
			ELSE 'Hospitals and Clinics'
		END),
	-- facilitytype
		(CASE
			WHEN Description LIKE '%Residential%'
				THEN 'Residential Health Care'
			ELSE Description
		END),
	-- operatortype
		(CASE
			WHEN operator_name = 'City of New York' THEN 'Public'
			WHEN operator_name = 'NYC Health and Hospital Corporation' THEN 'Public'
			WHEN ownership_type = 'State' THEN 'Public'
			ELSE 'Non-public'
		END),	
	-- operatorname
		(CASE
			WHEN operator_name = 'City of New York' THEN 'NYC Department of Health and Mental Hygiene'
			WHEN operator_name = 'NYC Health and Hospital Corporation' THEN 'NYC Health and Hospitals Corporation'
			WHEN ownership_type = 'State' THEN 'NYS Department of Health'
			ELSE operator_name
		END),
	-- operatorabbrev
		(CASE
			WHEN operator_name = 'City of New York' THEN 'NYCDOHMH'
			WHEN operator_name = 'NYC Health and Hospitals Corporation' THEN 'NYCHHC'
			WHEN ownership_type = 'State' THEN 'NYSDOH'
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
		(CASE
			WHEN description LIKE '%Hospice%' THEN TRUE
			WHEN description LIKE '%Residential%' THEN TRUE
			ELSE FALSE
		END)
FROM
	nysdoh_facilities_healthfacilities AS f
WHERE
	Facility_County = 'New York'
	OR Facility_County = 'Bronx'
	OR Facility_County = 'Kings'
	OR Facility_County = 'Queens'
	OR Facility_County = 'Richmond';

-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM nysdoh_facilities_healthfacilities
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
) AND (Facility_County = 'New York'
	OR Facility_County = 'Bronx'
	OR Facility_County = 'Kings'
	OR Facility_County = 'Queens'
	OR Facility_County = 'Richmond');
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
	'nysdoh_facilities_healthfacilities'
FROM nysdoh_facilities_healthfacilities, facilities
WHERE facilities.hash = nysdoh_facilities_healthfacilities.hash;

INSERT INTO
facdb_agencyid(
	uid,
	overabbrev,
	idagency,
	idname
)
SELECT
	uid,
	'NYSDOH',
	Facility_ID,
	'NYSDOH Facility ID'
FROM nysdoh_facilities_healthfacilities, facilities
WHERE facilities.hash = nysdoh_facilities_healthfacilities.hash;

--INSERT INTO
--facdb_area(
--	uid,
--	area,
--	areatype
--)
--SELECT
--	uid,
--
--FROM nysdoh_facilities_healthfacilities, facilities
--WHERE facilities.hash = nysdoh_facilities_healthfacilities.hash;
--
--INSERT INTO
--facdb_bbl(
--	uid,
--	bbl
--)
--SELECT
--	uid,
--
--FROM nysdoh_facilities_healthfacilities, facilities
--WHERE facilities.hash = nysdoh_facilities_healthfacilities.hash;
--
--INSERT INTO
--facdb_bin(
--	uid,
--	bin
--)
--SELECT
--	uid,
--
--FROM nysdoh_facilities_healthfacilities, facilities
--WHERE facilities.hash = nysdoh_facilities_healthfacilities.hash;

INSERT INTO
facdb_capacity(
  uid,
  capacity,
  capacitytype
)
SELECT
	uid,
	total_capacity,
	total_capacity-c.total_available
FROM
	facilities,
	(SELECT
		f.uid,
		c.*
	FROM
		facdb_agencyid AS f
	LEFT JOIN
		nysdoh_nursinghomebedcensus AS c
	ON
		f.idagency=c.facility_id::numeric
		AND f.overabbrev = 'NYSDOH') AS censusuids
WHERE facilities.uid = censusuids.uid;

INSERT INTO
facdb_oversight(
	uid,
	overagency,
	overabbrev,
	overlevel
)
SELECT
	uid,
	'NYS Department of Health',
	'NYSDOH',
	'State'
FROM nysdoh_facilities_healthfacilities, facilities
WHERE facilities.hash = nysdoh_facilities_healthfacilities.hash;

INSERT INTO
facdb_utilization(
	uid,
	util,
	utiltype
)
SELECT
	uid,

FROM nysdoh_facilities_healthfacilities, facilities
WHERE facilities.hash = nysdoh_facilities_healthfacilities.hash;