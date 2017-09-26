DROP VIEW nysopwdd_facilities_providers_facdbview;
CREATE VIEW nysopwdd_facilities_providers_facdbview AS
SELECT DISTINCT
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
FROM nysopwdd_facilities_providers
WHERE
	county = 'NEW YORK'
	OR county = 'BRONX'
	OR county = 'KINGS'
	OR county = 'QUEENS'
	OR county = 'RICHMOND';

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
	-- hash
	hash,
    -- uid
    NULL,
	-- geom
	(CASE
		WHEN (Location_1 IS NOT NULL) AND (Location_1 LIKE '%(%') THEN 
			ST_SetSRID(
				ST_MakePoint(
					trim(trim(split_part(split_part(Location_1,'(',2),',',2),')'),' ')::double precision,
					trim(split_part(split_part(Location_1,'(',2),',',1),' ')::double precision),
				4326)
	END),
    -- geomsource
    'Agency',
	-- facilityname
	initcap(service_provider_agency),
	-- addressnumber
	split_part(trim(both ' ' from initcap(street_address_)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(street_address_)), strpos(trim(both ' ' from initcap(street_address_)), ' ')+1, (length(trim(both ' ' from initcap(street_address_)))-strpos(trim(both ' ' from initcap(street_address_)), ' ')))),
	-- address
	initcap(street_address_),
	-- borough
		(CASE
			WHEN county = 'NEW YORK' THEN 'Manhattan'
			WHEN county = 'BRONX' THEN 'Bronx'
			WHEN county = 'KINGS' THEN 'Brooklyn'
			WHEN county = 'QUEENS' THEN 'Queens'
			WHEN county = 'RICHMOND' THEN 'Staten Island'
		END),
	-- zipcode
	LEFT(zip_code,5)::integer,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	'Programs for People with Disabilities',
	-- facilitytype
	'Programs for People with Disabilities',
	-- operatortype
	'Non-public',
	-- operatorname
	initcap(service_provider_agency),
	-- operatorabbrev
	'Non-public',
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
FROM nysopwdd_facilities_providers_facdbview;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM nysopwdd_facilities_providers_facdbview
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key);
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
	'nysopwdd_facilities_providers'
FROM nysopwdd_facilities_providers, facilities
WHERE facilities.hash = nysopwdd_facilities_providers.hash;

-- agency id NA

-- area NA

-- bbl NA

-- bin NA 

-- capacity NA

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
    'NYS Office for People With Developmental Disabilities',
    'NYSOPWDD',
    'State'
FROM bic_facilities_tradewaste, facilities
WHERE facilities.hash = bic_facilities_tradewaste.hash;

-- utilization NA