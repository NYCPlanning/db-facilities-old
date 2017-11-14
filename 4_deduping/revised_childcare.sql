CREATE VIEW duplicates AS
WITH groupings AS (
	SELECT
		min(a.uid) AS minuid,
		array_agg(DISTINCT a.uid) AS alluids,
		count(DISTINCT a.uid) AS count,
		array_to_string(array_agg(DISTINCT a.pgtable),',') AS pgtables,
		array_to_string(array_agg(DISTINCT a.factype),',') AS factypes,
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
		,4) AS facnamefour,
		a.bin
	FROM facdb_backuppredup a
	LEFT JOIN facdb_backuppredup b
	ON a.bin = b.bin
	WHERE
		a.facgroup = 'Child Care and Pre-Kindergarten' AND b.facgroup = 'Child Care and Pre-Kindergarten'
		AND a.factype <> 'K-12 School - Unspecified' AND b.factype <> 'K-12 School - Unspecified'
		AND a.factype <> 'DOE Lyfe Program Child Care' AND b.factype <> 'DOE Lyfe Program Child Care'
		AND a.factype NOT LIKE '%Disabilities%' AND b.factype NOT LIKE '%Disabilities%'
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
	GROUP BY
		a.bin,
		b.bin,
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
	ORDER BY bin
),

lookup AS (
	SELECT minuid, unnest(alluids) AS uids, factypes, pgtables FROM groupings
),

duplicates AS (
SELECT
	a.*,
	b.uid,
	b.pgtable,
	ROW_NUMBER() OVER (PARTITION BY a.minuid ORDER BY
		CASE b.pgtable
			WHEN 'doe_facilities_universalprek' THEN 1
			WHEN 'acs_facilities_daycareheadstart' THEN 2
			WHEN 'doe_facilities_schoolsbluebook' THEN 3
			WHEN 'dcas_facilities_colp' THEN 4
			WHEN 'hhs_facilities_financialscontracts' THEN 5
			WHEN 'hhs_facilities_proposals' THEN 6
			WHEN 'dohmh_facilities_daycare' THEN 7
			ELSE 8
		END) AS ranking,
	CASE
		WHEN pgtables LIKE '%doe_facilities_universalprek%' AND factypes LIKE '%Infant%' THEN 'Dual Child Care and Universal Pre-K'
		WHEN pgtables LIKE '%doe_facilities_universalprek%' AND factypes NOT LIKE '%Infant%' THEN 'DOE Universal Pre-Kindergarten'
		ELSE 'Child Care'
	END AS facsubgrp
FROM lookup AS a
LEFT JOIN facdb_backuppredup AS b
ON a.uids = b.uid
ORDER BY minuid)

SELECT facsubgrp, count(*)
FROM duplicates
WHERE ranking = 1
GROUP BY facsubgrp

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

-- 
UPDATE facilities
SET facsubgrp = 

-- Deleting duplicate records
DELETE FROM facilities USING duplicates
WHERE facilities.uid = duplicates.uid
AND duplicates.ranking<>1;

-- Dropping duplicate records
DROP VIEW IF EXISTS duplicates;
