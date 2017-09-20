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
	initcap(facility_name),
	-- addressnumber
	split_part(trim(both ' ' from address_number), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from address_number), strpos(trim(both ' ' from address_number), ' ')+1, (length(trim(both ' ' from address_number))-strpos(trim(both ' ' from address_number), ' ')))),
	-- address
	address_number,
	-- borough
	initcap(borough),
	-- zipcode
	NULL,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
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
	dycd_facilities_otherprograms
GROUP BY
	hash,
    facility_name,
    facility_type,
    address_number,
	street_name,
	borough,
	bbls,
	bin,
	x_coordinate,
	y_coordinate,
	provider_name,
	date_source_data_updated;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dycd_facilities_otherprograms
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
)
GROUP BY
	hash,
    facility_name,
    facility_type,
    address_number,
	street_name,
	borough,
	bbls,
	bin,
	x_coordinate,
	y_coordinate,
	provider_name,
	date_source_data_updated;
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
	'dycd_facilities_otherprograms'
FROM dycd_facilities_otherprograms, facilities
WHERE facilities.hash = dycd_facilities_otherprograms.hash;

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
	'NYCDYCD',
	unique_id,
	'DYCD unique_id'
FROM dycd_facilities_otherprograms, facilities
WHERE facilities.hash = dycd_facilities_otherprograms.hash;

-- area NA

-- bbl NA

-- bin NA

-- capacity NA

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
    'NYC Department of Youth and Community Development',
    'NYCDYCD',
    'City'
FROM dycd_facilities_otherprograms, facilities
WHERE facilities.hash = dycd_facilities_otherprograms.hash;

-- utilization NA
