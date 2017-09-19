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
        NULL,
	-- facilityname
	initcap(LGL_NM),
	-- address number
		(CASE
			WHEN Address IS NOT NULL THEN split_part(trim(both ' ' from Address), ' ', 1)
		END),
	-- street name
		(CASE
			WHEN Address IS NOT NULL THEN initcap(trim(both ' ' from substr(trim(both ' ' from Address), strpos(trim(both ' ' from Address), ' ')+1, (length(trim(both ' ' from Address))-strpos(trim(both ' ' from Address), ' ')))))
		END),
	-- address
		(CASE
			WHEN Address IS NOT NULL THEN initcap(Address)
		END),
	-- borough
	NULL,
	-- zipcode
		(CASE
			WHEN Zip IS NOT NULL THEN Zip::integer
		END),
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
		(CASE

			WHEN agency LIKE '%Children%' AND (Program_name LIKE '%secure Placement%' OR Program_name LIKE '%Secure Placement%' OR Program_name LIKE '%Detention%')
				THEN 'Detention and Correctional'
			WHEN agency LIKE '%Children%' AND Program_name LIKE '%Early Learn%'
				THEN 'Child Care'
			WHEN agency LIKE '%Education%' AND Program_name LIKE '%Prek%'
				THEN 'DOE Universal Pre-Kindergarten'
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

			WHEN agency LIKE '%Health%' AND Program_name LIKE '%Clinic%'
				THEN 'Hospitals and Clinics'
			WHEN agency LIKE '%Health%' AND Program_name LIKE '%HPDP%'
				THEN 'Health Promotion and Disease Prevention'
			WHEN agency LIKE '%Health%' AND Program_name LIKE '%Housing%'
				THEN 'Residential Health Care'
			WHEN agency LIKE '%Health%' AND (Program_name LIKE '%MHy%' OR Program_name LIKE '%Mental%' OR Program_name LIKE '%Psychosocial%')
				THEN 'Mental Health'
			WHEN agency LIKE '%Health%' AND (Program_name LIKE '%Withdrawal%' OR Program_name LIKE '%Drug%')
				THEN 'Chemical Dependency'
			WHEN agency LIKE '%Health%'
				THEN 'Other Health Care'

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
			WHEN agency LIKE '%Human%' OR agency LIKE '%Social%'
				THEN 'Legal and Intervention Services'
		END),
	-- facilitytype
		(CASE
			WHEN agency LIKE '%Youth%' AND Program_name LIKE '%COMPASS%' THEN 'COMPASS Program'
			WHEN agency LIKE '%Youth%' AND Program_name LIKE '%Cornerstone%' THEN 'Cornerstone Community Center Program'
			WHEN agency LIKE '%Youth%' AND Program_name LIKE '%Beacon%' THEN 'Beacon Community Center Program'
			WHEN agency LIKE '%Youth%' AND Program_name LIKE '%Literacy%' THEN 'Literacy Program'
			WHEN agency LIKE '%Youth%' AND Program_name LIKE '%Neighborhood Development%' THEN 'Neighborhood Development Area Program'
			WHEN agency LIKE '%Youth%' THEN 'Other Youth Program'
			ELSE split_part(Program_name,' (',1)
		END),
	-- operatortype
	'Non-public',
	-- operatorname
	initcap(LGL_NM),
	-- operatorabbrev
	'Non-public',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
	NULL,
	-- youth
	NULL,
	-- senior
	NULL,
	-- family
	NULL,
	-- disabilities
	NULL,
	-- dropouts
	NULL,
	-- unemployed
	NULL,
	-- homeless
	NULL,
	-- immigrants
	NULL,
	-- groupquarters
	NULL
FROM
	hhs_facilities_fmscontracts
WHERE
	Program_name NOT LIKE '%Summer Youth%'
	AND Program_name NOT LIKE '%Specialized FFC%'
	AND Program_name NOT LIKE '%Specialized NSP%'
	AND Program_name NOT LIKE '%Specialized PC%'
	AND Program_name NOT LIKE '%HIV%'
	AND Program_name NOT LIKE '%AIDS%'
	AND Program_name NOT LIKE '%HASA%'
	AND Agency NOT LIKE '%Homeless%'
	AND Agency NOT LIKE '%Housing%'
	AND contract_end_date::date > CURRENT_TIMESTAMP
GROUP BY
	hash,
	agency,
	lgl_nm,
	program_name,
	address,
	zip;


-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM hhs_facilities_fmscontracts
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
)
GROUP BY
	hash,
	agency,
	lgl_nm,
	program_name,
	address,
	zip
