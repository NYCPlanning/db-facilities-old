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
	-- ST_SetSRID(ST_MakePoint(long, lat),4326)
		(CASE
			-- if switched coordinates were provided
			WHEN 
				gis_latitude_y::double precision < 37
				AND gis_latitude_y::double precision <> 0
				AND gis_longitude_x::double precision > -69
				AND gis_longitude_x::double precision <> 0
			THEN ST_SetSRID(ST_MakePoint(gis_latitude_y::double precision, gis_longitude_x::double precision),4326)
			-- if correct coordinates were provided
			WHEN 
				gis_latitude_y::double precision > 37
				AND gis_longitude_x::double precision < -69
			THEN ST_SetSRID(ST_MakePoint(gis_longitude_x::double precision, gis_latitude_y::double precision),4326)
		END),
    -- geomsource
    'Agency',
	-- facilityname
	initcap(popular_name),
	-- addressnumber
	split_part(trim(both ' ' from physical_address_line1), ' ', 1),
	-- streetname
	initcap(trim(both ' ' from substr(trim(both ' ' from physical_address_line1), strpos(trim(both ' ' from physical_address_line1), ' ')+1, (length(trim(both ' ' from physical_address_line1))-strpos(trim(both ' ' from physical_address_line1), ' '))))),
	-- address
	initcap(physical_address_line1),
	-- borough
		(CASE
			WHEN County_Desc = 'NEW YORK' THEN 'Manhattan'
			WHEN County_Desc = 'BRONX' THEN 'Bronx'
			WHEN County_Desc = 'KINGS' THEN 'Brooklyn'
			WHEN County_Desc = 'QUEENS' THEN 'Queens'
			WHEN County_Desc = 'RICHMOND' THEN 'Staten Island'
		END),
	-- zipcode
	zipcd5::integer,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
		(CASE
			WHEN Institution_Sub_Type_Desc LIKE '%GED-ALTERNATIVE%' THEN 'GED and Alternative High School Equivalency'
			WHEN Institution_Sub_Type_Desc LIKE '%CHARTER SCHOOL%'
				THEN 'Charter K-12 Schools'
			WHEN Institution_Sub_Type_Desc LIKE '%MUSEUM%' THEN 'Museums'
			WHEN Institution_Sub_Type_Desc LIKE '%HISTORICAL%' THEN 'Historical Societies'
			WHEN Institution_Type_Desc LIKE '%LIBRARIES%' THEN 'Academic and Special Libraries'
			WHEN Institution_Type_Desc LIKE '%CHILD NUTRITION%' THEN 'Child Nutrition'
			WHEN Institution_Sub_Type_Desc LIKE '%PRE-SCHOOL%' AND (Institution_Sub_Type_Desc LIKE '%DISABILITIES%' OR Institution_Sub_Type_Desc LIKE '%SWD%')
				THEN 'Preschools for Students with Disabilities'
			WHEN (Institution_Type_Desc LIKE '%DISABILITIES%')
				THEN 'Public and Private Special Education Schools'
			WHEN Institution_Sub_Type_Desc LIKE '%PRE-K%' THEN 'Offices'
			WHEN (Institution_Type_Desc LIKE 'PUBLIC%') OR (Institution_Sub_Type_Desc LIKE 'PUBLIC%') THEN 'Public K-12 Schools'
			WHEN (Institution_Type_Desc LIKE '%COLLEGE%') OR (Institution_Type_Desc LIKE '%CUNY%') OR 
				(Institution_Type_Desc LIKE '%SUNY%') OR (Institution_Type_Desc LIKE '%SUNY%')
				THEN 'Colleges or Universities'
			WHEN Institution_Type_Desc LIKE '%PROPRIETARY%'
				THEN 'Proprietary Schools'
			WHEN Institution_Type_Desc LIKE '%NON-IMF%'
				THEN 'Public K-12 Schools'
			ELSE 'Non-Public K-12 Schools'
		END),
	-- facilitytype
		(CASE
			WHEN Institution_Sub_Type_Desc LIKE '%CHARTER SCHOOL%'
				THEN 'Charter School'
			WHEN Institution_Type_Desc = 'CUNY'
				THEN CONCAT('CUNY - ', initcap(right(Institution_Sub_Type_Desc,-5)))
			WHEN Institution_Type_Desc = 'SUNY' 
				THEN CONCAT('SUNY - ', initcap(right(Institution_Sub_Type_Desc,-5)))
			WHEN Institution_Type_Desc = 'NON-PUBLIC SCHOOLS'
				AND (prek::numeric+halfk::numeric+fullk::numeric+gr1::numeric+gr2::numeric+gr3::numeric+gr4::numeric+gr5::numeric+uge::numeric)>0
				THEN 'Elementary School - Non-public'
			WHEN Institution_Type_Desc = 'NON-PUBLIC SCHOOLS'
				AND (gr6::numeric+gr7::numeric+gr8::numeric)>0
				THEN 'Middle School - Non-public'
			WHEN Institution_Type_Desc = 'NON-PUBLIC SCHOOLS'
				AND (gr9::numeric+gr10::numeric+gr11::numeric+gr12::numeric+ugs::numeric)>0
				THEN 'High School - Non-public'
			WHEN Institution_Type_Desc = 'NON-PUBLIC SCHOOLS'
				AND Institution_Sub_Type_Desc NOT LIKE 'ESL'
				AND Institution_Sub_Type_Desc NOT LIKE 'BUILDING'
				THEN 'Other School - Non-public'
			WHEN Institution_Sub_Type_Desc LIKE '%AHSEP%'
				THEN initcap(split_part(Institution_Sub_Type_Desc,'(',1))
			ELSE initcap(Institution_Sub_Type_Desc)
		END),
	-- operatortype
		(CASE
			WHEN Institution_Type_Desc = 'Public K-12 Schools' THEN 'Public'
			WHEN Institution_Type_Desc LIKE '%NON-IMF%' THEN 'Public'
			WHEN Institution_Type_Desc = 'CUNY' THEN 'Public'
			WHEN Institution_Type_Desc = 'SUNY' THEN 'Public'
			ELSE 'Non-public'
		END),
	-- operatorname
		(CASE
			WHEN Institution_Type_Desc = 'Public K-12 Schools' THEN 'NYC Department of Education'
			WHEN Institution_Type_Desc LIKE '%NON-IMF%' THEN 'NYC Department of Education'
			WHEN Institution_Type_Desc = 'CUNY' THEN 'City University of New York'
			WHEN Institution_Type_Desc = 'SUNY' THEN 'State University of New York'
			ELSE initcap(Legal_Name)
		END),
	-- operator abbrev
		(CASE
			WHEN Institution_Type_Desc = 'Public K-12 Schools' THEN 'NYCDOE'
			WHEN Institution_Type_Desc = 'Public K-12 Schools' THEN 'NYCDOE'
			WHEN Institution_Type_Desc = 'CUNY' THEN 'CUNY'
			WHEN Institution_Type_Desc = 'SUNY' THEN 'SUNY'
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
			WHEN Institution_Sub_Type_Desc LIKE '%RESIDENTIAL%' THEN TRUE
			ELSE FALSE
		END)
