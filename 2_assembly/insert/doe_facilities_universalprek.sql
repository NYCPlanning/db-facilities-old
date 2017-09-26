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
			WHEN borough = 'M' THEN 'Manhattan'
			WHEN borough = 'X' THEN 'Bronx'
			WHEN borough = 'K' THEN 'Brooklyn'
			WHEN borough = 'Q' THEN 'Queens'
			WHEN borough = 'R' THEN 'Staten Island'
		END),
	-- zipcode
	zip::integer,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	'DOE Universal Pre-Kindergarten',
	-- facilitytype
		(CASE
			WHEN prek_type = 'DOE' THEN 'DOE Universal Pre-K'
			WHEN prek_type = 'CHARTER' OR prek_type = 'Charter' THEN 'DOE Universal Pre-K - Charter '
			WHEN prek_type = 'NYCEEC' THEN 'Early Education Program'
		END),
	-- operatortype
		(CASE
			WHEN prek_type = 'DOE' THEN 'Public'
			ELSE 'Non-public'
		END),
	-- operatorname
		(CASE
			WHEN prek_type = 'DOE' THEN 'NYC Department of Education'
			WHEN prek_type = 'CHARTER' THEN locname
			WHEN prek_type = 'NYCEEC' THEN locname
			ELSE 'Unknown'
		END),
	-- operatorabbrev
		(CASE
			WHEN prek_type = 'DOE' THEN 'NYCDOE'
			WHEN prek_type = 'CHARTER' THEN 'Charter'
			WHEN prek_type = 'NYCEEC' THEN 'Non-public'
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

-- facdb_uid_key
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

-- pgtable
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

-- agency id
INSERT INTO
facdb_agencyid(
	uid,
	idagency,
	idname,
	idfield,
	idtable
)
SELECT
	uid,
	loccode,
	'DOE Location Code',
	'loccode',
	'doe_facilities_universalprek'
FROM doe_facilities_universalprek, facilities
WHERE facilities.hash = doe_facilities_universalprek.hash;

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
	seats::text,
	'Student Seats Overseen by DOE'
FROM doe_facilities_universalprek, facilities
WHERE facilities.hash = doe_facilities_universalprek.hash;

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
    'NYC Department of Education',
    'NYCDOE',
    'City'
FROM doe_facilities_universalprek, facilities
WHERE facilities.hash = doe_facilities_universalprek.hash;

-- utilization NA
