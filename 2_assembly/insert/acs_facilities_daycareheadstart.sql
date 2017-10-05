INSERT INTO
facilities (
pgtable,
hash,
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
geom,
geomsource,
latitude,
longitude,
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
overlevel,
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
	'acs_facilities_daycareheadstart',
	-- hash,
    hash,
    -- idagency
	el_program_number,
	-- idname
	'Early Learn Program Number',
	-- idfield
	'acs_facilities_daycareheadstart',
	-- facilityname
	Program_Name,
	-- addressnumber
	split_part(trim(both ' ' from initcap(Program_Address)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(Program_Address)), strpos(trim(both ' ' from initcap(Program_Address)), ' ')+1, (length(trim(both ' ' from initcap(Program_Address)))-strpos(trim(both ' ' from initcap(Program_Address)), ' ')))),
	-- address
	initcap(Program_Address),
	-- borough
		(CASE
			WHEN Boro = 'MN' THEN 'Manhattan'
			WHEN Boro = 'BX' THEN 'Bronx'
			WHEN Boro = 'BK' THEN 'Brooklyn'
			WHEN Boro = 'QN' THEN 'Queens'
			WHEN Boro = 'SI' THEN 'Staten Island'
		END),
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- geom
	NULL,
	-- geomsource
	NULL,
	-- latitude
	NULL,
	-- longitude
	NULL,
	-- facilitytype
		(CASE
			WHEN Model_Type = 'DE' OR Model_Type = 'DU' THEN 'Dual Enrollment Child Care/Head Start'
			WHEN Model_Type = 'CC' THEN 'Child Care'
			WHEN Model_Type = 'HS' THEN 'Head Start'
			ELSE 'Child Care'
		END),
	-- facilitysubgroup
	'Child Care',
	-- capacity
	ROUND(Total::numeric,0)::text,
	-- utilization
	NULL,
	-- capacitytype
	'Seats in Contract',
	-- utilizationrate
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
	'Non-public',
	-- operatorname
	Contractor_Name,
	-- operator abbrev
	'Non-public',
	-- oversightagency
	'NYC Administration for Childrens Services',
	-- oversightabbrev
	'NYCACS',
	-- oversightlevel
	'City',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
	TRUE,
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
	acs_facilities_daycareheadstart;