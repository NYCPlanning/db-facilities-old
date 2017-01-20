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
	ARRAY['nysparks_facilities_historicplaces'],
	-- hash,
	md5(CAST((nysparks_facilities_historicplaces.*) AS text)),
	-- geom
	-- ST_SetSRID(ST_MakePoint(long, lat),4326)
	ST_SetSRID(ST_MakePoint(longitude, latitude),4326),
	-- idagency
	ARRAY[National_Register_Number],
	-- facilityname
	Resource_Name,
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
	'State Historic Place',
	-- domain
	'Parks, Cultural, and Other Community Facilities',
	-- facilitygroup
	'Historical Sites',
	-- facilitysubgroup
	'Historical Sites',
	-- agencyclass1
	'NA',
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
	'FIX THIS (Previosly said Mix)',
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
	nysparks_facilities_historicplaces
WHERE
	Resource_Name NOT LIKE '%Historic District%'
	AND (County = 'New York'
	OR County = 'Bronx'
	OR County = 'Kings'
	OR County = 'Queens'
	OR County = 'Richmond')