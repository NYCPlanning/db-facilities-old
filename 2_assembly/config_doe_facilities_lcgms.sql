INSERT INTO
facilities (
	pgtable,
	hash,
	geom,
	idagency,
	facname,
	addressnum,
	streetname,
	address,
	boro,
	zipcode,
	bbl,
	bin,
	factype,
	facdomain,
	facgroup,
	facsubgrp,
	agencyclass1,
	agencyclass2,
	capacity,
	util,
	captype,
	utilrate,
	area,
	areatype,
	optype,
	opname,
	opabbrev,
	overagency,
	overabbrev,
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
	ARRAY['doe_facilities_lcgms'],
	-- hash,
    a.hash,
	-- geom
	NULL,
	-- idagency
	ARRAY[b.org_id||'-'||b.bldg_id],
	-- facilityname
	initcap(LocationName),
	-- addressnumber
	split_part(b.Address,' ',1),
	-- streetname
	initcap(trim(both ' ' from substr(trim(both ' ' from b.Address), strpos(trim(both ' ' from b.Address), ' ')+1, (length(trim(both ' ' from b.Address))-strpos(trim(both ' ' from b.Address), ' '))))),
	-- address
	initcap(b.Address),
	-- borough
		(CASE
			WHEN LEFT(LocationCode,1) = 'M' THEN 'Manhattan'
			WHEN LEFT(LocationCode,1) = 'X' THEN 'Bronx'
			WHEN LEFT(LocationCode,1) = 'K' THEN 'Brooklyn'
			WHEN LEFT(LocationCode,1) = 'Q' THEN 'Queens'
			WHEN LEFT(LocationCode,1) = 'R' THEN 'Staten Island'
		END),
	-- zipcode
	NULL,
	-- bbl
		(CASE
			WHEN BoroughBlockLot <> '0' THEN ARRAY[BoroughBlockLot]
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
	-- domain
	'Education, Child Welfare, and Youth',
	-- facilitygroup
		(CASE
			WHEN LocationCategoryDescription LIKE '%Early%' OR LocationCategoryDescription LIKE '%Pre-K%' THEN 'Day Care and Pre-Kindergarten'
			ELSE 'Schools (K-12)'
		END),
	-- facilitysubgroup
		(CASE
			WHEN a.LocationTypeDescription LIKE '%Special%' THEN 'Public and Private Special Education Schools'
			WHEN a.LocationCategoryDescription LIKE '%Early%' OR a.LocationCategoryDescription LIKE '%Pre-K%' THEN 'DOE Universal Pre-Kindergarten'
			WHEN a.ManagedByName = 'Charter' THEN 'Charter K-12 Schools'
			ELSE 'Public K-12 Schools'
		END),
	-- agencyclass1
	NULL,
	-- agencyclass2
	NULL,
	-- capacity
		ARRAY[b.ps_capacity,b.ms_capacity,b.hs_capacity],
	-- utilization
	ARRAY[ROUND(b.Org_Enroll::numeric,0)::text],
	-- capacitytype
	ARRAY['PS Seats', 'MS Seats', 'HS Seats'],
	-- utilizationrate
		(CASE
			WHEN (Org_Enroll::numeric <> 0 AND b.Org_Target_Cap::numeric <> 0) THEN ARRAY[ROUND((Org_Enroll::numeric/b.Org_Target_Cap::numeric),3)::text]
		END),
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
		(CASE
			WHEN ManagedByName = 'Charter' THEN 'Non-public'
			ELSE 'Public'
		END),
	-- operatorname
		(CASE
			WHEN ManagedByName = 'Charter' THEN LocationName
			ELSE 'NYC Department of Education'
		END),
	-- operator abbrev
		(CASE
			WHEN ManagedByName = 'Charter' THEN 'Non-public'
			ELSE 'NYCDOE'
		END),
	-- oversightagency
	ARRAY['NYC Department of Education'],
	-- oversightabbrev
	ARRAY['NYCDOE'],
	-- datecreated
	CURRENT_TIMESTAMP,
	-- buildingid
	BuildingCode,
	-- buildingname
	NULL,
	-- schoolorganizationlevel
	NULL,
	-- children
		(CASE
			WHEN LocationCategoryDescription LIKE '%Pre-K%' OR LocationCategoryDescription LIKE '%Elementary%' OR LocationCategoryDescription LIKE '%Early%' OR LocationCategoryDescription LIKE '%K-%' THEN TRUE
			ELSE FALSE
		END),
	-- youth
		(CASE
			WHEN LocationCategoryDescription LIKE '%High%' OR LocationCategoryDescription LIKE '%Secondary%' OR LocationCategoryDescription LIKE '%K-12%' THEN TRUE
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
WHERE b.org_id IS NOT NULL