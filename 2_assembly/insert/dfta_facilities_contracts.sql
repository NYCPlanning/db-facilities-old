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
	initcap(Sponsor_Name),
	-- addressnumber
	split_part(trim(both ' ' from initcap(Program_Address)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(Program_Address)), strpos(trim(both ' ' from initcap(Program_Address)), ' ')+1, (length(trim(both ' ' from initcap(Program_Address)))-strpos(trim(both ' ' from initcap(Program_Address)), ' ')))),
	-- address
	initcap(Program_Address),
	-- borough
	NULL,
	-- zipcode
	Program_Zipcode::integer,
	-- domain
	'Health and Human Services',
	-- facilitygroup
	'Human Services',
	-- facilitysubgroup
	'Senior Services',
	-- facilitytype
		(CASE
			WHEN Contract_Type LIKE '%INNOVATIVE%' AND RIGHT(Provider_ID,2) <> '01' THEN 'Satellite Senior Centers'
			WHEN Contract_Type LIKE '%NEIGHBORHOOD%' AND RIGHT(Provider_ID,2) <> '01' THEN 'Satellite Senior Centers'
			WHEN Contract_Type LIKE '%INNOVATIVE%' THEN 'Innovative Senior Centers'
			WHEN Contract_Type LIKE '%NEIGHBORHOOD%' THEN 'Neighborhood Senior Centers'
			WHEN Contract_Type LIKE '%MEALS%' THEN  initcap(Contract_Type)
			ELSE 'Senior Services'
		END),
	-- operatortype
	'Non-public',
	-- operatorname
	initcap(Sponsor_Name),
	-- operatorabbrev
	'Non-public',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
	FALSE,
	-- youth
	FALSE,
	-- senior
	TRUE,
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
	dfta_facilities_contracts;

-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dfta_facilities_contracts
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
	'dfta_facilities_contracts'
FROM dfta_facilities_contracts, facilities
WHERE facilities.hash = dfta_facilities_contracts.hash;

INSERT INTO
facdb_agencyid(
	uid,
	overabbrev,
	idagency,
	idname
)
SELECT
	uid,
	'NYCDFTA',
	Provider_ID,
	'Provider ID'
FROM dfta_facilities_contracts, facilities
WHERE facilities.hash = dfta_facilities_contracts.hash;

--INSERT INTO
--facdb_area(
--	uid,
--	area,
--	areatype
--)
--SELECT
--	uid,
--
--FROM dfta_facilities_contracts, facilities
--WHERE facilities.hash = dfta_facilities_contracts.hash;
--
--INSERT INTO
--facdb_bbl(
--	uid,
--	bbl
--)
--SELECT
--	uid,
--
--FROM dfta_facilities_contracts, facilities
--WHERE facilities.hash = dfta_facilities_contracts.hash;
--
--INSERT INTO
--facdb_bin(
--	uid,
--	bin
--)
--SELECT
--	uid,
--
--FROM dfta_facilities_contracts, facilities
--WHERE facilities.hash = dfta_facilities_contracts.hash;
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
--FROM dfta_facilities_contracts, facilities
--WHERE facilities.hash = dfta_facilities_contracts.hash;


INSERT INTO
facdb_oversight(
	uid,
	overagency,
	overabbrev,
	overlevel
)
SELECT
	uid,
    'NYC Department for the Aging',
    'NYCDFTA',
    'City'
FROM dfta_facilities_contracts, facilities
WHERE facilities.hash = dfta_facilities_contracts.hash;

--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid,
--
--FROM dfta_facilities_contracts, facilities
--WHERE facilities.hash = dfta_facilities_contracts.hash;
--

