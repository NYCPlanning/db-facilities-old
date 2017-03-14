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
	ARRAY['sbs_facilities_workforce1'],
	-- hash,
	md5(CAST((sbs_facilities_workforce1.*) AS text)),
	-- geom
	ST_SetSRID(ST_MakePoint(Longitude::numeric, Latitude::numeric),4326),
	-- idagency
	NULL,
	-- facilityname
	Name,
	-- addressnumber
	Address_Number,
	-- streetname
	Street,
	-- address
 	Street_Address_1,
	-- borough
	Borough,
	-- zipcode
	ZIP::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
	Location_Type,
	-- domain
	'Health and Human Services',
	-- facilitygroup
	'Human Services',
	-- facilitysubgroup
	'Workforce Development',
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
	'Public',
	-- operatorname
	'NYC Department of Small Business Services',
	-- operatorabbrev
	'NYCSBS',
	-- oversightagency
	ARRAY['NYC Department of Small Business Services'],
	-- oversightabbrev
	ARRAY['NYCSBS'],
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
	TRUE,
	-- homeless
	FALSE,
	-- immigrants
	FALSE,
	-- groupquarters
	FALSE
FROM 
	sbs_facilities_workforce1