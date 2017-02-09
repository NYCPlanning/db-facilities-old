--------------------------------------------------------------------------------------------------
-- 1. CREATING A TABLE TO BACKUP THE DUPLICATE RECORDS BEFORE DROPPING THEM FROM THE DATABASE
--------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS duplicates_ccprek_dohmh;
CREATE TABLE duplicates_ccprek_dohmh AS (

-- starting with all records in table, 
WITH primaryhashs AS (
	SELECT
		(array_agg(distinct hash))[1] AS hash
		-- ^ grabs first hash to keep for the primary record
	FROM facilities
	WHERE
		pgtable = ARRAY['dohmh_facilities_daycare']::text[]
		AND geom IS NOT NULL
		AND bin IS NOT NULL
		AND bin <> ARRAY['']
		AND bin <> ARRAY['0.00000000000']
	GROUP BY
		facilitysubgroup,
		bin,
		(LEFT(
			TRIM(
		split_part(
			REPLACE(
		REPLACE(
			REPLACE(
		REPLACE(
			REPLACE(
		UPPER(facilityname)
			,'THE ','')
		,'-','')
			,' ','')
		,'.','')
			,',','')
		,'(',1)
			,' ')
		,4))
),

primaries AS (
	SELECT *
	FROM facilities
	WHERE hash IN (SELECT hash from primaryhashs)
),

matches AS (
	SELECT
		a.hash,
		b.hash AS hash_b
	FROM primaries AS a
	LEFT JOIN facilities AS b
	ON a.bin = b.bin
	WHERE
		b.pgtable = ARRAY['dohmh_facilities_daycare']::text[]
		AND a.facilitysubgroup = b.facilitysubgroup
		AND a.hash <> b.hash
		AND b.geom IS NOT NULL
		AND
			LEFT(
				TRIM(
					split_part(
				REPLACE(
					REPLACE(
				REPLACE(
					REPLACE(
				REPLACE(
					UPPER(a.facilityname)
				,'THE ','')
					,'-','')
				,' ','')
					,'.','')
				,',','')
					,'(',1)
				,' ')
			,4)
			LIKE
			LEFT(
				TRIM(
					split_part(
				REPLACE(
					REPLACE(
				REPLACE(
					REPLACE(
				REPLACE(
					UPPER(b.facilityname)
				,'THE ','')
					,'-','')
				,' ','')
					,'.','')
				,',','')
					,'(',1)
				,' ')
			,4)
),

duplicates AS (
	SELECT
		hash,
		array_agg(hash_b) AS hash_merged
	FROM matches
	GROUP BY
	hash
)

SELECT facilities.*
FROM facilities
WHERE facilities.hash IN (SELECT unnest(duplicates.hash_merged) FROM duplicates)
ORDER BY hash

);

--------------------------------------------------------------------------------------------------
-- 2. UPDATING FACDB BY MERGING ATTRIBUTES FROM DUPLICATE RECORDS INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

WITH primaryhashs AS (
	SELECT
		(array_agg(distinct hash))[1] AS hash
	FROM facilities
	WHERE
		pgtable = ARRAY['dohmh_facilities_daycare']::text[]
		AND geom IS NOT NULL
		AND bin IS NOT NULL
		AND bin <> ARRAY['']
		AND bin <> ARRAY['0.00000000000']
	GROUP BY
		facilitysubgroup,
		bin,
		(LEFT(
			TRIM(
		split_part(
			REPLACE(
		REPLACE(
			REPLACE(
		REPLACE(
			REPLACE(
		UPPER(facilityname)
			,'THE ','')
		,'-','')
			,' ','')
		,'.','')
			,',','')
		,'(',1)
			,' ')
		,4))
),

primaries AS (
	SELECT *
	FROM facilities
	WHERE hash IN (SELECT hash from primaryhashs)
),

matches AS (
	SELECT
		a.hash,
		a.facilityname,
		a.facilitytype,
		a.capacity,
		(CASE WHEN b.capacity IS NULL THEN ARRAY['FAKE!'] ELSE b.capacity END) AS capacity_b,
		b.uid AS uid_b,
		b.hash AS hash_b,
		(CASE WHEN b.idagency IS NULL THEN ARRAY['FAKE!'] ELSE b.idagency END) AS idagency_b,
		(CASE WHEN b.bin IS NULL THEN ARRAY['FAKE!'] ELSE b.bin END) AS bin_b
	FROM primaries AS a
	LEFT JOIN facilities AS b
	ON
	a.bin = b.bin
	WHERE
		b.pgtable = ARRAY['dohmh_facilities_daycare']::text[]
		AND a.facilitysubgroup = b.facilitysubgroup
		AND a.hash <> b.hash
		AND b.geom IS NOT NULL
		AND
			LEFT(
				TRIM(
					split_part(
				REPLACE(
					REPLACE(
				REPLACE(
					REPLACE(
				REPLACE(
					UPPER(a.facilityname)
				,'THE ','')
					,'-','')
				,' ','')
					,'.','')
				,',','')
					,'(',1)
				,' ')
			,4)
			LIKE
			LEFT(
				TRIM(
					split_part(
				REPLACE(
					REPLACE(
				REPLACE(
					REPLACE(
				REPLACE(
					UPPER(b.facilityname)
				,'THE ','')
					,'-','')
				,' ','')
					,'.','')
				,',','')
					,'(',1)
				,' ')
			,4)
),

duplicates AS (
	SELECT
		hash,
		count(*) AS countofdups,
		facilityname,
		facilitytype,
		array_agg(bin_b) AS bin_merged,
		array_agg(uid_b) AS uid_merged,
		array_agg(distinct idagency_b) AS idagency_merged,
		array_agg(distinct hash_b) AS hash_merged,
		array_agg(capacity_b) AS capacity_merged
	FROM matches
	GROUP BY
		hash, facilityname, facilitytype, capacity
	ORDER BY facilitytype, countofdups DESC )

UPDATE facilities AS f
SET
	bin = 
		(CASE 
			WHEN d.bin_merged <> ARRAY['FAKE!'] THEN array_cat(f.bin, d.bin_merged)
			ELSE f.bin
		END),
	idagency = 
		(CASE 
			WHEN d.idagency_merged <> ARRAY['FAKE!'] THEN array_cat(f.idagency, d.idagency_merged)
			ELSE f.idagency
		END),
	uid_merged = d.uid_merged,
	hash_merged = d.hash_merged,
	capacity = 
		(CASE 
			WHEN d.capacity_merged <> ARRAY['FAKE!'] THEN array_cat(f.capacity, d.capacity_merged)
			ELSE f.capacity
		END)
FROM duplicates AS d
WHERE f.hash = d.hash
;

--------------------------------------------------------------------------------------------------
-- 3. DROPPING DUPLICATE RECORDS AFTER ATTRIBUTES HAVE BEEN MERGED INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

DELETE FROM facilities
WHERE facilities.hash IN (SELECT duplicates_ccprek_dohmh.hash FROM duplicates_ccprek_dohmh)
;

