--------------------------------------------------------------------------------------------------
-- 1. CREATING A TABLE TO BACKUP THE DUPLICATE RECORDS BEFORE DROPPING THEM FROM THE DATABASE
--------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS duplicates_ccprek_dohmh;
CREATE TABLE duplicates_ccprek_dohmh AS (

-- starting with all records in table, 
WITH primaries AS (
	SELECT
		(array_agg(distinct guid))[1] AS guid,
		array_agg(distinct guid) AS guid_merged,
		(array_agg(distinct facilityname))[1] AS facilityname,
		BBL,
		facilitysubgroup
		-- ^ grabs first guid to keep for the primary record
	FROM facilities
	WHERE
		pgtable = ARRAY['dohmh_facilities_daycare']::text[]
		AND geom IS NOT NULL
		AND BBL IS NOT NULL
		AND BBL <> '{""}'
		AND BBL <> '{0.00000000000}'
	GROUP BY
		facilitysubgroup,
		BBL,
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

matches AS (
	SELECT
		a.guid,
		b.guid AS guid_b
	FROM primaries AS a
	LEFT JOIN facilities AS b
	ON a.bbl = b.bbl
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

WITH primaries AS (
	SELECT
		(array_agg(distinct guid))[1] AS guid,
		(array_agg(distinct facilityname))[1] AS facilityname,
		array_to_string((array_agg(distinct facilitytype)),' & ') AS facilitytype,
		BBL,
		(SELECT SUM(s) FROM UNNEST(array_agg(capacity)) s) AS capacity,
		facilitysubgroup
	FROM facilities
	WHERE
		pgtable = ARRAY['dohmh_facilities_daycare']::text[]
		AND geom IS NOT NULL
		AND BBL IS NOT NULL
		AND BBL <> '{""}'
		AND BBL <> '{0.00000000000}'
	GROUP BY
		facilitysubgroup,
		BBL,
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

matches AS (
	SELECT
		a.guid,
		a.facilityname,
		a.facilitytype,
		a.capacity,
		b.guid AS guid_b,
		b.hash AS hash_b,
		b.idagency AS idagency_b,
		b.bin AS bin_b
	FROM primaries AS a
	LEFT JOIN facilities AS b
	ON
	a.bbl = b.bbl
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
		array_agg(BIN_b) AS bin_merged,
		array_agg(guid_b) AS guid_merged,
		array_agg(distinct idagency_b) AS idagency_merged,
		array_agg(distinct hash_b) AS hash_merged,
		capacity
	FROM matches
	GROUP BY
		guid, facilityname, facilitytype, capacity
	ORDER BY facilitytype, countofdups DESC )

UPDATE facilities AS f
SET
	BIN = array_cat(BIN, d.bin_merged),
	idagency = array_cat(idagency, d.idagency_merged),
	guid_merged = d.guid_merged,
	hash_merged = d.hash_merged,
	capacity = d.capacity
FROM duplicates AS d
WHERE f.guid = d.guid
;

--------------------------------------------------------------------------------------------------
-- 3. DROPPING DUPLICATE RECORDS AFTER ATTRIBUTES HAVE BEEN MERGED INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

DELETE FROM facilities
WHERE facilities.guid IN (SELECT duplicates_ccprek_dohmh.guid FROM duplicates_ccprek_dohmh)
;

