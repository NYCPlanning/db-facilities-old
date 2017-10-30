-- Reconcile duplicate records in DOE and ACS data keeping DOE as the primary record

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
		a.pgtable = 'doe_facilities_universalprek'
		AND b.pgtable = 'acs_facilities_daycareheadstart'
		AND a.facgroup LIKE '%Child Care%'
		AND (a.factype LIKE '%Early%'
			OR a.factype LIKE '%Charter%')
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
	,4),
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
	,4),
	a.pgtable,
	b.pgtable,
	a.bin,
	b.bin
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

-- Changing the facsubgrp for duplicate records
UPDATE facilities AS f
SET
facsubgrp = 'Dual Child Care and Universal Pre-K'
WHERE f.uid IN (SELECT DISTINCT minuid FROM duplicates);

-- Deleting duplicate records
DELETE FROM facilities USING duplicates
WHERE facilities.uid = duplicates.uid
AND duplicates.uid<>duplicates.minuid;

-- Dropping duplicate records
DROP VIEW IF EXISTS duplicates;



