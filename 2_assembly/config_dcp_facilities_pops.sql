INSERT INTO
facilities(
	hash,
	uid,
	facname,
	addressnum,
	streetname,
	address,
	city,
	boro,
	borocode,
	zipcode,
	geom geometry,
	geomsource,
	latitude,
	longitude,
	xcoord,
	ycoord,
	commboard,
	council,
	censtract,
	nta,
	facdomain,
	facgroup,
	facsubgrp,
	factype,
	proptype,
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

-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dcp_facilities_pops
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
);
-- JOIN uid FROM KEY ONTO DATABASE
UPDATE facilities AS f
SET uid = k.uid
FROM facdb_uid_key AS k
WHERE k.hash = f.hash;

INSERT INTO
facdb_agencyid(

)
INSERT INTO
facdb_area(

)
INSERT INTO
facdb_bbl(

)
INSERT INTO
facdb_bin(

)
INSERT INTO
facdb_capacity(

)
INSERT INTO
facdb_pgtable(

)
INSERT INTO
facdb_hashesmerged(

)
INSERT INTO
facdb_oldid(

)
INSERT INTO
facdb_oversight(

)
INSERT INTO
facdb_uidsmerged(

)
INSERT INTO
facdb_utilization(

)




SELECT
	-- pgtable
	ARRAY['dcp_facilities_pops'],
	-- hash,
    hash,
	-- geom
	NULL,
	-- idagency
	ARRAY[DCP_RECORD],
	-- facilityname
	(CASE
		WHEN Building_Name IS NOT NULL AND Building_Name <> '' THEN Building_Name
		ELSE Building_Address
	END),
	-- addressnumber
	split_part(trim(both ' ' from initcap(Building_Address)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(Building_Address)), strpos(trim(both ' ' from initcap(Building_Address)), ' ')+1, (length(trim(both ' ' from initcap(Building_Address)))-strpos(trim(both ' ' from initcap(Building_Address)), ' ')))),
	-- address
	initcap(Building_Address),
	-- borough
		(CASE
			WHEN LEFT(DCP_RECORD,1) = 'B' THEN 'Brooklyn'
			WHEN LEFT(DCP_RECORD,1) = 'Q' THEN 'Queens'
			ELSE 'Manhattan'
		END),
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
	'Privately Owned Public Space',
	-- domain
	'Parks, Gardens, and Historical Sites',
	-- facilitygroup
	'Parks and Plazas',
	-- facilitysubgroup
	'Privately Owned Public Space',
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
	'Not Available',
	-- operator abbrev
	'Non-public',
	-- oversightagency
	ARRAY['NYC Department of City Planning', 'NYC Department of Buildings'],
	-- oversightabbrev
	ARRAY['NYCDCP', 'NYCDOB'],
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
	dcp_facilities_pops