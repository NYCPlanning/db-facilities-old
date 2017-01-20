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
	ARRAY['nysparks_facilities_parks'],
	-- hash,
	md5(CAST((nysparks_facilities_parks.*) AS text)),
	-- geom
	ST_SetSRID(ST_MakePoint(longitude, latitude),4326),
	-- idagency
	NULL,
	-- facilityname
	name,
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- borough
	County,
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
	category,
	-- domain
	'Parks, Cultural, and Other Community Facilities',
	-- facilitygroup
	'Parks and Plazas',
	-- facilitysubgroup
		(CASE
			WHEN category LIKE '%Preserve%' THEN 'Preserves and Conservation Areas'
			ELSE 'Parks'
		END),
	-- agencyclass1
	category,
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
	'Public',
	-- operatorname
	'New York State Office of Parks, Recreation and Historic Preservation',
	-- operatorabbrev
	'NYSOPRHP',
	-- oversightagency
	ARRAY['New York State Office of Parks, Recreation and Historic Preservation'],
	-- oversightabbrev
	ARRAY['NYSOPRHP'],
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
	nysparks_facilities_parks
WHERE
	County = 'New York'
	OR County = 'Bronx'
	OR County = 'Kings'
	OR County = 'Queens'
	OR County = 'Richmond'