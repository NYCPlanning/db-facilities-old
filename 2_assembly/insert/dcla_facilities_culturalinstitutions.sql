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
	Organization_Name,
	-- addressnumber
	split_part(trim(both ' ' from initcap(Address)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(Address)), strpos(trim(both ' ' from initcap(Address)), ' ')+1, (length(trim(both ' ' from initcap(Address)))-strpos(trim(both ' ' from initcap(Address)), ' ')))),
	-- address
	initcap(Address),
	-- borough
	borough,
	-- zipcode
	left(zip_code,5)::integer,
	-- domain
	'Libraries and Cultural Programs',
	-- facilitygroup
	'Cultural Institutions',
	-- facilitysubgroup
		(CASE
			WHEN Discipline LIKE '%Museum%' THEN 'Museums'
			ELSE 'Other Cultural Institutions'
		END),
	-- facilitytype
		(CASE
			WHEN Discipline IS NOT NULL THEN Discipline
			ELSE 'Unspecified Discipline'
		END),
-- operatortype
	'Non-public',
	-- operatorname
	Organization_Name,
	-- operatorabbrev
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
	dcla_facilities_culturalinstitutions;

-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dcla_facilities_culturalinstitutions
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
	'dcla_facilities_culturalinstitutions'
FROM dcla_facilities_culturalinstitutions, facilities
WHERE facilities.hash = dcla_facilities_culturalinstitutions.hash;

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
--FROM dcla_facilities_culturalinstitutions, facilities
--WHERE facilities.hash = dcla_facilities_culturalinstitutions.hash;
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
--FROM dcla_facilities_culturalinstitutions, facilities
--WHERE facilities.hash = dcla_facilities_culturalinstitutions.hash;
--
--INSERT INTO
--facdb_bbl(
--	uid,
--	bbl
--)
--SELECT
--	uid,
--
--FROM dcla_facilities_culturalinstitutions, facilities
--WHERE facilities.hash = dcla_facilities_culturalinstitutions.hash;
--
--INSERT INTO
--facdb_bin(
--	uid,
--	bin
--)
--SELECT
--	uid,
--
--FROM dcla_facilities_culturalinstitutions, facilities
--WHERE facilities.hash = dcla_facilities_culturalinstitutions.hash;
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
--FROM dcla_facilities_culturalinstitutions, facilities
--WHERE facilities.hash = dcla_facilities_culturalinstitutions.hash;


INSERT INTO
facdb_oversight(
	uid,
	overagency,
	overabbrev,
	overlevel
)
SELECT
	uid,
        'NYC Department of Cultural Affairs',
        'NYCDCLA',
        'City'
FROM dcla_facilities_culturalinstitutions, facilities
WHERE facilities.hash = dcla_facilities_culturalinstitutions.hash;

--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid,
--
--FROM dcla_facilities_culturalinstitutions, facilities
--WHERE facilities.hash = dcla_facilities_culturalinstitutions.hash;
--