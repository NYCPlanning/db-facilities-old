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
	parkid,
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
	ARRAY['nysed_facilities_activeinstitutions'],
	-- hash,
	md5(CAST((nysed_facilities_activeinstitutions.*) AS text)),
	-- geom
	-- ST_SetSRID(ST_MakePoint(long, lat),4326)
		(CASE
			-- if switched coordinates were provided
			WHEN 
				Gis_Latitude_Y::double precision < 37
				AND Gis_Latitude_Y::double precision <> 0
				AND Gis_Longitude_X::double precision > -69
				AND Gis_Longitude_X::double precision <> 0
			THEN ST_SetSRID(ST_MakePoint(Gis_Latitude_Y::double precision, Gis_Longitude_X::double precision),4326)
			-- if correct coordinates were provided
			WHEN 
				Gis_Latitude_Y::double precision > 37
				AND Gis_Longitude_X::double precision < -69
			THEN ST_SetSRID(ST_MakePoint(Gis_Longitude_X::double precision, Gis_Latitude_Y::double precision),4326)
		END),
	-- idagency
	ARRAY[Sed_Code],
	-- facilityname
	initcap(Popular_Name),
	-- address number
	split_part(trim(both ' ' from physical_address_line1), ' ', 1),
	-- street name
	initcap(trim(both ' ' from substr(trim(both ' ' from physical_address_line1), strpos(trim(both ' ' from physical_address_line1), ' ')+1, (length(trim(both ' ' from physical_address_line1))-strpos(trim(both ' ' from physical_address_line1), ' '))))),
	-- address
	initcap(Physical_Address_Line1),
	-- borough
		(CASE
			WHEN County_Desc = 'NEW YORK' THEN 'Manhattan'
			WHEN County_Desc = 'BRONX' THEN 'Bronx'
			WHEN County_Desc = 'KINGS' THEN 'Brooklyn'
			WHEN County_Desc = 'QUEENS' THEN 'Queens'
			WHEN County_Desc = 'RICHMOND' THEN 'Staten Island'
		END),
	-- zipcode
	zipcd5::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- parkid
	NULL,
	-- facilitytype
		(CASE
			WHEN Institution_Sub_Type_Desc LIKE '%PUBLIC SCHOOL%'
				THEN 'Public School'
			WHEN Institution_Type_Desc = 'CUNY'
				THEN CONCAT('CUNY - ', initcap(right(Institution_Sub_Type_Desc,-5)))
			WHEN Institution_Type_Desc = 'SUNY' 
				THEN CONCAT('SUNY - ', initcap(right(Institution_Sub_Type_Desc,-5)))
			WHEN Institution_Type_Desc = 'NON-PUBLIC SCHOOLS'
				AND (prek::numeric+halfk::numeric+fullk::numeric+gr1::numeric+gr2::numeric+gr3::numeric+gr4::numeric+gr5::numeric+uge::numeric)>0
				THEN 'Elementary School - Non-public'
			WHEN Institution_Type_Desc = 'NON-PUBLIC SCHOOLS'
				AND (gr6::numeric+gr7::numeric+gr8::numeric)>0
				THEN 'Middle School - Non-public'
			WHEN Institution_Type_Desc = 'NON-PUBLIC SCHOOLS'
				AND (gr9::numeric+gr10::numeric+gr11::numeric+gr12::numeric+ugs::numeric)>0
				THEN 'High School - Non-public'
			WHEN Institution_Type_Desc = 'NON-PUBLIC SCHOOLS'
				AND Institution_Sub_Type_Desc NOT LIKE 'ESL'
				AND Institution_Sub_Type_Desc NOT LIKE 'BUILDING'
				THEN 'Other School - Non-public'
			WHEN Institution_Sub_Type_Desc LIKE '%AHSEP%'
				THEN initcap(split_part(Institution_Sub_Type_Desc,'(',1))
			ELSE initcap(Institution_Sub_Type_Desc)
			-- WHEN (Institution_Type_Desc <> 'CUNY') AND (Institution_Type_Desc <> 'CUNY') AND (Institution_Type_Desc <> 'NON-PUBLIC SCHOOLS')
			-- 	THEN CONCAT(initcap(Institution_Type_Desc),' - ',initcap(Institution_Sub_Type_Desc))
		END),
	-- domain
		(CASE
			WHEN Institution_Type_Desc LIKE '%MUSEUM%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN Institution_Type_Desc LIKE '%LIBRARIES%' THEN 'Parks, Cultural, and Other Community Facilities'
			ELSE 'Education, Child Welfare, and Youth'
		END),
	-- facilitygroup
		(CASE
			WHEN Institution_Type_Desc LIKE '%MUSEUM%' THEN 'Cultural Institutions'
			WHEN Institution_Type_Desc LIKE '%LIBRARIES%' THEN 'Libraries'
			WHEN Institution_Type_Desc LIKE '%CHILD NUTRITION%' THEN 'Child Welfare'
			WHEN Institution_Type_Desc LIKE '%PROPRIETARY%' THEN 'Vocational and Proprietary Schools'
			WHEN (Institution_Type_Desc LIKE '%COLLEGE%') OR (Institution_Type_Desc LIKE '%CUNY%') OR 
				(Institution_Type_Desc LIKE '%SUNY%') OR (Institution_Type_Desc LIKE '%SUNY%')
				THEN 'Higher Education'
			ELSE 'Schools (K-12)'
		END),
	-- facilitysubgroup
		(CASE
			WHEN Institution_Sub_Type_Desc LIKE '%MUSEUM%' THEN 'Museums'
			WHEN Institution_Sub_Type_Desc LIKE '%HISTORICAL%' THEN 'Historical Societies'
			WHEN Institution_Type_Desc LIKE '%LIBRARIES%' THEN 'Academic Libraries'
			WHEN Institution_Type_Desc LIKE '%CHILD NUTRITION%' THEN 'Child Nutrition'
			WHEN (Institution_Type_Desc LIKE '%DISABILITIES%')
				THEN 'Other Schools Serving Students with Disabilities'
			WHEN Institution_Sub_Type_Desc LIKE '%PRE-K%' THEN 'Preschools'
			WHEN Institution_Sub_Type_Desc LIKE '%PRE-SCHOOL%' THEN 'Preschools'
			WHEN (Institution_Type_Desc LIKE 'PUBLIC%') OR (Institution_Sub_Type_Desc LIKE 'PUBLIC%') THEN 'Public Schools'
			WHEN (Institution_Type_Desc LIKE '%COLLEGE%') OR (Institution_Type_Desc LIKE '%CUNY%') OR 
				(Institution_Type_Desc LIKE '%SUNY%') OR (Institution_Type_Desc LIKE '%SUNY%')
				THEN 'Colleges or Universities'
			WHEN Institution_Type_Desc LIKE '%PROPRIETARY%'
				THEN 'Proprietary Schools'
			WHEN Institution_Type_Desc LIKE '%NON-IMF%'
				THEN 'Public Schools'
			ELSE 'Non-public Schools'
		END),
	-- agencyclass1
	Institution_Sub_Type_Desc,
	-- agencyclass2
	Institution_Type_Desc,

	-- capacity
	NULL,
	-- utilization
	enrollment,
	-- capacitytype
		(CASE 
			WHEN enrollment IS NOT NULL THEN 'Seats'
			ELSE NULL
		END),
	-- utlizationrate
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
		(CASE
			WHEN Institution_Type_Desc = 'PUBLIC SCHOOLS' THEN 'Public'
			WHEN Institution_Type_Desc LIKE '%NON-IMF%' THEN 'Public'
			WHEN Institution_Type_Desc = 'CUNY' THEN 'Public'
			WHEN Institution_Type_Desc = 'SUNY' THEN 'Public'
			ELSE 'Non-public'
		END),
	-- operatorname
		(CASE
			WHEN Institution_Type_Desc = 'PUBLIC SCHOOLS' THEN 'New York City Department of Education'
			WHEN Institution_Type_Desc LIKE '%NON-IMF%' THEN 'New York City Department of Education'
			WHEN Institution_Type_Desc = 'CUNY' THEN 'City University of New York'
			WHEN Institution_Type_Desc = 'SUNY' THEN 'State University of New York'
			ELSE initcap(Legal_Name)
		END),
	-- operatorabbrev
		(CASE
			WHEN Institution_Type_Desc = 'PUBLIC SCHOOLS' THEN 'NYCDOE'
			WHEN Institution_Type_Desc = 'PUBLIC SCHOOLS' THEN 'NYCDOE'
			WHEN Institution_Type_Desc = 'CUNY' THEN 'CUNY'
			WHEN Institution_Type_Desc = 'SUNY' THEN 'SUNY'
			ELSE 'Non-public'
		END),
	-- oversightagency
		ARRAY[(CASE
			WHEN Institution_Type_Desc = 'PUBLIC SCHOOLS' THEN ARRAY['New York City Department of Education', 'New York State Education Department']
			WHEN Institution_Type_Desc LIKE '%NON-IMF%' THEN ARRAY['New York City Department of Education', 'New York State Education Department']
			ELSE ARRAY['New York State Education Department']
		END)],
	-- oversightabbrev
		ARRAY[(CASE
			WHEN Institution_Type_Desc = 'PUBLIC SCHOOLS' THEN ARRAY['NYCDOE', 'NYSED']
			WHEN Institution_Type_Desc LIKE '%NON-IMF%' THEN ARRAY['NYCDOE', 'NYSED']
			ELSE ARRAY['NYSED']
		END)],
	-- datecreated
	CURRENT_TIMESTAMP,
	-- buildingid
	NULL,
	-- building name
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
		(CASE
			WHEN Institution_Sub_Type_Desc LIKE '%RESIDENTIAL%' THEN TRUE
			ELSE FALSE
		END)
