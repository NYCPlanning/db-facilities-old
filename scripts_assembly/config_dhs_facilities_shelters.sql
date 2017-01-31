INSERT INTO
facilities (
	pgtable,
	hash,
	geom,
	idagency,
	facilityname,
	addressnumber,
	streetname,
	address,
	borough,
	zipcode,
	bbl,
	bin,
	facilitytype,
	domain,
	facilitygroup,
	facilitysubgroup,
	agencyclass1,
	agencyclass2,
	capacity,
	utilization,
	capacitytype,
	utilizationrate,
	area,
	areatype,
	operatortype,
	operatorname,
	operatorabbrev,
	oversightagency,
	oversightabbrev,
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
	ARRAY['dhs_facilities_shelters'],
	-- hash,
	md5(CAST((dhs_facilities_shelters.*) AS text)),
	-- geom
	ST_Transform(ST_SetSRID(ST_MakePoint(x_coordinate, y_coordinate), 2236),4326),
	-- idagency
	ARRAY[Unique_ID],
	-- facilityname
	initcap(Facility_Name),
	-- addressnumber
	address_number,
	-- streetname
	initcap(street_name),
	-- address
	CONCAT(address_number,' ',initcap(street_name)),
	-- borough
	initcap(Borough),
	-- zipcode
	NULL,
	-- bbl
	ARRAY[BBLs],
	-- bin
	NULL,
	-- facilitytype
	initcap(facility_type),
	-- domain
	'Health and Human Services',
	-- facilitygroup
	'Human Services',
	-- facilitysubgroup
	'Shelters and Transitional Housing',
	-- agencyclass1
	facility_type,
	-- agencyclass2
	NULL,
	-- capacity
	capacity,
	-- utilization
	NULL,
	-- capacitytype
	capacity_type,
	-- utilizationrate
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
		(CASE
			WHEN provider_name LIKE '%NYC Dept%' THEN 'Public'
			ELSE 'Non-public'
		END),
	-- operatorname
	provider_name,
	-- operatorabbrev
		(CASE
			WHEN provider_name LIKE '%NYC Dept%' THEN 'NYCDHS'
			ELSE 'Non-public'
		END),
	-- oversightagency
	ARRAY['New York City Department of Homeless Services'],
	-- oversightabbrev
	ARRAY['NYCDHS'],
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
	(CASE
		WHEN facility_type LIKE '%Family%' THEN TRUE
		ELSE FALSE
	END),
	-- disabilities
	FALSE,
	-- dropouts
	FALSE,
	-- unemployed
	FALSE,
	-- homeless
	TRUE,
	-- immigrants
	FALSE,
	-- groupquarters
	TRUE
FROM 
	dhs_facilities_shelters