FROM
	(SELECT
		nysed_facilities_activeinstitutions.*,
		nysed_nonpublicenrollment.*,
		(CASE 
			WHEN (prek::numeric+halfk::numeric+fullk::numeric+gr1::numeric+gr2::numeric+gr3::numeric+gr4::numeric+gr5::numeric+gr6::numeric+uge::numeric+gr7::numeric+gr8::numeric+gr9::numeric+gr10::numeric+gr11::numeric+gr12::numeric+ugs::numeric) IS NOT NULL THEN (prek::numeric+halfk::numeric+fullk::numeric+gr1::numeric+gr2::numeric+gr3::numeric+gr4::numeric+gr5::numeric+gr6::numeric+uge::numeric+gr7::numeric+gr8::numeric+gr9::numeric+gr10::numeric+gr11::numeric+gr12::numeric+ugs::numeric)
			ELSE NULL
		END) AS enrollment
		FROM nysed_facilities_activeinstitutions
		LEFT JOIN nysed_nonpublicenrollment
		ON trim(replace(nysed_nonpublicenrollment.beds_code,',',''),' ')::text = nysed_facilities_activeinstitutions.sed_code::text
		) AS nysed_facilities_activeinstitutions
WHERE
	(Institution_Type_Desc = 'PUBLIC SCHOOLS' AND Institution_Sub_Type_Desc LIKE '%GED%')
	OR Institution_Sub_Type_Desc LIKE '%CHARTER SCHOOL%'
	OR (Institution_Type_Desc <> 'PUBLIC SCHOOLS'
	AND Institution_Type_Desc <> 'NON-IMF SCHOOLS'
	AND Institution_Type_Desc <> 'GOVERNMENT AGENCIES' -- MAY ACTUALLY WANT TO USE THESE
	AND Institution_Type_Desc <> 'INDEPENDENT ORGANIZATIONS'
	AND Institution_Type_Desc <> 'LIBRARY SYSTEMS'
	AND Institution_Type_Desc <> 'LOCAL GOVERNMENTS'
	AND Institution_Type_Desc <> 'SCHOOL DISTRICTS'
	AND Institution_Sub_Type_Desc <> 'PUBLIC LIBRARIES'
	AND Institution_Sub_Type_Desc <> 'HISTORICAL RECORDS REPOSITORIES'
	AND Institution_Sub_Type_Desc <> 'CHARTER CORPORATION'
	AND Institution_Sub_Type_Desc <> 'HOME BOUND'
	AND Institution_Sub_Type_Desc <> 'HOME INSTRUCTED'
	AND Institution_Sub_Type_Desc <> 'NYC BUREAU'
	AND Institution_Sub_Type_Desc <> 'NYC NETWORK'
	AND Institution_Sub_Type_Desc <> 'OUT OF DISTRICT PLACEMENT'
	AND Institution_Sub_Type_Desc <> 'BUILDINGS UNDER CONSTRUCTION');

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM (SELECT
		nysed_facilities_activeinstitutions.*,
		nysed_nonpublicenrollment.*,
		(CASE 
			WHEN (prek::numeric+halfk::numeric+fullk::numeric+gr1::numeric+gr2::numeric+gr3::numeric+gr4::numeric+gr5::numeric+gr6::numeric+uge::numeric+gr7::numeric+gr8::numeric+gr9::numeric+gr10::numeric+gr11::numeric+gr12::numeric+ugs::numeric) IS NOT NULL THEN (prek::numeric+halfk::numeric+fullk::numeric+gr1::numeric+gr2::numeric+gr3::numeric+gr4::numeric+gr5::numeric+gr6::numeric+uge::numeric+gr7::numeric+gr8::numeric+gr9::numeric+gr10::numeric+gr11::numeric+gr12::numeric+ugs::numeric)
			ELSE NULL
		END) AS enrollment
		FROM nysed_facilities_activeinstitutions
		LEFT JOIN nysed_nonpublicenrollment
		ON trim(replace(nysed_nonpublicenrollment.beds_code,',',''),' ')::text = nysed_facilities_activeinstitutions.sed_code::text
		) AS nysed_facilities_activeinstitutions
