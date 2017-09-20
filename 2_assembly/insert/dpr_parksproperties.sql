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
	ST_Centroid(geom),
	-- geomsource
    'Agency',
	-- facilityname
	signname,
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- borough
		(CASE
			WHEN Borough = 'M' THEN 'Manhattan'
			WHEN Borough = 'X' THEN 'Bronx'
			WHEN Borough = 'K' THEN 'Brooklyn'
			WHEN Borough = 'Q' THEN 'Queens'
			WHEN Borough = 'R' THEN 'Staten Island'
		END),
	-- zipcode
	zipcode,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
		(CASE
			-- admin of gov
			WHEN typecatego = 'Undeveloped' THEN 'Miscellaneous Use'
			WHEN typecatego = 'Lot' THEN 'City Agency Parking'
			-- parks
			WHEN typecatego = 'Cemetery' THEN 'Cemeteries'
			WHEN typecatego = 'Historic House Park' THEN 'Historical Sites'
			WHEN typecatego = 'Triangle/Plaza' THEN 'Streetscapes, Plazas, and Malls'
			WHEN typecatego = 'Mall' THEN 'Streetscapes, Plazas, and Malls'
			WHEN typecatego = 'Strip' THEN 'Streetscapes, Plazas, and Malls'
			WHEN typecatego = 'Parkway' THEN 'Streetscapes, Plazas, and Malls'
			WHEN typecatego = 'Tracking' THEN 'Streetscapes, Plazas, and Malls'
			WHEN typecatego = 'Garden' THEN 'Gardens'
			WHEN typecatego = 'Nature Area' THEN 'Preserves and Conservation Areas'
			WHEN typecatego = 'Flagship Park' THEN 'Parks'
			WHEN typecatego = 'Community Park' THEN 'Parks'
			WHEN typecatego = 'Neighborhood Park' THEN 'Parks'
			ELSE 'Recreation and Waterfront Sites'
		END),
	-- facilitytype
	typecatego,
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
	dpr_parksproperties;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dpr_parksproperties
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
	'dpr_parksproperties'
FROM dpr_parksproperties, facilities
WHERE facilities.hash = dpr_parksproperties.hash;

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
	'NYCDPR',
	gispropnum,
	'Park ID'
FROM dpr_parksproperties, facilities
WHERE facilities.hash = dpr_parksproperties.hash;

-- area
INSERT INTO
facdb_area(
	uid,
	area,
	areatype
)
SELECT
	uid,
	ST_Area(dpr_parksproperties.geom::geography)::numeric*.000247105,
	'Acres'
FROM dpr_parksproperties, facilities
WHERE facilities.hash = dpr_parksproperties.hash;

-- bbl NA

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
	'NYC Department of Parks and Recreation',
	'NYCDPR',
    'City'
FROM dpr_parksproperties, facilities
WHERE facilities.hash = dpr_parksproperties.hash;

-- utilization NA
