DROP VIEW doe_facilities_schoolsbluebook_facdbview;
CREATE VIEW doe_facilities_schoolsbluebook_facdbview AS 
SELECT * FROM doe_facilities_schoolsbluebook
WHERE
	RIGHT(org_id,3) <> 'SPE'
	AND RIGHT(org_id,3) <> 'AAC'
	AND RIGHT(org_id,3) <> 'UFT';


--facilities
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
			WHEN X <> '#N/A' THEN ST_Transform(ST_SetSRID(ST_MakePoint(x::double precision, y::double precision),2263),4326)
		END),
    -- geomsource
    'Agency',
	-- facilityname
	initcap(organization_name),
	-- addressnumber
		(CASE
			WHEN address <> '#N/A' THEN split_part(address,' ',1)
		END),
	-- streetname
		(CASE
			WHEN address <> '#N/A' THEN initcap(trim(both ' ' from substr(trim(both ' ' from address), strpos(trim(both ' ' from address), ' ')+1, (length(trim(both ' ' from address))-strpos(trim(both ' ' from address), ' ')))))
		END),
	-- address
		(CASE
			WHEN address <> '#N/A' THEN initcap(address)
		END),
	-- borough
		(CASE
			WHEN LEFT(org_id,1) = 'M' THEN 'Manhattan'
			WHEN LEFT(org_id,1) = 'X' THEN 'Bronx'
			WHEN LEFT(org_id,1) = 'K' THEN 'Brooklyn'
			WHEN LEFT(org_id,1) = 'Q' THEN 'Queens'
			WHEN LEFT(org_id,1) = 'R' THEN 'Staten Island'
		END),
	-- zipcode
	NULL,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
		(CASE
			WHEN charter IS NOT NULL AND org_level <> 'SPED' THEN 'Charter K-12 Schools'
			WHEN org_level = 'SPED' THEN 'Public and Private Special Education Schools'
			WHEN RIGHT(org_id,3) = 'ADM' THEN 'Offices'
			WHEN RIGHT(org_id,3) = 'CBO' THEN 'Community Centers and Community School Programs'
			WHEN RIGHT(org_id,3) = 'DRG' THEN 'Community Centers and Community School Programs'
			WHEN RIGHT(org_id,3) = 'SFS' THEN 'Child Nutrition'
			WHEN RIGHT(org_id,3) = 'OTH' THEN 'Community Centers and Community School Programs'
			WHEN RIGHT(org_id,3) = 'SST' THEN 'School-Based Safety Program'
			WHEN RIGHT(org_id,3) = 'CEP' THEN 'Workforce Development'
			WHEN RIGHT(org_id,3) = 'SBH' THEN 'Health Promotion and Disease Prevention'
			WHEN organization_name LIKE '%PRE-K%' THEN 'DOE Universal Pre-Kindergarten'
			WHEN organization_name LIKE '%LYFE%' THEN 'Child Care'
			ELSE 'Public K-12 Schools'
		END),
	-- facilitytype
		(CASE
			WHEN RIGHT(org_id,3) = 'ADM' THEN 'School Administration Site'
			WHEN RIGHT(org_id,3) = 'CBO' THEN 'School-Based Community Based Organization'
			WHEN RIGHT(org_id,3) = 'DRG' THEN 'School-Based Drug Program'
			WHEN RIGHT(org_id,3) = 'SBH' THEN 'School-Based Health Program'
			WHEN RIGHT(org_id,3) = 'SFS' THEN 'School-Based Food Services'
			WHEN RIGHT(org_id,3) = 'OTH' THEN 'School-Based Community Service'
			WHEN RIGHT(org_id,3) = 'SST' THEN 'School-Based Safety Program'
			WHEN RIGHT(org_id,3) = 'CEP' THEN 'School-Based Continuing Education Program'
			WHEN charter IS NULL AND org_level = 'PS' THEN 'Elementary School - Public'
			WHEN charter IS NULL AND org_level = 'PSIS' THEN 'Elementary and Middle School - Public'
			WHEN charter IS NULL AND org_level = 'IS' THEN 'Middle School - Public'
			WHEN charter IS NULL AND org_level = 'ISHS' THEN 'Middle and High School - Public'
			WHEN charter IS NULL AND org_level = 'IS/JHS' THEN 'High School - Public'
			WHEN charter IS NULL AND org_level = 'HS' THEN 'High School - Public'
			WHEN charter IS NULL AND org_level = 'SPED' THEN 'Special Ed School - Public'
			WHEN charter IS NULL AND org_level = 'OTHER' THEN 'Other School - Public'
			WHEN charter IS NOT NULL AND org_level = 'PS' THEN 'Elementary School - Charter'
			WHEN charter IS NOT NULL AND org_level = 'PSIS' THEN 'Elementary and Middle School - Charter'
			WHEN charter IS NOT NULL AND org_level = 'IS' THEN 'Middle School - Charter'
			WHEN charter IS NOT NULL AND org_level = 'ISHS' THEN 'Middle and High School - Charter'
			WHEN charter IS NOT NULL AND org_level = 'IS/JHS' THEN 'High School - Charter'
			WHEN charter IS NOT NULL AND org_level = 'HS' THEN 'High School - Charter'
			WHEN charter IS NOT NULL AND org_level = 'SPED' THEN 'Special Ed School - Charter'
			WHEN charter IS NOT NULL AND org_level = 'OTHER' THEN 'Other School - Charter'
			WHEN Organization_Name LIKE '%LYFE%' THEN 'DOE Lyfe Program Child Care'
			ELSE 'Other K-12 School - Unspecified'
		END),
	-- operatortype
		(CASE
			WHEN charter IS NOT NULL THEN 'Non-public'
			ELSE 'Public'
		END),
	-- operatorname
		(CASE
			WHEN charter IS NOT NULL THEN Organization_Name
			ELSE 'NYC Department of Education'
		END),
	-- operator abbrev
		(CASE
			WHEN charter IS NOT NULL THEN 'Non-public'
			ELSE 'NYCDOE'
		END),
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
		(CASE
			WHEN org_level = 'PS' THEN TRUE
			WHEN org_level = 'PSIS' THEN TRUE
			WHEN org_level = 'IS' THEN TRUE
			WHEN org_level = 'ISHS' THEN TRUE
			WHEN org_level = 'IS/JHS' THEN TRUE
			WHEN org_level = 'HS' THEN FALSE
			WHEN org_level = 'SPED' THEN FALSE
			WHEN org_level = 'OTHER' THEN FALSE
		END),
	-- youth
		(CASE
			WHEN org_level = 'PS' THEN FALSE
			WHEN org_level = 'PSIS' THEN FALSE
			WHEN org_level = 'IS' THEN FALSE
			WHEN org_level = 'ISHS' THEN TRUE
			WHEN org_level = 'IS/JHS' THEN TRUE
			WHEN org_level = 'HS' THEN TRUE
			WHEN org_level = 'SPED' THEN FALSE
			WHEN org_level = 'OTHER' THEN FALSE
		END),
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
FROM doe_facilities_schoolsbluebook_facdbview;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM doe_facilities_schoolsbluebook_facdbview
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key);
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
	'doe_facilities_schoolsbluebook'
