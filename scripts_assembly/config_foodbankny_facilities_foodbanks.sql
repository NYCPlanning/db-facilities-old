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
	'foodbankny_facilities_foodbanks',
	-- hash,
	md5(CAST((*) AS text)),
	-- geom
	ST_SetSRID(ST_MakePoint(longitude_x, latitude_y),4326),	
	-- idagency
	NULL,
	-- facilityname
	name,
	-- address number
	split_part(trim(both ' ' from address), ' ', 1),
	-- street name
	initcap(trim(both ' ' from substr(trim(both ' ' from address), strpos(trim(both ' ' from address), ' ')+1, (length(trim(both ' ' from address))-strpos(trim(both ' ' from address), ' '))))),
	-- address
	address,
	-- borough
	NULL,
	-- zipcode
	LEFT(zip_code,5)::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- parkid
	NULL,
	-- facilitytype
		(CASE
			WHEN fbc_agency_category_code = 'PANTRY' THEN 'Food Pantry'
			WHEN fbc_agency_category_code = 'SOUP KITCH' THEN 'Soup Kitchen'
		END),
	-- domain
	'Health and Human Services',
	-- facilitygroup
	'Human Services',
	-- facilitysubgroup
	'Soup Kitchens and Food Pantries',
	-- agencyclass1
	fbc_agency_category_code,
	-- agencyclass2
	'NA',
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
	name,
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	ARRAY['Non-public'],
	-- oversightabbrev
	ARRAY['Non-public'],
	-- datecreated
	CURRENT_TIMESTAMP,
	-- buildingid
	NULL,
	-- buildingname
	NULL,
	-- schoolorganizationlevel
	NULL,
	-- children
	FALSE,
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
	foodbankny_facilities_foodbanks
