-- Reconcile duplicate records in COLP by bbl 

-- Finding duplicate records
CREATE VIEW duplicates AS
WITH grouping AS (
SELECT 
	min(a.uid) as minuid,
	count(*) as count,
	a.bbl,
	a.facsubgrp,
	a.overabbrev
	FROM facilities a
	JOIN facilities b
	ON a.bbl = b.bbl
	WHERE
		a.facsubgrp=b.facsubgrp
		AND a.overabbrev=b.overabbrev
		AND b.pgtable = 'dcas_facilities_colp'
		AND a.pgtable <> b.pgtable
		AND a.geom IS NOT NULL
		AND b.geom IS NOT NULL
		AND a.bbl IS NOT NULL
		AND a.bbl <> '{""}'
	GROUP BY 
		a.bbl,
		a.facsubgrp,
		a.overabbrev),
-- getting attributes for colp records
colpdups AS (
	SELECT 
		a.minuid,
		b.*
	FROM grouping a
	LEFT JOIN facilities b
	ON a.bbl = b.bbl AND a.facsubgrp = b.facsubgrp AND a.overabbrev = b.overabbrev
	WHERE b.pgtable = 'dcas_facilities_colp')
-- finding duplicate neighbioring colp records
	SELECT a.minuid,
	b.*
	FROM colpdups a
	LEFT JOIN facilities b
	ON a.factype=b.factype AND a.overabbrev=b.overabbrev
	WHERE
		b.pgtable = 'dcas_facilities_colp'
		AND b.geom IS NOT NULL
		AND ST_DWithin(a.geom::geography, b.geom::geography, 500)
		AND LEFT(
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
			,4);

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



