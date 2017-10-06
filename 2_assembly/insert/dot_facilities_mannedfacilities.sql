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
	'dot_facilities_mannedfacilities',
	-- hash,
    hash,
	-- geom
	geom,
	-- idagency
	NULL,
	NULL,
	NULL,
	-- facilityname
	(CASE
		WHEN oper_label IS NOT NULL THEN oper_label
		ELSE label
	END),
	-- addressnumber
	(CASE 
		WHEN arc_street IS NOT NULL THEN split_part(trim(both ' ' from REPLACE(arc_street,' - ','-')), ' ', 1)
		ELSE NULL
	END),
	-- streetname
	(CASE 
		WHEN arc_street IS NOT NULL THEN trim(both ' ' from substr(trim(both ' ' from REPLACE(arc_street,' - ','-')), strpos(trim(both ' ' from REPLACE(arc_street,' - ','-')), ' ')+1, (length(trim(both ' ' from REPLACE(arc_street,' - ','-')))-strpos(trim(both ' ' from REPLACE(arc_street,' - ','-')), ' '))))
		ELSE NULL
	END),
	-- address
	(CASE 
		WHEN arc_street IS NOT NULL THEN arc_street
		ELSE NULL
	END),
	-- borough
	NULL,
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	'agency',
	-- facilitytype
	(CASE
		WHEN oper_label LIKE '%Asphalt%' THEN 'Asphalt Plant'
		WHEN oper_label IS NOT NULL THEN
			REPLACE(
			REPLACE(
			REPLACE(
			REPLACE(
			REPLACE(
			REPLACE(
			REPLACE(
			oper_label,
			'RRM','Roadway Repair and Maintenance'),
			'SIM','Sidewalk and Inspection Management'),
			'OCMC','Construction Mitigation and Coordination'),
			'HIQA','Highway Inspection and Quality Assurance'),
			'BCO','Borough Commissioner’s Office'),
			'JETS','Roadway Repair and Maintenance'),
			'TMC','Traffic Management Center')
		ELSE 'Manned Transportation Facility'
	END),
	-- facilitysubgroup
	(CASE
		WHEN oper_label LIKE '%Asphalt%' THEN 'Material Supplies'
		ELSE 'Other Transportation'
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
	'NYC Department of Transportation',
	-- operatorabbrev
	'NYCDOT',
	-- oversightagency
	'NYC Department of Transportation',
	-- oversightabbrev
	'NYCDOT',
	-- datecreated
	CURRENT_TIMESTAMP,
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
	dot_facilities_mannedfacilities