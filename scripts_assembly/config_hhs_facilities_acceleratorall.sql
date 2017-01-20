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
agencysource,
sourcedatasetname,
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
	(CASE
		WHEN flag = 'contracts' THEN ARRAY['hhs_facilities_contracts']
		WHEN flag = 'financials' THEN ARRAY['hhs_facilities_financials']
		WHEN flag = 'proposals' THEN ARRAY['hhs_facilities_proposals']
	END),
	-- hash,
	md5(CAST((hhs_facilities_acceleratorall.*) AS text)),
	-- geom
	the_geom,
	-- idagency
	ARRAY[ein],
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
	-- borough
	NULL,
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
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
			WHEN agency LIKE '%Children%' AND (Program_name LIKE '%Secure Placement%' OR Program_name LIKE '%secure Placement%')
				THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN agency LIKE '%Children%' OR (agency LIKE '%Youth%' AND Program_name NOT LIKE '%Homeless%')
				THEN 'Education, Child Welfare, and Youth'
			ELSE 'Health and Human Services'
		END),

	-- facilitygroup
		(CASE
			
			WHEN agency LIKE '%Children%' AND (Program_name LIKE '%secure Placement%' OR Program_name LIKE '%Secure Placement%')
				THEN 'Justice and Corrections'
			WHEN agency LIKE '%Children%' AND Program_name LIKE '%Early Learn%'
				THEN 'Child Care and Pre-Kindergarten'
			WHEN agency LIKE '%Children%'
				THEN 'Childrens Services'

			WHEN agency LIKE '%Education%'
				THEN 'Human Services'

			WHEN agency LIKE '%Youth%' AND Program_name LIKE '%Homeless%'
				THEN 'Human Services'
			WHEN agency LIKE '%Youth%'
				THEN 'Youth Services'

			WHEN agency LIKE '%Health%'
				THEN 'Health Care'

			ELSE 'Human Services'
		END),

	-- facilitysubgroup
		(CASE

			WHEN agency LIKE '%Children%' AND (Program_name LIKE '%secure Placement%' OR Program_name LIKE '%Secure Placement%')
				THEN 'Detention and Correctional'
			WHEN agency LIKE '%Children%' AND Program_name LIKE '%Early Learn%'
				THEN 'Child Care'
			WHEN agency LIKE '%Children%' AND (Program_name LIKE '%FFC%' OR Program_name LIKE '%Foster%' OR Program_name LIKE '%Residential%')
				THEN 'Foster Care Services and Residential Care'
			WHEN agency LIKE '%Children%'
				THEN 'Preventative Care, Evaluation Services, and Respite'

			WHEN agency LIKE '%Education%'
				THEN 'Community Centers and Community School Programs'
				
			WHEN agency LIKE '%Youth%' AND Program_name LIKE '%COMPASS%'
				THEN 'Comprehensive After School System (COMPASS) Sites'
			WHEN agency LIKE '%Youth%' AND Program_name LIKE '%Summer%'
				THEN 'Summer Youth Employment Site'
			WHEN agency LIKE '%Youth%' AND Program_name LIKE '%Homeless%'
				THEN 'Shelters and Transitional Housing'
			WHEN agency LIKE '%Youth%'
				THEN 'Youth Centers, Literacy Programs, Job Training, and Immigrant Services'

			WHEN agency LIKE '%Homeless%' AND (Program_name LIKE '%Outreach%' OR Program_name LIKE '%Prevention%')
				THEN 'Non-residential Housing and Homeless Services'
			WHEN agency LIKE '%Homeless%'
				THEN 'Shelters and Transitional Housing'

			WHEN agency LIKE '%Health%' AND Program_name LIKE '%HPDP%'
				THEN 'Health Promotion and Disease Prevention'
			WHEN agency LIKE '%Health%' AND Program_name LIKE '%MHy%'
				THEN 'Mental Health'

			WHEN agency LIKE '%Probation%' OR agency LIKE '%Correction%' OR agency LIKE '%Mayor%' OR agency LIKE '%Police%'
				THEN 'Legal and Intervention Services'

			WHEN agency LIKE '%Housing%' AND Program_name LIKE '%Family Centers%'
				THEN 'Shelters and Transitional Housing'
			WHEN agency LIKE '%Housing%'
				THEN 'Non-residential Housing and Homeless Services'

			WHEN agency LIKE '%Business%'
				THEN 'Workforce Development'

			WHEN agency LIKE '%Aging%'
				THEN 'Senior Services'

			WHEN agency LIKE '%Social%' AND (Program_name LIKE '%Job%' OR Program_name LIKE '%Work%')
				THEN 'Workforce Development'

			WHEN (agency LIKE '%Human%' OR agency LIKE '%Social%') AND Program_name LIKE '%AIDS%'
				THEN 'Shelters and Transitional Housing'

			WHEN agency LIKE '%Human%' AND Program_name LIKE '%Adult Protective%'
				THEN 'Programs for People with Disabilities'
			WHEN agency LIKE '%Human%' AND Program_name LIKE '%Housing%'
				THEN 'Shelters and Transitional Housing'
			WHEN agency LIKE '%Human%' AND Program_name LIKE '%WEP%'
				THEN 'Workforce Development'
			WHEN agency LIKE '%Human%'
				THEN 'Legal and Intervention Services'
		END),
	-- agencyclass1
	Services,
	-- agencyclass2
	Program_name,
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
	-- operatortype
	'Non-public',
	-- operatorname
	initcap(provider_name),
	-- operatorabbrev
	'Non-public',
	-- oversightagency
		ARRAY[(CASE
			WHEN agency LIKE '%DOE%' THEN 'New York City Department of Education'
			WHEN agency LIKE '%SBS%' THEN 'New York City Department of Small Business Services'
			WHEN agency LIKE '%DHS%' THEN 'New York City Department of Homeless Services'
			WHEN agency LIKE '%HRA%' OR agency LIKE '%Social Services%' OR agency LIKE '%DSS%'THEN 'New York City Human Resources Administration/Department of Social Services'
			WHEN agency LIKE '%DFTA%' THEN 'New York City Department for the Aging'
			WHEN agency LIKE '%HPD%' OR agency LIKE '%Housing Preservation%' THEN 'New York City Department of Housing Preservation and Development'
			WHEN agency LIKE '%DOHMH%' THEN 'New York City Department of Health and Mental Hygiene'
			WHEN agency LIKE '%ACS%' OR agency LIKE '%Children%' THEN 'New York City Administration for Childrens Services'
			WHEN agency LIKE '%NYPD%' THEN 'New York Police Department'
			WHEN agency LIKE '%DOP%' THEN 'New York City Department of Probation'
			WHEN agency LIKE '%DYCD%' OR agency LIKE '%Youth%' THEN 'New York City Department of Youth and Community Development'
			WHEN agency LIKE '%MOCJ%' THEN 'New York City Office of the Mayor'
			WHEN agency LIKE '%Mayor%' OR agency LIKE '%MAYOR%' THEN 'New York City Office of the Mayor'
			WHEN agency LIKE '%DOC%' THEN 'New York City Department of Correction'
			ELSE CONCAT('New York City ', agency)
		END)],
	-- oversightabbrev
		ARRAY[(CASE
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
				THEN 'NYCHRA/DSS'
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
				OR agency LIKE '%MAYORALITY%'
				OR agency LIKE '%Mayor%'
				THEN 'NYCMO'
			WHEN agency LIKE '%Social Services%'
				OR agency LIKE '%DSS%'
				THEN 'NYCHRA/DSS'
			WHEN agency LIKE '%Correction%'
				OR agency LIKE '%DOC%'
				THEN 'NYCDOC'
			ELSE CONCAT('NYC', UPPER(agency))
		END)],
	-- datecreated
	CURRENT_TIMESTAMP,
	-- agencysource
	ARRAY['NYCHHS'],
	-- sourcedatasetname
	ARRAY[CONCAT('HHS Accelerator - ',initcap(flag))],
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
WHERE flag <> 'contracts'