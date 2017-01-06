--------------------------------------------------------------------------------------------------
-- 1. CREATING A TABLE TO BACKUP THE DUPLICATE RECORDS BEFORE DROPPING THEM FROM THE DATABASE
--------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS duplicates_ccprek_doe_dohmh;
CREATE TABLE duplicates_ccprek_doe_dohmh AS (

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
		AND a.bbl IS NOT NULL
		AND b.bbl IS NOT NULL
		AND a.bbl <> '{""}'
		AND b.bbl <> '{""}'
		AND a.bbl <> '{0.00000000000}'
		AND b.bbl <> '{0.00000000000}'
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
		AND a.id <> b.id
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
		a.id,
		b.id as id_b,
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
		a.oversightagency,
		b.oversightagency as oversightagency_b,
		a.oversightabbrev,
		b.oversightabbrev as oversightabbrev_b
	FROM facilities a
	LEFT JOIN facilities b
	ON a.bbl = b.bbl
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
		AND a.bbl IS NOT NULL
		AND b.bbl IS NOT NULL
		AND a.bbl <> '{""}'
		AND b.bbl <> '{""}'
		AND a.bbl <> '{0.00000000000}'
		AND b.bbl <> '{0.00000000000}'
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
		AND a.id <> b.id
		ORDER BY CONCAT(a.pgtable,'-',b.pgtable), a.facilityname, a.facilitysubgroup
	), 

duplicates AS (
	SELECT
		count(*) AS countofdups,
		facilityname,
		facilitytype,
		array_agg(distinct facilitytype_b) AS facilitytype_merged,
		array_agg(distinct bin_b) AS BIN,
		guid,
		array_agg(guid_b) AS guid_merged,
		array_agg(distinct idagency_b) AS idagency_merged,
		array_agg(hash_b) AS hash_merged,
		array_agg(distinct agencysource_b) AS agencysource,
		array_agg(distinct sourcedatasetname_b) AS sourcedatasetname,
		array_agg(distinct oversightagency_b) AS oversightagency,
		array_agg(distinct oversightabbrev_b) AS oversightabbrev,
		array_agg(distinct pgtable_b) AS pgtable
	FROM matches
	GROUP BY
	guid, facilityname, facilitytype
	ORDER BY facilitytype, countofdups DESC )

UPDATE facilities AS f
SET
	BIN = d.BIN,
	idagency = array_cat(idagency, d.idagency_merged),
	guid_merged = d.guid_merged,
	hash_merged = d.hash_merged,
	pgtable = array_cat(f.pgtable,d.pgtable),
	sourcedatasetname = array_cat(f.sourcedatasetname, d.sourcedatasetname),
	oversightagency = array_cat(f.oversightagency, d.oversightagency),
	oversightabbrev = array_cat(f.oversightabbrev, d.oversightabbrev),
	-- MIGHT ADD CASE THAT CHANGES THE FACILITY TYPE IF WE INCLUDE MATCHES BEYOND PRESCHOOL (DAY CARE)
	facilitysubgroup = (CASE
		WHEN array_to_string(facilitytype_merged,',') LIKE '%Infants/Toddlers%' AND array_to_string(facilitytype_merged,',') LIKE '%Preschool%' THEN 'Dual Pre-K and Child Care'
		ELSE facilitysubgroup
		END)
FROM duplicates AS d
WHERE f.guid = d.guid
;

--------------------------------------------------------------------------------------------------
-- 3. DROPPING DUPLICATE RECORDS AFTER ATTRIBUTES HAVE BEEN MERGED INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

DELETE FROM facilities
WHERE facilities.guid IN (SELECT duplicates_ccprek_doe_dohmh.guid FROM duplicates_ccprek_doe_dohmh)
;

