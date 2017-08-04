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
		WHEN Building_Name IS NOT NULL AND Building_Name <> '' THEN Building_Name
		ELSE Building_Address
	END),
	-- addressnumber
	split_part(trim(both ' ' from initcap(Building_Address)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(Building_Address)), strpos(trim(both ' ' from initcap(Building_Address)), ' ')+1, (length(trim(both ' ' from initcap(Building_Address)))-strpos(trim(both ' ' from initcap(Building_Address)), ' ')))),
	-- address
	initcap(Building_Address),
	-- borough
		(CASE
			WHEN LEFT(DCP_RECORD,1) = 'B' THEN 'Brooklyn'
			WHEN LEFT(DCP_RECORD,1) = 'Q' THEN 'Queens'
			ELSE 'Manhattan'
		END),
	-- zipcode
	NULL,
	-- facilitydomain
	'Parks, Gardens, and Historical Sites',
	-- facilitygroup
	'Parks and Plazas',
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
	DCP_RECORD,
	'DCP Record ID'
FROM
	dcp_facilities_pops,
	facilities
WHERE
	facilities.hash = dcp_facilities_pops.hash;

-- INSERT INTO
-- facdb_area(
-- 	uid,
-- 	area,
-- 	areatype
-- )
-- SELECT
-- 	uid,

-- FROM
-- 	dcp_facilities_pops,
-- 	facilities
-- WHERE
-- 	facilities.hash = dcp_facilities_pops.hash;

-- INSERT INTO
-- facdb_bbl(
-- 	uid,
-- 	bbl
-- )
-- SELECT
-- 	uid,

-- FROM
-- 	dcp_facilities_pops,
-- 	facilities
-- WHERE
-- 	facilities.hash = dcp_facilities_pops.hash;

-- INSERT INTO
-- facdb_bin(
-- 	uid,
-- 	bin
-- )
-- SELECT
-- 	uid,

-- FROM
-- 	dcp_facilities_pops,
-- 	facilities
-- WHERE
-- 	facilities.hash = dcp_facilities_pops.hash;

-- INSERT INTO
-- facdb_capacity(
--    uid,
--    capacity,
--    capacitytype
-- )
-- SELECT
-- 	uid,

-- FROM
-- 	dcp_facilities_pops,
-- 	facilities
-- WHERE
-- 	facilities.hash = dcp_facilities_pops.hash;

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

INSERT INTO
facdb_oversight(
	uid,
	overagency,
	overabbrev,
	overlevel
)
SELECT
	uid,
	'NYC Department of Buildings',
	'NYCDOB',
	'City'
FROM
	dcp_facilities_pops,
	facilities
WHERE
	facilities.hash = dcp_facilities_pops.hash;

-- INSERT INTO
-- facdb_utilization(
-- 	uid,
-- 	util,
-- 	utiltype
-- )
-- SELECT
-- 	uid,

-- FROM
-- 	dcp_facilities_pops,
-- 	facilities
-- WHERE
-- 	facilities.hash = dcp_facilities_pops.hash;