INSERT INTO
facilities (
	pgtable,
	hash,
	geom,
	idagency,
	facilityname,
	addressnumber,
	streetname,
	address,
	borough,
	zipcode,
	bbl,
	bin,
	facilitytype,
	domain,
	facilitygroup,
	facilitysubgroup,
	agencyclass1,
	agencyclass2,
	capacity,
	utilization,
	capacitytype,
	utilizationrate,
	area,
	areatype,
	operatortype,
	operatorname,
	operatorabbrev,
	oversightagency,
	oversightabbrev,
	datecreated,
	buildingid,
	buildingname,
	schoolorganizationlevel,
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
	ARRAY['doe_facilities_universalprek'],
	-- hash,
	md5(CAST((doe_facilities_universalprek.*) AS text)),
	-- geom
	ST_Transform(ST_SetSRID(ST_MakePoint(x, y),2263),4326),
	-- idagency
	ARRAY[LOCCODE],
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
	-- facilitytype
		(CASE
			WHEN PreK_Type = 'DOE' THEN 'Universal Pre-K'
			WHEN PreK_Type = 'CHARTER' OR PreK_Type = 'Charter' THEN 'Universal Pre-K - Charter '
			WHEN PreK_Type = 'NYCEEC' THEN 'NYC Early Education Center'
		END),
	-- domain
	'Education, Child Welfare, and Youth',
	-- facilitygroup
	'Child Care and Pre-Kindergarten',
	-- facilitysubgroup
	'Pre-Kindergarten',
	-- agencyclass1
	PreK_Type,
	-- agencyclass2
	'NA',
	-- capacity
	Seats,
	-- utilization
	NULL,
	-- capacitytype
	'Seats',
	-- utilizationrate
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
		(CASE
			WHEN PreK_Type = 'DOE' THEN 'Public'
			WHEN PreK_Type = 'CHARTER' THEN 'Charter'
			WHEN PreK_Type = 'NYCEEC' THEN 'Non-public'
			ELSE 'Unknown'
		END),
	-- operatorname
		(CASE
			WHEN PreK_Type = 'DOE' THEN 'New York City Department of Education'
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
	ARRAY['New York City Department of Education'],
	-- oversightabbrev
	ARRAY['NYCDOE'],
	-- datecreated
	CURRENT_TIMESTAMP,
	-- buildingid
	NULL,
	-- buildingname
	NULL,
	-- schoolorganizationlevel
	NULL,
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