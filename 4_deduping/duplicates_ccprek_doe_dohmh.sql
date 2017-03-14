--------------------------------------------------------------------------------------------------
-- 1. CREATING A TABLE TO BACKUP THE DUPLICATE RECORDS BEFORE DROPPING THEM FROM THE DATABASE
--------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS duplicates_ccprek_doe_dohmh;
CREATE TABLE duplicates_ccprek_doe_dohmh AS (

WITH matches AS (
	SELECT
		CONCAT(a.pgtable,'-',b.pgtable) as sourcecombo,
		a.hash,
		b.hash as hash_b,
		a.facilityname,
		b.facilityname as facilityname_b
	FROM facilities a
	LEFT JOIN facilities b
	ON a.bin = b.bin
	WHERE
		a.facilitygroup LIKE '%Child Care%'
		AND (a.facilitytype LIKE '%Early%'
		OR a.facilitytype LIKE '%Charter%')
		-- AND b.facilitytype LIKE '%Preschool%'
		AND b.facilitytype NOT LIKE '%Camp%'
		-- NEED TO CHECK IF OTHER TYPES STILL NEED TO BE CAPTURED, LIKE NON-PRESCHOOL AND THEN CHANGE TYPE TO DUAL
		AND a.pgtable @> ARRAY['doe_facilities_universalprek']::text[]
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
		AND a.hash <> b.hash
		ORDER BY CONCAT(a.pgtable,'-',b.pgtable), a.facilityname, a.facilitysubgroup
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

WITH matches AS (
	SELECT
		CONCAT(a.pgtable,'-',b.pgtable) as sourcecombo,
		a.idagency,
		b.idagency as idagency_b,
		a.uid,
		b.uid as uid_b,
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
		b.datesourceupdated as datesourceupdated_b,
		(CASE WHEN b.linkdata IS NULL THEN ARRAY['FAKE!'] ELSE b.linkdata END) as linkdata_b,
		a.oversightagency,
		b.oversightlevel as oversightlevel_b,
		b.oversightagency as oversightagency_b,
		a.oversightabbrev,
		b.oversightabbrev as oversightabbrev_b,
		(CASE WHEN b.capacity IS NULL THEN ARRAY['FAKE!'] ELSE b.capacity END) as capacity_b,
		(CASE WHEN b.capacitytype IS NULL THEN ARRAY['FAKE!'] ELSE b.capacitytype END) capacitytype_b,
		(CASE WHEN b.utilization IS NULL THEN ARRAY['FAKE!'] ELSE b.utilization END) as utilization_b,
		(CASE WHEN b.area IS NULL THEN ARRAY['FAKE!'] ELSE b.area END) as area_b,
		(CASE WHEN b.areatype IS NULL THEN ARRAY['FAKE!'] ELSE b.areatype END) areatype_b
	FROM facilities a
	LEFT JOIN facilities b
	ON a.bin = b.bin
	WHERE
		a.facilitygroup LIKE '%Child Care%'
		AND (a.facilitytype LIKE '%Early%'
		OR a.facilitytype LIKE '%Charter%')
		-- AND b.facilitytype LIKE '%Preschool%'
		AND b.facilitytype NOT LIKE '%Camp%'
		AND a.pgtable @> ARRAY['doe_facilities_universalprek']::text[]
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
		AND a.hash <> b.hash
		ORDER BY CONCAT(a.pgtable,'-',b.pgtable), a.facilityname, a.facilitysubgroup
	), 

duplicates AS (
	SELECT
		count(*) AS countofdups,
		facilityname,
		facilitytype,
		array_agg(distinct facilitytype_b) AS facilitytype_merged,
		hash,
		array_agg(uid_b) AS uid_merged,
		array_agg(distinct idagency_b) AS idagency_merged,
		array_agg(hash_b) AS hash_merged,
		array_agg(distinct agencysource_b) AS agencysource,
		array_agg(distinct sourcedatasetname_b) AS sourcedatasetname,
		array_agg(distinct datesourceupdated_b) AS datesourceupdated,
		array_agg(distinct linkdata_b) AS linkdata,
		array_agg(distinct oversightlevel_b) AS oversightlevel,
		array_agg(distinct oversightagency_b) AS oversightagency,
		array_agg(distinct oversightabbrev_b) AS oversightabbrev,
		array_agg(distinct pgtable_b) AS pgtable,
		array_agg(capacity_b) AS capacity,
		array_agg(distinct capacitytype_b) AS capacitytype,
		array_agg(utilization_b) AS utilization,
		array_agg(area_b) AS area,
		array_agg(distinct areatype_b) AS areatype
	FROM matches
	GROUP BY
	hash, facilityname, facilitytype
	ORDER BY facilitytype, countofdups DESC )

UPDATE facilities AS f
SET
	idagency = array_cat(idagency, d.idagency_merged),
	uid_merged = d.uid_merged,
	hash_merged = d.hash_merged,
	pgtable = array_cat(f.pgtable,d.pgtable),
	agencysource = array_cat(f.agencysource, d.agencysource),
	sourcedatasetname = array_cat(f.sourcedatasetname, d.sourcedatasetname),
	datesourceupdated = array_cat(f.datesourceupdated, d.datesourceupdated),
	linkdata = array_cat(f.linkdata, d.linkdata),
	oversightlevel = array_cat(f.oversightlevel, d.oversightlevel),
	oversightagency = array_cat(f.oversightagency, d.oversightagency),
	oversightabbrev = array_cat(f.oversightabbrev, d.oversightabbrev),
	capacity = (CASE WHEN d.capacity <> ARRAY['FAKE!'] THEN array_cat(f.capacity, d.capacity) END),
	capacitytype = (CASE WHEN d.capacitytype <> ARRAY['FAKE!'] THEN array_cat(f.capacitytype, d.capacitytype) END),
	utilization = (CASE WHEN d.utilization <> ARRAY['FAKE!'] THEN array_cat(f.utilization, d.utilization) END),
	area = (CASE WHEN d.area <> ARRAY['FAKE!'] THEN array_cat(f.area, d.area) END),
	areatype = (CASE WHEN d.areatype <> ARRAY['FAKE!'] THEN array_cat(f.areatype, d.areatype) END),
	facilitysubgroup = (CASE
		WHEN array_to_string(facilitytype_merged,',') LIKE '%Infants/Toddlers%' AND array_to_string(facilitytype_merged,',') LIKE '%Preschool%' THEN 'Dual Child Care and Universal Pre-K'
		ELSE facilitysubgroup
		END)
FROM duplicates AS d
WHERE f.hash = d.hash
;

--------------------------------------------------------------------------------------------------
-- 3. DROPPING DUPLICATE RECORDS AFTER ATTRIBUTES HAVE BEEN MERGED INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

DELETE FROM facilities
WHERE facilities.hash IN (SELECT duplicates_ccprek_doe_dohmh.hash FROM duplicates_ccprek_doe_dohmh)
;