FROM doe_facilities_schoolsbluebook_facdbview, facilities
WHERE facilities.hash = doe_facilities_schoolsbluebook_facdbview.hash;

-- agency id
INSERT INTO
facdb_agencyid(
	uid,
	idagency,
	idname,
	idfield,
	idtable
)
SELECT
	uid,
	org_id,
	'DOE Organization ID',
	'org_id',
	'doe_facilities_schoolsbluebook'
FROM doe_facilities_schoolsbluebook, facilities
WHERE facilities.hash = doe_facilities_schoolsbluebook.hash;

INSERT INTO
facdb_agencyid(
	uid,
	idagency,
	idname,
	idfield,
	idtable
)
SELECT
	uid,
	bldg_id,
	'DOE Building ID',
	'bldg_id',
	'doe_facilities_schoolsbluebook'
FROM doe_facilities_schoolsbluebook, facilities
WHERE facilities.hash = doe_facilities_schoolsbluebook.hash;

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
		WHEN org_target_cap <> 0 THEN ROUND(org_target_cap::numeric,0)::text
	END),
	'Target Student Capacity'
FROM doe_facilities_schoolsbluebook, facilities
WHERE facilities.hash = doe_facilities_schoolsbluebook.hash
AND org_target_cap <> 0;

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
    'NYC Department of Education',
    'NYCDOE',
    'City'
FROM doe_facilities_schoolsbluebook, facilities
WHERE facilities.hash = doe_facilities_schoolsbluebook.hash;

-- utilization
INSERT INTO
facdb_utilization(
	uid,
	util,
	utiltype
)
SELECT
	uid,
	(CASE
		WHEN (org_enroll <> 0 AND org_target_cap <> 0) THEN ROUND((org_enroll::numeric/org_target_cap::numeric),3)::text
	END),
	'Number of Students Enrolled'
FROM doe_facilities_schoolsbluebook, facilities
WHERE facilities.hash = doe_facilities_schoolsbluebook.hash
AND org_enroll <> 0 AND org_target_cap <> 0;
