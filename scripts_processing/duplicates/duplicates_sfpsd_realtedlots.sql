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
		a.hash,
		b.hash AS hash_b,
		a.capacity,
		b.capacity AS capacity_b
	FROM primaries AS a
	LEFT JOIN facilities AS b
	ON a.idold = b.idold
),

duplicates AS (
	SELECT
		hash,
		array_agg(hash_b) AS hash_merged
	FROM matches
	GROUP BY
	hash)

duplicates AS (
	SELECT
		count(*) AS countofdups,
		facilityname,
		facilitytype,
		array_agg(distinct facilitytype_b) AS facilitytype_merged,
		hash,
		array_agg(uid_b) AS uid_merged,
		array_agg(hash_b) AS hash_merged,
		array_agg(bin_b) AS bin,
		array_agg(distinct agencysource_b) AS agencysource,
		array_agg(distinct sourcedatasetname_b) AS sourcedatasetname,
		array_agg(distinct datesourceupdated_b) AS datesourceupdated,
		array_agg(distinct linkdata_b) AS linkdata,
		array_agg(distinct oversightlevel_b) AS oversightlevel,
		array_agg(distinct oversightagency_b) AS oversightagency,
		array_agg(distinct oversightabbrev_b) AS oversightabbrev,
		array_agg(distinct pgtable_b) AS pgtable,
		array_agg(distinct colpusetype) AS colpusetype,
		unnest(array_agg(distinct propertytype_b)) AS propertytype
	FROM matches
	GROUP BY
	hash, facilityname, facilitytype
	ORDER BY facilitytype, countofdups DESC )

UPDATE facilities AS f
SET
	uid_merged = d.uid_merged,
	hash_merged = d.hash_merged,
	bin = 
		(CASE
			WHEN d.bin <> ARRAY['FAKE!'] THEN array_cat(f.bin,d.bin)
			ELSE f.bin
		END),
	pgtable = array_cat(f.pgtable,d.pgtable),
	agencysource = array_cat(f.agencysource,d.agencysource),
	sourcedatasetname = array_cat(f.sourcedatasetname,d.sourcedatasetname),
	datesourceupdated = array_cat(f.datesourceupdated,d.datesourceupdated),
	linkdata = array_cat(f.linkdata,d.linkdata),
	colpusetype = d.colpusetype,
	propertytype = d.propertytype
FROM duplicates AS d
WHERE f.hash = d.hash
;

--------------------------------------------------------------------------------------------------
-- 3. DROPPING DUPLICATE RECORDS AFTER ATTRIBUTES HAVE BEEN MERGED INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

DELETE FROM facilities
WHERE facilities.hash IN (SELECT duplicates_sfpsd_relatedlots.hash FROM duplicates_sfpsd_relatedlots)
;

