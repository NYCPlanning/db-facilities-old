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
	'nysopwdd_facilities_providers',
	-- hash,
    hash,
	-- geom
	(CASE
		WHEN (Location_1 IS NOT NULL) AND (Location_1 LIKE '%(%') THEN 
			ST_SetSRID(
				ST_MakePoint(
					trim(trim(split_part(split_part(Location_1,'(',2),',',2),')'),' ')::double precision,
					trim(split_part(split_part(Location_1,'(',2),',',1),' ')::double precision),
				4326)
	END),
	-- idagency
	NULL,
	NULL,
	NULL,
	-- facilityname
	initcap(Service_Provider_Agency),
	-- addressnumber
	split_part(trim(both ' ' from initcap(Street_Address_)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(Street_Address_)), strpos(trim(both ' ' from initcap(Street_Address_)), ' ')+1, (length(trim(both ' ' from initcap(Street_Address_)))-strpos(trim(both ' ' from initcap(Street_Address_)), ' ')))),
	-- address
	initcap(Street_Address_),
	-- borough
		(CASE
			WHEN County = 'NEW YORK' THEN 'Manhattan'
			WHEN County = 'BRONX' THEN 'Bronx'
			WHEN County = 'KINGS' THEN 'Brooklyn'
			WHEN County = 'QUEENS' THEN 'Queens'
			WHEN County = 'RICHMOND' THEN 'Staten Island'
		END),
	-- zipcode
	LEFT(Zip_Code,5)::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	'agency',
	-- facilitytype
	'Programs for People with Disabilities',
		-- (CASE
		-- 	WHEN 	
		-- 	Intermediate_Care_Facilities_ICFs
		-- 	Individual_Residential_Alternative_IRA
		-- 	Family_Care
		-- 	Consolidated_Supports_And_Services
		-- 	Individual_Support_Services_ISSs
		-- 	Day_Training
		-- 	Day_Treatment
		-- 	Senior_Geriatric_Services
		-- 	Day_Habilitation
		-- 	Work_Shop
		-- 	Prevocational
		-- 	Supported_Employment_Enrollments
		-- 	Community_Habilitation
		-- 	Family_Support_Services
		-- 	Care_at_Home_Waiver_Services
		-- 	Developmental_Centers_And_Special_Population_Services
		-- END),
	-- facilitysubgroup
	'Programs for People with Disabilities',
	-- capacity
	NULL,
	-- utilization
	NULL,
	-- capacitytype
	NULL,
	-- utilizationrate
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
	'Non-public',
	-- operatorname
	initcap(Service_Provider_Agency),
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	'NYS Office for People With Developmental Disabilities',
	-- oversightabbrev
	'NYSOPWDD',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
	FALSE,
	-- youth
	FALSE,
	-- senior
		(CASE
			WHEN Senior_Geriatric_Services = 'Y' THEN TRUE
			ELSE FALSE
		END),
	-- family
		(CASE
			WHEN family_care = 'Y' THEN TRUE
			WHEN family_support_services = 'Y' THEN TRUE
			ELSE FALSE
		END),
	-- disabilities
	TRUE,
	-- dropouts
	FALSE,
	-- unemployed
	FALSE,
	-- homeless
	FALSE,
	-- immigrants
	FALSE,
	-- groupquarters
		(CASE
			WHEN Individual_Residential_Alternative_IRA = 'Y' THEN TRUE
			ELSE FALSE
		END)
FROM
	nysopwdd_facilities_providers
WHERE
	County = 'NEW YORK'
	OR County = 'BRONX'
	OR County = 'KINGS'
	OR County = 'QUEENS'
	OR County = 'RICHMOND'
GROUP BY
	hash,
	Developmental_Disability_Services_Office,
	Service_Provider_Agency,
	Street_Address_,
	Street_Address_Line_2,
	City,
	State,
	Zip_Code,
	Phone,
	County,
	Website_Url,
	Intermediate_Care_Facilities_ICFs,
	Individual_Residential_Alternative_IRA,
	Family_Care,
	Consolidated_Supports_And_Services,
	Individual_Support_Services_ISSs,
	Day_Training,
	Day_Treatment,
	Senior_Geriatric_Services,
	Day_Habilitation,
	Work_Shop,
	Prevocational,
	Supported_Employment_Enrollments,
	Community_Habilitation,
	Family_Support_Services,
	Care_at_Home_Waiver_Services,
	Developmental_Centers_And_Special_Population_Services,
	Location_1