FROM
	(SELECT
		nysed_facilities_activeinstitutions.*,
		nysed_nonpublicenrollment.*,
		(CASE 
			WHEN (prek::numeric+halfk::numeric+fullk::numeric+gr1::numeric+gr2::numeric+gr3::numeric+gr4::numeric+gr5::numeric+gr6::numeric+uge::numeric+gr7::numeric+gr8::numeric+gr9::numeric+gr10::numeric+gr11::numeric+gr12::numeric+ugs::numeric) IS NOT NULL THEN (prek::numeric+halfk::numeric+fullk::numeric+gr1::numeric+gr2::numeric+gr3::numeric+gr4::numeric+gr5::numeric+gr6::numeric+uge::numeric+gr7::numeric+gr8::numeric+gr9::numeric+gr10::numeric+gr11::numeric+gr12::numeric+ugs::numeric)
			ELSE NULL
		END) AS enrollment
		FROM nysed_facilities_activeinstitutions
		LEFT JOIN nysed_nonpublicenrollment
		ON trim(replace(nysed_nonpublicenrollment.beds_code,',',''),' ')::text = nysed_facilities_activeinstitutions.sed_code::text
		) AS nysed_facilities_activeinstitutions
WHERE 1=1
	AND Institution_Sub_Type_Desc NOT LIKE '%BUREAU%'
	AND Institution_Type_Desc <> 'LIBRARY SYSTEMS'
	AND Institution_Sub_Type_Desc <> 'PUBLIC LIBRARIES'
	AND Institution_Sub_Type_Desc <> 'SPECIAL LIBRARIES'
	AND Institution_Sub_Type_Desc <> 'HISTORICAL RECORDS REPOSITORIES'
	AND Institution_Sub_Type_Desc <> 'CHARTER CORPORATION'
	AND Institution_Type_Desc <> 'INDEPENDENT ORGANIZATIONS'
	AND Institution_Type_Desc <> 'LOCAL GOVERNMENTS'
	AND Institution_Type_Desc <> 'HOME BOUND'
	AND Institution_Type_Desc <> 'HOME INSTRUCTED'
	AND Institution_Type_Desc <> 'SCHOOL DISTRICTS'
	AND Institution_Type_Desc <> 'GOVERNMENT AGENCIES' -- MAY ACTUALLY WANT TO USE THESE
