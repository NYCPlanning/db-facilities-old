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
	-- hash
    hash,
    -- uid
    NULL,
	-- geom
	ST_SetSRID(ST_MakePoint(facility_longitude, facility_latitude),4326),
    -- geomsource
    'Agency',
	-- facilityname
	facility_name,
	-- addressnumber
	split_part(trim(both ' ' from facility_address_1), ' ', 1),
	-- streetname
	initcap(trim(both ' ' from substr(trim(both ' ' from facility_address_1), strpos(trim(both ' ' from facility_address_1), ' ')+1, (length(trim(both ' ' from facility_address_1))-strpos(trim(both ' ' from facility_address_1), ' '))))),
	-- address
	facility_address_1,
	-- borough
		(CASE
			WHEN facility_county = 'New York' THEN 'Manhattan'
			WHEN facility_county = 'Bronx' THEN 'Bronx'
			WHEN facility_county = 'Kings' THEN 'Brooklyn'
			WHEN facility_county = 'Queens' THEN 'Queens'
			WHEN facility_county = 'Richmond' THEN 'Staten Island'
		END),
	-- zipcode
	LEFT(facility_zip_code,5)::integer,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
		(CASE
			WHEN description LIKE '%Residential%'
				OR description LIKE '%Hospice%'
				THEN 'Residential Health Care'
			WHEN description LIKE '%Adult Day Health%'
				THEN 'Other Health Care'
			WHEN description LIKE '%Home%'
				THEN 'Other Health Care'
			ELSE 'Hospitals and Clinics'
		END),
	-- facilitytype
		(CASE
			WHEN description LIKE '%Residential%'
				THEN 'Residential Health Care'
			ELSE description
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
	facility_county = 'New York'
	OR facility_county = 'Bronx'
	OR facility_county = 'Kings'
	OR facility_county = 'Queens'
	OR facility_county = 'Richmond';

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM nysdoh_facilities_healthfacilities
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
) AND (facility_county = 'New York'
	OR facility_county = 'Bronx'
	OR facility_county = 'Kings'
	OR facility_county = 'Queens'
	OR facility_county = 'Richmond');
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
	'nysdoh_facilities_healthfacilities'
FROM nysdoh_facilities_healthfacilities, facilities
WHERE facilities.hash = nysdoh_facilities_healthfacilities.hash;

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
	'NYSDOH',
	facility_id,
	'NYSDOH Facility ID'
FROM nysdoh_facilities_healthfacilities, facilities
WHERE facilities.hash = nysdoh_facilities_healthfacilities.hash;

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
	censusuids.uid,
	censusuids.total_capacity,
	'beds'
FROM
	facilities,
	(SELECT
		f.uid,
		c.*
	FROM
		facdb_agencyid AS f
	LEFT JOIN
		nysdoh_nursinghomebedcensus AS c
	ON f.idagency::numeric=c.facility_id::numeric
		AND f.overabbrev = 'NYSDOH') AS censusuids
WHERE facilities.uid = censusuids.uid;

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
	'NYS Department of Health',
	'NYSDOH',
	'State'
FROM nysdoh_facilities_healthfacilities, facilities
WHERE facilities.hash = nysdoh_facilities_healthfacilities.hash;

-- utilization
INSERT INTO
facdb_utilization(
	uid,
	util,
	utiltype
)
SELECT
	censusuids.uid,
	censusuids.total_capacity-censusuids.total_available,
	'beds'
FROM
	facilities,
	(SELECT
		f.uid,
		c.*
	FROM
		facdb_agencyid AS f
	LEFT JOIN
		nysdoh_nursinghomebedcensus AS c
	ON f.idagency::numeric=c.facility_id::numeric
		AND f.overabbrev = 'NYSDOH') AS censusuids
WHERE facilities.uid = censusuids.uid;