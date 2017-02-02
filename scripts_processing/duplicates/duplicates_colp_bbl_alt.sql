--------------------------------------------------------------------------------------------------
-- 1. CREATING A TABLE TO BACKUP THE DUPLICATE RECORDS BEFORE DROPPING THEM FROM THE DATABASE
--------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS duplicates_colp_bbl;
CREATE TABLE duplicates_colp_bbl AS (

WITH matches AS (
	SELECT
		CONCAT(a.pgtable,'-',b.pgtable) as sourcecombo,
		a.guid,
		b.guid as guid_b,
		a.facilityname,
		b.facilityname as facilityname_b
	FROM facilities a
	LEFT JOIN facilities b
	ON a.bbl = b.bbl
	WHERE
		a.facilitysubgroup = b.facilitysubgroup
		AND b.pgtable = ARRAY['dcas_facilities_colp']
		AND a.pgtable <> ARRAY['dcas_facilities_colp']
		AND a.oversightabbrev @> b.oversightabbrev
		AND a.geom IS NOT NULL
		AND b.geom IS NOT NULL
		AND a.bbl IS NOT NULL
		AND b.bbl IS NOT NULL
		AND a.bbl <> ARRAY['']
		AND b.bbl <> ARRAY['']
		AND a.bbl <> ARRAY['0.00000000000']
		AND b.bbl <> ARRAY['0.00000000000']
		AND a.pgtable <> b.pgtable
		AND a.guid <> b.guid
		ORDER BY CONCAT(a.pgtable,'-',b.pgtable), a.facilityname, a.facilitysubgroup
	),  

duplicates AS (
	SELECT
		guid,
		array_agg(guid_b) AS guid_merged
	FROM matches
	GROUP BY
	guid)

SELECT facilities.*
FROM facilities
WHERE facilities.guid IN (SELECT unnest(duplicates.guid_merged) FROM duplicates)
ORDER BY guid

);

--------------------------------------------------------------------------------------------------
-- 2. UPDATING FACDB BY MERGING ATTRIBUTES FROM DUPLICATE RECORDS INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

WITH matches AS (
	SELECT
		CONCAT(a.pgtable,'-',b.pgtable) as sourcecombo,
		a.idagency,
		b.idagency as idagency_b,
		a.guid,
		b.guid as guid_b,
		a.hash,
		b.hash as hash_b,
		a.facilityname,
		b.facilityname as facilityname_b,
		a.facilitysubgroup,
		b.facilitysubgroup as facilitysubgroup_b,
		a.facilitytype,
		b.facilitytype as facilitytype_b,
		a.processingflag,
		b.processingflag as processingflag_b,
		a.bbl,
		(CASE WHEN b.bin IS NULL THEN ARRAY ['FAKE!'] ELSE b.bin END) as bin_b,
		a.address,
		b.address as address_b,
		a.geom,
		a.pgtable,
		b.pgtable as pgtable_b,
		a.agencysource,
		b.agencysource as agencysource_b,
		a.sourcedatasetname,
		b.sourcedatasetname as sourcedatasetname_b,
		b.linkdata as linkdata_b,
		a.oversightagency,
		b.oversightagency as oversightagency_b,
		a.oversightabbrev,
		b.oversightabbrev as oversightabbrev_b,
		b.agencyclass2,
		b.propertytype as propertytype_b,
		b.colpusetype
	FROM facilities a
	LEFT JOIN facilities b
	ON a.bbl = b.bbl
	WHERE
		a.facilitysubgroup = b.facilitysubgroup
		AND b.pgtable = ARRAY['dcas_facilities_colp']
		AND a.pgtable <> ARRAY['dcas_facilities_colp']
		AND a.oversightabbrev @> b.oversightabbrev
		AND a.geom IS NOT NULL
		AND b.geom IS NOT NULL
		AND a.bbl IS NOT NULL
		AND b.bbl IS NOT NULL
		AND a.bbl <> ARRAY['']
		AND b.bbl <> ARRAY['']
		AND a.bbl <> ARRAY['0.00000000000']
		AND b.bbl <> ARRAY['0.00000000000']
		AND a.pgtable <> b.pgtable
		AND a.guid <> b.guid
		ORDER BY CONCAT(a.pgtable,'-',b.pgtable), a.facilityname, a.facilitysubgroup
	), 

duplicates AS (
	SELECT
		count(*) AS countofdups,
		facilityname,
		facilitytype,
		array_agg(distinct facilitytype_b) AS facilitytype_merged,
		guid,
		array_agg(guid_b) AS guid_merged,
		array_agg(hash_b) AS hash_merged,
		array_agg(bin_b) AS bin,
		array_agg(distinct agencysource_b) AS agencysource,
		array_agg(distinct sourcedatasetname_b) AS sourcedatasetname,
		array_agg(distinct linkdata_b) AS linkdata,
		array_agg(distinct oversightagency_b) AS oversightagency,
		array_agg(distinct oversightabbrev_b) AS oversightabbrev,
		array_agg(distinct pgtable_b) AS pgtable,
		array_agg(distinct colpusetype) AS colpusetype,
		unnest(array_agg(distinct propertytype_b)) AS propertytype
	FROM matches
	GROUP BY
	guid, facilityname, facilitytype
	ORDER BY facilitytype, countofdups DESC )

UPDATE facilities AS f
SET
	guid_merged = d.guid_merged,
	hash_merged = d.hash_merged,
	bin = 
		(CASE
			WHEN d.bin <> ARRAY['FAKE!'] THEN array_cat(f.bin,d.bin)
			ELSE f.bin
		END),
	pgtable = array_cat(f.pgtable,d.pgtable),
	agencysource = array_cat(f.agencysource,d.agencysource),
	sourcedatasetname = array_cat(f.sourcedatasetname,d.sourcedatasetname),
	linkdata = array_cat(f.linkdata,d.linkdata),
	colpusetype = d.colpusetype,
	propertytype = d.propertytype
FROM duplicates AS d
WHERE f.guid = d.guid
;

--------------------------------------------------------------------------------------------------
-- 3. DROPPING DUPLICATE RECORDS AFTER ATTRIBUTES HAVE BEEN MERGED INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

DELETE FROM facilities
WHERE facilities.guid IN (SELECT duplicates_colp_bbl.guid FROM duplicates_colp_bbl)
;