WHERE
	(Institution_Type_Desc = 'PUBLIC SCHOOLS' AND Institution_Sub_Type_Desc LIKE '%GED%')
	OR Institution_Sub_Type_Desc LIKE '%CHARTER SCHOOL%'
	OR (Institution_Type_Desc <> 'PUBLIC SCHOOLS'
	AND Institution_Type_Desc <> 'NON-IMF SCHOOLS'
	AND Institution_Type_Desc <> 'GOVERNMENT AGENCIES' -- MAY ACTUALLY WANT TO USE THESE
	AND Institution_Type_Desc <> 'INDEPENDENT ORGANIZATIONS'
	AND Institution_Type_Desc <> 'LIBRARY SYSTEMS'
	AND Institution_Type_Desc <> 'LOCAL GOVERNMENTS'
	AND Institution_Type_Desc <> 'SCHOOL DISTRICTS'
	AND Institution_Sub_Type_Desc <> 'PUBLIC LIBRARIES'
	AND Institution_Sub_Type_Desc <> 'HISTORICAL RECORDS REPOSITORIES'
	AND Institution_Sub_Type_Desc <> 'CHARTER CORPORATION'
	AND Institution_Sub_Type_Desc <> 'HOME BOUND'
	AND Institution_Sub_Type_Desc <> 'HOME INSTRUCTED'
	AND Institution_Sub_Type_Desc <> 'NYC BUREAU'
	AND Institution_Sub_Type_Desc <> 'NYC NETWORK'
	AND Institution_Sub_Type_Desc <> 'OUT OF DISTRICT PLACEMENT'
	AND Institution_Sub_Type_Desc <> 'BUILDINGS UNDER CONSTRUCTION')
AND hash NOT IN (
SELECT hash FROM facdb_uid_key
);
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
	'nysed_facilities_activeinstitutions'
FROM nysed_facilities_activeinstitutions, facilities
WHERE facilities.hash = nysed_facilities_activeinstitutions.hash;

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
	'NA',
	Sed_Code,
	'Sed_Code'
FROM nysed_facilities_activeinstitutions, facilities
WHERE facilities.hash = nysed_facilities_activeinstitutions.hash;

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
	NULL,
	(CASE 
		WHEN enrollment IS NOT NULL THEN 'Seats'
		ELSE NULL
	END)
