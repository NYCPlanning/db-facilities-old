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
		(CASE
			WHEN Center_Name LIKE '%SBCC%' THEN initcap(Legal_Name)
			WHEN Center_Name LIKE '%SCHOOL BASED CHILD CARE%' THEN initcap(Legal_Name)
			ELSE initcap(Center_Name)
		END),
	-- addressnumber
	Building,
	-- streetname
	initcap(Street),
	-- address
	CONCAT(Building,' ',initcap(Street)),
	-- borough
	initcap(Borough),
	-- zipcode
	ZipCode::integer,
	-- domain
	'Education, Child Welfare, and Youth',
	-- facilitygroup
		(CASE
			WHEN (facility_type = 'CAMP' OR facility_type = 'Camp' OR program_type LIKE '%CAMP%' OR program_type LIKE '%Camp%')
				THEN 'Camps'
			ELSE 'Child Care and Pre-Kindergarten'
		END),
	-- facilitysubgroup
		(CASE
			WHEN (facility_type = 'CAMP' OR facility_type = 'Camp' OR program_type LIKE '%CAMP%' OR program_type LIKE '%Camp%')
				THEN 'Camps'
			ELSE 'Child Care'
		END),
	-- facilitytype
		(CASE
			WHEN (facility_type = 'CAMP' OR facility_type = 'Camp') AND (program_type = 'All Age Camp' OR program_type = 'ALL AGE CAMP')
				THEN 'Camp - All Age'
			WHEN (facility_type = 'CAMP' OR facility_type = 'Camp') AND (program_type = 'School Age Camp' OR program_type = 'SCHOOL AGE CAMP')
				THEN 'Camp - School Age'
			WHEN (program_type = 'Preschool Camp' OR program_type = 'PRESCHOOL CAMP')
				THEN 'Camp - Preschool Age'
			WHEN (facility_type = 'GDC') AND (program_type = 'Child Care - Infants/Toddlers' OR program_type = 'INFANT TODDLER')
				THEN 'Group Day Care - Infants/Toddlers'
			WHEN (facility_type = 'GDC') AND (program_type = 'Child Care - Pre School' OR program_type = 'PRESCHOOL')
				THEN 'Group Day Care - Preschool'
			WHEN (facility_type = 'SBCC') AND (program_type = 'PRESCHOOL')
				THEN 'School Based Child Care - Preschool'
			WHEN (facility_type = 'SBCC') AND (program_type = 'INFANT TODDLER')
				THEN 'School Based Child Care - Infants/Toddlers'
			WHEN facility_type = 'SBCC'
				THEN 'School Based Child Care - Age Unspecified'
			WHEN facility_type = 'GDC'
				THEN 'Group Day Care - Age Unspecified'
			ELSE CONCAT(facility_type,' - ',program_type)
		END),
	-- operatortype
	'Non-public',
	-- operator
	initcap(Legal_Name),
	-- operatorabbrev
	'Non-public',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
	TRUE,
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
	dohmh_facilities_daycare
GROUP BY
	hash,
	Day_Care_ID,
	Center_Name,
	Legal_Name,
	Building,
	Street,
	ZipCode,
	Borough,
	facility_type,
	child_care_type,
	program_type,
	Maximum_Capacity
;

-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dohmh_facilities_daycare
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
)
GROUP BY
	hash,
	Day_Care_ID,
	Center_Name,
	Legal_Name,
	Building,
	Street,
	ZipCode,
	Borough,
	facility_type,
	child_care_type,
	program_type,
	Maximum_Capacity;
        
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
	'dohmh_facilities_daycare'
FROM dohmh_facilities_daycare, facilities
WHERE facilities.hash = dohmh_facilities_daycare.hash
GROUP BY
	facilities.uid,
        dohmh_facilities_daycare.hash,
	Day_Care_ID,
	Center_Name,
	Legal_Name,
	Building,
	Street,
	dohmh_facilities_daycare.ZipCode,
	Borough,
	facility_type,
	child_care_type,
	program_type,
	Maximum_Capacity;

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
--FROM dohmh_facilities_daycare, facilities
--WHERE facilities.hash = dohmh_facilities_daycare.hash;
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
--FROM dohmh_facilities_daycare, facilities
--WHERE facilities.hash = dohmh_facilities_daycare.hash;
--
--INSERT INTO
--facdb_bbl(
--	uid,
--	bbl
--)
--SELECT
--	uid,
--
--FROM dohmh_facilities_daycare, facilities
--WHERE facilities.hash = dohmh_facilities_daycare.hash;
--
--INSERT INTO
--facdb_bin(
--	uid,
--	bin
--)
--SELECT
--	uid,
--
--FROM dohmh_facilities_daycare, facilities
--WHERE facilities.hash = dohmh_facilities_daycare.hash;

INSERT INTO
facdb_capacity(
  uid,
  capacity,
  capacitytype
)
SELECT
	uid,
	Maximum_Capacity::text,
	'Maximum Seats Based on Sq Ft'
FROM dohmh_facilities_daycare, facilities
WHERE facilities.hash = dohmh_facilities_daycare.hash
AND Maximum_Capacity <> '0'
GROUP BY
	facilities.uid,
        dohmh_facilities_daycare.hash,
	Day_Care_ID,
	Center_Name,
	Legal_Name,
	Building,
	Street,
	dohmh_facilities_daycare.ZipCode,
	Borough,
	facility_type,
	child_care_type,
	program_type,
	Maximum_Capacity;

INSERT INTO
facdb_oversight(
	uid,
	overagency,
	overabbrev,
	overlevel
)
SELECT
	uid,
    'NYC Department of Health and Mental Hygiene',
    'NYCDOHMH',
    'City'
FROM dohmh_facilities_daycare, facilities
WHERE facilities.hash = dohmh_facilities_daycare.hash
GROUP BY
	facilities.uid,
        dohmh_facilities_daycare.hash,
	Day_Care_ID,
	Center_Name,
	Legal_Name,
	Building,
	Street,
	dohmh_facilities_daycare.ZipCode,
	Borough,
	facility_type,
	child_care_type,
	program_type,
	Maximum_Capacity;

--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid,
--
--FROM dohmh_facilities_daycare, facilities
--WHERE facilities.hash = dohmh_facilities_daycare.hash;
--
