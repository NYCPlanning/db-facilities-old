--------------------------------------------------------------------------------------------------
-- 1. CREATING A TABLE TO BACKUP THE DUPLICATE RECORDS BEFORE DROPPING THEM FROM THE DATABASE
--------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS duplicates_ccprek_acs_dohmh;
CREATE TABLE duplicates_ccprek_acs_dohmh AS (

WITH matches AS (
	SELECT
		CONCAT(a.pgtable,'-',b.pgtable) as sourcecombo,
		a.guid,
		b.guid as guid_b,
		a.facilityname,
		b.facilityname as facilityname_b
	FROM facilities a
	LEFT JOIN facilities b
	ON a.bin = b.bin
	WHERE
		b.facilitytype NOT LIKE '%Camp%'
		AND a.pgtable = ARRAY['acs_facilities_daycareheadstart']::text[]
		AND b.pgtable = ARRAY['dohmh_facilities_daycare']::text[]
		AND a.geom IS NOT NULL
		AND b.geom IS NOT NULL
		AND a.bin IS NOT NULL
		AND b.bin IS NOT NULL
		AND a.bin <> ARRAY['']
		AND b.bin <> ARRAY['']
		AND a.bin <> ARRAY['0.00000000000']
		AND b.bin <> ARRAY['0.00000000000']
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
		(CASE WHEN b.capacity IS NULL THEN ARRAY['FAKE!'] ELSE b.capacity END) as capacity_b,
		(CASE WHEN b.capacitytype IS NULL THEN ARRAY['FAKE!'] ELSE b.capacitytype END) capacitytype_b,
		a.bin,
		b.bin as bin_b,
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
		b.oversightabbrev as oversightabbrev_b
	FROM facilities a
	LEFT JOIN facilities b
	ON a.bin = b.bin
	WHERE
		b.facilitytype NOT LIKE '%Camp%'
		AND a.pgtable = ARRAY['acs_facilities_daycareheadstart']::text[]
		AND b.pgtable = ARRAY['dohmh_facilities_daycare']::text[]
		AND a.geom IS NOT NULL
		AND b.geom IS NOT NULL
		AND a.bin IS NOT NULL
		AND b.bin IS NOT NULL
		AND a.bin <> ARRAY['']
		AND b.bin <> ARRAY['']
		AND a.bin <> ARRAY['0.00000000000']
		AND b.bin <> ARRAY['0.00000000000']
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
		array_agg(distinct idagency_b) AS idagency_merged,
		array_agg(distinct hash_b) AS hash_merged,
		array_agg(distinct agencysource_b) AS agencysource,
		array_agg(distinct sourcedatasetname_b) AS sourcedatasetname,
		array_agg(distinct linkdata_b) AS linkdata,
		array_agg(distinct oversightagency_b) AS oversightagency,
		array_agg(distinct oversightabbrev_b) AS oversightabbrev,
		array_agg(distinct pgtable_b) AS pgtable,
		array_agg(capacity_b) AS capacity,
		array_agg(distinct capacitytype_b) AS capacitytype
	FROM matches
	GROUP BY
	guid, facilityname, facilitytype
	ORDER BY facilitytype, countofdups DESC )

UPDATE facilities AS f
SET
	idagency = array_cat(idagency, d.idagency_merged),
	guid_merged = d.guid_merged,
	hash_merged = d.hash_merged,
	pgtable = array_cat(f.pgtable,d.pgtable),
	agencysource = array_cat(f.agencysource, d.agencysource),
	sourcedatasetname = array_cat(f.sourcedatasetname, d.sourcedatasetname),
	linkdata = array_cat(f.linkdata, d.linkdata),
	oversightagency = array_cat(f.oversightagency, d.oversightagency),
	oversightabbrev = array_cat(f.oversightabbrev, d.oversightabbrev),
	capacity = (CASE WHEN d.capacity <> ARRAY['FAKE!'] THEN array_cat(f.capacity, d.capacity) END),
	capacitytype = (CASE WHEN d.capacitytype <> ARRAY['FAKE!'] THEN array_cat(f.capacitytype, d.capacitytype) END)
FROM duplicates AS d
WHERE f.guid = d.guid
;

--------------------------------------------------------------------------------------------------
-- 3. DROPPING DUPLICATE RECORDS AFTER ATTRIBUTES HAVE BEEN MERGED INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

DELETE FROM facilities
WHERE facilities.guid IN (SELECT duplicates_ccprek_acs_dohmh.guid FROM duplicates_ccprek_acs_dohmh)
;

