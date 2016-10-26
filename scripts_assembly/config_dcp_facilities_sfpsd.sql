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
	id,
	-- idagency
	NULL,
	-- facilityname
	initcap(facname),
	-- addressnumber
	split_part(trim(both ' ' from facaddress), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from facaddress), strpos(trim(both ' ' from facaddress), ' ')+1, (length(trim(both ' ' from facaddress))-strpos(trim(both ' ' from facaddress), ' ')))),
	-- address
	facaddress,
	-- city
	NULL,
	-- borough
		(CASE
			WHEN borocode = 1 THEN 'Manhattan'
			WHEN borocode = 2 THEN 'Bronx'
			WHEN borocode = 3 THEN 'Brooklyn'
			WHEN borocode = 4 THEN 'Queens'
			WHEN borocode = 5 THEN 'Staten Island'
		END),
	-- boroughcode
	borocode,
	-- zipcode
	NULL,
	-- bbl
	ARRAY[bbl::text],
	-- bin
	NULL,
	-- parkid
	NULL,
	-- xcoord
	xcoord,
	-- ycoord
	ycoord,
	-- latitude
	ST_Y(geom),
	-- longitude
	ST_X(geom),
	-- facilitytype
	ft_decode,
	-- domain
		(CASE 
			WHEN ft_decode = 'City-State Park' THEN 'Parks, Cultural, and Other Community Facilities'
			ELSE 'Core Infrastructure and Transportation'
		END),
	-- facilitygroup
		(CASE 
			WHEN ft_decode = 'City-State Park' THEN 'Parks and Plazas'
			WHEN ft_decode = 'PANYNJ Bus Terminal' THEN 'Transportation'
			WHEN ft_decode = 'Wastewater Treatment Plant' THEN 'Wastewater and Waste Management'
			WHEN ft_decode = 'Public Park and Ride Lot' THEN 'Transportation'
			WHEN ft_decode = 'MTA Paratransit Vehicle Depot' THEN 'Transportation'
			WHEN ft_decode = 'MTA Bus Depot' THEN 'Transportation'
			WHEN ft_decode = 'NYCT Maintenance and Other Facility' THEN 'Transportation'
			WHEN ft_decode = 'NYCT Subway Yard' THEN 'Transportation'
			WHEN ft_decode = 'Metro-North Maintenance and Other Facility' THEN 'Transportation'
			WHEN ft_decode = 'Metro-North Yard' THEN 'Transportation'
			WHEN ft_decode = 'LIRR Maintenance and Other Facility' THEN 'Transportation'
			WHEN ft_decode = 'LIRR Yard' THEN 'Transportation'
			WHEN ft_decode = 'Amtrak Maintenance and Other Facility' THEN 'Transportation'
			WHEN ft_decode = 'Amtrak Yard' THEN 'Transportation'
		END),
	-- facilitysubgroup
		(CASE 
			WHEN ft_decode = 'City-State Park' THEN 'Parks'
			WHEN ft_decode = 'PANYNJ Bus Terminal' THEN 'Bus Depots and Terminals'
			WHEN ft_decode = 'Wastewater Treatment Plant' THEN 'Wastewater Treatment Plant'
			WHEN ft_decode = 'Public Park and Ride Lot' THEN 'Parking Lots and Garages'
			WHEN ft_decode = 'MTA Paratransit Vehicle Depot' THEN 'Bus Depots and Terminals'
			WHEN ft_decode = 'MTA Bus Depot' THEN 'Bus Depots and Terminals'
			WHEN ft_decode = 'NYCT Maintenance and Other Facility' THEN 'Rail Yards and Maintenance'
			WHEN ft_decode = 'NYCT Subway Yard' THEN 'Rail Yards and Maintenance'
			WHEN ft_decode = 'Metro-North Maintenance and Other Facility' THEN 'Rail Yards and Maintenance'
			WHEN ft_decode = 'Metro-North Yard' THEN 'Rail Yards and Maintenance'
			WHEN ft_decode = 'LIRR Maintenance and Other Facility' THEN 'Rail Yards and Maintenance'
			WHEN ft_decode = 'LIRR Yard' THEN 'Rail Yards and Maintenance'
			WHEN ft_decode = 'Amtrak Maintenance and Other Facility' THEN 'Rail Yards and Maintenance'
			WHEN ft_decode = 'Amtrak Yard' THEN 'Rail Yards and Maintenance'
		END),
	-- agencyclass1
	'NA',
	-- agencyclass2
	'NA',
	-- colpusetype
	NULL,
	-- capacity
	capacity,
	-- utilization
	NULL,
	-- capacitytype
		(CASE 
			WHEN ft_decode = 'City-State Park' THEN 'Acres'
			ELSE 'NA'
		END),
	-- utilizationrate
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- servicearea
	NULL,
	-- operatortype
		(CASE
			WHEN ft_decode = 'MTA Paratransit Vehicle Depot' THEN 'Proprietary'
			ELSE 'Public'
		END),
	-- operatorname
		(CASE 
			WHEN ft_decode = 'PANYNJ Bus Terminal' THEN 'Port Authority of New York & New Jersey'
			WHEN ft_decode = 'Wastewater Treatment Plant' THEN 'New York City Department of Environmental Protection'
			WHEN ft_decode = 'MTA Paratransit Vehicle Depot' THEN 'Proprietary'
			WHEN ft_decode = 'MTA Bus Depot' THEN 'Metropolitan Transportation Authority / New York City Transit'
			WHEN ft_decode = 'NYCT Maintenance and Other Facility' THEN 'Metropolitan Transportation Authority / New York City Transit'
			WHEN ft_decode = 'NYCT Subway Yard' THEN 'Metropolitan Transportation Authority / New York City Transit'
			WHEN ft_decode = 'Metro-North Maintenance and Other Facility' THEN 'Metropolitan Transportation Authority / Metro-North'
			WHEN ft_decode = 'Metro-North Yard' THEN 'Metropolitan Transportation Authority / Metro-North'
			WHEN ft_decode = 'LIRR Maintenance and Other Facility' THEN 'Metropolitan Transportation Authority / Long Island Rail Road'
			WHEN ft_decode = 'LIRR Yard' THEN 'Metropolitan Transportation Authority / Long Island Rail Road'
			WHEN ft_decode = 'Amtrak Maintenance and Other Facility' THEN 'Amtrak'
			WHEN ft_decode = 'Amtrak Yard' THEN 'Amtrak'
			WHEN agencyoper = '24.0000000000' THEN 'New York City Department of Transportation'
			WHEN agencyoper = '63.0000000000' THEN 'New York State Department of Transportation'
			WHEN agencyoper = '80.0000000000' THEN 'Hudson River Park Trust'
			WHEN agencyoper = '81.0000000000' THEN 'Brooklyn Bridge Park Corporation'
			WHEN agencyoper = '83.0000000000' THEN 'Roosevelt Island Operating Corporation'
			WHEN agencyoper = '84.0000000000' THEN 'Trust for Governors Island'
			ELSE 'Metropolitan Transportation Authority / New York City Transit'
		END),
	-- operatorabbrev
		(CASE 
			WHEN ft_decode = 'PANYNJ Bus Terminal' THEN 'PANYNJ'
			WHEN ft_decode = 'Wastewater Treatment Plant' THEN 'NYCDEP'
			WHEN ft_decode = 'MTA Paratransit Vehicle Depot' THEN 'Non-public'
			WHEN ft_decode = 'MTA Bus Depot' THEN 'MTA-NYCT'
			WHEN ft_decode = 'NYCT Maintenance and Other Facility' THEN 'MTA-NYCT'
			WHEN ft_decode = 'NYCT Subway Yard' THEN 'MTA-NYCT'
			WHEN ft_decode = 'Metro-North Maintenance and Other Facility' THEN 'MTA-MN'
			WHEN ft_decode = 'Metro-North Yard' THEN 'MTA-MN'
			WHEN ft_decode = 'LIRR Maintenance and Other Facility' THEN 'MTA-LIRR'
			WHEN ft_decode = 'LIRR Yard' THEN 'MTA-LIRR'
			WHEN ft_decode = 'Amtrak Maintenance and Other Facility' THEN 'Amtrak'
			WHEN ft_decode = 'Amtrak Yard' THEN 'Amtrak'
			WHEN agencyoper = '24.0000000000' THEN 'NYCDOT'
			WHEN agencyoper = '63.0000000000' THEN 'NYSDOT'
			WHEN agencyoper = '80.0000000000' THEN 'HRPT'
			WHEN agencyoper = '81.0000000000' THEN 'BBPC'
			WHEN agencyoper = '83.0000000000' THEN 'RIOC'
			WHEN agencyoper = '84.0000000000' THEN 'TGI'
			ELSE 'MTA-NYCT'
		END),
	-- oversightagency
		(CASE 
			WHEN ft_decode = 'PANYNJ Bus Terminal' THEN 'Port Authority of New York & New Jersey'
			WHEN ft_decode = 'Wastewater Treatment Plant' THEN 'New York City Department of Environmental Protection'
			WHEN ft_decode = 'MTA Paratransit Vehicle Depot' THEN 'Metropolitan Transportation Authority / New York City Transit'
			WHEN ft_decode = 'MTA Bus Depot' THEN 'Metropolitan Transportation Authority / New York City Transit'
			WHEN ft_decode = 'NYCT Maintenance and Other Facility' THEN 'Metropolitan Transportation Authority / New York City Transit'
			WHEN ft_decode = 'NYCT Subway Yard' THEN 'Metropolitan Transportation Authority / New York City Transit'
			WHEN ft_decode = 'Metro-North Maintenance and Other Facility' THEN 'Metropolitan Transportation Authority / Metro-North'
			WHEN ft_decode = 'Metro-North Yard' THEN 'Metropolitan Transportation Authority / Metro-North'
			WHEN ft_decode = 'LIRR Maintenance and Other Facility' THEN 'Metropolitan Transportation Authority / Long Island Rail Road'
			WHEN ft_decode = 'LIRR Yard' THEN 'Metropolitan Transportation Authority / Long Island Rail Road'
			WHEN ft_decode = 'Amtrak Maintenance and Other Facility' THEN 'Amtrak'
			WHEN ft_decode = 'Amtrak Yard' THEN 'Amtrak'
			WHEN agencyoper = '24.0000000000' THEN 'New York City Department of Transportation'
			WHEN agencyoper = '63.0000000000' THEN 'New York State Department of Transportation'
			WHEN agencyoper = '80.0000000000' THEN 'Hudson River Park Trust'
			WHEN agencyoper = '81.0000000000' THEN 'Brooklyn Bridge Park Corporation'
			WHEN agencyoper = '83.0000000000' THEN 'Roosevelt Island Operating Corporation'
			WHEN agencyoper = '84.0000000000' THEN 'Trust for Governors Island'
			ELSE 'Metropolitan Transportation Authority / New York City Transit'
		END),
	-- oversightabbrev
		(CASE 
			WHEN ft_decode = 'PANYNJ Bus Terminal' THEN 'PANYNJ'
			WHEN ft_decode = 'Wastewater Treatment Plant' THEN 'NYCDEP'
			WHEN ft_decode = 'MTA Paratransit Vehicle Depot' THEN 'MTA-NYCT'
			WHEN ft_decode = 'MTA Bus Depot' THEN 'MTA-NYCT'
			WHEN ft_decode = 'NYCT Maintenance and Other Facility' THEN 'MTA-NYCT'
			WHEN ft_decode = 'NYCT Subway Yard' THEN 'MTA-NYCT'
			WHEN ft_decode = 'Metro-North Maintenance and Other Facility' THEN 'MTA-MN'
			WHEN ft_decode = 'Metro-North Yard' THEN 'MTA-MN'
			WHEN ft_decode = 'LIRR Maintenance and Other Facility' THEN 'MTA-LIRR'
			WHEN ft_decode = 'LIRR Yard' THEN 'MTA-LIRR'
			WHEN ft_decode = 'Amtrak Maintenance and Other Facility' THEN 'Amtrak'
			WHEN ft_decode = 'Amtrak Yard' THEN 'Amtrak'
			WHEN agencyoper = '24.0000000000' THEN 'NYCDOT'
			WHEN agencyoper = '63.0000000000' THEN 'NYSDOT'
			WHEN agencyoper = '80.0000000000' THEN 'HRPT'
			WHEN agencyoper = '81.0000000000' THEN 'BBPC'
			WHEN agencyoper = '83.0000000000' THEN 'RIOC'
			WHEN agencyoper = '84.0000000000' THEN 'TGI'
			ELSE 'MTA-NYCT'
		END),
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
	'2016-08-01',
	-- datesourceupdated
	'2015-03-01',
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
	geom,
	-- agencysource
		(CASE 
			WHEN ft_decode = 'PANYNJ Bus Terminal' THEN 'PANYNJ'
			WHEN ft_decode = 'Wastewater Treatment Plant' THEN 'NYCDEP'
			WHEN ft_decode = 'MTA Paratransit Vehicle Depot' THEN 'MTA-NYCT'
			WHEN ft_decode = 'MTA Bus Depot' THEN 'MTA-NYCT'
			WHEN ft_decode = 'NYCT Maintenance and Other Facility' THEN 'MTA-NYCT'
			WHEN ft_decode = 'NYCT Subway Yard' THEN 'MTA-NYCT'
			WHEN ft_decode = 'Metro-North Maintenance and Other Facility' THEN 'MTA-MN'
			WHEN ft_decode = 'Metro-North Yard' THEN 'MTA-MN'
			WHEN ft_decode = 'LIRR Maintenance and Other Facility' THEN 'MTA-LIRR'
			WHEN ft_decode = 'LIRR Yard' THEN 'MTA-LIRR'
			WHEN ft_decode = 'Amtrak Maintenance and Other Facility' THEN 'Amtrak'
			WHEN ft_decode = 'Amtrak Yard' THEN 'Amtrak'
			WHEN agencyoper = '24.0000000000' THEN 'NYCDOT'
			WHEN agencyoper = '63.0000000000' THEN 'NYSDOT'
			WHEN agencyoper = '80.0000000000' THEN 'HRPT'
			WHEN agencyoper = '81.0000000000' THEN 'BBPC'
			WHEN agencyoper = '83.0000000000' THEN 'RIOC'
			WHEN agencyoper = '84.0000000000' THEN 'TGI'
			ELSE 'MTA-NYCT'
		END),
	-- sourcedatasetname
	'Selected Facilities and Program Sites Database',
	-- linkdata
	'http://www1.nyc.gov/site/planning/data-maps/open-data/dwn-selfac.page',
	-- linkdownload
	'http://www1.nyc.gov/assets/planning/download/zip/data-maps/open-data/nyc_facilities2015_shp.zip',
	-- datatype
	'Shapefile',
	-- refreshmeans
	'NA',
	-- refreshfrequency
	'NA',
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
	dcp_facilities_sfpsd
WHERE 1=1
	AND (ft_decode = 'City-State Park'
	OR ft_decode = 'PANYNJ Bus Terminal'
	OR ft_decode = 'Wastewater Treatment Plant'
	OR ft_decode = 'Public Park and Ride Lot'
	OR ft_decode = 'MTA Paratransit Vehicle Depot'
	OR ft_decode = 'MTA Bus Depot'
	OR ft_decode = 'NYCT Maintenance and Other Facility'
	OR ft_decode = 'NYCT Subway Yard'
	OR ft_decode = 'Metro-North Maintenance and Other Facility'
	OR ft_decode = 'Metro-North Yard'
	OR ft_decode = 'LIRR Maintenance and Other Facility'
	OR ft_decode = 'LIRR Yard'
	OR ft_decode = 'Amtrak Maintenance and Other Facility'
	OR ft_decode = 'Amtrak Yard')