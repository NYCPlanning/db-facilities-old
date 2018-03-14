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
	ARRAY['dycd_facilities_afterschoolprograms'],
	-- hash,
    hash,
	-- geom
	ST_SetSRID(ST_MakePoint(Longitude::double precision, Latitude::double precision),4326),
	-- idagency
	NULL,
	-- facilityname
	SITE_NAME,
	-- addressnumber
		(CASE
			WHEN Location1 IS NOT NULL THEN split_part(trim(both ' ' from Location1), ' ', 1)
		END),
	-- street name
		(CASE
			WHEN Location1 IS NOT NULL THEN initcap(trim(both ' ' from substr(trim(both ' ' from Location1), strpos(trim(both ' ' from Location1), ' ')+1, (length(trim(both ' ' from Location1))-strpos(trim(both ' ' from Location1), ' ')))))
		END),
	-- address
		(CASE
			WHEN Location1 IS NOT NULL THEN initcap(Location1)
		END),
	-- borough
	initcap(BOROUGH_COMMUNITY),
	-- zipcode
	Postcode::integer,
	-- bbl
	BBL,
	-- bin
	BIN,
	-- facilitytype
	program||' '||program_type,
	-- domain
	'Education, Child Welfare, and Youth',
	-- facilitygroup
	'Youth Services',
	-- facilitysubgroup
	'Comprehensive After School System (COMPASS) Sites',
	-- agencyclass1
	NULL,
	-- agencyclass2
	NULL,
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
	AGENCY,
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	ARRAY['NYC Department of Youth and Community Development'],
	-- oversightabbrev
	ARRAY['NYCDYCD'],
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
	TRUE,
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
	dycd_facilities_afterschoolprograms
GROUP BY
	hash,
	SITE_NAME,
	Location1,
	BOROUGH_COMMUNITY,
	Postcode,
	BBL,
	BIN,
	Latitude,
	Longitude,
	AGENCY,
	program,
	program_type