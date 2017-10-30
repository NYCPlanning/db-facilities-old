-- Reconcile remaining duplicate records 

-- Finding duplicate records
CREATE VIEW duplicates AS
WITH grouping AS (
SELECT 
	min(a.uid) as minuid,
	count(*) as count,
	LEFT(
		TRIM(
			split_part(
		REPLACE(
			REPLACE(
		REPLACE(
			REPLACE(
		REPLACE(
			UPPER(a.facname)
		,'THE ','')
			,'-','')
		,' ','')
			,'.','')
		,',','')
			,'(',1)
		,' ')
	,4) as facnamefour,
	a.pgtable,
	b.pgtable as pgtable_b,
	a.bin
	FROM facilities a
	LEFT JOIN facilities b
	ON a.bin = b.bin
	WHERE
		a.facsubgrp = b.facsubgrp
		AND a.facgroup <> 'Child Care and Pre-Kindergarten'
	    AND a.pgtable <> 'dcas_facilities_colp'
	    AND b.pgtable <> 'dcas_facilities_colp'
		AND a.geom IS NOT NULL
		AND b.geom IS NOT NULL
		AND a.bin IS NOT NULL
		AND b.bin IS NOT NULL
		AND
			LEFT(
				TRIM(
					split_part(
				REPLACE(
					REPLACE(
				REPLACE(
					REPLACE(
				REPLACE(
					UPPER(a.facname)
				,'THE ','')
					,'-','')
				,' ','')
					,'.','')
				,',','')
					,'(',1)
				,' ')
			,4)
			=
			LEFT(
				TRIM(
					split_part(
				REPLACE(
					REPLACE(
				REPLACE(
					REPLACE(
				REPLACE(
					UPPER(b.facname)
				,'THE ','')
					,'-','')
				,' ','')
					,'.','')
				,',','')
					,'(',1)
				,' ')
			,4)
		AND a.pgtable <> b.pgtable
		AND a.uid <> b.uid
		AND ( (a.pgtable = 'dycd_facilities_compass' AND b.pgtable LIKE 'hhs_facilities_%' AND a.facsubgrp = 'Comprehensive After School System (COMPASS) Sites')
		OR (a.pgtable = 'dycd_facilities_otherprograms' AND b.pgtable LIKE 'hhs_facilities_%' AND a.facsubgrp = 'Youth Centers, Literacy Programs, Job Training, and Immigrant Services')
		OR (a.pgtable = 'doe_facilities_schoolsbluebook' AND b.pgtable LIKE 'hhs_facilities_%' AND a.facsubgrp = 'Community Centers and Community School Programs')
		OR (a.pgtable = 'doe_facilities_schoolsbluebook' AND b.pgtable = 'nysed_facilities_activeinstitutions')
		OR (a.pgtable = 'hhs_facilities_proposals' AND b.pgtable = 'hhs_facilities_financialscontracts')
		OR (a.pgtable = 'dfta_facilities_contracts' AND b.pgtable LIKE 'hhs_facilities_%')
		OR (a.pgtable = 'dca_facilities_operatingbusinesses' AND b.pgtable = '%nysdec_facilities_solidwaste')
		OR (a.pgtable = 'dcla_facilities_culturalinstitutions' AND b.pgtable = 'nysed_facilities_activeinstitutions' AND a.facsubgrp = 'Museums')
		OR (a.pgtable = 'nysdoh_facilities_healthfacilities' AND b.pgtable = 'hhs_facilities_proposals')
		OR (a.pgtable = 'nysparks_facilities_historicplaces' AND b.pgtable = 'usnps_facilities_parks')
		OR (a.pgtable = 'dpr_parksproperties' AND b.pgtable = 'bbpc_facilities_sfpsd')
		OR (a.pgtable = 'dpr_parksproperties' AND b.pgtable = 'nysparks_facilities_historicplaces')
		OR (a.pgtable = 'dpr_parksproperties' AND b.pgtable = 'nysdec_facilities_lands')
		OR (a.pgtable = 'sbs_facilities_workforce1' AND b.pgtable = 'hhs_facilities_proposals')
		OR (a.pgtable = 'bic_facilities_tradewaste' AND b.pgtable = 'nysdec_facilities_solidwaste')
		OR (a.pgtable = 'nysomh_facilities_mentalhealth' AND b.pgtable LIKE '%{hhs_facilities_%'))
		GROUP BY
		facnamefour,
		a.pgtable,
		b.pgtable,
		a.bin
)
		SELECT a.*,
			b.minuid
		FROM facilities a
		JOIN grouping b
		ON LEFT(
				TRIM(
					split_part(
				REPLACE(
					REPLACE(
				REPLACE(
					REPLACE(
				REPLACE(
					UPPER(a.facname)
				,'THE ','')
					,'-','')
				,' ','')
					,'.','')
				,',','')
					,'(',1)
				,' ')
			,4)=b.facnamefour
		AND (a.pgtable = b.pgtable 
			OR a.pgtable = b.pgtable_b)
		AND a.bin=b.bin
