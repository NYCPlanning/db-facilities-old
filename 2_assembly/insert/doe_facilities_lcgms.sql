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
	initcap(LocationName),
	-- addressnumber
	split_part(doe_facilities_schoolsbluebook.Address,' ',1),
	-- streetname
	initcap(trim(both ' ' from substr(trim(both ' ' from doe_facilities_schoolsbluebook.Address), strpos(trim(both ' ' from doe_facilities_schoolsbluebook.Address), ' ')+1, (length(trim(both ' ' from doe_facilities_schoolsbluebook.Address))-strpos(trim(both ' ' from doe_facilities_schoolsbluebook.Address), ' '))))),
	-- address
	initcap(doe_facilities_schoolsbluebook.Address),
	-- borough
		(CASE
			WHEN LEFT(LocationCode,1) = 'M' THEN 'Manhattan'
			WHEN LEFT(LocationCode,1) = 'X' THEN 'Bronx'
			WHEN LEFT(LocationCode,1) = 'K' THEN 'Brooklyn'
			WHEN LEFT(LocationCode,1) = 'Q' THEN 'Queens'
			WHEN LEFT(LocationCode,1) = 'R' THEN 'Staten Island'
		END),
	-- zipcode
	doe_facilities_schoolsbluebook.Zip::numeric,
	-- domain
	'Education, Child Welfare, and Youth',
	-- facilitygroup
	NULL,
	-- facilitysubgroup
		(CASE
			WHEN LocationTypeDescription LIKE '%Special%' THEN 'Public and Private Special Education Schools'
			WHEN LocationCategoryDescription LIKE '%Early%' OR LocationCategoryDescription LIKE '%Pre-K%' THEN 'DOE Universal Pre-Kindergarten'
			WHEN ManagedByName = 'Charter' THEN 'Charter K-12 Schools'
			ELSE 'Public K-12 Schools'
		END),
	-- facilitytype
		(CASE
			WHEN ManagedByName = 'Charter' AND lower(LocationCategoryDescription) LIKE '%school%' THEN CONCAT(LocationCategoryDescription, ' - Charter')
			WHEN ManagedByName = 'Charter' THEN CONCAT(LocationCategoryDescription, ' School - Charter')
			WHEN lower(LocationCategoryDescription) LIKE '%school%' THEN CONCAT(LocationCategoryDescription, ' - Public')
			ELSE CONCAT(LocationCategoryDescription, ' School - Public')
		END),
	-- operatortype
		(CASE
			WHEN ManagedByName = 'Charter' THEN 'Non-public'
			ELSE 'Public'
		END),
	-- operatorname
		(CASE
			WHEN ManagedByName = 'Charter' THEN LocationName
			ELSE 'NYC Department of Education'
		END),
	-- operator abbrev
		(CASE
			WHEN ManagedByName = 'Charter' THEN 'Non-public'
			ELSE 'NYCDOE'
		END),
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
		(CASE
			WHEN LocationCategoryDescription LIKE '%Pre-K%' OR LocationCategoryDescription LIKE '%Elementary%' OR LocationCategoryDescription LIKE '%Early%' OR LocationCategoryDescription LIKE '%K-%' THEN TRUE
			ELSE FALSE
		END),
	-- youth
		(CASE
			WHEN LocationCategoryDescription LIKE '%High%' OR LocationCategoryDescription LIKE '%Secondary%' OR LocationCategoryDescription LIKE '%K-12%' THEN TRUE
			ELSE FALSE
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
FROM
	doe_facilities_lcgms;

-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM doe_facilities_lcgms
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
	'doe_facilities_lcgms'
FROM doe_facilities_lcgms, facilities
WHERE facilities.hash = doe_facilities_lcgms.hash;

INSERT INTO
facdb_agencyid(
	uid,
	overabbrev,
	idagency,
	idname
)
SELECT
	uid,
	'NYCDOE',
	LocationCode,
	'DOE Location Code'
FROM doe_facilities_lcgms, facilities
WHERE facilities.hash = doe_facilities_lcgms.hash;

INSERT INTO
facdb_agencyid(
	uid,
	overabbrev,
	idagency,
	idname
)
SELECT
	uid,
	'NYCDOE',
	BuildingCode,
	'DOE Building Code'
FROM doe_facilities_lcgms, facilities
WHERE facilities.hash = doe_facilities_lcgms.hash;

--INSERT INTO
--facdb_area(
--	uid,
--	area,
--	areatype
--)
--SELECT
--	uid,
--
--FROM doe_facilities_lcgms, facilities
--WHERE facilities.hash = doe_facilities_lcgms.hash;

INSERT INTO
facdb_bbl(
	uid,
	bbl
)
SELECT
	uid,
	(CASE
		WHEN BoroughBlockLot <> '0' THEN ARRAY[BoroughBlockLot]
	END)
FROM doe_facilities_lcgms, facilities
WHERE facilities.hash = doe_facilities_lcgms.hash;

--INSERT INTO
--facdb_bin(
--	uid,
--	bin
--)
--SELECT
--	uid,
--
--FROM doe_facilities_lcgms, facilities
--WHERE facilities.hash = doe_facilities_lcgms.hash;
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
--FROM doe_facilities_lcgms, facilities
--WHERE facilities.hash = doe_facilities_lcgms.hash;

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
FROM doe_facilities_lcgms, facilities
WHERE facilities.hash = doe_facilities_lcgms.hash;

--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid,
--
--FROM doe_facilities_lcgms, facilities
--WHERE facilities.hash = doe_facilities_lcgms.hash;
--