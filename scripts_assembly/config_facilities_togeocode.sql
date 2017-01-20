-- This script has a unique INSERT statement

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
	agencysource,
	sourcedatasetname,
	linkdata,
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
	ARRAY['togeocode'],
	-- hash,
	md5(CAST((togeocode.*) AS text)),
	-- geom
	NULL,
	-- idagency
	NULL,
	-- facilityname
	facilityname,
	-- addressnumber
	trim(addressnumber,'"'),
	-- streetname
	initcap(replace(streetname, 'STEET', 'STREET')),
	-- address
	initcap(replace(address, 'STEET', 'STREET')),
	-- borough
	borough,
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
	facilitytype,
	-- domain
	'Public Safety, Emergency Services, and Administration of Justice',
	-- facilitygroup
	'Justice and Corrections',
	-- facilitysubgroup
		(CASE
			WHEN (facilitytype LIKE '%Courthouse%') OR (operatorname LIKE '%Court%') THEN
				'Courthouses and Judicial'
			ELSE 'Detention and Correctional'
		END),
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
	operatortype,
	-- operatorname
	operatorname,
	-- operatorabbrev
	operatorabbrev,
	-- oversightagency
	ARRAY[oversightagency],
	-- oversightabbrev
	ARRAY[oversightabbrev],
	-- datecreated
	CURRENT_TIMESTAMP,
	-- agencysource
	ARRAY[datasource],
	-- sourcedatasetname
	ARRAY[dataset],
	-- linkdata
	ARRAY[datalink],
	-- buildingid
	NULL,
	-- buildingname
	NULL,
	-- schoolorganizationlevel
	NULL,
	-- children
	FALSE,
	-- youth
		(CASE
			WHEN facilitytype LIKE '%Juvenile%' THEN TRUE
			ELSE FALSE
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
		(CASE
			WHEN facilitytype LIKE '%Detention%' THEN TRUE
			WHEN facilitytype LIKE '%Residential%' THEN TRUE
			WHEN facilitytype LIKE '%Correctional%' THEN TRUE
			WHEN facilitytype LIKE '%Reception%' THEN TRUE
			ELSE FALSE
		END)
FROM
	togeocode