;

-- Inserting values into relational tables
WITH distincts AS(
	SELECT DISTINCT minuid, bbl
	FROM duplicates
	WHERE bbl IS NOT NULL)

	INSERT INTO facdb_bbl
	SELECT minuid, bbl
	FROM distincts;

WITH distincts AS(
	SELECT DISTINCT minuid, bin
	FROM duplicates
	WHERE bin IS NOT NULL)

	INSERT INTO facdb_bin
	SELECT minuid, bin
	FROM distincts;

WITH distincts AS(
	SELECT DISTINCT minuid, idagency, idname, idfield, pgtable
	FROM duplicates
	WHERE idagency IS NOT NULL)

	INSERT INTO facdb_agencyid
	SELECT minuid, idagency, idname, idfield, pgtable
	FROM distincts;

WITH distincts AS(
	SELECT DISTINCT minuid, area, areatype
	FROM duplicates
	WHERE area IS NOT NULL)

	INSERT INTO facdb_area
	SELECT minuid, area, areatype
	FROM distincts;

WITH distincts AS(
	SELECT DISTINCT minuid, capacity, capacitytype
	FROM duplicates
	WHERE capacity IS NOT NULL)

	INSERT INTO facdb_capacity
	SELECT minuid, capacity, capacitytype
	FROM distincts;

WITH distincts AS(
	SELECT DISTINCT minuid, hash
	FROM duplicates
	WHERE hash IS NOT NULL)

	INSERT INTO facdb_hashes
	SELECT minuid, hash
	FROM distincts;

WITH distincts AS(
	SELECT DISTINCT minuid, overagency, overabbrev, overlevel
	FROM duplicates
	WHERE overagency IS NOT NULL)

	INSERT INTO facdb_oversight
	SELECT minuid, overagency, overabbrev, overlevel
	FROM distincts;

WITH distincts AS(
	SELECT DISTINCT minuid, pgtable
	FROM duplicates
	WHERE pgtable IS NOT NULL)

	INSERT INTO facdb_pgtable
	SELECT minuid, pgtable
	FROM distincts;

WITH distincts AS(
	SELECT DISTINCT minuid, uid
	FROM duplicates
	WHERE uid IS NOT NULL)

	INSERT INTO facdb_uidsmerged
	SELECT minuid, uid
	FROM distincts;

WITH distincts AS(
	SELECT DISTINCT minuid, util, capacitytype
	FROM duplicates
	WHERE util IS NOT NULL)

	INSERT INTO facdb_utilization
	SELECT minuid, util, capacitytype
	FROM distincts;

-- Deleting duplicate records
DELETE FROM facilities USING duplicates
WHERE facilities.uid = duplicates.uid
AND duplicates.uid<>duplicates.minuid;

-- Dropping duplicate records
DROP VIEW IF EXISTS duplicates;



