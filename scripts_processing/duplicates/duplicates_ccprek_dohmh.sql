--------------------------------------------------------------------------------------------------
-- 1. CREATING A TABLE TO BACKUP THE DUPLICATE RECORDS BEFORE DROPPING THEM FROM THE DATABASE
--------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS duplicates_ccprek_dohmh;
CREATE TABLE duplicates_ccprek_dohmh AS (

-- starting with all records in table, 
WITH primaryguids AS (
	SELECT
		(array_agg(distinct guid))[1] AS guid
		-- ^ grabs first guid to keep for the primary record
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
	WHERE guid IN (SELECT guid from primaryguids)
),

matches AS (
	SELECT
		a.guid,
		b.guid AS guid_b
	FROM primaries AS a
	LEFT JOIN facilities AS b
	ON a.bin = b.bin
	WHERE
		b.pgtable = ARRAY['dohmh_facilities_daycare']::text[]
		AND a.facilitysubgroup = b.facilitysubgroup
		AND a.guid <> b.guid
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
		guid,
		array_agg(guid_b) AS guid_merged
	FROM matches
	GROUP BY
	guid
)

SELECT facilities.*
FROM facilities
WHERE facilities.guid IN (SELECT unnest(duplicates.guid_merged) FROM duplicates)
ORDER BY guid

);

--------------------------------------------------------------------------------------------------
-- 2. UPDATING FACDB BY MERGING ATTRIBUTES FROM DUPLICATE RECORDS INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

WITH primaryguids AS (
	SELECT
		(array_agg(distinct guid))[1] AS guid
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
	WHERE guid IN (SELECT guid from primaryguids)
),

matches AS (
	SELECT
		a.guid,
		a.facilityname,
		a.facilitytype,
		a.capacity,
		(CASE WHEN b.capacity IS NULL THEN ARRAY['FAKE!'] ELSE b.capacity END) AS capacity_b,
		b.guid AS guid_b,
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
		AND a.guid <> b.guid
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
		guid,
		count(*) AS countofdups,
		facilityname,
		facilitytype,
		array_agg(bin_b) AS bin_merged,
		array_agg(guid_b) AS guid_merged,
		array_agg(distinct idagency_b) AS idagency_merged,
		array_agg(distinct hash_b) AS hash_merged,
		array_agg(capacity_b) AS capacity_merged
	FROM matches
	GROUP BY
		guid, facilityname, facilitytype, capacity
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
	guid_merged = d.guid_merged,
	hash_merged = d.hash_merged,
	capacity = 
		(CASE 
			WHEN d.capacity_merged <> ARRAY['FAKE!'] THEN array_cat(f.capacity, d.capacity_merged)
			ELSE f.capacity
		END)
FROM duplicates AS d
WHERE f.guid = d.guid
;

--------------------------------------------------------------------------------------------------
-- 3. DROPPING DUPLICATE RECORDS AFTER ATTRIBUTES HAVE BEEN MERGED INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

DELETE FROM facilities
WHERE facilities.guid IN (SELECT duplicates_ccprek_dohmh.guid FROM duplicates_ccprek_dohmh)
;

