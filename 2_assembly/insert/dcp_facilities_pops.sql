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
    -- uid,
    NULL,
	-- geom
	NULL,
	-- geomsource
	'None',
	-- facilityname
	(CASE
		WHEN building_name IS NOT NULL AND building_name <> '' THEN building_name
		ELSE building_address
	END),
	-- addressnumber
	split_part(trim(both ' ' from initcap(building_address)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(building_address)), strpos(trim(both ' ' from initcap(building_address)), ' ')+1, (length(trim(both ' ' from initcap(building_address)))-strpos(trim(both ' ' from initcap(building_address)), ' ')))),
	-- address
	initcap(building_address),
	-- borough
		(CASE
			WHEN LEFT(dcp_record,1) = 'B' THEN 'Brooklyn'
			WHEN LEFT(dcp_record,1) = 'Q' THEN 'Queens'
			ELSE 'Manhattan'
		END),
	-- zipcode
	NULL,
	-- facilitydomain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	'Privately Owned Public Space',
	-- facilitytype
	'Privately Owned Public Space',
	-- operatortype
	'Non-public',
	-- operatorname
	'Not Available',
	-- operator abbrev
	'Non-public',
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
	FALSE
FROM
	dcp_facilities_pops;

-- facdb_uid_key
-- Insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dcp_facilities_pops
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
);
-- JOIN uid FROM KEY ONTO DATABASE
UPDATE facilities AS f
SET uid = k.uid
FROM facdb_uid_key AS k
WHERE k.hash = f.hash AND f.uid IS NULL;

-- pgtable
INSERT INTO
facdb_pgtable(
   uid,
   pgtable
)
SELECT
	uid,
	'dcp_facilities_pops'
FROM
	dcp_facilities_pops,
	facilities
WHERE
	facilities.hash = dcp_facilities_pops.hash;

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
	'NYCDCP',
	dcp_record,
	'DCP Record ID'
FROM
	dcp_facilities_pops,
	facilities
WHERE
	facilities.hash = dcp_facilities_pops.hash;

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
	'NYC Department of City Planning',
	'NYCDCP',
	'City'
FROM
	dcp_facilities_pops,
	facilities
WHERE
	facilities.hash = dcp_facilities_pops.hash;

-- utilization NA
