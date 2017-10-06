INSERT INTO
facilities (
	pgtable,
	hash,
	geom,
	idagency,
	idname,
	idfield,
	facname,
	addressnum,
	streetname,
	address,
	boro,
	zipcode,
	bbl,
	bin,
	geomsource,
	factype,
	facsubgrp,
	capacity,
	util,
	capacitytype,
	utilrate,
	area,
	areatype,
	optype,
	opname,
	opabbrev,
	overagency,
	overabbrev,
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
	-- pgtable
	'doe_facilities_universalprek',
	-- hash,
    hash,
	-- geom
	ST_Transform(ST_SetSRID(ST_MakePoint(x, y),2263),4326),
	-- idagency
	LOCCODE,
	'DOE Location Code',
	'loccode',
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
	-- bbl
	NULL,
	-- bin
	NULL,
	'agency',
	-- facilitytype
		(CASE
			WHEN PreK_Type = 'DOE' THEN 'DOE Universal Pre-K'
			WHEN PreK_Type = 'CHARTER' OR PreK_Type = 'Charter' THEN 'DOE Universal Pre-K - Charter '
			WHEN PreK_Type = 'NYCEEC' THEN 'Early Education Program'
		END),
	-- facilitysubgroup
	'DOE Universal Pre-Kindergarten',
	-- capacity
	Seats::text,
	-- utilization
	NULL,
	-- capacitytype
	'Seats Overseen by DOE',
	-- utilizationrate
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
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
	-- oversightagency
	'NYC Department of Education',
	-- oversightabbrev
	'NYCDOE',
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
	doe_facilities_universalprek