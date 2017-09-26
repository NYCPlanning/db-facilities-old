DROP VIEW hhs_facilities_financialscontracts_facdbview;
CREATE VIEW hhs_facilities_financialscontracts_facdbview AS 
SELECT DISTINCT 
	hash,
	agency_name,
	provider_name,
	Program_name,
	site_name,
	address_1,
	address_2,
	city,
	state,
	zip_code
FROM hhs_facilities_financialscontracts
WHERE
	program_name NOT LIKE '%Summer Youth%'
	AND program_name NOT LIKE '%Specialized FFC%'
	AND program_name NOT LIKE '%Specialized NSP%'
	AND program_name NOT LIKE '%Specialized PC%'
	AND program_name NOT LIKE '%HIV%'
	AND program_name NOT LIKE '%AIDS%'
	AND Program_name NOT LIKE '%HASA%'
	AND agency_name NOT LIKE '%Homeless%'
	AND agency_name NOT LIKE '%Housing%'
	AND contract_end_date::date > CURRENT_TIMESTAMP;

-- facilities
INSERT INTO
facilities(
	hash,
	uid,
    geom,
    geomsource,
	facname,
	addressnum,
	streetname,
	address,
	boro,
	zipcode,
	facdomain,
	facgroup,
	facsubgrp,
	factype,
	optype,
	opname,
	opabbrev,
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
	-- hash,
    hash,
    -- uid
    NULL,
	-- geom
	NULL,
    -- geomsource
    'None',
	-- facilityname
	(CASE
		WHEN site_name IS NOT NULL THEN initcap(site_name)
		ELSE initcap(provider_name)
	END),
	-- address number
		(CASE
			WHEN address_1 IS NOT NULL THEN split_part(trim(both ' ' from address_1), ' ', 1)
		END),
	-- street name
		(CASE
			WHEN address_1 IS NOT NULL THEN initcap(trim(both ' ' from substr(trim(both ' ' from address_1), strpos(trim(both ' ' from address_1), ' ')+1, (length(trim(both ' ' from address_1))-strpos(trim(both ' ' from address_1), ' ')))))
		END),
	-- address
		(CASE
			WHEN address_1 IS NOT NULL THEN initcap(address_1)
		END),
	-- borough
	NULL,
	-- zipcode
	zip_code::integer,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
		(CASE

			WHEN agency_name LIKE '%Children%' AND (Program_name LIKE '%secure Placement%' OR Program_name LIKE '%Secure Placement%' OR Program_name LIKE '%Detention%')
				THEN 'Detention and Correctional'
			WHEN agency_name LIKE '%Children%' AND Program_name LIKE '%Early Learn%'
				THEN 'Child Care'
			WHEN agency_name LIKE '%Education%' AND Program_name LIKE '%Prek%'
				THEN 'DOE Universal Pre-Kindergarten'
			WHEN agency_name LIKE '%Children%' AND (Program_name LIKE '%FFC%' OR Program_name LIKE '%Foster%' OR Program_name LIKE '%Residential%')
				THEN 'Foster Care Services and Residential Care'
			WHEN agency_name LIKE '%Children%'
				THEN 'Preventative Care, Evaluation Services, and Respite'

			WHEN agency_name LIKE '%Education%'
				THEN 'Community Centers and Community School Programs'	
				
			WHEN agency_name LIKE '%Youth%' AND Program_name LIKE '%COMPASS%'
				THEN 'Comprehensive After School System (COMPASS) Sites'
			WHEN agency_name LIKE '%Youth%' AND Program_name LIKE '%Summer%'
				THEN 'Summer Youth Employment Site'
			WHEN agency_name LIKE '%Youth%' AND Program_name LIKE '%Homeless%'
				THEN 'Shelters and Transitional Housing'
			WHEN agency_name LIKE '%Youth%'
				THEN 'Youth Centers, Literacy Programs, Job Training, and Immigrant Services'

			WHEN agency_name LIKE '%Homeless%' AND (Program_name LIKE '%Outreach%' OR Program_name LIKE '%Prevention%')
				THEN 'Non-residential Housing and Homeless Services'
			WHEN agency_name LIKE '%Homeless%'
				THEN 'Shelters and Transitional Housing'

			WHEN agency_name LIKE '%Health%' AND Program_name LIKE '%Clinic%'
				THEN 'Hospitals and Clinics'
			WHEN agency_name LIKE '%Health%' AND Program_name LIKE '%HPDP%'
				THEN 'Health Promotion and Disease Prevention'
			WHEN agency_name LIKE '%Health%' AND Program_name LIKE '%Housing%'
				THEN 'Residential Health Care'
			WHEN agency_name LIKE '%Health%' AND (Program_name LIKE '%MHy%' OR Program_name LIKE '%Mental%' OR Program_name LIKE '%Psychosocial%')
				THEN 'Mental Health'
			WHEN agency_name LIKE '%Health%' AND (Program_name LIKE '%Withdrawal%' OR Program_name LIKE '%Drug%')
				THEN 'Chemical Dependency'
			WHEN agency_name LIKE '%Health%'
				THEN 'Other Health Care'

			WHEN agency_name LIKE '%Probation%' OR agency_name LIKE '%Correction%' OR agency_name LIKE '%Mayor%' OR agency_name LIKE '%Police%'
				THEN 'Legal and Intervention Services'

			WHEN agency_name LIKE '%Housing%' AND Program_name LIKE '%Family Centers%'
				THEN 'Shelters and Transitional Housing'
			WHEN agency_name LIKE '%Housing%'
				THEN 'Non-residential Housing and Homeless Services'

			WHEN agency_name LIKE '%Business%'
				THEN 'Workforce Development'

			WHEN agency_name LIKE '%Aging%'
				THEN 'Senior Services'

			WHEN agency_name LIKE '%Social%' AND (Program_name LIKE '%Job%' OR Program_name LIKE '%Work%')
				THEN 'Workforce Development'

			WHEN (agency_name LIKE '%Human%' OR agency_name LIKE '%Social%') AND Program_name LIKE '%AIDS%'
				THEN 'Shelters and Transitional Housing'

			WHEN agency_name LIKE '%Human%' AND Program_name LIKE '%Adult Protective%'
				THEN 'Programs for People with Disabilities'
			WHEN agency_name LIKE '%Human%' AND Program_name LIKE '%Housing%'
				THEN 'Shelters and Transitional Housing'
			WHEN agency_name LIKE '%Human%' AND Program_name LIKE '%WEP%'
				THEN 'Workforce Development'
			WHEN agency_name LIKE '%Human%' OR agency_name LIKE '%Social%'
				THEN 'Legal and Intervention Services'
		END),
	-- facilitytype
		(CASE
			WHEN agency_name LIKE '%Youth%' AND program_name LIKE '%COMPASS%' THEN 'COMPASS Program'
			WHEN agency_name LIKE '%Youth%' AND program_name LIKE '%Cornerstone%' THEN 'Cornerstone Community Center Program'
			WHEN agency_name LIKE '%Youth%' AND program_name LIKE '%Beacon%' THEN 'Beacon Community Center Program'
			WHEN agency_name LIKE '%Youth%' AND program_name LIKE '%Literacy%' THEN 'Literacy Program'
			WHEN agency_name LIKE '%Youth%' AND program_name LIKE '%Neighborhood Development%' THEN 'Neighborhood Development Area Program'
			WHEN agency_name LIKE '%Youth%' THEN 'Other Youth Program'
			ELSE split_part(program_name,' (',1)
		END),
	-- operatortype
	'Non-public',
	-- operatorname
	initcap(provider_name),
	-- operatorabbrev
	'Non-public',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
        FALSE,
	--	(CASE
	--		WHEN facility_type LIKE '%Child%' THEN TRUE
	--		ELSE FALSE
	--	END),
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
              --  (CASE
	      --     WHEN facility_type LIKE '%Nursing Home%' THEN TRUE
              --   ELSE FALSE
	      --   END)
FROM hhs_facilities_financialscontracts_facdbview;

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM hhs_facilities_financialscontracts_facdbview
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key);
-- JOIN uid FROM KEY ONTO DATABASE
UPDATE facilities AS f
SET uid = k.uid
FROM facdb_uid_key AS k
WHERE k.hash = f.hash AND
      f.uid IS NULL;

