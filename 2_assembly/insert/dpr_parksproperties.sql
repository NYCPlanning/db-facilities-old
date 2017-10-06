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
	'dpr_parksproperties',
	-- hash,
    hash,
	-- geom
	ST_Centroid(geom),
	-- idagency
	gispropnum,
	'DPR GIS Property Number',
	'gispropnum',
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
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	'agency',
	-- facilitytype
	typecatego,
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
	-- capacity
	NULL,
	-- utilization
	NULL,
	-- capacitytype
	NULL,
	-- utilizationrate
	NULL,
	-- area
	ST_Area(geom::geography)::numeric*.000247105,
	-- areatype
	'Acres',
	-- operatortype
	'Public',
	-- operatorname
	'NYC Department of Parks and Recreation',
	-- operatorabbrev
	'NYCDPR',
	-- oversightagency
	'NYC Department of Parks and Recreation',
	-- oversightabbrev
	'NYCDPR',
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
	dpr_parksproperties