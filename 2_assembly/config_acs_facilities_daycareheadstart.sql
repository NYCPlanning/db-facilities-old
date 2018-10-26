INSERT INTO
facilities (
	pgtable,
	hash,
	geom,
	idagency,
	facname,
	addressnum,
	streetname,
	address,
	boro,
	zipcode,
	bbl,
	bin,
	factype,
	facdomain,
	facgroup,
	facsubgrp,
	agencyclass1,
	agencyclass2,
	capacity,
	util,
	captype,
	utilrate,
	area,
	areatype,
	optype,
	opname,
	opabbrev,
	overagency,
	overabbrev,
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
	ARRAY['acs_facilities_daycareheadstart'],
	-- hash,
    hash,
	-- geom
	NULL,
	-- idagency
	NULL,
	-- facilityname
	ProgramName,
	-- addressnumber
	split_part(trim(both ' ' from initcap(ProgramAddress)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(ProgramAddress)), strpos(trim(both ' ' from initcap(ProgramAddress)), ' ')+1, (length(trim(both ' ' from initcap(ProgramAddress)))-strpos(trim(both ' ' from initcap(ProgramAddress)), ' ')))),
	-- address
	initcap(ProgramAddress),
	-- borough
		(CASE
			WHEN Boro = 'MN' THEN 'Manhattan'
			WHEN Boro = 'BX' THEN 'Bronx'
			WHEN Boro = 'BK' THEN 'Brooklyn'
			WHEN Boro = 'QN' THEN 'Queens'
			WHEN Boro = 'SI' THEN 'Staten Island'
		END),
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
	'Day Care',
	-- domain
	'Education, Child Welfare, and Youth',
	-- facilitygroup
	'Day Care and Pre-Kindergarten',
	-- facilitysubgroup
	'Day Care',
	-- agencyclass1
	NULL,
	-- agencyclass2
	'NA',
	-- capacity
	ARRAY[ROUND(Total::numeric,0)::text],
	-- utilization
	NULL,
	-- capacitytype
	ARRAY['Seats in ACS Contract'],
	-- utilizationrate
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
	'Non-public',
	-- operatorname
	ContractorName,
	-- operator abbrev
	'Non-public',
	-- oversightagency
	ARRAY['NYC Administration for Childrens Services'],
	-- oversightabbrev
	ARRAY['NYCACS'],
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
	acs_facilities_daycareheadstart