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
	NULL,
	-- idagency
	NULL,
	-- facilityname
	name_of_center,
	-- addressnumber
	split_part(trim(both ' ' from address_line_1), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from split_part(address_line_1,',',1)), strpos(trim(both ' ' from split_part(address_line_1,',',1)), ' ')+1, (length(trim(both ' ' from split_part(address_line_1,',',1)))-strpos(trim(both ' ' from split_part(address_line_1,',',1)), ' ')))),
	-- address
 	split_part(address_line_1,',',1),
	-- borough
	NULL,
	-- zipcode
	ROUND(zip_code::numeric,0),
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
	'Workforce1 Career Centers',
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
	'New York City New York City Department of Small Business Services',
	-- operatorabbrev
	'NYCSBS',
	-- oversightagency
	ARRAY['New York City New York City Department of Small Business Services'],
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