--------------------------------------------------------------------------------------------------
-- 1. CREATING A TABLE TO BACKUP THE DUPLICATE RECORDS BEFORE DROPPING THEM FROM THE DATABASE
--------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS duplicates_sfpsd_relatedlots;
CREATE TABLE duplicates_sfpsd_relatedlots AS (

WITH primaryhashs AS (
	SELECT (array_agg(distinct hash))[1] AS hash
	FROM facilities
	WHERE
		array_to_string(pgtable,',') LIKE '%sfpsd%'
	GROUP BY
		idold
),

primaries AS (
	SELECT *
	FROM facilities
	WHERE hash IN (SELECT hash from primaryhashs)
),

matches AS (
	SELECT
		a.hash,
		b.hash AS hash_b,
		a.capacity,
		b.capacity AS capacity_b
	FROM primaries AS a
	LEFT JOIN facilities AS b
	ON a.idold = b.idold
	WHERE a.hash <> b.hash
),

duplicates AS (
	SELECT
		hash,
		array_agg(hash_b) AS hash_merged
	FROM matches
	GROUP BY
	hash)

SELECT facilities.*
FROM facilities
WHERE facilities.hash IN (SELECT unnest(duplicates.hash_merged) FROM duplicates)
ORDER BY hash

);

--------------------------------------------------------------------------------------------------
-- 2. UPDATING FACDB BY MERGING ATTRIBUTES FROM DUPLICATE RECORDS INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

WITH primaryhashs AS (
	SELECT (array_agg(distinct hash))[1] AS hash
	FROM facilities
	WHERE
		array_to_string(pgtable,',') LIKE '%sfpsd%'
	GROUP BY
		idold
),

primaries AS (
	SELECT *
	FROM facilities
	WHERE hash IN (SELECT hash from primaryhashs)
),

matches AS (
	SELECT
		a.idold,
		a.hash,
		b.hash AS hash_b,
		b.uid AS uid_b,
		(CASE WHEN b.bin IS NULL THEN ARRAY['FAKE!'] ELSE b.bin END) AS bin_b,
		(CASE WHEN b.bbl IS NULL THEN ARRAY['FAKE!'] ELSE b.bbl END) AS bbl_b
	FROM primaries AS a
	LEFT JOIN facilities AS b
	ON a.idold = b.idold
	WHERE a.hash <> b.hash
),

duplicates AS (
	SELECT
		hash,
		idold,
		array_agg(hash_b) AS hash_merged,
		array_agg(uid_b) AS uid_merged,
		array_agg(bbl_b) AS bbl,
		array_agg(bin_b) AS bin
	FROM matches
	GROUP BY
	hash, idold)

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
WHERE f.hash = d.hash
;

--------------------------------------------------------------------------------------------------
-- 3. DROPPING DUPLICATE RECORDS AFTER ATTRIBUTES HAVE BEEN MERGED INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

DELETE FROM facilities
WHERE facilities.hash IN (SELECT duplicates_sfpsd_relatedlots.hash FROM duplicates_sfpsd_relatedlots)
;

