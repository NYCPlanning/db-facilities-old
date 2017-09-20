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
    NULL,
	-- facilityname
	facilityname,
	-- addressnumber
	trim(addressnumber,'"'),
	-- streetname
	initcap(replace(streetname, 'STEET', 'STREET')),
	-- address
	initcap(replace(address, 'STEET', 'STREET')),
	-- borough
	borough,
	-- zipcode
	NULL,
	-- domain
	NULL,
	-- facilitygroup
	NULL,
	-- facilitysubgroup
		(CASE
			WHEN (facilitytype LIKE '%Courthouse%') OR (operatorname LIKE '%Court%') THEN
				'Courthouses and Judicial'
			ELSE 'Detention and Correctional'
		END),
    -- facilitytype
	facilitytype,
	-- operatortype
	operatortype,
	-- operatorname
	operatorname,
	-- operatorabbrev
	operatorabbrev,
	-- datecreated
	CURRENT_TIMESTAMP,
	-- children
	FALSE,
	-- youth
		(CASE
			WHEN facilitytype LIKE '%Juvenile%' THEN TRUE
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
		(CASE
			WHEN facilitytype LIKE '%Detention%' THEN TRUE
			WHEN facilitytype LIKE '%Residential%' THEN TRUE
			WHEN facilitytype LIKE '%Correctional%' THEN TRUE
			WHEN facilitytype LIKE '%Reception%' THEN TRUE
			ELSE FALSE
		END)
FROM
	dcp_facilities_togeocode;
-- the name of this dataset is very misleading

-- facdb_uid_key
-- insert the new values into the key table
INSERT INTO facdb_uid_key
SELECT hash
FROM dcp_facilities_togeocode
WHERE hash NOT IN (
SELECT hash FROM facdb_uid_key
);
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
       (CASE 
             WHEN oversightabbrev = 'NYSOCFS' THEN 'nysocfs_facilities_facilities'
	     WHEN oversightabbrev = 'USCOURTS' THEN 'uscourts_facilities_courts'
	     WHEN oversightabbrev = 'NYCDOC' THEN 'nycdoc_facilities_corrections'
	     WHEN oversightabbrev = 'NYCOURTS' THEN 'nycourts_facilities_courts'
	     WHEN oversightabbrev = 'NYSDOCCS' THEN 'nysdoccs_facilities_corrections'
	     WHEN oversightabbrev = 'FBOP' THEN 'fbop_facilities_corrections'
	END)
FROM dcp_facilities_togeocode, facilities
WHERE facilities.hash = dcp_facilities_togeocode.hash;

-- agency id NA

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
	oversightagency,
	oversightabbrev,
    (CASE
        WHEN oversightagency IN ('New York City Department of Correction')
            THEN 'City'
        WHEN oversightagency IN ('Federal Bureau of Prisons',
                                 'United States Courts')
            THEN 'Federal'
        WHEN oversightagency IN ('New York State Office of Children and Family Services',
                                 'New York State Department of Corrections and Community Supervision',
                                 'New York State Unified Court System')
            THEN 'State'
     END)
FROM dcp_facilities_togeocode, facilities
WHERE facilities.hash = dcp_facilities_togeocode.hash;

-- utilization NA

