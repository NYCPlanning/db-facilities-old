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
	NULL,
    -- geomsource
    'None',
	-- facilityname
		(CASE
			WHEN center_name LIKE '%SBCC%' THEN initcap(legal_name)
			WHEN center_name LIKE '%SCHOOL BASED CHILD CARE%' THEN initcap(legal_name)
			ELSE initcap(center_name)
		END),
	-- addressnumber
	building,
	-- streetname
	initcap(street),
	-- address
	CONCAT(building,' ',initcap(street)),
	-- borough
	initcap(borough),
	-- zipcode
	zipcode::integer,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
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
	initcap(legal_name),
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
	day_care_id,
	center_name,
	legal_name,
	building,
	street,
	zipcode,
	borough,
	facility_type,
	child_care_type,
	program_type,
	maximum_capacity
;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dohmh_facilities_daycare
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
)
GROUP BY
	day_care_id,
	center_name,
	legal_name,
	building,
	street,
	zipcode,
	borough,
	facility_type,
	child_care_type,
	program_type,
	maximum_capacity;   
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
	'dohmh_facilities_daycare'
FROM dohmh_facilities_daycare, facilities
WHERE facilities.hash = dohmh_facilities_daycare.hash
GROUP BY
	facilities.uid,
        dohmh_facilities_daycare.hash,
	day_care_id,
	center_name,
	legal_name,
	building,
	street,
	dohmh_facilities_daycare.zipcode,
	borough,
	facility_type,
	child_care_type,
	program_type,
	maximum_capacity;

-- agency id NA

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
	maximum_capacity::text,
	'Maximum Seats Based on Sq Ft'
FROM dohmh_facilities_daycare, facilities
WHERE facilities.hash = dohmh_facilities_daycare.hash
AND maximum_capacity <> '0'
GROUP BY
	facilities.uid,
        dohmh_facilities_daycare.hash,
	day_care_id,
	center_name,
	legal_name,
	building,
	street,
	dohmh_facilities_daycare.zipcode,
	borough,
	facility_type,
	child_care_type,
	program_type,
	maximum_capacity;

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
    'NYC Department of Health and Mental Hygiene',
    'NYCDOHMH',
    'City'
FROM dohmh_facilities_daycare, facilities
WHERE facilities.hash = dohmh_facilities_daycare.hash
GROUP BY
	facilities.uid,
        dohmh_facilities_daycare.hash,
	day_care_id,
	center_name,
	legal_name,
	building,
	street,
	dohmh_facilities_daycare.zipcode,
	borough,
	facility_type,
	child_care_type,
	program_type,
	maximum_capacity;

-- utilization NA