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
	(CASE
		WHEN x_coordinate IS NOT NULL THEN ST_Transform(ST_SetSRID(ST_MakePoint(x_coordinate, y_coordinate), 2236),4326)
	END),
    -- geomsource
    'Agency',
	-- facilityname
	initcap(facility_name),
	-- addressnumber
	address_number,
	-- streetname
	initcap(street_name),
	-- address
	CONCAT(address_number,' ',initcap(street_name)),
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
		WHEN (facility_type LIKE '%DROP%' OR facility_type LIKE '%Drop%') THEN 'Non-residential Housing and Homeless Services'
		WHEN facility_type LIKE '%Supportive Housing%' THEN 'Permanent Supportive SRO Housing' 
		ELSE 'Shelters and Transitional Housing'
	END),
	-- facilitytype
	initcap(facility_type),
	-- operatortype
		(CASE
			WHEN provider_name LIKE '%NYC Dept%' THEN 'Public'
			ELSE 'Non-public'
		END),
	-- operatorname
	initcap(provider_name),
	-- operatorabbrev
		(CASE
			WHEN provider_name LIKE '%NYC Dept%' THEN 'NYCDHS'
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
	(CASE
		WHEN facility_type LIKE '%Family%' THEN TRUE
		ELSE FALSE
	END),
	-- disabilities
	FALSE,
	-- dropouts
	FALSE,
	-- unemployed
	FALSE,
	-- homeless
	TRUE,
	-- immigrants
	FALSE,
	-- groupquarters
	TRUE
FROM
	dhs_facilities_shelters;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dhs_facilities_shelters
WHERE hash NOT IN (
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
	'dhs_facilities_shelters'
FROM dhs_facilities_shelters, facilities
WHERE facilities.hash = dhs_facilities_shelters.hash;

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
	'NYCDHS',
	(CASE
		WHEN unique_id IS NOT NULL THEN unique_id
	END),
	'Unique ID'
FROM dhs_facilities_shelters, facilities
WHERE facilities.hash = dhs_facilities_shelters.hash;

-- area NA

-- bbl
INSERT INTO
facdb_bbl(
	uid,
	bbl
)
SELECT
	uid,
	REPLACE(bbls,'|','')
FROM doe_facilities_busroutesgarages, facilities
WHERE facilities.hash = doe_facilities_busroutesgarages.hash;

-- bin
INSERT INTO
facdb_bin(
	uid,
	bin
)
SELECT
	uid,
	bin
FROM doe_facilities_busroutesgarages, facilities
WHERE facilities.hash = doe_facilities_busroutesgarages.hash;

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
		WHEN capacity <> '--' THEN capacity::text
	END),
	(CASE
		WHEN capacity <> '--' AND capacity IS NOT NULL THEN capacity_type
	END)
FROM dhs_facilities_shelters, facilities
WHERE facilities.hash = dhs_facilities_shelters.hash;

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
    'NYC Department of Homeless Services',
    'NYCDHS',
    'City'
FROM dhs_facilities_shelters, facilities
WHERE facilities.hash = dhs_facilities_shelters.hash;

-- utilization NA

