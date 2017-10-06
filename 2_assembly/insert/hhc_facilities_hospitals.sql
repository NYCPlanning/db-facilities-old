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
	'hhc_facilities_hospitals',
	-- hash,
    hash,
	-- geom
	ST_SetSRID(
		ST_MakePoint(
			trim(trim(split_part(split_part(Location_1,'(',2),',',2),')'),' ')::double precision,
			trim(split_part(split_part(Location_1,'(',2),',',1),' ')::double precision),
		4326),
	-- idagency
	NULL,
	NULL,
	NULL,
	-- facilityname
	facility_name,
	-- addressnumber
	split_part(Location_1, ' ', 1),
	-- streetname
	split_part(split_part(Location_1, ' ', 2),'(',1),
	-- address
	split_part(Location_1, '(', 1),
	-- borough
	Borough,
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	'agency',
	-- facilitytype
		(CASE 
			WHEN facility_type LIKE '%Diagnostic%' THEN 'Diagnostic and Treatment Center'
			ELSE facility_type
		END),
	-- facilitysubgroup
		(CASE
			WHEN facility_type = 'Nursing Home' THEN 'Residential Health Care'
			ELSE 'Hospitals and Clinics'
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
	NULL,
	-- areatype
	NULL,
	-- operatortype
	'Public',
	-- operatorname
	'NYC Health and Hospitals Corporation',
	-- operatorabbrev
	'NYCHHC',
	-- oversightagency
	'NYS Department of Health',
	-- oversightabbrev
	'NYSDOH',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
		(CASE
			WHEN facility_type LIKE '%Child%' THEN TRUE
			ELSE FALSE
		END),
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
		(CASE
			WHEN facility_type LIKE '%Nursing Home%' THEN TRUE
			ELSE FALSE
		END)
FROM
	hhc_facilities_hospitals