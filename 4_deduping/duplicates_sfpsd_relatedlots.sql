--------------------------------------------------------------------------------------------------
-- 1. CREATING A TABLE TO BACKUP THE DUPLICATE RECORDS BEFORE DROPPING THEM FROM THE DATABASE
--------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS duplicates_sfpsd_relatedlots;
CREATE TABLE duplicates_sfpsd_relatedlots AS (

WITH primaryuids AS (
	SELECT (array_agg(distinct uid))[1] AS uid
	FROM facilities
	WHERE
		array_to_string(pgtable,',') LIKE '%sfpsd%'
	GROUP BY
		idold
),

primaries AS (
	SELECT *
	FROM facilities
	WHERE uid IN (SELECT uid from primaryuids)
),

matches AS (
	SELECT
		a.uid,
		b.uid AS uid_b,
		a.capacity,
		b.capacity AS capacity_b
	FROM primaries AS a
	LEFT JOIN facilities AS b
	ON a.idold = b.idold
	WHERE a.uid <> b.uid
),

duplicates AS (
	SELECT
		uid,
		array_agg(uid_b) AS uid_merged
	FROM matches
	GROUP BY
	uid)

SELECT facilities.*
FROM facilities
WHERE facilities.uid IN (SELECT unnest(duplicates.uid_merged) FROM duplicates)
ORDER BY uid

);

--------------------------------------------------------------------------------------------------
-- 2. UPDATING FACDB BY MERGING ATTRIBUTES FROM DUPLICATE RECORDS INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

WITH primaryuids AS (
	SELECT (array_agg(distinct uid))[1] AS uid
	FROM facilities
	WHERE
		array_to_string(pgtable,',') LIKE '%sfpsd%'
	GROUP BY
		idold
),

primaries AS (
	SELECT *
	FROM facilities
	WHERE uid IN (SELECT uid from primaryuids)
),

matches AS (
	SELECT
		a.idold,
		a.uid,
		b.hash AS hash_b,
		b.uid AS uid_b,
		(CASE WHEN b.bin IS NULL THEN ARRAY['FAKE!'] ELSE b.bin END) AS bin_b,
		(CASE WHEN b.bbl IS NULL THEN ARRAY['FAKE!'] ELSE b.bbl END) AS bbl_b
	FROM primaries AS a
	LEFT JOIN facilities AS b
	ON a.idold = b.idold
	WHERE a.uid <> b.uid
),

duplicates AS (
	SELECT
		uid,
		idold,
		array_agg(hash_b) AS hash_merged,
		array_agg(uid_b) AS uid_merged,
		array_agg(bbl_b) AS bbl,
		array_agg(bin_b) AS bin
	FROM matches
	GROUP BY
	uid, idold)

UPDATE facilities AS f
SET
	uid_merged = array_cat(f.uid_merged,d.uid_merged),
	hash_merged = array_cat(f.hash_merged,d.hash_merged),
	bin = 
		(CASE
			WHEN d.bin <> ARRAY['FAKE!'] THEN array_cat(f.bin,d.bin)
			ELSE f.bin
		END),
	bbl = 
		(CASE
			WHEN d.bbl <> ARRAY['FAKE!'] THEN array_cat(f.bbl,d.bbl)
			ELSE f.bbl
		END)
FROM duplicates AS d
WHERE f.uid = d.uid
;

--------------------------------------------------------------------------------------------------
-- 3. DROPPING DUPLICATE RECORDS AFTER ATTRIBUTES HAVE BEEN MERGED INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

DELETE FROM facilities
WHERE facilities.uid IN (SELECT duplicates_sfpsd_relatedlots.uid FROM duplicates_sfpsd_relatedlots)
;