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
	parkid,
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
	'doe_facilities_schoolsbluebook',
	-- hash,
	md5(CAST((*) AS text)),
	-- geom
		(CASE
			WHEN X <> '#N/A' THEN ST_Transform(ST_SetSRID(ST_MakePoint(X::double precision, Y::double precision),2263),4326)
		END),
	-- idagency
	ARRAY[Bldg_ID],
	-- facilityname
	initcap(Bldg_Name),
	-- addressnumber
		(CASE
			WHEN Address <> '#N/A' THEN split_part(Address,' ',1)
		END),
	-- streetname
		(CASE
			WHEN Address <> '#N/A' THEN initcap(trim(both ' ' from substr(trim(both ' ' from Address), strpos(trim(both ' ' from Address), ' ')+1, (length(trim(both ' ' from Address))-strpos(trim(both ' ' from Address), ' ')))))
		END),
	-- address
		(CASE
			WHEN Address <> '#N/A' THEN initcap(Address)
		END),
	-- borough
		(CASE
			WHEN LEFT(Org_ID,1) = 'M' THEN 'Manhattan'
			WHEN LEFT(Org_ID,1) = 'X' THEN 'Bronx'
			WHEN LEFT(Org_ID,1) = 'K' THEN 'Brooklyn'
			WHEN LEFT(Org_ID,1) = 'Q' THEN 'Queens'
			WHEN LEFT(Org_ID,1) = 'R' THEN 'Staten Island'
		END),
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- parkid
	NULL,
	-- facilitytype
		(CASE
			WHEN Charter IS NULL AND Org_Level = 'PS' THEN 'Elementary School - Public'
			WHEN Charter IS NULL AND Org_Level = 'PSIS' THEN 'Elementary and Middle School - Public'
			WHEN Charter IS NULL AND Org_Level = 'IS' THEN 'Middle School - Public'
			WHEN Charter IS NULL AND Org_Level = 'ISHS' THEN 'Middle and High School - Public'
			WHEN Charter IS NULL AND Org_Level = 'IS/JHS' THEN 'High School - Public'
			WHEN Charter IS NULL AND Org_Level = 'HS' THEN 'High School - Public'
			WHEN Charter IS NULL AND Org_Level = 'SPED' THEN 'Special Ed School - Public'
			WHEN Charter IS NULL AND Org_Level = 'OTHER' THEN 'Other School - Public'
			WHEN Charter IS NOT NULL AND Org_Level = 'PS' THEN 'Elementary School - Charter'
			WHEN Charter IS NOT NULL AND Org_Level = 'PSIS' THEN 'Elementary and Middle School - Charter'
			WHEN Charter IS NOT NULL AND Org_Level = 'IS' THEN 'Middle School - Charter'
			WHEN Charter IS NOT NULL AND Org_Level = 'ISHS' THEN 'Middle and High School - Charter'
			WHEN Charter IS NOT NULL AND Org_Level = 'IS/JHS' THEN 'High School - Charter'
			WHEN Charter IS NOT NULL AND Org_Level = 'HS' THEN 'High School - Charter'
			WHEN Charter IS NOT NULL AND Org_Level = 'SPED' THEN 'Special Ed School - Charter'
			WHEN Charter IS NOT NULL AND Org_Level = 'OTHER' THEN 'Other School - Charter'
			ELSE 'Other School - Unspecified'
		END),
	-- domain
	'Education, Child Welfare, and Youth',
	-- facilitygroup
	'Schools (K-12)',
	-- facilitysubgroup
	'Public Schools',
	-- agencyclass1
	Charter,
	-- agencyclass2
	Org_Level,

	-- capacity
	PS_Capacity::numeric + MS_Capacity::numeric + HS_Capacity::numeric,
	-- utilization
	Org_Enroll::numeric,
	-- capacitytype
	'Seats',
	-- utilizationrate
		(CASE
			WHEN (PS_Capacity::numeric + MS_Capacity::numeric + HS_Capacity::numeric) <> 0 THEN Org_Enroll::numeric/(PS_Capacity::numeric + MS_Capacity::numeric + HS_Capacity::numeric)
		END),
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
		(CASE
			WHEN Charter IS NOT NULL THEN 'Non-public'
			ELSE 'Public'
		END),
	-- operatorname
		(CASE
			WHEN Charter IS NOT NULL THEN 'Organization_Name'
			ELSE 'New York City Department of Education'
		END),
	-- operator abbrev
		(CASE
			WHEN Charter IS NOT NULL THEN 'Non-public'
			ELSE 'NYCDOE'
		END),
	-- oversightagency
	ARRAY['New York City Department of Education'],
	-- oversightabbrev
	ARRAY['NYCDOE'],
	-- datecreated
	CURRENT_TIMESTAMP,
	-- buildingid
	Bldg_ID,
	-- buildingname
	Bldg_Name,
	-- schoolorganizationlevel
	NULL,
	-- children
		(CASE
			WHEN Org_Level = 'PS' THEN TRUE
			WHEN Org_Level = 'PSIS' THEN TRUE
			WHEN Org_Level = 'IS' THEN TRUE
			WHEN Org_Level = 'ISHS' THEN TRUE
			WHEN Org_Level = 'IS/JHS' THEN TRUE
			WHEN Org_Level = 'HS' THEN FALSE
			WHEN Org_Level = 'SPED' THEN FALSE
			WHEN Org_Level = 'OTHER' THEN FALSE
		END),
	-- youth
		(CASE
			WHEN Org_Level = 'PS' THEN FALSE
			WHEN Org_Level = 'PSIS' THEN FALSE
			WHEN Org_Level = 'IS' THEN FALSE
			WHEN Org_Level = 'ISHS' THEN TRUE
			WHEN Org_Level = 'IS/JHS' THEN TRUE
			WHEN Org_Level = 'HS' THEN TRUE
			WHEN Org_Level = 'SPED' THEN FALSE
			WHEN Org_Level = 'OTHER' THEN FALSE
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
	doe_facilities_schoolsbluebook