FROM (SELECT
		nysed_facilities_activeinstitutions.*,
		nysed_nonpublicenrollment.*,
		(CASE 
			WHEN (prek::numeric+halfk::numeric+fullk::numeric+gr1::numeric+gr2::numeric+gr3::numeric+gr4::numeric+gr5::numeric+gr6::numeric+uge::numeric+gr7::numeric+gr8::numeric+gr9::numeric+gr10::numeric+gr11::numeric+gr12::numeric+ugs::numeric) IS NOT NULL THEN (prek::numeric+halfk::numeric+fullk::numeric+gr1::numeric+gr2::numeric+gr3::numeric+gr4::numeric+gr5::numeric+gr6::numeric+uge::numeric+gr7::numeric+gr8::numeric+gr9::numeric+gr10::numeric+gr11::numeric+gr12::numeric+ugs::numeric)
			ELSE NULL
		END) AS enrollment
		FROM nysed_facilities_activeinstitutions
		LEFT JOIN nysed_nonpublicenrollment
		ON trim(replace(nysed_nonpublicenrollment.beds_code,',',''),' ')::text = nysed_facilities_activeinstitutions.sed_code::text
		) AS nysed_facilities_activeinstitutions
WHERE
	(Institution_Type_Desc = 'PUBLIC SCHOOLS' AND Institution_Sub_Type_Desc LIKE '%GED%')
	OR Institution_Sub_Type_Desc LIKE '%CHARTER SCHOOL%'
	OR (Institution_Type_Desc <> 'PUBLIC SCHOOLS'
	AND Institution_Type_Desc <> 'NON-IMF SCHOOLS'
	AND Institution_Type_Desc <> 'GOVERNMENT AGENCIES' -- MAY ACTUALLY WANT TO USE THESE
	AND Institution_Type_Desc <> 'INDEPENDENT ORGANIZATIONS'
	AND Institution_Type_Desc <> 'LIBRARY SYSTEMS'
	AND Institution_Type_Desc <> 'LOCAL GOVERNMENTS'
	AND Institution_Type_Desc <> 'SCHOOL DISTRICTS'
	AND Institution_Sub_Type_Desc <> 'PUBLIC LIBRARIES'
	AND Institution_Sub_Type_Desc <> 'HISTORICAL RECORDS REPOSITORIES'
	AND Institution_Sub_Type_Desc <> 'CHARTER CORPORATION'
	AND Institution_Sub_Type_Desc <> 'HOME BOUND'
	AND Institution_Sub_Type_Desc <> 'HOME INSTRUCTED'
	AND Institution_Sub_Type_Desc <> 'NYC BUREAU'
	AND Institution_Sub_Type_Desc <> 'NYC NETWORK'
	AND Institution_Sub_Type_Desc <> 'OUT OF DISTRICT PLACEMENT'
	AND Institution_Sub_Type_Desc <> 'BUILDINGS UNDER CONSTRUCTION') 
AND facilities.hash = nysed_facilities_activeinstitutions.hash,
facilities;

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
    (CASE
		WHEN Institution_Type_Desc = 'Public K-12 Schools' THEN 'NYC Department of Education, NYS Education Department'
		WHEN Institution_Type_Desc LIKE '%NON-IMF%' THEN 'NYC Department of Education, NYS Education Department'
		ELSE 'NYS Education Department'
	END),
    (CASE
		WHEN Institution_Type_Desc = 'Public K-12 Schools' THEN 'NYCDOE, NYSED'
		WHEN Institution_Type_Desc LIKE '%NON-IMF%' THEN 'NYCDOE, NYSED'
		ELSE 'NYSED'
	END),
    NULL
FROM nysed_facilities_activeinstitutions, facilities
WHERE facilities.hash = nysed_facilities_activeinstitutions.hash;

-- utilization
INSERT INTO
facdb_utilization(
	uid,
	util,
	utiltype
)
SELECT
	uid,
	enrollment::text,
	'Seats'
FROM 	(SELECT
		nysed_facilities_activeinstitutions.*,
		nysed_nonpublicenrollment.*,
		(CASE 
			WHEN (prek::numeric+halfk::numeric+fullk::numeric+gr1::numeric+gr2::numeric+gr3::numeric+gr4::numeric+gr5::numeric+gr6::numeric+uge::numeric+gr7::numeric+gr8::numeric+gr9::numeric+gr10::numeric+gr11::numeric+gr12::numeric+ugs::numeric) IS NOT NULL THEN (prek::numeric+halfk::numeric+fullk::numeric+gr1::numeric+gr2::numeric+gr3::numeric+gr4::numeric+gr5::numeric+gr6::numeric+uge::numeric+gr7::numeric+gr8::numeric+gr9::numeric+gr10::numeric+gr11::numeric+gr12::numeric+ugs::numeric)
			ELSE NULL
		END) AS enrollment
		FROM nysed_facilities_activeinstitutions
		LEFT JOIN nysed_nonpublicenrollment
		ON trim(replace(nysed_nonpublicenrollment.beds_code,',',''),' ')::text = nysed_facilities_activeinstitutions.sed_code::text
		) AS nysed_facilities_activeinstitutions, facilities
WHERE facilities.hash = nysed_facilities_activeinstitutions.hash;

