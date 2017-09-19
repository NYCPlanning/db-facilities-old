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
	ST_SetSRID(
		ST_MakePoint(
			trim(trim(split_part(split_part(Location_1,'(',2),',',2),')'),' ')::double precision,
			trim(split_part(split_part(Location_1,'(',2),',',1),' ')::double precision),
		4326),
    -- geomsource
    'Agency',
	-- facilityname
	facility_name,
	-- addressnumber
	split_part(Location_1, ' ', 1),
	-- streetname
	split_part(split_part(Location_1, ' ', 2),'(',1),
	-- address
	split_part(Location_1, '(', 1),
	-- borough
	Borough,
	-- zipcode
	NULL,
	-- domain
	NULL,
	-- facilitygroup
	'Health Care',
	-- facilitysubgroup
		(CASE
			WHEN facility_type = 'Nursing Home' THEN 'Residential Health Care'
			ELSE 'Hospitals and Clinics'
		END),
	-- facilitytype
		(CASE 
			WHEN facility_type LIKE '%Diagnostic%' THEN 'Diagnostic and Treatment Center'
			ELSE facility_type
		END),
	-- operatortype
	'Public',
	-- operatorname
	'NYC Health and Hospitals Corporation',
	-- operatorabbrev
	'NYCHHC',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
		(CASE
			WHEN facility_type LIKE '%Child%' THEN TRUE
			ELSE FALSE
		END),
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
			WHEN facility_type LIKE '%Nursing Home%' THEN TRUE
			ELSE FALSE
		END)
FROM
	hhc_facilities_hospitals;

-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM hhc_facilities_hospitals
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
	'hhc_facilities_hospitals'
FROM hhc_facilities_hospitals, facilities
WHERE facilities.hash = hhc_facilities_hospitals.hash;

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
--FROM hhc_facilities_hospitals, facilities
--WHERE facilities.hash = hhc_facilities_hospitals.hash;
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
--FROM hhc_facilities_hospitals, facilities
--WHERE facilities.hash = hhc_facilities_hospitals.hash;
--
--INSERT INTO
--facdb_bbl(
--	uid,
--	bbl
--)
--SELECT
--	uid,
--
--FROM hhc_facilities_hospitals, facilities
--WHERE facilities.hash = hhc_facilities_hospitals.hash;
--
--INSERT INTO
--facdb_bin(
--	uid,
--	bin
--)
--SELECT
--	uid,
--
--FROM hhc_facilities_hospitals, facilities
--WHERE facilities.hash = hhc_facilities_hospitals.hash;
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
--FROM hhc_facilities_hospitals, facilities
--WHERE facilities.hash = hhc_facilities_hospitals.hash;


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
FROM hhc_facilities_hospitals, facilities
WHERE facilities.hash = hhc_facilities_hospitals.hash;

--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid,
--
--FROM hhc_facilities_hospitals, facilities
--WHERE facilities.hash = hhc_facilities_hospitals.hash;