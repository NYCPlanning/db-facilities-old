--------------------------------------------------------------------------------------------------
-- 1. CREATING A TABLE TO BACKUP THE DUPLICATE RECORDS BEFORE DROPPING THEM FROM THE DATABASE
--------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS duplicates_colp_bbl;
CREATE TABLE duplicates_colp_bbl AS (

WITH matches AS (
	SELECT
		CONCAT(a.pgtable,'-',b.pgtable) as sourcecombo,
		a.uid,
		b.uid as uid_b,
		a.facname,
		b.facname as facname_b
	FROM facilities a
	LEFT JOIN facilities b
	ON a.bbl = b.bbl
	WHERE
		a.facsubgrp = b.facsubgrp
		AND b.pgtable = ARRAY['dcas_facilities_colp']
		AND a.pgtable <> ARRAY['dcas_facilities_colp']
		AND a.overabbrev @> b.overabbrev
		AND a.geom IS NOT NULL
		AND b.geom IS NOT NULL
		AND a.bbl IS NOT NULL
		AND b.bbl IS NOT NULL
		AND a.bbl <> ARRAY['']
		AND b.bbl <> ARRAY['']
		AND a.bbl <> ARRAY['0.00000000000']
		AND b.bbl <> ARRAY['0.00000000000']
		AND a.pgtable <> b.pgtable
		AND a.uid <> b.uid
		ORDER BY CONCAT(a.pgtable,'-',b.pgtable), a.facname, a.facsubgrp
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

WITH matches AS (
	SELECT
		CONCAT(a.pgtable,'-',b.pgtable) as sourcecombo,
		a.idagency,
		b.idagency as idagency_b,
		a.uid,
		b.uid as uid_b,
		a.hash,
		b.hash as hash_b,
		a.facname,
		b.facname as facname_b,
		a.facsubgrp,
		b.facsubgrp as facsubgrp_b,
		a.factype,
		b.factype as factype_b,
		a.processingflag,
		b.processingflag as processingflag_b,
		a.bbl,
		(CASE WHEN b.bin IS NULL THEN ARRAY ['FAKE!'] ELSE b.bin END) as bin_b,
		a.address,
		b.address as address_b,
		a.geom,
		a.pgtable,
		b.pgtable as pgtable_b,
		a.datasource,
		b.datasource as datasource_b,
		a.dataname,
		b.dataname as dataname_b,
		b.datadate as datadate_b,
		b.dataurl as dataurl_b,
		a.overagency,
		b.overlevel as overlevel_b,
		b.overagency as overagency_b,
		a.overabbrev,
		b.overabbrev as overabbrev_b,
		b.agencyclass2,
		b.proptype as proptype_b,
		b.colpusetype
	FROM facilities a
	LEFT JOIN facilities b
	ON a.bbl = b.bbl
	WHERE
		a.facsubgrp = b.facsubgrp
		AND b.pgtable = ARRAY['dcas_facilities_colp']
		AND a.pgtable <> ARRAY['dcas_facilities_colp']
		AND a.overabbrev @> b.overabbrev
		AND a.geom IS NOT NULL
		AND b.geom IS NOT NULL
		AND a.bbl IS NOT NULL
		AND b.bbl IS NOT NULL
		AND a.bbl <> ARRAY['']
		AND b.bbl <> ARRAY['']
		AND a.bbl <> ARRAY['0.00000000000']
		AND b.bbl <> ARRAY['0.00000000000']
		AND a.pgtable <> b.pgtable
		AND a.uid <> b.uid
		ORDER BY CONCAT(a.pgtable,'-',b.pgtable), a.facname, a.facsubgrp
	), 

duplicates AS (
	SELECT
		count(*) AS countofdups,
		facname,
		factype,
		array_agg(distinct factype_b) AS factype_merged,
		uid,
		array_agg(distinct uid_b) AS uid_merged,
		array_agg(distinct hash_b) AS hash_merged,
		array_agg(distinct bin_b) AS bin,
		array_agg(distinct datasource_b) AS datasource,
		array_agg(distinct dataname_b) AS dataname,
		array_agg(distinct datadate_b) AS datadate,
		array_agg(distinct dataurl_b) AS dataurl,
		array_agg(distinct overlevel_b) AS overlevel,
		array_agg(distinct overagency_b) AS overagency,
		array_agg(distinct overabbrev_b) AS overabbrev,
		array_agg(distinct pgtable_b) AS pgtable,
		array_agg(distinct colpusetype) AS colpusetype,
		unnest(array_agg(distinct proptype_b)) AS proptype
	FROM matches
	GROUP BY
	uid, facname, factype
	ORDER BY factype, countofdups DESC )

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
	datasource = array_cat(f.datasource,d.datasource),
	dataname = array_cat(f.dataname,d.dataname),
	datadate = array_cat(f.datadate,d.datadate),
	dataurl = array_cat(f.dataurl,d.dataurl),
	colpusetype = d.colpusetype,
	proptype = d.proptype
FROM duplicates AS d
WHERE f.uid = d.uid
;

--------------------------------------------------------------------------------------------------
-- 3. DROPPING DUPLICATE RECORDS AFTER ATTRIBUTES HAVE BEEN MERGED INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

DELETE FROM facilities
WHERE facilities.uid IN (SELECT duplicates_colp_bbl.uid FROM duplicates_colp_bbl)
;

