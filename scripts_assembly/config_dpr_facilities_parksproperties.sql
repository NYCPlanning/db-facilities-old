INSERT INTO
facilities (
	id,
	idold,
	idagency,
	facilityname,
	addressnumber,
	streetname,
	address,
	city,
	borough,
	boroughcode,
	zipcode,
	bbl,
	bin,
	parkid,
	xcoord,
	ycoord,
	latitude,
	longitude,
	facilitytype,
	domain,
	facilitygroup,
	facilitysubgroup,
	agencyclass1,
	agencyclass2,
	colpusetype,
	capacity,
	utilization,
	capacitytype,
	utilizationrate,
	area,
	areatype,
	servicearea,
	operatortype,
	operatorname,
	operatorabbrev,
	oversightagency,
	oversightabbrev,
	dateactive,
	dateinactive,
	inactivestatus,
	tags,
	notes,
	datesourcereceived,
	datesourceupdated,
	datecreated,
	dateedited,
	creator,
	editor,
	geom,
	agencysource,
	sourcedatasetname,
	linkdata,
	linkdownload,
	datatype,
	refreshmeans,
	refreshfrequency,
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
	-- id
	NULL,
	-- idold
	NULL,
	-- idagency
	gispropnum,
	-- facilityname
	signname,
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- city
	NULL,
	-- borough
		(CASE
			WHEN Borough = 'M' THEN 'Manhattan'
			WHEN Borough = 'X' THEN 'Bronx'
			WHEN Borough = 'K' THEN 'Brooklyn'
			WHEN Borough = 'Q' THEN 'Queens'
			WHEN Borough = 'R' THEN 'Staten Island'
		END),
	-- boroughcode
		(CASE
			WHEN Borough = 'M' THEN 1
			WHEN Borough = 'X' THEN 2
			WHEN Borough = 'K' THEN 3
			WHEN Borough = 'Q' THEN 4
			WHEN Borough = 'R' THEN 5
		END),
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- parkid
	NULL,
	-- xcoord
	NULL,
	-- ycoord
	NULL,
	-- latitude
	ST_Y(ST_Centroid(geom)),
	-- longitude
	ST_X(ST_Centroid(geom)),
	-- facilitytype
	typecatego,
	-- domain
		(CASE
			-- admin of gov
			WHEN typecatego = 'Undeveloped' THEN 'Administration of Government'
			WHEN typecatego = 'Lot' THEN 'Administration of Government'
			-- parks
			ELSE 'Parks, Cultural, and Other Community Facilities'
		END),
	-- facilitygroup
		(CASE
			-- admin of gov
			WHEN typecatego = 'Undeveloped' THEN 'Other Property'
			WHEN typecatego = 'Lot' THEN 'Parking, Maintenance, and Storage'
			-- parks
			WHEN typecatego = 'Historic House Park' THEN 'Historical Sites'
			ELSE 'Parks and Plazas'
		END),
	-- facilitysubgroup
		(CASE
			-- admin of gov
			WHEN typecatego = 'Undeveloped' THEN 'Undeveloped or No Use'
			WHEN typecatego = 'Lot' THEN 'Parking'
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
	-- agencyclass1
	typecatego,
	-- agencyclass2
	'NA',
	-- colpusetype
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
	ST_Area(geom::geography)::numeric*.000247105,
	-- areatype
	'Acres',
	-- servicearea
	NULL,
	-- operatortype
	'Public',
	-- operatorname
	'New York City Department of Parks and Recreation',
	-- operatorabbrev
	'NYCDPR',
	-- oversightagency
	'New York City Department of Parks and Recreation',
	-- oversightabbrev
	'NYCDPR',
	-- dateactive
	NULL,
	-- dateinactive
	NULL,
	-- inactivestatus
	NULL,
	-- tags
	NULL,
	-- notes
	NULL,
	-- datesourcereceived
	'2016-07-27',
	-- datesourceupdated
	'2016-07-27',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- dateedited
	CURRENT_TIMESTAMP,
	-- creator
	'Hannah Kates',
	-- editor
	'Hannah Kates',
	-- geom
	-- ST_SetSRID(ST_MakePoint(long, lat),4326)
	ST_Centroid(geom),
	-- agencysource
	'NYCDPR',
	-- sourcedatasetname
	'Parks Parks Properties',
	-- linkdata
	'https://data.cityofnewyork.us/City-Government/Parks-Properties/rjaj-zgq7',
	-- linkdownload
	'https://data.cityofnewyork.us/api/geospatial/rjaj-zgq7?method=export&format=Original',
	-- datatype
	'Shapefile',
	-- refreshmeans
	'Pull from NYC Open Data',
	-- refreshfrequency
	'Nightly pull',
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
	dpr_parksproperties