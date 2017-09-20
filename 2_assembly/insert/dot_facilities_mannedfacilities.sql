-- facilities
INSERT INTO
facilities(
	hash,
	uid,
    geom,
    geomsource,
	facname,
	addressnum,
	streetname,
	address,
	boro,
	zipcode,
	facdomain,
	facgroup,
	facsubgrp,
	factype,
	optype,
	opname,
	opabbrev,
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
	-- hash,
    hash,
    -- uid
    NULL,
	-- geom
	geom,
    -- geomsource
    'Agency',
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
	boroname,
	-- zipcode
	NULL,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
	(CASE
		WHEN oper_label LIKE '%Asphalt%' THEN 'Material Supplies'
		ELSE 'Other Transportation'
	END),
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
	-- operatortype
	'Public',
	-- operatorname
	'NYC Department of Transportation',
	-- operatorabbrev
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
	dot_facilities_mannedfacilities;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dot_facilities_mannedfacilities
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
);
-- JOIN uid FROM KEY ONTO DATABASE
UPDATE facilities AS f
SET uid = k.uid
FROM facdb_uid_key AS k
WHERE k.hash = f.hash AND
      f.uid IS NULL;

-- pgtable
INSERT INTO
facdb_pgtable(
   uid,
   pgtable
)
SELECT
	uid,
	'dot_facilities_mannedfacilities'
FROM dot_facilities_mannedfacilities, facilities
WHERE facilities.hash = dot_facilities_mannedfacilities.hash;

-- agency id
INSERT INTO
facdb_agencyid(
	uid,
	overabbrev,
	idagency,
	idname
)
SELECT
	uid,
	'DOT'
	gid,
	'gid'
FROM dot_facilities_mannedfacilities, facilities
WHERE facilities.hash = dot_facilities_mannedfacilities.hash;

-- area NA

-- bbl
INSERT INTO
facdb_bbl(
	uid,
	bbl
)
SELECT
	uid,
	bbl
FROM dot_facilities_mannedfacilities, facilities
WHERE facilities.hash = dot_facilities_mannedfacilities.hash;

-- bin NA

-- capacity NA

-- oversight
INSERT INTO
facdb_oversight(
	uid,
	overagency,
	overabbrev,
	overlevel
)
SELECT
	uid,
	'NYC Department of Transportation',
	'NYCDOT',
    'City'
FROM dot_facilities_mannedfacilities, facilities
WHERE facilities.hash = dot_facilities_mannedfacilities.hash;

-- utilization NA