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
	'bic_facilities_tradewaste',
	-- hash,
    hash,
	-- geom
	(CASE
		WHEN (Location_1 IS NOT NULL) AND (Location_1 LIKE '%(%') THEN 
			ST_SetSRID(
				ST_MakePoint(
					trim(trim(split_part(split_part(Location_1,'(',2),',',2),' '),')')::double precision,
					trim(trim(split_part(split_part(Location_1,'(',2),',',1),'('),' ')::double precision),
				4326)
	END),
	-- idagency
	NULL,
	NULL,
	NULL,
	-- facilityname
	initcap(BUS_NAME),
	-- addressnumber
	initcap(split_part(REPLACE(REPLACE(Mailing_Office,' - ','-'),' -','-'), ' ', 1)),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(split_part(REPLACE(REPLACE(Mailing_Office,' - ','-'),' -','-'), '(', 1))), strpos(trim(both ' ' from initcap(split_part(REPLACE(REPLACE(Mailing_Office,' - ','-'),' -','-'), '(', 1))), ' ')+1, (length(trim(both ' ' from initcap(split_part(REPLACE(REPLACE(Mailing_Office,' - ','-'),' -','-'), '(', 1))))-strpos(trim(both ' ' from initcap(split_part(REPLACE(REPLACE(Mailing_Office,' - ','-'),' -','-'), '(', 1))), ' ')))),
	-- address
	initcap(split_part(REPLACE(REPLACE(Mailing_Office,' - ','-'),' -','-'), '(', 1)),
	-- borough
	NULL,
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	'agecny',
	-- facilitytype
	'Trade Waste Carter Site',
	-- facilitysubgroup
	'Solid Waste Transfer and Carting',
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
	initcap(BUS_NAME),
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	'NYC Business Integrity Commission',
	-- oversightabbrev
	'NYCBIC',
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
	bic_facilities_tradewaste