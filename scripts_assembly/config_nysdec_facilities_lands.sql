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
	ARRAY['nysdec_facilities_lands'],
	-- hash,
	md5(CAST((nysdec_facilities_lands.*) AS text)),
	-- geom
	ST_Centroid(geom),
	-- idagency
	ARRAY[lands_uid],
	-- facilityname
	initcap(facility),
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- borough
		(CASE
			WHEN County = 'NEW YORK' THEN 'Manhattan'
			WHEN County = 'BRONX' THEN 'Bronx'
			WHEN County = 'KINGS' THEN 'Brooklyn'
			WHEN County = 'QUEENS' THEN 'Queens'
			WHEN County = 'RICHMOND' THEN 'Staten Island'
		END),
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
		(CASE
			WHEN category = 'NRA' THEN 'Natural Resource Area'
			ELSE initcap(category)
		END),
	-- domain
	'Parks, Cultural, and Other Community Facilities',
	-- facilitygroup
	'Parks and Plazas',
	-- facilitysubgroup
	'Preserves and Conservation Areas',
	-- agencyclass1
	category,
	-- agencyclass2
		(CASE
			WHEN class IS NOT NULL THEN class
			ELSE 'NA'
		END),

	-- capacity
	NULL,
	-- utilization
	NULL,
	-- capacitytype
	NULL,
	-- utilizationrate
	NULL,
	-- area
	acres,
	-- areatype
	'Acres',
	-- operatortype
	'Public',
	-- operatorname
	'New York State Department of Environmental Conservation',
	-- operatorabbrev
	'NYSDEC',
	-- oversightagency
	ARRAY['New York State Department of Environmental Conservation'],
	-- oversightabbrev
	ARRAY['NYSDEC'],
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
	nysdec_facilities_lands
WHERE
	County = 'NEW YORK'
	OR County = 'BRONX'
	OR County = 'KINGS'
	OR County = 'QUEENS'
	OR County = 'RICHMOND'