;
-- JOIN uid FROM KEY ONTO DATABASE
UPDATE facilities AS f
SET uid = k.uid
FROM facdb_uid_key AS k
WHERE k.hash = f.hash AND
      f.uid IS NULL;

INSERT INTO
facdb_pgtable(
   uid,
   pgtable
)
SELECT
	uid,
	'hhs_facilities_fmscontracts'
FROM hhs_facilities_fmscontracts, facilities
WHERE facilities.hash = hhs_facilities_fmscontracts.hash
GROUP BY
    facilities.uid,
	hhs_facilities_fmscontracts.hash,
	agency,
	lgl_nm,
	program_name,
	hhs_facilities_fmscontracts.address,
	zip
;


INSERT INTO
facdb_agencyid(
	uid,
	overabbrev,
	idagency,
	idname
)	
SELECT
	uid,
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
	END),
        CT_Num,
        'Contract Number'
FROM hhs_facilities_fmscontracts, facilities
WHERE facilities.hash = hhs_facilities_fmscontracts.hash
GROUP BY
    facilities.uid,
	hhs_facilities_fmscontracts.hash,
	agency,
	lgl_nm,
	program_name,
	hhs_facilities_fmscontracts.address,
	zip,
	CT_Num
;

--INSERT INTO
--facdb_area(
--	uid,
--	area,
--	areatype
--)
--SELECT
--	uid,
--
--FROM hhs_facilities_fmscontracts, facilities
--WHERE facilities.hash = hhs_facilities_fmscontracts.hash;
--
--INSERT INTO
--facdb_bbl(
--	uid,
--	bbl
--)
--SELECT
--	uid,
--
--FROM hhs_facilities_fmscontracts, facilities
--WHERE facilities.hash = hhs_facilities_fmscontracts.hash;
--
--INSERT INTO
--facdb_bin(
--	uid,
--	bin
--)
--SELECT
--	uid,
--
--FROM hhs_facilities_fmscontracts, facilities
--WHERE facilities.hash = hhs_facilities_fmscontracts.hash;
--
--INSERT INTO
--facdb_capacity(
--  uid,
--  capacity,
--  capacitytype
--)
--SELECT
--	uid,
--	ROUND(Total::numeric,0)::text,
--	'Seats in ACS Contract'
--FROM hhs_facilities_fmscontracts, facilities
--WHERE facilities.hash = hhs_facilities_fmscontracts.hash;
--

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
           WHEN agency LIKE '%DOE%' THEN 'NYC Department of Education'
	   WHEN agency LIKE '%SBS%' THEN 'NYC Department of Small Business Services'
	   WHEN agency LIKE '%DHS%' THEN 'NYC Department of Homeless Services'
	   WHEN agency LIKE '%HRA%' OR agency LIKE '%Social Services%' OR agency LIKE '%DSS%'THEN 'NYC Human Resources Administration/Department of Social Services'
	   WHEN agency LIKE '%DFTA%' THEN 'NYC Department for the Aging'
	   WHEN agency LIKE '%HPD%' OR agency LIKE '%Housing Preservation%' THEN 'NYC Department of Housing Preservation and Development'
	   WHEN agency LIKE '%DOHMH%' THEN 'NYC Department of Health and Mental Hygiene'
	   WHEN agency LIKE '%ACS%' OR agency LIKE '%Children%' THEN 'NYC Administration for Childrens Services'
	   WHEN agency LIKE '%NYPD%' THEN 'NYC Police Department'
	   WHEN agency LIKE '%DOP%' THEN 'NYC Department of Probation'
	   WHEN agency LIKE '%DYCD%' OR agency LIKE '%Youth%' THEN 'NYC Department of Youth and Community Development'
	   WHEN agency LIKE '%MOCJ%' THEN 'NYC Office of the Mayor'
	   WHEN agency LIKE '%Mayor%' OR agency LIKE '%MAYOR%' THEN 'NYC Office of the Mayor'
	   WHEN agency LIKE '%DOC%' THEN 'NYC Department of Correction'
	   ELSE CONCAT('NYC ', agency)
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
	  END),
      'City'
FROM hhs_facilities_fmscontracts, facilities
WHERE facilities.hash = hhs_facilities_fmscontracts.hash
GROUP BY
        facilities.uid,
	hhs_facilities_fmscontracts.hash,
	agency,
	lgl_nm,
	program_name,
	hhs_facilities_fmscontracts.address,
	zip
;

--INSERT INTO
--facdb_utilization(
--	uid,
--	util,
--	utiltype
--)
--SELECT
--	uid,
--
--FROM hhs_facilities_fmscontracts, facilities
--WHERE facilities.hash = hhs_facilities_fmscontracts.hash;
--
