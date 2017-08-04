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
	ST_Transform(ST_SetSRID(ST_MakePoint(x, y),2263),4326),
    -- geomsource
    'Agency',
	-- facilityname
	LocName,
	-- addressnumber
	split_part(trim(both ' ' from REPLACE(address,' - ','-')), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from REPLACE(address,' - ','-')), strpos(trim(both ' ' from REPLACE(address,' - ','-')), ' ')+1, (length(trim(both ' ' from REPLACE(address,' - ','-')))-strpos(trim(both ' ' from REPLACE(address,' - ','-')), ' ')))),
	-- address
	REPLACE(address,' - ','-'),
	-- borough
		(CASE
			WHEN Borough = 'M' THEN 'Manhattan'
			WHEN Borough = 'X' THEN 'Bronx'
			WHEN Borough = 'K' THEN 'Brooklyn'
			WHEN Borough = 'Q' THEN 'Queens'
			WHEN Borough = 'R' THEN 'Staten Island'
		END),
	-- zipcode
	zip::integer,
	-- domain
	'Education, Child Welfare, and Youth',
	-- facilitygroup
	'Child Care and Pre-Kindergarten',
	-- facilitysubgroup
	'DOE Universal Pre-Kindergarten',
	-- facilitytype
		(CASE
			WHEN PreK_Type = 'DOE' THEN 'DOE Universal Pre-K'
			WHEN PreK_Type = 'CHARTER' OR PreK_Type = 'Charter' THEN 'DOE Universal Pre-K - Charter '
			WHEN PreK_Type = 'NYCEEC' THEN 'Early Education Program'
		END),
	-- operatortype
		(CASE
			WHEN PreK_Type = 'DOE' THEN 'Public'
			ELSE 'Non-public'
		END),
	-- operatorname
		(CASE
			WHEN PreK_Type = 'DOE' THEN 'NYC Department of Education'
			WHEN PreK_Type = 'CHARTER' THEN LocName
			WHEN PreK_Type = 'NYCEEC' THEN LocName
			ELSE 'Unknown'
		END),
	-- operatorabbrev
		(CASE
			WHEN PreK_Type = 'DOE' THEN 'NYCDOE'
			WHEN PreK_Type = 'CHARTER' THEN 'Charter'
			WHEN PreK_Type = 'NYCEEC' THEN 'Non-public'
			ELSE 'Unknown'
		END),
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
	TRUE,
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
	doe_facilities_universalprek;

-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM doe_facilities_universalprek
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
	'doe_facilities_universalprek'
FROM doe_facilities_universalprek, facilities
WHERE facilities.hash = doe_facilities_universalprek.hash;

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
	LOCCODE,
	'DOE Location Code'
FROM doe_facilities_universalprek, facilities
WHERE facilities.hash = doe_facilities_universalprek.hash;

--INSERT INTO
--facdb_area(
--	uid,
--	area,
--	areatype
--)
--SELECT
--	uid,
--
--FROM doe_facilities_universalprek, facilities
--WHERE facilities.hash = doe_facilities_universalprek.hash;

-- no bbl column in source table?
--INSERT INTO
--facdb_bbl(
--	uid,
--	bbl
--)
--SELECT
--	uid,
--	(CASE
--		WHEN BoroughBlockLot <> '0' THEN BoroughBlockLot
--	END)
--FROM doe_facilities_universalprek, facilities
--WHERE facilities.hash = doe_facilities_universalprek.hash;
--
--INSERT INTO
--facdb_bin(
--	uid,
--	bin
--)
--SELECT
--	uid,
--
--FROM doe_facilities_universalprek, facilities
--WHERE facilities.hash = doe_facilities_universalprek.hash;

INSERT INTO
facdb_capacity(
  uid,
  capacity,
  capacitytype
)
SELECT
	uid,
	Seats::text,
	'Student Seats Overseen by DOE'
FROM doe_facilities_universalprek, facilities
WHERE facilities.hash = doe_facilities_universalprek.hash;

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
FROM doe_facilities_universalprek, facilities
WHERE facilities.hash = doe_facilities_universalprek.hash;

--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid
--FROM doe_facilities_universalprek, facilities
--WHERE facilities.hash = doe_facilities_universalprek.hash;
