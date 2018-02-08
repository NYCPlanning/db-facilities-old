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
	'doe_facilities_lcgms',
	-- hash,
    a.hash,
	-- geom
	NULL,
	-- idagency
	b.org_id||'-'||b.bldg_id,
	'DOE Organization ID and Building ',
	'org_idp-bldg_id',
	-- facilityname
	initcap(a.locationname),
	-- addressnumber
	split_part(b.address,' ',1),
	-- streetname
	initcap(trim(both ' ' from substr(trim(both ' ' from b.address), strpos(trim(both ' ' from b.address), ' ')+1, (length(trim(both ' ' from b.address))-strpos(trim(both ' ' from b.address), ' '))))),
	-- address
	initcap(b.address),
	-- borough
		(CASE
			WHEN LEFT(a.locationcode,1) = 'M' THEN 'Manhattan'
			WHEN LEFT(a.locationcode,1) = 'X' THEN 'Bronx'
			WHEN LEFT(a.locationcode,1) = 'K' THEN 'Brooklyn'
			WHEN LEFT(a.locationcode,1) = 'Q' THEN 'Queens'
			WHEN LEFT(a.locationcode,1) = 'R' THEN 'Staten Island'
		END),
	-- zipcode
	NULL,
	-- bbl
		(CASE
			WHEN a.boroughblocklot <> '0' THEN a.boroughblocklot
		END),
	-- bin
	NULL,
	-- facilitytype
		(CASE
			WHEN a.ManagedByName = 'Charter' AND lower(a.LocationCategoryDescription) LIKE '%school%' AND a.LocationTypeDescription NOT LIKE '%Special%' THEN CONCAT(a.LocationCategoryDescription, ' - Charter')
			WHEN a.ManagedByName = 'Charter' AND lower(a.LocationCategoryDescription) LIKE '%school%' AND a.LocationTypeDescription LIKE '%Special%' THEN CONCAT(a.LocationCategoryDescription, ' - Charter, Special Education')
			WHEN a.ManagedByName = 'Charter'AND  a.LocationTypeDescription NOT LIKE '%Special%' THEN CONCAT(a.LocationCategoryDescription, ' School - Charter')
			WHEN a.ManagedByName = 'Charter' AND a.LocationTypeDescription LIKE '%Special%' THEN CONCAT(a.LocationCategoryDescription, ' School - Charter, Special Education')
			WHEN lower(a.LocationCategoryDescription) LIKE '%school%' AND a.LocationTypeDescription NOT LIKE '%Special%' THEN CONCAT(a.LocationCategoryDescription, ' - Public')
			WHEN lower(a.LocationCategoryDescription) LIKE '%school%' AND a.LocationTypeDescription LIKE '%Special%' THEN CONCAT(a.LocationCategoryDescription, ' - Public, Special Education')
			WHEN a.LocationTypeDescription LIKE '%Special%' THEN CONCAT(a.LocationCategoryDescription, ' School - Public, Special Education')
			ELSE CONCAT(a.LocationCategoryDescription, ' School - Public')
		END),
	-- facilitysubgroup
		(CASE
			WHEN a.LocationTypeDescription LIKE '%Special%' THEN 'Public and Private Special Education Schools'
			WHEN a.LocationCategoryDescription LIKE '%Early%' OR a.LocationCategoryDescription LIKE '%Pre-K%' THEN 'DOE Universal Pre-Kindergarten'
			WHEN a.ManagedByName = 'Charter' THEN 'Charter K-12 Schools'
			ELSE 'Public K-12 Schools'
		END),
	-- capacity
	b.ps_capacity||','b.ms_capacity||','||b.hs_capacity,
	NULL,
	-- utilization
	ROUND(b.org_enroll::numeric,0)::text,
	NULL,
	-- capacitytype
	'Seats',
	NULL,
	-- utilizationrate
		(CASE
			WHEN (b.Org_Enroll <> 0 AND b.Org_Target_Cap <> 0) THEN ROUND((b.Org_Enroll::numeric/b.Org_Target_Cap::numeric),3)::text
		END),
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
		(CASE
			WHEN a.ManagedByName = 'Charter' THEN 'Non-public'
			ELSE 'Public'
		END),
	-- operatorname
		(CASE
			WHEN a.ManagedByName = 'Charter' THEN LocationName
			ELSE 'NYC Department of Education'
		END),
	-- operator abbrev
		(CASE
			WHEN a.ManagedByName = 'Charter' THEN 'Non-public'
			ELSE 'NYCDOE'
		END),
	-- oversightagency
	'NYC Department of Education',
	-- oversightabbrev
	'NYCDOE',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
		(CASE
			WHEN a.LocationCategoryDescription LIKE '%Pre-K%' OR a.LocationCategoryDescription LIKE '%Elementary%' OR a.LocationCategoryDescription LIKE '%Early%' OR a.LocationCategoryDescription LIKE '%K-%' THEN TRUE
			ELSE FALSE
		END),
	-- youth
		(CASE
			WHEN a.LocationCategoryDescription LIKE '%High%' OR a.LocationCategoryDescription LIKE '%Secondary%' OR a.LocationCategoryDescription LIKE '%K-12%' THEN TRUE
			ELSE FALSE
		END),
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
	doe_facilities_lcgms a
LEFT JOIN
	doe_facilities_schoolsbluebook b
ON 
	a.LocationCode = b.Org_ID