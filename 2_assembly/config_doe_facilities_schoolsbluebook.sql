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
	ARRAY['doe_facilities_schoolsbluebook'],
	-- hash,
	md5(CAST((doe_facilities_schoolsbluebook.*) AS text)),
	-- geom
		(CASE
			WHEN X <> '#N/A' THEN ST_Transform(ST_SetSRID(ST_MakePoint(X::double precision, Y::double precision),2263),4326)
		END),
	-- idagency
	ARRAY[Org_ID],
	-- facilityname
	initcap(Organization_Name),
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
	-- facilitytype
		(CASE
			WHEN RIGHT(Org_ID,3) = 'ADM' THEN 'School Administration Site'
			WHEN RIGHT(Org_ID,3) = 'CBO' THEN 'School-Based Community Based Organization'
			WHEN RIGHT(Org_ID,3) = 'DRG' THEN 'School-Based Drug Program'
			WHEN RIGHT(Org_ID,3) = 'DRG' THEN 'School-Based Health Program'
			WHEN RIGHT(Org_ID,3) = 'SFS' THEN 'School-Based Food Services'
			WHEN RIGHT(Org_ID,3) = 'OTH' THEN 'School-Based Community Service'
			WHEN RIGHT(Org_ID,3) = 'SST' THEN 'School-Based Safety Program'
			WHEN RIGHT(Org_ID,3) = 'CEP' THEN 'School-Based Continuing Education Program'
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
		(CASE
			WHEN RIGHT(Org_ID,3) = 'ADM' THEN 'Administration of Government'
			WHEN RIGHT(Org_ID,3) = 'CBO' THEN 'Health and Human Services'
			WHEN RIGHT(Org_ID,3) = 'DRG' THEN 'Health and Human Services'
			WHEN RIGHT(Org_ID,3) = 'DRG' THEN 'Health and Human Services'
			WHEN RIGHT(Org_ID,3) = 'SFS' THEN 'Education, Child Welfare, and Youth'
			WHEN RIGHT(Org_ID,3) = 'OTH' THEN 'Health and Human Services'
			WHEN RIGHT(Org_ID,3) = 'SST' THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN RIGHT(Org_ID,3) = 'CEP' THEN 'Health and Human Services'
			ELSE 'Education, Child Welfare, and Youth'
		END),
	-- facilitygroup
		(CASE
			WHEN RIGHT(Org_ID,3) = 'ADM' THEN 'Offices, Training, and Testing'
			WHEN RIGHT(Org_ID,3) = 'CBO' THEN 'Human Services'
			WHEN RIGHT(Org_ID,3) = 'DRG' THEN 'Human Services'
			WHEN RIGHT(Org_ID,3) = 'SFS' THEN 'Child Welfare'
			WHEN RIGHT(Org_ID,3) = 'OTH' THEN 'Human Services'
			WHEN RIGHT(Org_ID,3) = 'SST' THEN 'Public Safety'
			WHEN RIGHT(Org_ID,3) = 'CEP' THEN 'Human Services'
			ELSE 'Schools (K-12)'
		END),
	-- facilitysubgroup
		(CASE
			WHEN RIGHT(Org_ID,3) = 'ADM' THEN 'Offices'
			WHEN RIGHT(Org_ID,3) = 'CBO' THEN 'Community Centers and Community School Programs'
			WHEN RIGHT(Org_ID,3) = 'DRG' THEN 'Community Centers and Community School Programs'
			WHEN RIGHT(Org_ID,3) = 'SFS' THEN 'School-Based Food Services'
			WHEN RIGHT(Org_ID,3) = 'OTH' THEN 'Community Centers and Community School Programs'
			WHEN RIGHT(Org_ID,3) = 'SST' THEN 'School-Based Safety Program'
			WHEN RIGHT(Org_ID,3) = 'CEP' THEN 'Workforce Development'
			ELSE 'Public Schools'
		END),
	-- agencyclass1
	Charter,
	-- agencyclass2
	Org_Level,
	-- capacity
	(CASE
		WHEN Org_Target_Cap <> 0 THEN ARRAY[ROUND(Org_Target_Cap::numeric,0)::text]
	END),
	-- utilization
	ARRAY[ROUND(Org_Enroll::numeric,0)::text],
	-- capacitytype
	ARRAY['Seats'],
	-- utilizationrate
		(CASE
			WHEN (Org_Enroll <> 0 AND Org_Target_Cap <> 0) THEN ARRAY[ROUND((Org_Enroll::numeric/Org_Target_Cap::numeric),3)::text]
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
			ELSE 'NYC Department of Education'
		END),
	-- operator abbrev
		(CASE
			WHEN Charter IS NOT NULL THEN 'Non-public'
			ELSE 'NYCDOE'
		END),
	-- oversightagency
	ARRAY['NYC Department of Education'],
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
WHERE
	RIGHT(Org_ID,3) <> 'SPE'
	AND RIGHT(Org_ID,3) <> 'AAC'
	AND RIGHT(Org_ID,3) <> 'UFT'