
-- facilities

-- facdb_uid_key

-- pgtable

-- agency id

-- area

-- bbl

-- bin

-- capacity

-- oversight

-- utilization

-- hashesmerged

-- oldid

-- uidsmerged


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
    -- uid
	-- geom
    -- geomsource
	-- facilityname
	-- addressnumber
	-- streetname
	-- address
	-- borough
	-- zipcode
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	-- facilitytype
	-- operatortype
	-- operatorname
	-- operator abbrev
	-- datecreated
	-- children
	-- youth
	-- senior
	-- family
	-- disabilities
	-- dropouts
	-- unemployed
	-- homeless
	-- immigrants
	-- groupquarters



-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM nysed_facilities_activeinstitutions
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
	'nysed_facilities_activeinstitutions'
FROM nysed_facilities_activeinstitutions, facilities
WHERE facilities.hash = nysed_facilities_activeinstitutions.hash;

INSERT INTO
facdb_agencyid(
	uid,
	overabbrev,
	idagency,
	idname
)
SELECT
	uid,
	(CASE
		WHEN Institution_Type_Desc = 'Public K-12 Schools' THEN ARRAY['NYCDOE', 'NYSED']
		WHEN Institution_Type_Desc LIKE '%NON-IMF%' THEN ARRAY['NYCDOE', 'NYSED']
		ELSE ARRAY['NYSED']
	END),
	Sed_Code,
	''
FROM nysed_facilities_activeinstitutions, facilities
WHERE facilities.hash = nysed_facilities_activeinstitutions.hash;
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
--FROM bic_facilities_tradewaste, facilities
--WHERE facilities.hash = bic_facilities_tradewaste.hash;
--
--INSERT INTO
--facdb_bbl(
--	uid,
--	bbl
--)
--SELECT
--	uid,
--
--FROM bic_facilities_tradewaste, facilities
--WHERE facilities.hash = bic_facilities_tradewaste.hash;
--
--INSERT INTO
--facdb_bin(
--	uid,
--	bin
--)
--SELECT
--	uid,
--
--FROM bic_facilities_tradewaste, facilities
--WHERE facilities.hash = bic_facilities_tradewaste.hash;
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
--FROM bic_facilities_tradewaste, facilities
--WHERE facilities.hash = bic_facilities_tradewaste.hash;

INSERT INTO
facdb_oversight(
	uid,
	overagency,
	overabbrev,
	overlevel
)
SELECT
	uid,
    'NYC Business Integrity Commission',
    'NYCBIC',
    'City'
FROM bic_facilities_tradewaste, facilities
WHERE facilities.hash = bic_facilities_tradewaste.hash;

--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid,
--
--FROM bic_facilities_tradewaste, facilities
--WHERE facilities.hash = bic_facilities_tradewaste.hash;