-- pgtable
INSERT INTO
facdb_pgtable(
   uid,
   pgtable
)
SELECT
	uid,
	'hhs_facilities_financialscontracts'
FROM hhs_facilities_financialscontracts_facdbview, facilities
WHERE facilities.hash = hhs_facilities_financialscontracts_facdbview.hash;

-- agency id
INSERT INTO
facdb_agencyid(
	uid,
	idagency,
	idname,
	idfield,
	idtable
)
SELECT
	uid,
	external_contract_number,
	'External Contract Number',
	'external_contract_number',
	'hhs_facilities_financialscontracts'
FROM hhs_facilities_financialscontracts, facilities
WHERE facilities.hash = hhs_facilities_financialscontracts.hash;

-- area NA

-- bbl NA

-- bin NA

-- capacity NA

-- oversight
INSERT INTO
facdb_oversight(
	uid,
	overagency,
	overabbrev,
	overlevel
)
SELECT
	uid,
	-- oversightagency
		(CASE
			WHEN agency_name LIKE '%DOE%' THEN 'NYC Department of Education'
			WHEN agency_name LIKE '%SBS%' THEN 'NYC Department of Small Business Services'
			WHEN agency_name LIKE '%DHS%' THEN 'NYC Department of Homeless Services'
			WHEN agency_name LIKE '%HRA%' OR agency_name LIKE '%Social Services%' OR agency_name LIKE '%DSS%'THEN 'NYC Human Resources Administration/Department of Social Services'
			WHEN agency_name LIKE '%DFTA%' THEN 'NYC Department for the Aging'
			WHEN agency_name LIKE '%HPD%' OR agency_name LIKE '%Housing Preservation%' THEN 'NYC Department of Housing Preservation and Development'
			WHEN agency_name LIKE '%DOHMH%' THEN 'NYC Department of Health and Mental Hygiene'
			WHEN agency_name LIKE '%ACS%' OR agency_name LIKE '%Children%' THEN 'NYC Administration for Childrens Services'
			WHEN agency_name LIKE '%NYPD%' THEN 'NYC Police Department'
			WHEN agency_name LIKE '%DOP%' THEN 'NYC Department of Probation'
			WHEN agency_name LIKE '%DYCD%' OR agency_name LIKE '%Youth%' THEN 'NYC Department of Youth and Community Development'
			WHEN agency_name LIKE '%MOCJ%' THEN 'NYC Office of the Mayor'
			WHEN agency_name LIKE '%Mayor%' OR agency_name LIKE '%MAYOR%' THEN 'NYC Office of the Mayor'
			WHEN agency_name LIKE '%DOC%' THEN 'NYC Department of Correction'
			ELSE CONCAT('NYC ', agency_name)
		END),
	-- oversightabbrev
		(CASE
			WHEN agency_name LIKE '%DOE%'
				OR agency_name LIKE '%Department of Education%'
				THEN 'NYCDOE'
			WHEN agency_name LIKE '%SBS%'
				OR agency_name LIKE '%Small Business Services%'
				THEN 'NYCSBS'
			WHEN agency_name LIKE '%DHS%'
				OR agency_name LIKE '%Homeless Services%'
				THEN 'NYCDHS'
			WHEN agency_name LIKE '%HRA%'
				OR agency_name LIKE '%Human Resources%'
				THEN 'NYCHRA/DSS'
			WHEN agency_name LIKE '%DFTA%'
				OR agency_name LIKE '%Aging%'
				THEN 'NYCDFTA'
			WHEN agency_name LIKE '%HPD%'
				OR agency_name LIKE '%Housing Preservation%'
				THEN 'NYCHPD'
			WHEN agency_name LIKE '%DOHMH%'
				OR agency_name LIKE '%Health and Mental Hygiene%'
				THEN 'NYCDOHMH'
			WHEN agency_name LIKE '%ACS%'
				OR agency_name LIKE '%Children%'
				THEN 'NYCACS'
			WHEN agency_name LIKE '%NYPD%'
				OR agency_name LIKE '%Police%'
				THEN 'NYPD'
			WHEN agency_name LIKE '%DOP%'
				OR agency_name LIKE '%Probation%'
				THEN 'NYCDOP'
			WHEN agency_name LIKE '%DYCD%'
				OR agency_name LIKE '%Youth and Community%'
				THEN 'NYCDYCD'
			WHEN agency_name LIKE '%MOCJ%'
				OR agency_name LIKE '%Criminal Justice%'
				OR agency_name LIKE '%MAYORALITY%'
				OR agency_name LIKE '%Mayor%'
				THEN 'NYCMO'
			WHEN agency_name LIKE '%Social Services%'
				OR agency_name LIKE '%DSS%'
				THEN 'NYCHRA/DSS'
			WHEN agency_name LIKE '%Correction%'
				OR agency_name LIKE '%DOC%'
				THEN 'NYCDOC'
			ELSE CONCAT('NYC', UPPER(agency_name))
		END),
		'City'
FROM hhs_facilities_financialscontracts, facilities
WHERE facilities.hash = hhs_facilities_financialscontracts.hash;

-- utilization NA 