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
	ein,
	-- facilityname
	initcap(Provider_Name),
	-- address number
		(CASE
			WHEN service_location IS NOT NULL THEN split_part(trim(both ' ' from service_location), ' ', 1)
			WHEN agency_address IS NOT NULL THEN split_part(trim(both ' ' from agency_address), ' ', 1)
			ELSE split_part(trim(both ' ' from administrative_address), ' ', 1)
		END),
	-- street name
		(CASE
			WHEN service_location IS NOT NULL THEN initcap(trim(both ' ' from substr(trim(both ' ' from service_location), strpos(trim(both ' ' from service_location), ' ')+1, (length(trim(both ' ' from service_location))-strpos(trim(both ' ' from service_location), ' ')))))
			WHEN agency_address IS NOT NULL THEN initcap(trim(both ' ' from substr(trim(both ' ' from agency_address), strpos(trim(both ' ' from agency_address), ' ')+1, (length(trim(both ' ' from agency_address))-strpos(trim(both ' ' from agency_address), ' ')))))
			ELSE initcap(trim(both ' ' from substr(trim(both ' ' from administrative_address), strpos(trim(both ' ' from administrative_address), ' ')+1, (length(trim(both ' ' from administrative_address))-strpos(trim(both ' ' from administrative_address), ' ')))))
		END),
	-- address
		(CASE
			WHEN service_location IS NOT NULL THEN initcap(service_location)
			WHEN agency_address IS NOT NULL THEN initcap(agency_address)
			ELSE initcap(administrative_address)
		END),
	-- city
	NULL,
	-- borough
	NULL,
	-- boroughcode
	NULL,
	-- zipcode
	NULL,
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
	ST_Y(the_geom),
	-- longitude
	ST_X(the_geom),
	-- facilitytype
		(CASE
			WHEN Program_name LIKE '%Blended Case%' 
				THEN 'Blended Case Management'
			WHEN Program_name LIKE '%AIM%' 
				THEN 'Advocate Intervene Mentor'
			WHEN Program_name LIKE '%Disabilities%' 
				THEN 'Programs for People with Disabilities'
			WHEN Program_name LIKE '%Residential Health Care%'
				THEN 'Residential Health Care'
			WHEN Program_name LIKE '%Support%' 
				AND Program_name LIKE '%Housing%'
				THEN 'Supportive Housing'
			WHEN Program_name LIKE '%Alternative%'
				AND (Program_name LIKE '%Detention%'
				OR Program_name LIKE '%Incarceration%')
				THEN 'Alternative to Incarceration'
			WHEN Program_name LIKE '%Crime%'
				AND Program_name LIKE '%Victim%'
				THEN 'Crime Victim Services'
			WHEN Program_name LIKE '%Court%'
				AND Program_name LIKE '%Based%'
				THEN 'Court Based Programs'
			WHEN Program_name LIKE '%Workforce1%'
				THEN 'Workforce1 Centers'
			WHEN services LIKE '%Shelter%' 
				OR Program_name LIKE '%Shelter%'
				THEN 'Shelter'
			WHEN services LIKE '%SRO%' 
				OR Program_name LIKE '%SRO%'
				THEN 'Single Room Occupancy'
			WHEN (services LIKE '%Homelessness Prevention%' 
				OR Program_name LIKE '%Homelessness Prevention%')
				AND Program_name NOT LIKE '%AIDS%'
				THEN 'Homelessness Prevention and Outreach'
			WHEN Program_name LIKE '%Legal%'
				AND Program_name LIKE '%Services%'
				THEN 'Legal Services'
			WHEN services LIKE '%Non-secure Placement%' 
				OR Program_name LIKE '%Non-secure%' 
				OR Program_name LIKE '%Non-Secure%'
				THEN 'Juvenile Non-Secure Placement'
			WHEN services LIKE '%Foster Care%' 
				OR Program_name LIKE '%Specialized FFC%' 
				THEN 'Foster Care Services'
			WHEN (services LIKE '%Substance Abuse%'
				AND services NOT LIKE '%Shelter%'
				AND services NOT LIKE '%Health%')
				AND service_settings LIKE '%Inpatient%'
				THEN 'Inpatient'
			WHEN (services LIKE '%Substance Abuse%'
				AND services NOT LIKE '%Shelter%'
				AND services NOT LIKE '%Health%')
				AND service_settings LIKE '%Outpatient%'
				THEN 'Outpatient'
			WHEN (services LIKE '%Substance Abuse%' 
				AND services NOT LIKE '%Shelter%'
				AND services NOT LIKE '%Health%'
				AND services NOT LIKE '%Housing%')
				AND (service_settings NOT LIKE '%Inpatient%'
				AND service_settings NOT LIKE '%Outpatient%'
				AND Program_name NOT LIKE '%AIDS%')
				THEN 'Monitored Support'
			WHEN Program_name LIKE '%Crisis%'
				AND services LIKE '%Mental%'
				THEN 'Emergency'
			WHEN (services LIKE '%Mental%' 
				OR Program_name LIKE '%Behavioral Health%')
				AND services NOT LIKE '%Housing%'
				AND Program_name NOT LIKE '%School Based Health%'
				AND Program_name NOT LIKE '%School Based Hospital%'
				AND Program_name NOT LIKE '%School Based Diagnostic%'
				THEN 'Support'
			WHEN (Program_name LIKE '%Youth%' 
				OR Program_name LIKE '%Adolescent%')
				AND Program_name LIKE '%Literacy%'
				THEN 'Youth Literacy'
			WHEN (Program_name LIKE '%Youth%' 
				OR Program_name LIKE '%Young Adult%')
				AND (Program_name LIKE '%Employment%'
				OR Program_name LIKE '%Internship%')
				THEN 'Youth Employment'
			ELSE split_part(Program_name,' (',1)
		END),
	-- domain
		(CASE 
			WHEN services LIKE '%Non-secure Placement%' 
				OR Program_name LIKE '%Non-secure%' 
				OR Program_name LIKE '%Non-Secure%' 
				AND (agency LIKE '%Children%'
				OR agency LIKE '%ACS%')
				THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN services LIKE '%Homelessness Prevention%' 
				OR Program_name LIKE '%Homelessness Prevention%'
				THEN 'Health and Human Services'
			WHEN agency LIKE '%DOE%' 
				OR agency LIKE '%Education%'
				THEN 'Education, Child Welfare, and Youth'
			WHEN (agency LIKE '%ACS%' 
				OR agency LIKE '%Children%')
				AND Program_name NOT LIKE '%Disabilities%'
				AND services NOT LIKE '%Mental%' 
				AND Program_name NOT LIKE '%Behavioral Health%'
				AND Program_name NOT LIKE '%Mental Health%'
				THEN 'Education, Child Welfare, and Youth'
			WHEN agency LIKE '%DYCD%' 
				OR agency LIKE '%Youth%' 
				OR Program_name LIKE '%Youth%'
				AND Program_name NOT LIKE '%Behavioral Health%'
				AND Program_name NOT LIKE '%Mental Health%'
				THEN 'Education, Child Welfare, and Youth'
			ELSE 'Health and Human Services'
		END),
	-- facilitygroup
		(CASE

			WHEN services LIKE '%Non-secure Placement%' 
				OR Program_name LIKE '%Non-secure%' 
				OR Program_name LIKE '%Non-Secure%' 
				AND (agency LIKE '%Children%'
				OR agency LIKE '%ACS%')
				THEN 'Justice and Corrections'
			-- domain: Education, Child Welfare, and Youth

			-- facilitygroup: Schools
			-- facilitysubgroup: Preschools
			WHEN Program_name LIKE '%Early Learn%'
				THEN 'Child Care and Pre-Kindergarten'
			-- facilitysubgroup: Public Schools
			WHEN agency LIKE '%DOE%'
				OR agency LIKE '%Education%'
				THEN 'Schools'
			
			-- facilitygroup: Childrens Services
			-- facilitysubgroup: Childrens Services
			WHEN (agency LIKE '%ACS%'
				OR agency LIKE '%Children%')
				AND Program_name NOT LIKE '%Disabilities%'
				AND services NOT LIKE '%Mental%' 
				AND Program_name NOT LIKE '%Behavioral Health%'
				AND Program_name NOT LIKE '%Mental Health%'
				THEN 'Childrens Services'
			
			-- facilitygroup: Youth Services
			-- facilitysubgroup: Youth Services
			WHEN (agency LIKE '%DYCD%'
				OR agency LIKE '%Youth%' 
				OR Program_name LIKE '%Youth%') 
				AND services NOT LIKE '%Homelessness Prevention%'
				AND Program_name NOT LIKE '%Behavioral Health%'
				AND Program_name NOT LIKE '%Mental Health%'
				THEN 'Youth Services'
			
			-- domain: Health and Human Services
			-- facilitygroup: Human Services
			-- facilitysubgroup: Housing and Homeless Services
			WHEN ( agency LIKE '%HPD%'
				OR agency LIKE '%Housing%'
				OR agency LIKE '%DHS%'
				OR agency LIKE '%Homeless Services%'
				OR Program_name LIKE '%Re-Housing%'
				OR services LIKE '%Homelessness Prevention%'
				OR services LIKE '%Housing%'
				OR Program_name LIKE '%Homelessness Prevention%'
				OR services LIKE '%Shelter%'
				OR Program_name LIKE '%Shelter%')
				AND Program_name NOT LIKE '%AIDS%'
				THEN 'Human Services'
			-- facilitysubgroup: Workforce Development
			WHEN agency LIKE '%SBS%'
				OR agency LIKE '%Business%'
				OR Program_name LIKE '%Job%'
				OR Program_name LIKE '%Work%'
				OR Program_name LIKE '%WEP%'
				OR Program_name LIKE '%Employment%'
				OR Program_name LIKE '%Family Self Sufficiency%'
				OR Program_name LIKE '%Vocational%'
				THEN 'Human Services'
			-- facilitysubgroup: Senior Services
			WHEN agency LIKE '%DFTA%'
				OR agency LIKE '%Department for the Aging%'
				THEN 'Human Services'
			-- facilitysubgroup: Legal and Intervention Services
			WHEN Program_name NOT LIKE '%AIDS%'
				AND (agency LIKE '%DOP%'
					OR agency LIKE '%Probation%'
					OR agency LIKE '%Correction%'
					OR agency LIKE '%NYPD%'
					OR agency LIKE '%Police%'
					OR agency LIKE '%MOCJ%'
					OR agency LIKE '%Criminal Justice%'
					OR agency LIKE '%Social%'
					OR Program_name LIKE '%Legal%'
					OR Program_name LIKE '%Court%'
					OR Program_name LIKE '%Justice%'
					OR Program_name LIKE '%Discharge%'
					OR Program_name LIKE '%Incarceration%'
					OR Program_name LIKE '%Detention%'
					OR Program_name LIKE '%Intervention%'
					OR Program_name LIKE '%Mediation%'
					OR Program_name LIKE '%Defense%'
					OR Program_name LIKE '%Protective%'
					OR Program_name LIKE '%Advocacy%'
					OR Program_name LIKE '%Parent Pledge%'
					OR Program_name LIKE '%Gambling%')
				THEN 'Human Services'
			-- facilitysubgroup: Programs for People with Disabilities
			WHEN Program_name LIKE '%Disabilities%'
				THEN 'Human Services'

			-- facilitygroup: Health Care
			-- facilitysubgroup: Hospitals and Clinics
			WHEN Program_name LIKE '%Clinic%'
				OR Program_name LIKE '%Diagnostic%'
				THEN 'Health Care'
			-- facilitysubgroup: Residential Health Care
			WHEN Program_name LIKE '%Residential%'
				OR Program_name LIKE '%Housing%'
				OR Program_name LIKE '%Home Based%'
				THEN 'Health Care'
			-- facilitysubgroup: Chemical Dependency
			WHEN (Program_name LIKE '%Withdrawal%'
				OR services LIKE '%Substance Abuse%')
				AND services NOT LIKE '%Health%'
				AND services NOT LIKE '%Shelter%'
				AND Program_name NOT LIKE '%AIDS%'
				THEN 'Health Care'
			-- facilitysubgroup: Mental Health
			WHEN Program_name LIKE '%Mental%'
				OR Program_name LIKE '%Behavior%'
				OR services LIKE '%Mental%'
				THEN 'Health Care'
			-- facilitysubgroup: Other Health Care
			WHEN 
				Program_name LIKE '%AIDS%'
				OR Program_name NOT LIKE '%Disabilities%'
				AND (agency NOT LIKE '%DOP%'
					AND agency NOT LIKE '%Probation%'
					AND agency NOT LIKE '%Correction%'
					AND agency NOT LIKE '%NYPD%'
					AND agency NOT LIKE '%Police%'
					AND agency NOT LIKE '%MOCJ%'
					AND agency NOT LIKE '%Criminal Justice%'
					AND Program_name NOT LIKE '%Legal%'
					AND Program_name NOT LIKE '%Mental'
					AND Program_name NOT LIKE '%Court%'
					AND Program_name NOT LIKE '%Justice%'
					AND Program_name NOT LIKE '%Discharge%'
					AND Program_name NOT LIKE '%Incarceration%'
					AND Program_name NOT LIKE '%Detention%'
					AND Program_name NOT LIKE '%Intervention%'
					AND Program_name NOT LIKE '%Mediation%'
					AND Program_name NOT LIKE '%Defense%'
					AND Program_name NOT LIKE '%Protective%'
					AND Program_name NOT LIKE '%Advocacy%'
					AND Program_name NOT LIKE '%Parent Pledge%')
				THEN 'Health Care'

			ELSE 'Uncategorized'
		END),
	-- facilitysubgroup
		(CASE

			WHEN services LIKE '%Non-secure Placement%' 
				OR Program_name LIKE '%Non-secure%' 
				OR Program_name LIKE '%Non-Secure%' 
				AND (agency LIKE '%Children%'
				OR agency LIKE '%ACS%')
				THEN 'Detention and Correctional'
			-- domain: Education, Child Welfare, and Youth

			-- facilitygroup: Schools
			-- facilitysubgroup: Preschools
			WHEN Program_name LIKE '%Early Learn%'
				THEN 'Preschools'
			-- facilitysubgroup: Public Schools
			WHEN agency LIKE '%DOE%'
				OR agency LIKE '%Education%'
				THEN 'Public Schools'
			
			-- facilitygroup: Childrens Services
			-- facilitysubgroup: Childrens Services
			WHEN (agency LIKE '%ACS%'
				OR agency LIKE '%Children%')
				AND Program_name NOT LIKE '%Disabilities%'
				AND services NOT LIKE '%Mental%' 
				AND Program_name NOT LIKE '%Behavioral Health%'
				AND Program_name NOT LIKE '%Mental Health%'
				THEN 'Childrens Services'
			
			-- facilitygroup: Youth Services
			-- facilitysubgroup: Youth Services
			WHEN (agency LIKE '%DYCD%'
				OR agency LIKE '%Youth%' 
				OR Program_name LIKE '%Youth%') 
				AND services NOT LIKE '%Homelessness Prevention%'
				AND Program_name NOT LIKE '%Behavioral Health%'
				AND Program_name NOT LIKE '%Mental Health%'
				THEN 'Youth Services'
			
			-- domain: Health and Human Services
			-- facilitygroup: Human Services
			-- facilitysubgroup: Housing and Homeless Services
			WHEN (Program_name LIKE '%Safe Haven%'
				OR services LIKE '%Shelter%'
				OR Program_name LIKE '%Shelter%')
				AND Program_name NOT LIKE '%AIDS%'
				AND service_settings LIKE '%Residential%'
				THEN 'Shelters and Transitional Housing'
			WHEN (Program_name LIKE '%Homelessness Prevention%'
				OR agency LIKE '%HPD%'
				OR agency LIKE '%Housing%'
				OR agency LIKE '%DHS%'
				OR agency LIKE '%Homeless Services%'
				OR Program_name LIKE '%Re-Housing%'
				OR services LIKE '%Homelessness Prevention%'
				OR services LIKE '%Housing%')
				AND Program_name NOT LIKE '%AIDS%'
				THEN 'Non-residential Housing and Homeless Services'
			-- facilitysubgroup: Workforce Development
			WHEN agency LIKE '%SBS%'
				OR agency LIKE '%Business%'
				OR Program_name LIKE '%Job%'
				OR Program_name LIKE '%Work%'
				OR Program_name LIKE '%WEP%'
				OR Program_name LIKE '%Employment%'
				OR Program_name LIKE '%Family Self Sufficiency%'
				OR Program_name LIKE '%Vocational%'
				THEN 'Workforce Development'
			-- facilitysubgroup: Senior Services
			WHEN agency LIKE '%DFTA%'
				OR agency LIKE '%Department for the Aging%'
				THEN 'Senior Services'
			-- facilitysubgroup: Legal and Intervention Services
			WHEN Program_name NOT LIKE '%AIDS%'
				AND Program_name NOT LIKE '%Homelessness%'
				AND (agency LIKE '%DOP%'
					OR agency LIKE '%Probation%'
					OR agency LIKE '%Correction%'
					OR agency LIKE '%NYPD%'
					OR agency LIKE '%Police%'
					OR agency LIKE '%MOCJ%'
					OR agency LIKE '%Criminal Justice%'
					OR agency LIKE '%Social%'
					OR Program_name LIKE '%Legal%'
					OR Program_name LIKE '%Court%'
					OR Program_name LIKE '%Justice%'
					OR Program_name LIKE '%Discharge%'
					OR Program_name LIKE '%Incarceration%'
					OR Program_name LIKE '%Detention%'
					OR Program_name LIKE '%Intervention%'
					OR Program_name LIKE '%Mediation%'
					OR Program_name LIKE '%Defense%'
					OR Program_name LIKE '%Protective%'
					OR Program_name LIKE '%Advocacy%'
					OR Program_name LIKE '%Parent Pledge%'
					OR Program_name LIKE '%Gambling%')
				THEN 'Legal and Intervention Services'
			-- facilitysubgroup: Programs for People with Disabilities
			WHEN Program_name LIKE '%Disabilities%'
				THEN 'Programs for People with Disabilities'

			-- facilitygroup: Health Care
			-- facilitysubgroup: Hospitals and Clinics
			WHEN Program_name LIKE '%Clinic%'
				OR Program_name LIKE '%Diagnostic%'
				THEN 'Hospitals and Clinics'
			-- facilitysubgroup: Residential Health Care
			WHEN Program_name LIKE '%Residential%'
				OR Program_name LIKE '%Housing%'
				OR Program_name LIKE '%Home Based%'
				OR (Program_name LIKE '%AIDS%'
				AND services LIKE '%Housing%')
				THEN 'Residential Health Care'
			-- facilitysubgroup: Chemical Dependency
			WHEN (Program_name LIKE '%Withdrawal%'
				OR services LIKE '%Substance Abuse%')
				AND services NOT LIKE '%Health%'
				AND services NOT LIKE '%Shelter%'
				AND Program_name NOT LIKE '%AIDS%'
				THEN 'Chemical Dependency'
			-- facilitysubgroup: Mental Health
			WHEN Program_name LIKE '%Mental%'
				OR Program_name LIKE '%Behavior%'
				OR services LIKE '%Mental%'
				THEN 'Mental Health'
			-- facilitysubgroup: Other Health Care
			WHEN 
				Program_name LIKE '%AIDS%'
				OR Program_name NOT LIKE '%Disabilities%'
				AND (agency NOT LIKE '%DOP%'
					AND agency NOT LIKE '%Probation%'
					AND agency NOT LIKE '%Correction%'
					AND agency NOT LIKE '%NYPD%'
					AND agency NOT LIKE '%Police%'
					AND agency NOT LIKE '%MOCJ%'
					AND agency NOT LIKE '%Criminal Justice%'
					AND Program_name NOT LIKE '%Legal%'
					AND Program_name NOT LIKE '%Mental'
					AND Program_name NOT LIKE '%Court%'
					AND Program_name NOT LIKE '%Justice%'
					AND Program_name NOT LIKE '%Discharge%'
					AND Program_name NOT LIKE '%Incarceration%'
					AND Program_name NOT LIKE '%Detention%'
					AND Program_name NOT LIKE '%Intervention%'
					AND Program_name NOT LIKE '%Mediation%'
					AND Program_name NOT LIKE '%Defense%'
					AND Program_name NOT LIKE '%Protective%'
					AND Program_name NOT LIKE '%Advocacy%'
					AND Program_name NOT LIKE '%Parent Pledge%')
				THEN 'Other Health Care'

			ELSE 'Uncategorized'
		END),
	-- agencyclass1
	Services,
	-- agencyclass2
	Program_name,
	-- colpusetype
	NULL,
	-- capacity
	NULL,
	-- utilization
	NULL,
	-- capacitytype
	NULL,
	-- utlizationrate
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- servicearea
	NULL,
	-- operatortype
	'Non-public',
	-- operatorname
	initcap(provider_name),
	-- operatorabbrev
	'Non-public',
	-- oversightagency
		(CASE
			WHEN agency LIKE '%DOE%' THEN 'New York City Department of Education'
			WHEN agency LIKE '%SBS%' THEN 'New York City Department of Small Business Services'
			WHEN agency LIKE '%DHS%' THEN 'New York City Department of Homeless Services'
			WHEN agency LIKE '%HRA%' THEN 'New York City Human Resources Administration'
			WHEN agency LIKE '%DFTA%' THEN 'New York City Department for the Aging'
			WHEN agency LIKE '%HPD%' THEN 'New York City Department of Housing Preservation and Development'
			WHEN agency LIKE '%DOHMH%' THEN 'New York City Department of Health and Mental Hygiene'
			WHEN agency LIKE '%ACS%' THEN 'New York City Administration for Childrens Services'
			WHEN agency LIKE '%NYPD%' THEN 'New York City New York Police Department'
			WHEN agency LIKE '%DOP%' THEN 'New York City Department of Probation'
			WHEN agency LIKE '%DYCD%' THEN 'New York City Department of Youth and Community Development'
			WHEN agency LIKE '%MOCJ%' THEN 'New York City Mayors Office of Criminal Justice'
			WHEN agency LIKE '%DOC%' THEN 'New York City Department of Correction'
			ELSE CONCAT('New York City ', agency)
		END),
	-- oversightabbrev
		(CASE
			WHEN agency LIKE '%DOE%'
				OR agency LIKE '%Department of Education%'
				THEN 'NYCDOE'
			WHEN agency LIKE '%SBS%'
				OR agency LIKE '%Small Business Services%'
				THEN 'NYCSBS'
			WHEN agency LIKE '%DHS%'
				OR agency LIKE '%Homeless Services%'
				THEN 'NYCDHS'
			WHEN agency LIKE '%HRA%'
				OR agency LIKE '%Human Resources%'
				THEN 'NYCHRA'
			WHEN agency LIKE '%DFTA%'
				OR agency LIKE '%Aging%'
				THEN 'NYCDFTA'
			WHEN agency LIKE '%HPD%'
				OR agency LIKE '%Housing Preservation%'
				THEN 'NYCHPD'
			WHEN agency LIKE '%DOHMH%'
				OR agency LIKE '%Health and Mental Hygiene%'
				THEN 'NYCDOHMH'
			WHEN agency LIKE '%ACS%'
				OR agency LIKE '%Children%'
				THEN 'NYCACS'
			WHEN agency LIKE '%NYPD%'
				OR agency LIKE '%Police%'
				THEN 'NYPD'
			WHEN agency LIKE '%DOP%'
				OR agency LIKE '%Probation%'
				THEN 'NYCDOP'
			WHEN agency LIKE '%DYCD%'
				OR agency LIKE '%Youth and Community%'
				THEN 'NYCDYCD'
			WHEN agency LIKE '%MOCJ%'
				OR agency LIKE '%Criminal Justice%'
				THEN 'NYCMOCJ'
			WHEN agency LIKE '%Social Services%'
				OR agency LIKE '%DSS%'
				THEN 'NYCDSS'
			WHEN agency LIKE '%Correction%'
				OR agency LIKE '%DOC%'
				THEN 'NYCDOC'
			ELSE CONCAT('NYC', UPPER(agency))
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
	the_geom,
	-- agencysource
	'NYCHHS',
	-- sourcedatasetname
	CONCAT('HHS Accelerator - ',initcap(flag)),
	-- linkdata
	'NA',
	-- linkdownload
	'NA',
	-- datatype
	'CSV with Coordinates',
	-- refreshmeans
	'Request file from agency',
	-- refreshfrequency
	'Annually',
	-- buildingid
	NULL,
	-- building name
	NULL,
	-- schoolorganizationlevel
	NULL,
	-- children
		(CASE
			WHEN populations = 'Children' THEN TRUE
			WHEN populations = 'Young Adults, Children' THEN TRUE
			ELSE FALSE
		END),
	-- youth
		(CASE
			WHEN populations = 'Young Adults' THEN TRUE
			WHEN populations = 'Juvenile Justice Involved' THEN TRUE
			WHEN populations = 'Young Adults, Juvenile Justice Involved' THEN TRUE
			WHEN populations = 'Young Adults, Children' THEN TRUE
			ELSE FALSE
		END),
	-- senior
		(CASE
			WHEN populations = 'Aging' THEN TRUE
			ELSE FALSE
		END),
	-- family
		(CASE
			WHEN populations LIKE '%Mothers, Fathers%' THEN TRUE
			ELSE FALSE
		END),
	-- disabilities
		(CASE
			WHEN populations = 'Individuals with Disabilities' THEN TRUE
			ELSE FALSE
		END),
	-- dropouts
	FALSE,
	-- unemployed
		(CASE
			WHEN populations LIKE '%Underemployed%' THEN TRUE
			WHEN populations LIKE '%Unemployed%' THEN TRUE
			ELSE FALSE
		END),
	-- homeless
		(CASE
			WHEN populations = 'Homeless' THEN TRUE
			WHEN populations = 'Adults, Homeless' THEN TRUE
			ELSE FALSE
		END),
	-- immigrants
		(CASE
			WHEN populations = 'English Learners' THEN TRUE
			WHEN populations LIKE '%Immigrants%' THEN TRUE
			ELSE FALSE
		END),
	-- groupquarters
		(CASE
			WHEN service_settings LIKE '%Residential%' THEN TRUE
			ELSE FALSE
		END)
FROM
	hhs_facilities_acceleratorall