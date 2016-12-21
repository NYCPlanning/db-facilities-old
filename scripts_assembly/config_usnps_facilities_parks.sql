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
	ARRAY['usnps_facilities_parks'],
	-- hash,
	md5(CAST((usnps_facilities_parks.*) AS text)),
	-- geom
	ST_Centroid(geom),
	-- idagency
	ARRAY[unit_code],
	-- facilityname
	unit_name,
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- borough
	NULL,
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- parkid
	NULL,
	-- facilitytype
	unit_type,
	-- domain
	'Parks, Cultural, and Other Community Facilities',
	-- facilitygroup
	'Historical Sites',
	-- facilitysubgroup
	'Historical Sites',
	-- agencyclass1
	unit_type,
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
	'United States National Park Service',
	-- operatorabbrev
	'USNPS',
	-- oversightagency
	ARRAY['United States National Park Service'],
	-- oversightabbrev
	ARRAY['USNPS'],
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
	usnps_facilities_parks
WHERE
	state = 'NY'
	AND unit_code <> 'GATE'
	AND unit_code <> 'FIIS'