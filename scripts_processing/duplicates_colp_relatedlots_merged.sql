--------------------------------------------------------------------------------------------------
-- 1. CREATING A TABLE TO BACKUP THE DUPLICATE RECORDS BEFORE DROPPING THEM FROM THE DATABASE
--------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS duplicates_colp_relatedlots_merged;
CREATE TABLE duplicates_colp_relatedlots_merged AS (

-- starting with all COLP records that found non-COLP matches in FacDB and were merged/dropped 
WITH primaries AS (
	SELECT
		guid,
		geom,
		facilityname,
		BBL,
		facilitysubgroup,
		oversightabbrev
	FROM (SELECT * FROM duplicates_colp_bin UNION SELECT * FROM duplicates_colp_bbl) AS unioned
),

-- find other related COLP records, matching on agency, name, subgroup, and proximity (within 100m)
matches AS (
	SELECT
		a.guid,
		b.guid AS guid_b,
		a.geom,
		a.facilityname,
		b.facilityname as facilityname_b,
		a.BBL,
		b.BBL as BBL_b,
		a.facilitysubgroup,
		a.oversightabbrev
	FROM primaries AS a
	LEFT JOIN facilities AS b
	ON
		(LEFT(
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
		,4))
		=
		(LEFT(
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
		,4))
	WHERE
		b.pgtable = ARRAY['dcas_facilities_colp']::text[]
		AND a.facilitysubgroup = b.facilitysubgroup
		AND a.oversightabbrev = b.oversightabbrev
		AND a.guid <> b.guid
		AND ST_DWithin(a.geom::geography, b.geom::geography, 100)
		AND b.geom IS NOT NULL
),

duplicates AS (
	SELECT
		guid,
		array_agg(guid_b::text) AS guid_merged_b
	FROM matches
	GROUP BY
	guid
)

SELECT facilities.*
FROM facilities
WHERE facilities.guid::text IN (SELECT unnest(duplicates.guid_merged_b) FROM duplicates)
ORDER BY guid

);

--------------------------------------------------------------------------------------------------
-- 2. UPDATING FACDB BY MERGING ATTRIBUTES FROM DUPLICATE RECORDS INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

-- starting with all COLP records that found non-COLP matches in FacDB and were merged/dropped 
WITH primaries AS (
	SELECT
		guid,
		geom,
		facilityname,
		BBL,
		facilitysubgroup,
		oversightabbrev
	FROM (SELECT * FROM duplicates_colp_bin UNION SELECT * FROM duplicates_colp_bbl) AS unioned
),

-- find other related COLP records, matching on agency, name, subgroup, and proximity (within 100m)
matches AS (
	SELECT
		a.guid,
		a.geom,
		a.facilityname,
		a.facilitysubgroup,
		b.guid AS guid_b,
		b.hash AS hash_b,
		b.idagency AS idagency_b,
		b.bin AS bin_b,
		b.bbl AS bbl_b
	FROM primaries AS a
	LEFT JOIN facilities AS b
	ON
		(LEFT(
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
		,4))
		=
		(LEFT(
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
		,4))
	WHERE
		b.pgtable = ARRAY['dcas_facilities_colp']::text[]
		AND a.facilitysubgroup = b.facilitysubgroup
		AND a.guid <> b.guid
		AND b.geom IS NOT NULL
		AND ST_DWithin(a.geom::geography, b.geom::geography, 100)
),

duplicates AS (
	SELECT
		guid,
		count(*) AS countofdups,
		facilityname,
		facilitysubgroup,
		array_agg(guid_b::text) AS guid_merged_b,
		-- ( CASE WHEN array_agg(bin_b) IS NULL THEN NULL ELSE array_agg(bin_b) END ) AS bin_merged,
		( CASE WHEN array_agg(bbl_b) IS NULL THEN NULL ELSE array_agg(bbl_b) END ) AS bbl_merged,
		array_agg(distinct hash_b) AS hash_merged_b
	FROM matches
	GROUP BY
		guid, facilityname, facilitysubgroup
	ORDER BY facilitysubgroup, countofdups DESC )

UPDATE facilities AS f
SET
	-- BIN = array_cat(BIN, d.bin_merged),
	BBL = array_cat(BBL, d.bbl_merged),
	guid_merged = array_cat(guid_merged, d.guid_merged_b),
	hash_merged = array_cat(hash_merged, d.hash_merged_b)
FROM duplicates AS d
WHERE f.guid_merged @> ARRAY[d.guid::text]
;

--------------------------------------------------------------------------------------------------
-- 3. DROPPING DUPLICATE RECORDS AFTER ATTRIBUTES HAVE BEEN MERGED INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

DELETE FROM facilities
WHERE facilities.guid IN (SELECT duplicates_colp_relatedlots_merged.guid FROM duplicates_colp_relatedlots_merged)
;

