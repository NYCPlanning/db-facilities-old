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
	Sed_Code,
	-- facilityname
	initcap(Popular_Name),
	-- address number
	split_part(trim(both ' ' from physical_address_line1), ' ', 1),
	-- street name
	initcap(trim(both ' ' from substr(trim(both ' ' from physical_address_line1), strpos(trim(both ' ' from physical_address_line1), ' ')+1, (length(trim(both ' ' from physical_address_line1))-strpos(trim(both ' ' from physical_address_line1), ' '))))),
	-- address
	initcap(Physical_Address_Line1),
	-- city
	City,
	-- borough
		(CASE
			WHEN County_Desc = 'NEW YORK' THEN 'Manhattan'
			WHEN County_Desc = 'BRONX' THEN 'Bronx'
			WHEN County_Desc = 'KINGS' THEN 'Brooklyn'
			WHEN County_Desc = 'QUEENS' THEN 'Queens'
			WHEN County_Desc = 'RICHMOND' THEN 'Staten Island'
		END),
	-- boroughcode
		(CASE
			WHEN County_Desc = 'NEW YORK' THEN 1
			WHEN County_Desc = 'BRONX' THEN 2
			WHEN County_Desc = 'KINGS' THEN 3
			WHEN County_Desc = 'QUEENS' THEN 4
			WHEN County_Desc = 'RICHMOND' THEN 5
		END),
	-- zipcode
	zipcd5::integer,
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
		(CASE
			-- if switched coordinates were provided
			WHEN Gis_Latitude_Y::double precision < 37 THEN Gis_Longitude_X
			-- if correct coordinates were provided
			WHEN Gis_Latitude_Y::double precision > 37 THEN Gis_Latitude_Y
		END),
	-- longitude
		(CASE
			-- if switched coordinates were provided
			WHEN Gis_Longitude_X::double precision > -69 THEN Gis_Latitude_Y
			-- if correct coordinates were provided
			WHEN Gis_Longitude_X::double precision < -69 THEN Gis_Longitude_X
		END),
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
			ELSE 'Youth, Education, and Child Welfare'
		END),
	-- facilitygroup
		(CASE
			WHEN Institution_Type_Desc LIKE '%MUSEUM%' THEN 'Cultural Institutions'
			WHEN Institution_Type_Desc LIKE '%LIBRARIES%' THEN 'Libraries'
			WHEN Institution_Type_Desc LIKE '%CHILD NUTRITION%' THEN 'Child Welfare'
			ELSE 'Schools'
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
	-- colpusetype
	NULL,
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
	-- servicearea
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
		(CASE
			WHEN Institution_Type_Desc = 'PUBLIC SCHOOLS' THEN 'New York City Department of Education'
			WHEN Institution_Type_Desc LIKE '%NON-IMF%' THEN 'NYCDOE'
			ELSE 'New York State Education Department'
		END),
	-- oversightabbrev
		(CASE
			WHEN Institution_Type_Desc = 'PUBLIC SCHOOLS' THEN 'NYCDOE'
			WHEN Institution_Type_Desc LIKE '%NON-IMF%' THEN 'NYCDOE'
			ELSE 'NYSED'
		END),
	-- dateactive
	Active_Date::date,
	-- dateinactive
	NULL,
	-- inactivestatus
	NULL,
	-- tags
	NULL,
	-- notes
	NULL,
	-- datesoucereceived
	'2016-07-26',
	-- datesouceupdated
	'2016-07-26',
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
	-- agencysource
	'NYSED',
	-- sourcedatasetname
	'LIstings - Active Institutions with GIS coordinates and OITS Accuracy Code',
	-- linkdata
	'https://portal.nysed.gov/discoverer/app/grid;jsessionid=eikT4MZCXS4gnCu4gkga8RxAT-LFQX1XhLGyOQErv16YJWGj_jo8!-214928944?bi_origin=dvtb&bi_cPath=dvtb&numberLocale=en_US&source=dvtb&gotoNthPage=1&bi_tool=rt&event=bi_showTool&bi_rownavdv=s25&stateStr=eNrtVlFzmzgQ%2FjPY0xtPMiBjJ3nwg4vdlGmKe8ZpmnthZEkYJRgIksHOr79Fog71JO1Q957OL9rVov202tWKz2DbLDa65VKOUDdJKRuhq67IRt08TeXI7LKCJXIEi3BCu0JiyUbvhoO%2FDJwZHTSkYac%2FASm0SIiWNNayFmyTV5pBEqNbEDkSBe2S5HFEwgBbJjLKRxFJgLNXtAioAAWcnmIRbDvIskxw9RnNWdi5mCJzFuNMKQu8jJnSPqS5knOWpbkU5066SeROmSZMEADDaQkoIY4Fa0JftIYeU1gthLLd8IShJtxl%240g5xImG4Ro8t%24u4CTaowCLGpHKwzmfuwlfqtavlmBAlHSha03HYOoov0U5wgmMNe3BCqyqvqAos880PG%2FUPIrzmtVearLjcUL1ZB11%2466CrpqP9liOWP%2FjdH%2FhZrU%2Fm0%2FjVHKHfRqov1B7pqj1S1UQNiPa3xk1ElSjJ00TZ%2Fc1Se%24wy9lqQV8d0UJ06KUQgqgMff7uU8jmlPOSM6nhVRpw4giFJ8zUsRs73bsX50yu9ax6dNZc269ga7oat6jN5eN2M7DfuVp2Gg1vab5%2FqNNvEOH8tKrv9U0ckL1ijPvs7YB5%2Fn96o9VMW%24CxmRL8MdaFq5%2F5kANM%24DsPwUine9E59v5%2FNP0mw6s%2Fv5zPv28v0k%24td%249V0qKZ%2F306nnpprjLnrfPw88yaykarB0Vdr34gHFUX%2FYffsNxn%24ufAP3hHUvvD%2F8IzQQQPj4s%24%2FdodJRkdv8SVKk%2FovBEO%2FCd4%2FGvw2r%2F7zlIqC5QBmad4Tadpj0wKG7eOZtY57sECA13NpnZtl73G3pUVviZ9LmBABVnRZ7rYZ6RWglw%2477QMtgE3YZVFhAXEyNbRc%2FgRSfd9tl1zEshIkSis8Bbc3rtR4ZnMqo548s55L2zSrJUseMb6K5IHxOseUA2%2Fskeh7aBrkQW%24n4hJrEFWIGc7xWrwk4EQBTxTwRAFPFPBEAU8U8EQBTxTwf0EBY6LpTwlPkl33gv1CC1eKFyrTT%24ncr9ncg1piZDmnxo3rL6rmCIKxs3C%2FTgPXA8PiduHOPD%244cxcfA6AagTObzSeuN15M%2FWDsTYKKh4CHczsfO%2FfwdTLtoA%24WQeQuMwrOSpb%2FCyl4PR4%3D',
	-- linkdownload
	'NA',
	-- datatype
	'CSV with Coordinates',
	-- refreshmeans
	'Manual download',
	-- refreshfrequency
	'Weekly pull',
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
